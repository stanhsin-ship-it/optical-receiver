#!/usr/bin/env python3
"""
qrsendbin.py -- optical sender for arbitrary binary files.

Same optical channel as qrsend.py, with three changes that matter for binary:

  * gzip is applied only when it actually helps, so already-compressed files
    (zip, png, jpg, tar.gz) don't grow.
  * Binary files run long. The receiver reports which frame indices it is
    still missing, and --only replays just those instead of the whole file.
  * The payload is never decoded as text anywhere in the pipeline.

Usage:
    python3 qrsendbin.py firmware.bin
    python3 qrsendbin.py firmware.bin --version 10 --fps 3
    python3 qrsendbin.py firmware.bin --only 7,19,55-61     # replay gaps
    python3 qrsendbin.py firmware.bin --dump-dir ./frames   # calibration PNGs

--only must be given the same --version and --fps as the original run, or the
frame boundaries won't line up. The session ID is derived from the file
contents, so a replay always matches the session already on the receiver.

Requires: segno  (pip install segno --user)
Display uses tkinter.
"""

import argparse
import gzip
import hashlib
import os
import struct
import sys

import segno

MAGIC = b"QB"
PROTO = "QRTX2"

# magic(2) session(2) flags(1) total(2) idx(2) + CRC16(2)
FRAME_OVERHEAD = 11

FLAG_GZIP = 0x01

ALNUM_CAP_H = {
    4: 50, 5: 64, 6: 84, 7: 93, 8: 122, 9: 143, 10: 174,
    11: 200, 12: 227, 13: 259, 14: 283, 15: 321,
    16: 365, 17: 408, 18: 452, 19: 493, 20: 557,
    21: 587, 22: 640, 23: 672, 24: 744, 25: 779,
    26: 864, 27: 910, 28: 958, 29: 1016, 30: 1080,
    31: 1150, 32: 1226, 33: 1307, 34: 1394, 35: 1431,
    36: 1530, 37: 1591, 38: 1658, 39: 1774, 40: 1852,
}

BASE45_CHARSET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:"


def b45_encode(data: bytes) -> str:
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


def read_input(path: str):
    """Return (content_bytes, name).

    A plain file is read as-is. A folder is packed into a single deterministic
    .tar in memory, preserving the top folder name and subfolder structure, so
    the whole directory travels as one transfer and rebuilds with `tar xf` on
    the far side.
    """
    if os.path.isdir(path):
        import io
        import tarfile

        root = os.path.normpath(path)
        base = os.path.basename(root) or "folder"
        parent = os.path.dirname(root)

        entries = []
        for dirpath, dirnames, filenames in os.walk(root):
            dirnames.sort()
            for fn in sorted(filenames):
                full = os.path.join(dirpath, fn)
                arc = os.path.relpath(full, parent)  # keeps the top folder name
                entries.append((full, arc.replace(os.sep, "/")))
        if not entries:
            sys.exit(f"Folder {path!r} has no files to send.")

        buf = io.BytesIO()
        with tarfile.open(fileobj=buf, mode="w") as tar:
            for full, arc in entries:
                # Zero volatile metadata so the same folder yields the same tar
                # (and thus the same session id) each run.
                ti = tar.gettarinfo(full, arcname=arc)
                ti.mtime = 0
                ti.uid = ti.gid = 0
                ti.uname = ti.gname = ""
                with open(full, "rb") as fh:
                    tar.addfile(ti, fh)
        print(f"Packed {len(entries)} file(s) from {root}/ into {base}.tar")
        return buf.getvalue(), base + ".tar"

    with open(path, "rb") as fh:
        return fh.read(), os.path.basename(path)


def build_blob_bytes(content: bytes, name: str):
    """Return (blob, flags, digest) for raw bytes with a given logical name."""
    digest = hashlib.sha256(content).hexdigest()
    manifest = f"{PROTO}\n{name}\n{digest}\n".encode("utf-8")
    plain = manifest + content
    packed = gzip.compress(plain, 9)
    if len(packed) < len(plain):
        return packed, FLAG_GZIP, digest
    return plain, 0, digest


def build_blob(path: str):
    """Return (blob, flags, digest). Compression is used only if it wins."""
    content, name = read_input(path)
    return build_blob_bytes(content, name)


