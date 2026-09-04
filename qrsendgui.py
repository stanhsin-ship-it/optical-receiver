#!/usr/bin/env python3
"""
qrsendgui.py -- point-and-click front end for qrsendbin.py.

The optical protocol is not reimplemented here. This module imports
qrsendbin.py and calls its functions (read_input, plan_segments, chunk_blob,
build_blob, dump_frames, make_qr), so frames produced from the GUI are
bit-identical to frames produced from the command line, and the session ids
line up with a run started either way.

What the GUI adds:

  * A file manager: browse the filesystem and pick what to send. Ctrl-click
    (Cmd-click on macOS) adds one item, shift-click takes a range, ctrl-a takes
    every file in the folder. A folder is sent whole, packed into one
    deterministic tar by qrsendbin.
  * Several selections are queued into one loop. Each file already plans to its
    own session, and the receiver tracks sessions independently, so five files
    play back to back and land as five separate files -- no archive to unpack
    and nothing to restart between them.
  * Every command-line switch as a widget, with a live "bytes per frame"
    readout so the effect of --version is visible before you commit.
  * An Analyze step that runs the real planner and reports frames, sessions,
    split layout and wall-clock time per pass, so you can see how long a
    transfer will take before opening the sender window.
  * A player window that is a Toplevel rather than its own Tk root, so the
    control window survives the transfer. Space pauses, arrows step frames
    while paused, Esc/q stops.

Run:  python qrsendgui.py
Requires: segno (a wheel under segno/offline_packages/ is used automatically
if segno is not installed) and tkinter.
"""

import glob
import importlib.util
import io
import json
import os
import queue
import sys
import threading
import time
import traceback
from contextlib import redirect_stdout

import tkinter as tk
from tkinter import filedialog, messagebox, ttk

# ttk.Spinbox needs Tk 8.6.9; older server installs still have the tk one,
# which takes the same options.
Spinbox = getattr(ttk, "Spinbox", tk.Spinbox)

HERE = os.path.dirname(os.path.abspath(__file__))
CONFIG_PATH = os.path.join(os.path.expanduser("~"), ".qrsendgui.json")


# --------------------------------------------------------------------------
# Engine import
# --------------------------------------------------------------------------

def ensure_segno():
    """Import segno, falling back to the vendored wheel.

    A py3-none-any wheel is just a zip of pure Python, so putting it on
    sys.path is enough to import from it -- no install, no admin rights, which
    matters on the locked-down machines this tool exists for.
    """
    try:
        import segno  # noqa: F401
        return None
    except ImportError:
        pass
    for whl in sorted(glob.glob(os.path.join(HERE, "**", "segno-*.whl"), recursive=True)):
        sys.path.insert(0, whl)
        try:
            import segno  # noqa: F401
            return whl
        except ImportError:
            sys.path.pop(0)
    return None


def load_engine():
    """Load qrsendbin.py as a module, preferring the copy next to this file."""
    candidates = [
        os.path.join(HERE, "qrsendbin.py"),
        os.path.join(HERE, "2brady", "qrsendbin.py"),
        os.path.join(os.path.dirname(HERE), "qrsendbin.py"),
    ]
    for path in candidates:
        if os.path.isfile(path):
            spec = importlib.util.spec_from_file_location("qrsendbin", path)
            mod = importlib.util.module_from_spec(spec)
            sys.modules["qrsendbin"] = mod
            spec.loader.exec_module(mod)
            return mod, path
    raise SystemExit("qrsendbin.py not found next to qrsendgui.py.")


WHEEL_USED = ensure_segno()
try:
    QB, ENGINE_PATH = load_engine()
except ImportError as exc:                      # segno missing entirely
    root = tk.Tk()
    root.withdraw()
    messagebox.showerror(
        "qrsendgui",
        f"Could not import the sender engine:\n\n{exc}\n\n"
        "segno is required. Install it with:\n"
        "  pip install --user segno\n"
        "or drop segno-*.whl next to this script.")
    raise SystemExit(1)


# --------------------------------------------------------------------------
# Small helpers
# --------------------------------------------------------------------------

def human_bytes(n):
    """Byte counts the way the CLI prints them, with a friendly suffix."""
    if n < 1024:
        return f"{n:,} B"
    if n < 1024 * 1024:
        return f"{n:,} B ({n / 1024:.1f} KB)"
    return f"{n:,} B ({n / 1024 / 1024:.2f} MB)"


def human_time(secs):
    secs = int(round(secs))
    if secs < 60:
        return f"{secs}s"
    if secs < 3600:
        return f"{secs // 60}m {secs % 60:02d}s"
    return f"{secs // 3600}h {(secs % 3600) // 60:02d}m"


DOT = "·"          # separates file name from part label in captions


