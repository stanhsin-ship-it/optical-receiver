#!/usr/bin/env python3
"""
qrsend.py -- optical file sender: animates a small text file as a loop of QR codes.

Designed for a screen viewed through a lossy remote-desktop client (NoMachine),
captured by a phone camera. Low QR density + high ECC so the codes survive
video compression. No network, no back-channel: the loop just repeats until
the receiver has every frame.

Usage:
    python3 qrsend.py notes.txt
    python3 qrsend.py notes.txt --version 8 --fps 2
    python3 qrsend.py notes.txt --dump-dir ./frames   # write PNGs instead of showing a window

Requires: segno  (pip install segno --user)
Display uses tkinter, which ships with most Python installs.
"""

import argparse
import gzip
import hashlib
import os
import struct
import sys

import segno

MAGIC = b"QT"
PROTO = "QRTX1"

# Header: magic(2) session(2) total(2) idx(2)  + CRC16(2) trailer
FRAME_OVERHEAD = 10

# Max alphanumeric characters per QR at ECC level H (30% recovery).
# Low versions are deliberately favoured: fewer, larger modules survive
# remote-desktop compression far better than a dense v40 code.
ALNUM_CAP_H = {
    4: 50, 5: 64, 6: 84, 7: 93, 8: 122, 9: 143, 10: 174,
    11: 200, 12: 227, 13: 259, 14: 283, 15: 321,
}

BASE45_CHARSET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:"


def b45_encode(data: bytes) -> str:
    """RFC 9285 Base45. Output is pure QR-alphanumeric, so codes stay compact."""
    out = []
    for i in range(0, len(data) & ~1, 2):
        x = (data[i] << 8) | data[i + 1]
        e, x = divmod(x, 45 * 45)
        d, c = divmod(x, 45)
        out.append(BASE45_CHARSET[c] + BASE45_CHARSET[d] + BASE45_CHARSET[e])
    if len(data) & 1:
        d, c = divmod(data[-1], 45)
        out.append(BASE45_CHARSET[c] + BASE45_CHARSET[d])
    return "".join(out)


def crc16_ccitt(data: bytes) -> int:
    crc = 0xFFFF
    for byte in data:
        crc ^= byte << 8
        for _ in range(8):
            crc = ((crc << 1) ^ 0x1021) & 0xFFFF if crc & 0x8000 else (crc << 1) & 0xFFFF
    return crc


def build_blob(path: str) -> bytes:
    """Wrap the file in a self-describing manifest, then gzip the whole thing.

    Layout before compression:
        QRTX1\n<filename>\n<sha256 of content>\n<content bytes>
    """
    with open(path, "rb") as fh:
        content = fh.read()
    digest = hashlib.sha256(content).hexdigest()
    name = os.path.basename(path)
    manifest = f"{PROTO}\n{name}\n{digest}\n".encode("utf-8")
    return gzip.compress(manifest + content, 9)


def chunk_blob(blob: bytes, payload_size: int, session: int):
    total = (len(blob) + payload_size - 1) // payload_size
    if total > 0xFFFF:
        sys.exit("File is too large for this frame size. Split it first.")
    frames = []
    for idx in range(total):
        payload = blob[idx * payload_size:(idx + 1) * payload_size]
        head = MAGIC + struct.pack(">HHH", session, total, idx)
        body = head + payload
        frame = body + struct.pack(">H", crc16_ccitt(body))
        frames.append(b45_encode(frame))
    return frames


def make_qr(text: str, version: int):
    return segno.make(text, version=version, error="h", mode="alphanumeric")


# --------------------------------------------------------------------------
# Display
# --------------------------------------------------------------------------