def plan_segments(content: bytes, name: str, payload_size: int, split_size: int):
    """Turn one logical file into a list of segments to play in sequence.

    Small input -> a single segment (unchanged behaviour, one session).
    Large input -> a manifest segment plus one segment per part, each its own
    session, so the receiver can save the parts and auto-join them. Every
    segment is (session, frames, indices, label, name).
    """
    single_blob, single_flags, single_digest = build_blob_bytes(content, name)
    single_frames = chunk_blob(single_blob, payload_size,
                               session_from(single_digest), single_flags)

    # Keep it one session unless splitting genuinely reduces the babysitting,
    # i.e. the whole thing wouldn't comfortably land in a couple of passes.
    if len(single_frames) <= split_size // payload_size + 1 or split_size <= 0:
        return [{
            "session": session_from(single_digest),
            "frames": single_frames,
            "indices": list(range(len(single_frames))),
            "label": name,
            "name": name,
        }], False

    # Split: parts named like qrsplit, plus a JSON manifest, each as a segment.
    import json as _json
    whole_sha = hashlib.sha256(content).hexdigest()
    total = (len(content) + split_size - 1) // split_size
    width = max(3, len(str(total)))

    used_sids = set()

    def unique_sid(seed_digest):
        # Content-derived id, but nudged to stay unique within this batch so two
        # parts can't share a 16-bit session id and be conflated by the receiver.
        sid = session_from(seed_digest)
        while sid in used_sids:
            sid = (sid + 1) & 0xFFFF
        used_sids.add(sid)
        return sid

    segments = []
    for idx in range(total):
        chunk = content[idx * split_size:(idx + 1) * split_size]
        pname = f"{name}.qrpart{idx + 1:0{width}d}-of-{total}"
        blob, flags, digest = build_blob_bytes(chunk, pname)
        session = unique_sid(digest)
        frames = chunk_blob(blob, payload_size, session, flags)
        segments.append({
            "session": session, "frames": frames,
            "indices": list(range(len(frames))),
            "label": f"part {idx + 1}/{total}", "name": pname,
        })
    manifest = {
        "format": "qrpack1", "name": name, "size": len(content),
        "sha256": whole_sha, "parts": total, "part_size": split_size,
        "part_width": width,
    }
    mname = f"{name}.qrmanifest"
    mbytes = _json.dumps(manifest, indent=2).encode("utf-8")
    blob, flags, digest = build_blob_bytes(mbytes, mname)
    session = unique_sid(digest)
    mframes = chunk_blob(blob, payload_size, session, flags)
    # Manifest first, so the receiver knows the total up front.
    segments.insert(0, {
        "session": session, "frames": mframes,
        "indices": list(range(len(mframes))),
        "label": f"manifest (0/{total})", "name": mname,
    })
    return segments, True


def session_from(digest: str) -> int:
    """Derive the session from content, so a replay matches the live session."""
    return int(digest[:4], 16)


def parse_size(s: str) -> int:
    s = str(s).strip().lower()
    mult = 1
    if s.endswith("k"):
        mult, s = 1024, s[:-1]
    elif s.endswith("m"):
        mult, s = 1024 * 1024, s[:-1]
    try:
        return int(float(s) * mult)
    except ValueError:
        sys.exit(f"Bad size value: {s!r}. Use e.g. 40k, 256k, 1m, or a byte count.")


def chunk_blob(blob: bytes, payload_size: int, session: int, flags: int):
    total = (len(blob) + payload_size - 1) // payload_size
    if total > 0xFFFF:
        sys.exit(f"{total} frames exceeds the 65535 limit. Split the file or raise --version.")
    frames = []
    for idx in range(total):
        payload = blob[idx * payload_size:(idx + 1) * payload_size]
        body = MAGIC + struct.pack(">HBHH", session, flags, total, idx) + payload
        frames.append(b45_encode(body + struct.pack(">H", crc16_ccitt(body))))
    return frames


def parse_only(spec: str, total: int):
    """Parse '7,19,55-61' into a sorted list of indices."""
    want = set()
    for part in spec.split(","):
        part = part.strip()
        if not part:
            continue
        if "-" in part:
            a, b = part.split("-", 1)
            want.update(range(int(a), int(b) + 1))
        else:
            want.add(int(part))
    bad = [i for i in want if i >= total or i < 0]
    if bad:
        sys.exit(f"Frame indices out of range (file has {total}): {sorted(bad)}")
    return sorted(want)