def payload_size_for(version):
    """Bytes of file payload carried by one frame at this QR version."""
    return (QB.ALNUM_CAP_H[version] // 3) * 2 - QB.FRAME_OVERHEAD


def clean_only(spec):
    """Normalise whatever got pasted into the 'Replay only' box.

    qrgrab reports gaps as a ready-made command line --

        Replay the gaps with:  qrsendbin.py <file> --only 7,19,55-61

    -- and that whole line is what lands on the clipboard, so take the part
    after --only (or after 'missing:') and keep only what parse_only reads.
    """
    s = spec.strip()
    if "--only" in s:
        s = s.split("--only", 1)[1]
    elif "missing:" in s:
        s = s.split("missing:", 1)[1]
    kept = "".join(ch for ch in s if ch.isdigit() or ch in ",- ")
    return "".join(kept.split()).strip(",")


def capture(fn, *args, **kwargs):
    """Run an engine function, returning (result, printed_text).

    The engine prints progress and calls sys.exit() on bad input. Both are
    fine in a terminal and fatal in a GUI, so stdout is captured and SystemExit
    is turned back into a normal exception the caller can show in a dialog.
    """
    buf = io.StringIO()
    try:
        with redirect_stdout(buf):
            result = fn(*args, **kwargs)
    except SystemExit as exc:
        raise RuntimeError(str(exc) or "The sender engine aborted.") from None
    return result, buf.getvalue()


# --------------------------------------------------------------------------
# Player window
# --------------------------------------------------------------------------

class Player:
    """qrsendbin.show_loop, hosted in a Toplevel.

    Same state machine and the same meaning for gap_ticks / seg_repeat as the
    command-line player -- see show_loop's docstring for why those exist. The
    differences are that this one does not own the Tk root (so the control
    window stays alive), and that it can be paused and stepped, which is how
    you check a single frame decodes over a lossy remote-desktop link.
    """

    CACHE_MAX = 128

    def __init__(self, app, segments, version, fps, max_passes,
                 gap_ticks=4, seg_repeat=1, fullscreen=True, on_close=None):
        self.app = app
        self.segments = segments
        self.version = version
        self.fps = fps
        self.delay = max(1, int(1000 / fps))
        self.max_passes = max_passes
        self.gap_ticks = gap_ticks
        self.seg_repeat = 1 if len(segments) == 1 else max(1, seg_repeat)
        self.on_close = on_close

        self.total_frames = sum(len(s["frames"]) for s in segments)
        self.started = time.monotonic()
        self.paused = False
        self.after_id = None
        self.closed = False

        win = self.win = tk.Toplevel(app)
        win.title("qrsendbin -- sending")
        win.configure(bg="white")
        if fullscreen:
            win.attributes("-fullscreen", True)
        else:
            win.geometry("900x900")

        self.canvas = tk.Canvas(win, bg="white", highlightthickness=0)
        self.canvas.pack(fill="both", expand=True)
        self.label = tk.Label(win, bg="white", fg="black", font=("monospace", 13))
        self.label.pack(side="bottom", pady=6)

        win.update_idletasks()
        screen_h = win.winfo_height() - 60
        screen_w = win.winfo_width()

        # Geometry is constant across every frame of every segment: one QR
        # version means one module count, so scale is computed once.
        first = segments[0]["frames"][0]
        self.side = len(QB.make_qr(first, version).matrix)
        self.quiet = 6
        span = self.side + 2 * self.quiet
        self.scale = max(3, min(screen_w, screen_h) // span)
        self.px = span * self.scale

        from collections import OrderedDict
        self.cache = OrderedDict()

        self.blank = tk.PhotoImage(master=win, width=self.px, height=self.px)
        self.blank.put("white", to=(0, 0, self.px, self.px))
        self.img_id = self.canvas.create_image(screen_w // 2, screen_h // 2,
                                               image=self.blank)

        self.st = {"seg": 0, "i": 0, "pass": 1, "gap": gap_ticks, "rep": 1}

        win.bind("<Escape>", lambda e: self.close())
        win.bind("q", lambda e: self.close())
        win.bind("<space>", lambda e: self.toggle_pause())
        win.bind("<Right>", lambda e: self.step(1))
        win.bind("<Left>", lambda e: self.step(-1))
        win.bind("<F11>", lambda e: self.toggle_fullscreen())
        win.protocol("WM_DELETE_WINDOW", self.close)
        win.focus_force()
        self.after_id = win.after(self.delay, self.tick)

    # -- rendering ---------------------------------------------------------

    def render(self, text):
        hit = self.cache.get(text)
        if hit is not None:
            self.cache.move_to_end(text)
            return hit
        rows = QB.make_qr(text, self.version).matrix
        img = tk.PhotoImage(master=self.win, width=self.px, height=self.px)
        img.put("white", to=(0, 0, self.px, self.px))
        side, quiet, scale = self.side, self.quiet, self.scale
        for r, row in enumerate(rows):
            start = None
            for c in range(side + 1):
                dark = c < side and row[c]
                if dark and start is None:
                    start = c
                elif not dark and start is not None:
                    img.put("black", to=((quiet + start) * scale, (quiet + r) * scale,
                                         (quiet + c) * scale, (quiet + r) * scale + scale))
                    start = None
        self.cache[text] = img
        if len(self.cache) > self.CACHE_MAX:
            self.cache.popitem(last=False)
        return img

    def caption(self, extra=""):
        seg = self.segments[self.st["seg"]]
        cap = f"/{self.max_passes}" if self.max_passes else ""
        rep = f" [{self.st['rep']}/{self.seg_repeat}]" if self.seg_repeat > 1 else ""
        elapsed = time.monotonic() - self.started
        left = ""
        if self.max_passes:
            total = self.total_frames * self.max_passes / self.fps
            left = f"   ~{human_time(max(0, total - elapsed))} left"
        state = "   [PAUSED - space resumes]" if self.paused else ""
        return (f"{seg['label']}{rep}   {extra}   pass {self.st['pass']}{cap}"
                f"   {human_time(elapsed)}{left}{state}")

    # -- playback ----------------------------------------------------------

    def tick(self):
        if self.closed:
            return
        if self.paused:
            self.after_id = self.win.after(100, self.tick)
            return

        if self.st["gap"] > 0:
            # Blank frames park the screen while the receiver decodes, writes
            # and auto-joins the part that just finished.
            self.canvas.itemconfig(self.img_id, image=self.blank)
            self.label.config(text=self.caption("(starting…)"))
            self.st["gap"] -= 1
            self.after_id = self.win.after(self.delay, self.tick)
            return

        self.show_current()
        self.advance()
        if not self.closed:
            self.after_id = self.win.after(self.delay, self.tick)

    def show_current(self):
        seg = self.segments[self.st["seg"]]
        i = self.st["i"]
        self.canvas.itemconfig(self.img_id, image=self.render(seg["frames"][i]))
        self.label.config(text=self.caption(
            f"frame {seg['indices'][i]} ({i + 1}/{len(seg['frames'])})"
            f"   sess {seg['session']:04X}"))

    def advance(self):
        st = self.st
        seg = self.segments[st["seg"]]
        st["i"] += 1
        if st["i"] < len(seg["frames"]):
            return
        st["i"] = 0
        if st["rep"] < self.seg_repeat:
            st["rep"] += 1
            st["gap"] = self.gap_ticks
            return
        st["rep"] = 1
        st["seg"] += 1
        st["gap"] = self.gap_ticks
        if st["seg"] >= len(self.segments):          # a full pass is done
            st["seg"] = 0
            if self.max_passes and st["pass"] >= self.max_passes:
                self.win.after(self.delay, self.close)
                return
            st["pass"] += 1

    # -- controls ----------------------------------------------------------

    def toggle_pause(self):
        self.paused = not self.paused
        self.label.config(text=self.caption("paused" if self.paused else ""))

    def step(self, delta):
        """Move one frame while paused, for checking a single code decodes."""
        if not self.paused:
            return
        seg = self.segments[self.st["seg"]]
        self.st["i"] = (self.st["i"] + delta) % len(seg["frames"])
        self.st["gap"] = 0
        self.show_current()

    def toggle_fullscreen(self):
        self.win.attributes("-fullscreen", not self.win.attributes("-fullscreen"))

    def close(self):
        if self.closed:
            return
        self.closed = True
        if self.after_id is not None:
            try:
                self.win.after_cancel(self.after_id)
            except tk.TclError:
                pass
        try:
            self.win.destroy()
        except tk.TclError:
            pass
        if self.on_close:
            self.on_close()


# --------------------------------------------------------------------------
# File manager pane
# --------------------------------------------------------------------------

class FileBrowser(ttk.Frame):
    """Two-click file manager: navigate folders, pick a file or a folder."""

    def __init__(self, master, on_pick):
        super().__init__(master, padding=(6, 6))
        self.on_pick = on_pick
        self.cwd = os.path.expanduser("~")
        self.filter_var = tk.StringVar(value="*")
        self.path_var = tk.StringVar(value=self.cwd)

        bar = ttk.Frame(self)
        bar.pack(fill="x")
        ttk.Button(bar, text="Up", width=5, command=self.go_up).pack(side="left")
        ttk.Button(bar, text="Home", width=6, command=lambda: self.chdir(
            os.path.expanduser("~"))).pack(side="left", padx=(4, 0))
        ttk.Button(bar, text="Reload", width=7,
                   command=self.refresh).pack(side="left", padx=(4, 0))
        entry = ttk.Entry(bar, textvariable=self.path_var)
        entry.pack(side="left", fill="x", expand=True, padx=6)
        entry.bind("<Return>", lambda e: self.chdir(self.path_var.get()))
        ttk.Button(bar, text="Go", width=4,
                   command=lambda: self.chdir(self.path_var.get())).pack(side="left")

        row = ttk.Frame(self)
        row.pack(fill="x", pady=(6, 0))
        drives = self.list_drives()
        if drives:                       # Windows only; Linux has one tree
            ttk.Label(row, text="Drive:").pack(side="left")
            self.drive = ttk.Combobox(row, values=drives, width=5, state="readonly")
            self.drive.pack(side="left", padx=(4, 12))
            self.drive.bind("<<ComboboxSelected>>",
                            lambda e: self.chdir(self.drive.get() + os.sep))
        ttk.Label(row, text="Filter:").pack(side="left")
        filt = ttk.Entry(row, textvariable=self.filter_var, width=16)
        filt.pack(side="left", padx=4)
        filt.bind("<Return>", lambda e: self.refresh())
        ttk.Button(row, text="Apply", width=6, command=self.refresh).pack(side="left")
        ttk.Label(row, text="glob, e.g. *.bin   |   ctrl/shift-click for several",
                  foreground="#555").pack(side="left", padx=6)

        # The action row is packed before the list: pack() hands out slabs in
        # creation order, so claiming the bottom edge first keeps the buttons
        # under the tree instead of squeezed beside it.
        foot = ttk.Frame(self)
        foot.pack(side="bottom", fill="x", pady=(6, 0))
        ttk.Button(foot, text="Send selected", command=self.pick_selection).pack(side="left")
        ttk.Button(foot, text="Send this whole folder",
                   command=lambda: self.on_pick(self.cwd)).pack(side="left", padx=6)
        ttk.Button(foot, text="Open file(s)...", command=self.pick_dialog).pack(side="left")

        cols = ("size", "modified")
        self.tree = ttk.Treeview(self, columns=cols, selectmode="extended")
        self.tree.heading("#0", text="Name")
        self.tree.heading("size", text="Size")
        self.tree.heading("modified", text="Modified")
        self.tree.column("#0", width=320, stretch=True)
        self.tree.column("size", width=90, anchor="e", stretch=False)
        self.tree.column("modified", width=130, anchor="center", stretch=False)
        vsb = ttk.Scrollbar(self, orient="vertical", command=self.tree.yview)
        self.tree.configure(yscrollcommand=vsb.set)
        self.tree.pack(side="left", fill="both", expand=True, pady=6)
        vsb.pack(side="left", fill="y", pady=6)

        # "extended" is what gives ctrl-click and shift-click their usual
        # meaning; ctrl-a rounds it out for "everything in this folder".
        self.tree.bind("<Control-a>", self.select_all_files)
        self.tree.bind("<Command-a>", self.select_all_files)   # macOS
        self.tree.bind("<Double-1>", self.on_activate)
        self.tree.bind("<Return>", self.on_activate)
        self.tree.bind("<<TreeviewSelect>>", self.on_select)

        self.chdir(self.cwd)

    @staticmethod
    def list_drives():
        if os.name != "nt":
            return []
        import string
        return [f"{d}:" for d in string.ascii_uppercase if os.path.exists(f"{d}:\\")]

    def chdir(self, path):
        path = os.path.expanduser(path.strip().strip('"'))
        if os.path.isfile(path):
            self.on_pick(path)
            path = os.path.dirname(path)
        if not os.path.isdir(path):
            messagebox.showwarning("qrsendgui", f"Not a folder:\n{path}")
            return
        self.cwd = os.path.abspath(path)
        self.path_var.set(self.cwd)
        self.refresh()

    def go_up(self):
        parent = os.path.dirname(self.cwd.rstrip(os.sep))
        if parent and parent != self.cwd:
            self.chdir(parent)

    def refresh(self):
        self.tree.delete(*self.tree.get_children())
        pattern = (self.filter_var.get() or "*").strip()
        try:
            entries = list(os.scandir(self.cwd))
        except OSError as exc:
            self.tree.insert("", "end", text=f"! {exc.strerror}", values=("", ""))
            return
        dirs, files = [], []
        for e in entries:
            try:
                (dirs if e.is_dir() else files).append(e)
            except OSError:
                continue
        dirs.sort(key=lambda e: e.name.lower())
        files.sort(key=lambda e: e.name.lower())

        # Plain text markers rather than emoji: this runs over remote screen
        # capture on servers whose Tk may have no emoji font at all.
        import fnmatch
        for e in dirs:
            self.tree.insert("", "end", iid=e.path, text="[+] " + e.name + "/",
                             values=("<dir>", self.mtime(e)), tags=("dir",))
        for e in files:
            if pattern not in ("", "*") and not fnmatch.fnmatch(e.name.lower(), pattern.lower()):
                continue
            try:
                size = f"{e.stat().st_size:,}"
            except OSError:
                size = "?"
            self.tree.insert("", "end", iid=e.path, text="     " + e.name,
                             values=(size, self.mtime(e)), tags=("file",))
        self.tree.tag_configure("dir", foreground="#0a3d91")

    @staticmethod
    def mtime(entry):
        try:
            return time.strftime("%Y-%m-%d %H:%M", time.localtime(entry.stat().st_mtime))
        except OSError:
            return ""

    def selected_paths(self):
        """Every highlighted row that still exists, in the order shown.

        tree.selection() returns items in selection order, not list order, so
        a shift-click range would otherwise queue bottom-to-top depending on
        which end you started from. Sending follows what the eye sees.
        """
        chosen = set(self.tree.selection())
        return [p for p in self.tree.get_children("")
                if p in chosen and os.path.exists(p)]

    def selected_path(self):
        paths = self.selected_paths()
        return paths[0] if paths else None

    def on_select(self, _event=None):
        # A folder among the picks is fine -- the sender tars it -- but a lone
        # folder click is usually navigation, so it is not treated as a pick.
        paths = self.selected_paths()
        if len(paths) == 1 and os.path.isdir(paths[0]):
            return
        if paths:
            self.on_pick(paths)

    def on_activate(self, _event=None):
        paths = self.selected_paths()
        if not paths:
            return
        if len(paths) == 1 and os.path.isdir(paths[0]):
            self.chdir(paths[0])
        else:
            self.on_pick(paths)

    def select_all_files(self, _event=None):
        files = [p for p in self.tree.get_children("") if os.path.isfile(p)]
        self.tree.selection_set(files)
        if files:
            self.on_pick(files)
        return "break"

    def pick_selection(self):
        paths = self.selected_paths()
        if paths:
            self.on_pick(paths)

    def pick_dialog(self):
        paths = filedialog.askopenfilenames(initialdir=self.cwd,
                                            title="Choose file(s) to send")
        if paths:
            self.chdir(os.path.dirname(paths[0]))
            self.on_pick(list(paths))


# --------------------------------------------------------------------------
# Main window
# --------------------------------------------------------------------------

class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("qrsendbin -- optical file sender")
        self.geometry("1180x760")
        self.minsize(980, 620)

        self.targets = []
        self.plan = None            # (segments, was_split) from the last Analyze
        self.plan_key = None        # inputs the plan was built from
        self.player = None
        self.busy = False
        self.q = queue.Queue()

        self.v_version = tk.IntVar(value=6)
        self.v_fps = tk.DoubleVar(value=2.0)
        self.v_passes = tk.IntVar(value=0)
        self.v_split = tk.StringVar(value="40k")
        self.v_nosplit = tk.BooleanVar(value=False)
        self.v_repeat = tk.IntVar(value=2)
        self.v_gap = tk.IntVar(value=4)
        self.v_only = tk.StringVar(value="")
        self.v_full = tk.BooleanVar(value=True)

        self.build_ui()
        self.load_config()
        self.log(f"Engine   {ENGINE_PATH}")
        if WHEEL_USED:
            self.log(f"segno    loaded from wheel {os.path.basename(WHEEL_USED)}")
        self.log("Pick a file or folder on the left, set options, then Analyze.")
        self.on_setting_changed()
        self.after(100, self.drain_queue)
        self.protocol("WM_DELETE_WINDOW", self.on_quit)

    # -- layout ------------------------------------------------------------

    def build_ui(self):
        pane = ttk.PanedWindow(self, orient="horizontal")
        pane.pack(fill="both", expand=True, padx=8, pady=8)

        left = ttk.LabelFrame(pane, text="File manager")
        self.browser = FileBrowser(left, self.set_target)
        self.browser.pack(fill="both", expand=True)
        pane.add(left, weight=3)

        right = ttk.Frame(pane)
        pane.add(right, weight=2)

        # Target ----------------------------------------------------------
        tgt = ttk.LabelFrame(right, text="Selected", padding=8)
        tgt.pack(fill="x")
        self.lbl_target = ttk.Label(tgt, text="(nothing selected)", wraplength=460,
                                    justify="left", font=("TkDefaultFont", 10, "bold"))
        self.lbl_target.pack(anchor="w")
        self.lbl_target_info = ttk.Label(tgt, text="", foreground="#555")
        self.lbl_target_info.pack(anchor="w")

        # Settings --------------------------------------------------------
        st = ttk.LabelFrame(right, text="Settings", padding=8)
        st.pack(fill="x", pady=(8, 0))
        st.columnconfigure(1, weight=0)
        st.columnconfigure(2, weight=1)

        r = 0
        ttk.Label(st, text="QR version").grid(row=r, column=0, sticky="w", pady=2)
        vers = ttk.Combobox(st, width=6, state="readonly",
                            values=[str(v) for v in sorted(QB.ALNUM_CAP_H)],
                            textvariable=self.v_version)
        vers.grid(row=r, column=1, sticky="w")
        vers.bind("<<ComboboxSelected>>", lambda e: self.on_setting_changed())
        self.lbl_payload = ttk.Label(st, text="", foreground="#555")
        self.lbl_payload.grid(row=r, column=2, sticky="w", padx=6)

        r += 1
        ttk.Label(st, text="Frames / second").grid(row=r, column=0, sticky="w", pady=2)
        Spinbox(st, from_=0.5, to=30.0, increment=0.5, width=6,
                    textvariable=self.v_fps, command=self.on_setting_changed
                    ).grid(row=r, column=1, sticky="w")
        ttk.Label(st, text="higher = faster, but the receiver must keep up",
                  foreground="#555").grid(row=r, column=2, sticky="w", padx=6)

        r += 1
        ttk.Label(st, text="Passes").grid(row=r, column=0, sticky="w", pady=2)
        Spinbox(st, from_=0, to=99, width=6, textvariable=self.v_passes,
                    command=self.on_setting_changed).grid(row=r, column=1, sticky="w")
        ttk.Label(st, text="0 = loop until you stop it; 3–5 is comfortable",
                  foreground="#555").grid(row=r, column=2, sticky="w", padx=6)

        r += 1
        ttk.Label(st, text="Split size").grid(row=r, column=0, sticky="w", pady=2)
        e = ttk.Entry(st, width=8, textvariable=self.v_split)
        e.grid(row=r, column=1, sticky="w")
        e.bind("<FocusOut>", lambda ev: self.on_setting_changed())
        ttk.Checkbutton(st, text="never split (one long session)",
                        variable=self.v_nosplit, command=self.on_setting_changed
                        ).grid(row=r, column=2, sticky="w", padx=6)

        r += 1
        ttk.Label(st, text="Part repeat").grid(row=r, column=0, sticky="w", pady=2)
        Spinbox(st, from_=1, to=9, width=6, textvariable=self.v_repeat,
                    command=self.on_setting_changed).grid(row=r, column=1, sticky="w")
        ttk.Label(st, text="each part shown N× per pass (split runs only)",
                  foreground="#555").grid(row=r, column=2, sticky="w", padx=6)

        r += 1
        ttk.Label(st, text="Gap ticks").grid(row=r, column=0, sticky="w", pady=2)
        Spinbox(st, from_=0, to=30, width=6, textvariable=self.v_gap,
                    command=self.on_setting_changed).grid(row=r, column=1, sticky="w")
        ttk.Label(st, text="blank frames between parts, so the receiver can write",
                  foreground="#555").grid(row=r, column=2, sticky="w", padx=6)

        r += 1
        ttk.Label(st, text="Replay only").grid(row=r, column=0, sticky="w", pady=2)
        e = ttk.Entry(st, width=18, textvariable=self.v_only)
        e.grid(row=r, column=1, columnspan=2, sticky="w")
        e.bind("<FocusOut>", lambda ev: self.on_setting_changed())
        r += 1
        ttk.Label(st, text="paste qrgrab's \"--only 7,19,55-61\" line here to refill "
                           "gaps; single session, same QR version as the run it patches",
                  foreground="#555").grid(row=r, column=0, columnspan=3, sticky="w")

        r += 1
        ttk.Checkbutton(st, text="Fullscreen sender window (F11 toggles while playing)",
                        variable=self.v_full).grid(row=r, column=0, columnspan=3,
                                                   sticky="w", pady=(6, 0))

        # Plan ------------------------------------------------------------
        pl = ttk.LabelFrame(right, text="Plan", padding=8)
        pl.pack(fill="x", pady=(8, 0))
        self.txt_plan = tk.Text(pl, height=8, wrap="word", font=("monospace", 10),
                                bg="#f7f7f7", relief="flat", state="disabled")
        self.txt_plan.pack(fill="x")

        # Actions ---------------------------------------------------------
        act = ttk.Frame(right)
        act.pack(fill="x", pady=8)
        self.btn_analyze = ttk.Button(act, text="Analyze", command=self.do_analyze)
        self.btn_analyze.pack(side="left")
        self.btn_send = ttk.Button(act, text="Send", command=self.do_send)
        self.btn_send.pack(side="left", padx=6)
        self.btn_preview = ttk.Button(act, text="Preview one frame", command=self.do_preview)
        self.btn_preview.pack(side="left")
        self.btn_dump = ttk.Button(act, text="Dump PNGs…", command=self.do_dump)
        self.btn_dump.pack(side="left", padx=6)

        # Log -------------------------------------------------------------
        lg = ttk.LabelFrame(right, text="Log", padding=4)
        lg.pack(fill="both", expand=True)
        self.txt_log = tk.Text(lg, height=8, wrap="word", font=("monospace", 10),
                               state="disabled")
        sb = ttk.Scrollbar(lg, orient="vertical", command=self.txt_log.yview)
        self.txt_log.configure(yscrollcommand=sb.set)
        self.txt_log.pack(side="left", fill="both", expand=True)
        sb.pack(side="left", fill="y")

    # -- small UI helpers --------------------------------------------------

    def log(self, msg):
        self.txt_log.configure(state="normal")
        self.txt_log.insert("end", msg.rstrip() + "\n")
        self.txt_log.see("end")
        self.txt_log.configure(state="disabled")

    def set_plan_text(self, text):
        self.txt_plan.configure(state="normal")
        self.txt_plan.delete("1.0", "end")
        self.txt_plan.insert("1.0", text)
        self.txt_plan.configure(state="disabled")

    def set_busy(self, busy):
        self.busy = busy
        state = "disabled" if busy else "normal"
        for b in (self.btn_analyze, self.btn_send, self.btn_preview, self.btn_dump):
            b.configure(state=state)

    # -- target / settings -------------------------------------------------

    @staticmethod
    def folder_size(path):
        n = total = 0
        for dp, _, fns in os.walk(path):
            for fn in fns:
                n += 1
                try:
                    total += os.path.getsize(os.path.join(dp, fn))
                except OSError:
                    pass
        return n, total

    def set_target(self, paths):
        """Accepts one path or a list of them, from any of the pick buttons."""
        if isinstance(paths, str):
            paths = [paths]
        self.targets = [os.path.abspath(p) for p in paths]
        self.plan = None

        if len(self.targets) == 1:
            target = self.targets[0]
            if os.path.isdir(target):
                n, total = self.folder_size(target)
                self.lbl_target.config(text="[folder] " + target)
                self.lbl_target_info.config(
                    text=f"folder — {n} file(s), {human_bytes(total)}; "
                         f"sent as one .tar, unpacked on arrival by qrgrab")
            else:
                try:
                    size = os.path.getsize(target)
                except OSError:
                    size = 0
                self.lbl_target.config(text="[file]   " + target)
                self.lbl_target_info.config(text=f"file — {human_bytes(size)}")
        else:
            files = [p for p in self.targets if not os.path.isdir(p)]
            folders = [p for p in self.targets if os.path.isdir(p)]
            total = 0
            for p in files:
                try:
                    total += os.path.getsize(p)
                except OSError:
                    pass
            for p in folders:
                total += self.folder_size(p)[1]
            names = ", ".join(os.path.basename(p) for p in self.targets[:4])
            if len(self.targets) > 4:
                names += f", … (+{len(self.targets) - 4})"
            what = f"{len(files)} file(s)" if files else ""
            if folders:
                what += (" and " if what else "") + f"{len(folders)} folder(s)"
            self.lbl_target.config(text=f"[{len(self.targets)} selected] {names}")
            self.lbl_target_info.config(
                text=f"{what}, {human_bytes(total)} in total — sent one after "
                     f"another in a single loop; each arrives as its own file")
        self.set_plan_text("Settings or selection changed — press Analyze.")

    def on_setting_changed(self, *_):
        try:
            version = int(self.v_version.get())
        except (tk.TclError, ValueError):
            return
        ps = payload_size_for(version)
        cap = QB.ALNUM_CAP_H[version]
        if ps < 8:
            self.lbl_payload.config(text=f"{cap} chars — too small, use 6 or higher",
                                    foreground="#b00")
        else:
            note = "  (dense; test one frame over your link first)" if version > 15 else ""
            self.lbl_payload.config(text=f"{ps} bytes/frame{note}", foreground="#555")
        self.plan = None

    def settings_key(self):
        return (tuple(self.targets), int(self.v_version.get()), self.v_split.get(),
                bool(self.v_nosplit.get()), clean_only(self.v_only.get()))

    def require_target(self):
        live = [p for p in self.targets if os.path.exists(p)]
        if not live:
            messagebox.showinfo("qrsendgui", "Pick a file or folder on the left first.")
            return False
        self.targets = live
        return True

    def require_single(self, what):
        """Some actions only make sense for one input at a time."""
        if len(self.targets) != 1:
            messagebox.showinfo(
                "qrsendgui",
                f"{what} works on one file at a time.\n\n"
                f"{len(self.targets)} are selected — pick a single one first.")
            return False
        return True

    # -- planning (worker thread) -----------------------------------------

    def build_plan(self):
        """Run the engine planner. Returns (segments, was_split, notes).

        Several inputs become one playlist. Each file already plans to its own
        session (a split one to a manifest plus a session per part), and the
        receiver tracks sessions independently, so concatenating the segments
        is all that "send these five files" means: they play back to back in
        one loop and land as five separate files at the far end.
        """
        version = int(self.v_version.get())
        payload = payload_size_for(version)
        if payload < 8:
            raise RuntimeError("QR version too small. Use version 6 or higher.")
        notes = []
        only = clean_only(self.v_only.get())

        if only:
            # Gap fill works on a single session, exactly like --only.
            target = self.targets[0]
            (blob, flags, digest), out = capture(QB.build_blob, target)
            notes.append(out)
            session = QB.session_from(digest)
            frames, out = capture(QB.chunk_blob, blob, payload, session, flags)
            notes.append(out)
            indices, out = capture(QB.parse_only, only, len(frames))
            notes.append(out)
            frames = [frames[i] for i in indices]
            segs = [{"session": session, "frames": frames, "indices": indices,
                     "label": f"replay {only}", "name": os.path.basename(target)}]
            return segs, False, "".join(notes)

        if self.v_nosplit.get():
            split_size = 0
        else:
            split_size, out = capture(QB.parse_size, self.v_split.get())
            notes.append(out)

        segments, any_split = [], False
        for target in self.targets:
            (content, name), out = capture(QB.read_input, target)
            notes.append(out)
            (segs, was_split), out = capture(
                QB.plan_segments, content, name, payload, split_size)
            notes.append(out)
            # Label each segment with its file, so the caption on screen says
            # which of the five is playing rather than just "part 2 of 3".
            if len(self.targets) > 1:
                for seg in segs:
                    seg["label"] = f"{name}  {DOT}  {seg['label']}" \
                        if seg["label"] != name else name
            segments.extend(segs)
            any_split = any_split or was_split
        return segments, any_split, "".join(notes)

    def plan_summary(self, segments, was_split):
        version = int(self.v_version.get())
        fps = float(self.v_fps.get())
        passes = int(self.v_passes.get())
        repeat = max(1, int(self.v_repeat.get()))
        gap = max(0, int(self.v_gap.get()))
        total = sum(len(s["frames"]) for s in segments)

        # Repeats and gaps are real screen time, so count them in the estimate.
        # The player repeats every segment whenever there is more than one --
        # split parts and queued files alike -- so the same rule applies here,
        # or the estimate drifts from the clock as soon as you queue two files.
        reps = repeat if len(segments) > 1 else 1
        shown = total * reps
        gaps = gap * len(segments) * reps
        pass_secs = (shown + gaps) / fps

        lines = []
        if len(self.targets) == 1:
            kind = "folder → tar" if os.path.isdir(self.targets[0]) else "file"
            lines.append(f"Input       {os.path.basename(self.targets[0])}  ({kind})")
        else:
            names = ", ".join(os.path.basename(t) for t in self.targets[:3])
            if len(self.targets) > 3:
                names += f", … (+{len(self.targets) - 3} more)"
            lines.append(f"Input       {len(self.targets)} items: {names}")
            lines.append(f"            queued back to back; each lands as its "
                         f"own file at the far end")
        lines.append(f"QR          version {version}, ECC H, "
                     f"{payload_size_for(version)} bytes/frame")
        if was_split:
            parts = len(segments) - 1
            lines.append(f"Auto-split  {parts} parts + manifest, {total} frames total")
            lines.append(f"            each part shown {repeat}× per pass; "
                         f"receiver (qrgrab) rebuilds automatically")
        else:
            lines.append(f"Session     {segments[0]['session']:04X}  "
                         f"({len(segments)} segment)")
        lines.append(f"Frames      {total}   one full pass ≈ {human_time(pass_secs)} "
                     f"at {fps:g} fps")
        if passes:
            lines.append(f"Auto-stop   after {passes} passes "
                         f"(≈ {human_time(pass_secs * passes)})")
        else:
            lines.append("Auto-stop   off — loops until you press Esc")
        if total > 400:
            lines.append(f"!  {total} frames is a long run for an optical link. "
                         f"Raise the QR version, split smaller, or shrink the input.")
        return "\n".join(lines), pass_secs, total

    def run_async(self, work, done):
        """Do slow engine work off the Tk thread; deliver the result on it."""
        def runner():
            try:
                self.q.put((done, work(), None))
            except Exception as exc:                       # noqa: BLE001
                self.q.put((done, None, exc))
        self.set_busy(True)
        threading.Thread(target=runner, daemon=True).start()

    def drain_queue(self):
        try:
            while True:
                done, result, exc = self.q.get_nowait()
                self.set_busy(False)
                if exc is not None:
                    detail = "".join(traceback.format_exception_only(type(exc), exc)).strip()
                    self.log("ERROR  " + detail)
                    messagebox.showerror("qrsendgui", detail)
                else:
                    done(result)
        except queue.Empty:
            pass
        self.after(100, self.drain_queue)

    def ensure_plan(self, then):
        """Reuse the last plan if nothing that shapes it has changed."""
        cleaned = clean_only(self.v_only.get())
        if cleaned != self.v_only.get():
            self.v_only.set(cleaned)        # show what was understood
        # A gap fill replays frame indices of one session; with several inputs
        # selected there is no single session those indices belong to.
        if cleaned and not self.require_single("Replaying selected frames"):
            return
        if self.plan is not None and self.plan_key == self.settings_key():
            text, _, _ = self.plan_summary(*self.plan)
            self.set_plan_text(text)
            then(self.plan)
            return
        key = self.settings_key()

        def done(result):
            segments, was_split, notes = result
            self.plan = (segments, was_split)
            self.plan_key = key
            for line in notes.splitlines():
                if line.strip():
                    self.log(line)
            text, secs, total = self.plan_summary(segments, was_split)
            self.set_plan_text(text)
            self.log(f"Planned {total} frames in {len(segments)} segment(s), "
                     f"{human_time(secs)} per pass.")
            then(self.plan)

        what = (os.path.basename(self.targets[0]) if len(self.targets) == 1
                else f"{len(self.targets)} items")
        self.log(f"Planning {what} …")
        self.run_async(self.build_plan, done)

    # -- actions -----------------------------------------------------------

    def do_analyze(self):
        if not self.require_target():
            return
        self.ensure_plan(lambda plan: None)

    def do_send(self):
        if not self.require_target():
            return
        if self.player and not self.player.closed:
            messagebox.showinfo("qrsendgui", "A sender window is already open.")
            return

        def start(plan):
            segments, was_split = plan
            total = sum(len(s["frames"]) for s in segments)
            _, secs, _ = self.plan_summary(segments, was_split)
            if total > 400 and not messagebox.askyesno(
                    "qrsendgui",
                    f"{total} frames ≈ {human_time(secs)} per pass.\n"
                    "That is a long run for an optical link. Continue?"):
                self.log("Aborted before opening the sender.")
                return
            self.save_config()
            self.log("Sending - Esc or q stops, space pauses, arrows step.")
            self.player = Player(
                self, segments,
                version=int(self.v_version.get()),
                fps=float(self.v_fps.get()),
                max_passes=int(self.v_passes.get()),
                gap_ticks=max(0, int(self.v_gap.get())),
                seg_repeat=max(1, int(self.v_repeat.get())),
                fullscreen=bool(self.v_full.get()),
                on_close=lambda: self.log("Sender window closed."))

        self.ensure_plan(start)

    def do_preview(self):
        """Show the first frame, still, so you can verify it decodes."""
        if not self.require_target():
            return

        def start(plan):
            segments, _ = plan
            self.log("Preview — one still frame. Esc closes.")
            p = Player(self, [segments[0]], version=int(self.v_version.get()),
                       fps=float(self.v_fps.get()), max_passes=0, gap_ticks=0,
                       seg_repeat=1, fullscreen=bool(self.v_full.get()),
                       on_close=lambda: self.log("Preview closed."))
            p.paused = True
            p.st["gap"] = 0
            p.show_current()

        self.ensure_plan(start)

    def do_dump(self):
        """Write PNG frames instead of playing them (single session, like --dump-dir)."""
        if not self.require_target() or not self.require_single("Dumping PNG frames"):
            return
        out_dir = filedialog.askdirectory(title="Folder for PNG frames")
        if not out_dir:
            return
        version = int(self.v_version.get())
        payload = payload_size_for(version)
        only = clean_only(self.v_only.get())
        target = self.targets[0]

        def work():
            (blob, flags, digest), out1 = capture(QB.build_blob, target)
            session = QB.session_from(digest)
            frames, out2 = capture(QB.chunk_blob, blob, payload, session, flags)
            indices = list(range(len(frames)))
            out3 = ""
            if only:
                indices, out3 = capture(QB.parse_only, only, len(frames))
                frames = [frames[i] for i in indices]
            _, out4 = capture(QB.dump_frames, frames, indices, version, out_dir)
            return session, len(frames), out1 + out2 + out3 + out4

        def done(result):
            session, n, notes = result
            for line in notes.splitlines():
                if line.strip():
                    self.log(line)
            self.log(f"Dumped {n} PNG frames (session {session:04X}) to {out_dir}")
            messagebox.showinfo("qrsendgui", f"Wrote {n} PNG frames to\n{out_dir}")

        self.log(f"Dumping PNGs to {out_dir} …  (single session, ignores auto-split)")
        self.run_async(work, done)

    # -- config ------------------------------------------------------------

    def load_config(self):
        try:
            with open(CONFIG_PATH, "r", encoding="utf-8") as fh:
                cfg = json.load(fh)
        except (OSError, ValueError):
            return
        try:
            self.v_version.set(int(cfg.get("version", 6)))
            self.v_fps.set(float(cfg.get("fps", 2.0)))
            self.v_passes.set(int(cfg.get("passes", 0)))
            self.v_split.set(str(cfg.get("split", "40k")))
            self.v_nosplit.set(bool(cfg.get("no_split", False)))
            self.v_repeat.set(int(cfg.get("repeat", 2)))
            self.v_gap.set(int(cfg.get("gap", 4)))
            self.v_full.set(bool(cfg.get("fullscreen", True)))
        except (TypeError, ValueError):
            pass
        last = cfg.get("cwd")
        if last and os.path.isdir(last):
            self.browser.chdir(last)

    def save_config(self):
        cfg = {
            "version": int(self.v_version.get()),
            "fps": float(self.v_fps.get()),
            "passes": int(self.v_passes.get()),
            "split": self.v_split.get(),
            "no_split": bool(self.v_nosplit.get()),
            "repeat": int(self.v_repeat.get()),
            "gap": int(self.v_gap.get()),
            "fullscreen": bool(self.v_full.get()),
            "cwd": self.browser.cwd,
        }
        try:
            with open(CONFIG_PATH, "w", encoding="utf-8") as fh:
                json.dump(cfg, fh, indent=2)
        except OSError:
            pass

    def on_quit(self):
        try:
            self.save_config()
        finally:
            if self.player and not self.player.closed:
                self.player.close()
            self.destroy()


def main():
    app = App()
    if len(sys.argv) > 1 and os.path.exists(sys.argv[1]):
        app.set_target(sys.argv[1])
        app.browser.chdir(os.path.dirname(os.path.abspath(sys.argv[1])) or ".")
    app.mainloop()


if __name__ == "__main__":
    main()