def show_loop(frames, version, fps, session, max_passes=0):
    import tkinter as tk

    delay = int(1000 / fps)
    root = tk.Tk()
    root.title("qrsend")
    root.configure(bg="white")
    root.attributes("-fullscreen", True)

    canvas = tk.Canvas(root, bg="white", highlightthickness=0)
    canvas.pack(fill="both", expand=True)
    label = tk.Label(root, bg="white", fg="black", font=("monospace", 16))
    label.pack(side="bottom", pady=8)

    root.update_idletasks()
    screen_h = root.winfo_height() - 60
    screen_w = root.winfo_width()

    # Render each frame on demand rather than all up front. Building every
    # image before the first paint caused a white screen and an unresponsive
    # window (Esc ignored) on large files. Geometry is constant because every
    # frame uses the same QR version, so compute it once from frame 0.
    side = len(make_qr(frames[0], version).matrix)
    quiet = 6
    total_modules = side + 2 * quiet
    scale = max(3, min(screen_w, screen_h) // total_modules)
    px = total_modules * scale

    from collections import OrderedDict
    cache = OrderedDict()
    CACHE_MAX = 128

    def render(i):
        hit = cache.get(i)
        if hit is not None:
            cache.move_to_end(i)
            return hit
        rows = make_qr(frames[i], version).matrix
        img = tk.PhotoImage(width=px, height=px)
        img.put("white", to=(0, 0, px, px))
        for r, row in enumerate(rows):
            run_start = None
            for c in range(side + 1):
                dark = c < side and row[c]
                if dark and run_start is None:
                    run_start = c
                elif not dark and run_start is not None:
                    x0 = (quiet + run_start) * scale
                    x1 = (quiet + c) * scale
                    y0 = (quiet + r) * scale
                    y1 = y0 + scale
                    img.put("black", to=(x0, y0, x1, y1))
                    run_start = None
        cache[i] = img
        if len(cache) > CACHE_MAX:
            cache.popitem(last=False)
        return img

    n = len(frames)
    img_id = canvas.create_image(screen_w // 2, screen_h // 2, image=render(0))
    state = {"i": 0, "pass": 1}

    def tick():
        i = state["i"]
        canvas.itemconfig(img_id, image=render(i))
        cap = f"/{max_passes}" if max_passes else ""
        label.config(
            text=f"session {session:04X}   frame {i + 1}/{n}   "
                 f"pass {state['pass']}{cap}"
        )
        state["i"] = (i + 1) % n
        if state["i"] == 0:
            if max_passes and state["pass"] >= max_passes:
                root.after(delay, root.destroy)   # hold last frame, then quit
                return
            state["pass"] += 1
        root.after(delay, tick)

    root.bind("<Escape>", lambda e: root.destroy())
    root.bind("q", lambda e: root.destroy())
    root.focus_force()          # so key bindings receive Esc immediately
    root.after(delay, tick)     # start via the event loop, not inline
    root.mainloop()


def dump_frames(frames, version, out_dir):
    os.makedirs(out_dir, exist_ok=True)
    for i, text in enumerate(frames):
        qr = make_qr(text, version)
        qr.save(os.path.join(out_dir, f"frame_{i:04d}.png"), scale=10, border=6)
    print(f"Wrote {len(frames)} PNGs to {out_dir}")


def main():
    ap = argparse.ArgumentParser(description="Send a small file as a loop of QR codes.")
    ap.add_argument("file")
    ap.add_argument("--version", type=int, default=6, choices=sorted(ALNUM_CAP_H),
                    help="QR version, 4-15. Lower = larger modules = survives "
                         "compression better but needs more frames. Default 6.")
    ap.add_argument("--fps", type=float, default=2.0,
                    help="Frames per second. Default 2 -- slow enough for a "
                         "remote desktop to fully paint each code.")
    ap.add_argument("--passes", type=int, default=0, metavar="N",
                    help="Stop automatically after N full loops, then exit. The "
                         "receiver completes in about one pass, so 3-5 gives margin "
                         "with no back-channel. Default 0 = loop until Esc.")
    ap.add_argument("--dump-dir", help="Write PNG frames here instead of opening a window.")
    args = ap.parse_args()

    cap_chars = ALNUM_CAP_H[args.version]
    payload_size = (cap_chars // 3) * 2 - FRAME_OVERHEAD
    if payload_size < 8:
        sys.exit("QR version too small to carry a useful payload. Use --version 6 or higher.")

    blob = build_blob(args.file)
    session = int.from_bytes(os.urandom(2), "big")
    frames = chunk_blob(blob, payload_size, session)

    raw = os.path.getsize(args.file)
    secs = len(frames) / args.fps
    print(f"File        {args.file}  ({raw} bytes)")
    print(f"Compressed  {len(blob)} bytes")
    print(f"QR          version {args.version}, ECC H, {payload_size} bytes/frame")
    print(f"Frames      {len(frames)}   one full pass = {secs:.0f}s at {args.fps} fps")
    print(f"Session     {session:04X}")
    if args.passes:
        print(f"Auto-stop   after {args.passes} passes (~{secs * args.passes:.0f}s)")

    if args.dump_dir:
        dump_frames(frames, args.version, args.dump_dir)
    else:
        stop = f"after {args.passes} passes" if args.passes else "Press Esc or q"
        print(f"\nFullscreen window opening. Stops {stop}.")
        show_loop(frames, args.version, args.fps, session, args.passes)


if __name__ == "__main__":
    main()