def make_qr(text: str, version: int):
    return segno.make(text, version=version, error="h", mode="alphanumeric")


# --------------------------------------------------------------------------

def show_loop(segments, version, fps, max_passes=0):
    """Play a list of segments in sequence, each its own session, looping the
    whole list max_passes times (0 = forever). A single-file transfer is just a
    one-element list, so behaviour there is unchanged. A short blank gap between
    segments lets the receiver's settled-frame gate finalise each session before
    the next one starts."""
    import tkinter as tk

    delay = int(1000 / fps)
    gap_ticks = 2                      # blank frames between segments
    root = tk.Tk()
    root.title("qrsendbin")
    root.configure(bg="white")
    root.attributes("-fullscreen", True)

    canvas = tk.Canvas(root, bg="white", highlightthickness=0)
    canvas.pack(fill="both", expand=True)
    label = tk.Label(root, bg="white", fg="black", font=("monospace", 16))
    label.pack(side="bottom", pady=8)

    root.update_idletasks()
    screen_h = root.winfo_height() - 60
    screen_w = root.winfo_width()

    # Geometry is constant across all frames of all segments (same QR version).
    first_frame = segments[0]["frames"][0]
    side = len(make_qr(first_frame, version).matrix)
    quiet = 6
    span = side + 2 * quiet
    scale = max(3, min(screen_w, screen_h) // span)
    px = span * scale

    from collections import OrderedDict
    cache = OrderedDict()
    CACHE_MAX = 128

    blank = tk.PhotoImage(width=px, height=px)
    blank.put("white", to=(0, 0, px, px))

    def render(text):
        hit = cache.get(text)
        if hit is not None:
            cache.move_to_end(text)
            return hit
        rows = make_qr(text, version).matrix
        img = tk.PhotoImage(width=px, height=px)
        img.put("white", to=(0, 0, px, px))
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
        cache[text] = img
        if len(cache) > CACHE_MAX:
            cache.popitem(last=False)
        return img

    img_id = canvas.create_image(screen_w // 2, screen_h // 2, image=blank)
    st = {"seg": 0, "i": 0, "pass": 1, "gap": gap_ticks}   # start with a gap

    def tick():
        # Blank gap between segments / before the first one.
        if st["gap"] > 0:
            canvas.itemconfig(img_id, image=blank)
            seg = segments[st["seg"]]
            cap = f"/{max_passes}" if max_passes else ""
            label.config(text=f"{seg['label']}   (starting…)   pass {st['pass']}{cap}")
            st["gap"] -= 1
            root.after(delay, tick)
            return

        seg = segments[st["seg"]]
        frames = seg["frames"]
        i = st["i"]
        canvas.itemconfig(img_id, image=render(frames[i]))
        cap = f"/{max_passes}" if max_passes else ""
        label.config(text=f"{seg['label']}   frame {seg['indices'][i]} "
                          f"({i + 1}/{len(frames)})   sess {seg['session']:04X}   "
                          f"pass {st['pass']}{cap}")

        st["i"] += 1
        if st["i"] >= len(frames):
            st["i"] = 0
            st["seg"] += 1
            st["gap"] = gap_ticks
            if st["seg"] >= len(segments):        # finished a full pass
                st["seg"] = 0
                if max_passes and st["pass"] >= max_passes:
                    root.after(delay, root.destroy)
                    return
                st["pass"] += 1
        root.after(delay, tick)

    root.bind("<Escape>", lambda e: root.destroy())
    root.bind("q", lambda e: root.destroy())
    root.focus_force()
    root.after(delay, tick)
    root.mainloop()


def dump_frames(frames, indices, version, out_dir):
    os.makedirs(out_dir, exist_ok=True)
    for text, idx in zip(frames, indices):
        make_qr(text, version).save(
            os.path.join(out_dir, f"frame_{idx:05d}.png"), scale=10, border=6)
    print(f"Wrote {len(frames)} PNGs to {out_dir}")


def main():
    ap = argparse.ArgumentParser(description="Send a binary file as a loop of QR codes.")
    ap.add_argument("file", help="File to send, OR a folder (packed into one .tar "
                                 "and sent whole; rebuild on the far side with tar xf).")
    ap.add_argument("--version", type=int, default=6, choices=sorted(ALNUM_CAP_H),
                    help="QR version, 4-40 (40 is the largest the QR standard "
                         "defines). Higher packs more bytes/frame (fewer frames) but "
                         "the code is denser and NoMachine compression may blur it "
                         "past decoding. Above ~15, test one frame over your real NX "
                         "link before a full run. Default 6.")
    ap.add_argument("--fps", type=float, default=2.0, help="Frames per second. Default 2.")
    ap.add_argument("--passes", type=int, default=0, metavar="N",
                    help="Stop automatically after N full loops through the frames, "
                         "then exit. The screen-capture receiver completes in about "
                         "one pass, so 3-5 gives comfortable margin with no back-channel. "
                         "Default 0 = loop forever until you press Esc.")
    ap.add_argument("--only", help="Replay only these frames of a SINGLE file/part, "
                                   "e.g. 7,19,55-61. Use the same --version as the "
                                   "original run. Not for auto-split transfers.")
    ap.add_argument("--split-size", default="40k", metavar="BYTES",
                    help="When a transfer is large, auto-split into parts of about "
                         "this size (k/m suffixes ok). Default 40k.")
    ap.add_argument("--no-split", action="store_true",
                    help="Never auto-split; send as one long session no matter the size.")
    ap.add_argument("--dump-dir", help="Write PNG frames here instead of opening a window "
                                       "(single-session only; ignores auto-split).")
    args = ap.parse_args()

    payload_size = (ALNUM_CAP_H[args.version] // 3) * 2 - FRAME_OVERHEAD
    if payload_size < 8:
        sys.exit("QR version too small. Use --version 6 or higher.")

    # --only and --dump-dir operate on a single session (gap-fill / calibration).
    if args.only or args.dump_dir:
        blob, flags, digest = build_blob(args.file)
        session = session_from(digest)
        frames = chunk_blob(blob, payload_size, session, flags)
        indices = list(range(len(frames)))
        if args.only:
            indices = parse_only(args.only, len(frames))
            frames = [frames[i] for i in indices]
        print(f"Session     {session:04X}   frames {len(frames)}")
        if args.dump_dir:
            dump_frames(frames, indices, args.version, args.dump_dir)
        else:
            print(f"\nReplaying {len(frames)} frames. Press Esc or q to stop.")
            seg = [{"session": session, "frames": frames, "indices": indices,
                    "label": f"replay {args.only}", "name": args.file}]
            show_loop(seg, args.version, args.fps, args.passes)
        return

    content, name = read_input(args.file)
    split_size = 0 if args.no_split else parse_size(args.split_size)
    segments, was_split = plan_segments(content, name, payload_size, split_size)

    total_frames = sum(len(s["frames"]) for s in segments)
    if os.path.isdir(args.file):
        print(f"Input       {args.file}  (folder → tar, {len(content)} bytes)")
    else:
        print(f"File        {args.file}  ({os.path.getsize(args.file)} bytes)")
    print(f"QR          version {args.version}, ECC H, {payload_size} bytes/frame")
    if was_split:
        parts = len(segments) - 1
        print(f"Auto-split  {parts} parts + manifest, {total_frames} frames total")
        print(f"            receiver rebuilds automatically (qrgrab). Manifest sent first.")
    else:
        print(f"Session     {segments[0]['session']:04X}")
    pass_secs = total_frames / args.fps
    print(f"Frames      {total_frames}   one full pass = {pass_secs:.0f}s at {args.fps} fps")
    if args.passes:
        print(f"Auto-stop   after {args.passes} passes (~{pass_secs * args.passes:.0f}s)")

    # Very large even after splitting: warn before opening a multi-hour run.
    if total_frames > 400:
        pass_min = pass_secs / 60
        print(f"\n⚠  {total_frames} frames ≈ {pass_min:.0f} min per pass. "
              f"That's a lot for an optical link.")
        if not was_split:
            print("   Tip: drop --no-split, raise --version, or shrink the input.")
        try:
            if input("   Continue anyway? [y/N] ").strip().lower() != "y":
                print("   Aborted.")
                return
        except EOFError:
            pass

    stop = f"after {args.passes} passes" if args.passes else "Press Esc or q"
    if os.path.isdir(args.file):
        print("Receiver saves one .tar; rebuild it there with:  "
              f"tar xf {os.path.basename(os.path.normpath(args.file))}.tar")
    print(f"\nFullscreen window opening. Stops {stop}.")
    show_loop(segments, args.version, args.fps, args.passes)


if __name__ == "__main__":
    main()
