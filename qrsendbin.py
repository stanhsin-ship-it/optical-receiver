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


def build_blob(path: str):
    """Return (blob, flags, digest). Compression is used only if it wins."""
    with open(path, "rb") as fh:
        content = fh.read()
    digest = hashlib.sha256(content).hexdigest()
    manifest = f"{PROTO}\n{os.path.basename(path)}\n{digest}\n".encode("utf-8")
    plain = manifest + content
    packed = gzip.compress(plain, 9)
    if len(packed) < len(plain):
        return packed, FLAG_GZIP, digest
    return plain, 0, digest


def session_from(digest: str) -> int:
    """Derive the session from content, so a replay matches the live session."""
    return int(digest[:4], 16)


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

def show_loop(frames, indices, version, fps, session, max_passes=0):
    import tkinter as tk

    delay = int(1000 / fps)
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

    matrices = [[list(row) for row in make_qr(f, version).matrix] for f in frames]
    side = len(matrices[0])
    quiet = 6
    span = side + 2 * quiet
    scale = max(3, min(screen_w, screen_h) // span)

    images = []
    for rows in matrices:
        px = span * scale
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
        images.append(img)

    img_id = canvas.create_image(screen_w // 2, screen_h // 2, image=images[0])
    state = {"i": 0, "pass": 1}

    def tick():
        i = state["i"]
        canvas.itemconfig(img_id, image=images[i])
        cap = f"/{max_passes}" if max_passes else ""
        label.config(text=f"session {session:04X}   frame {indices[i]}   "
                          f"({i + 1}/{len(images)})   pass {state['pass']}{cap}")
        state["i"] = (i + 1) % len(images)
        if state["i"] == 0:
            # Just displayed the last frame of this pass. Stop if we've now
            # shown the requested number of full passes -- but hold this final
            # frame on screen for its full duration first, so the receiver has
            # a fair chance at it.
            if max_passes and state["pass"] >= max_passes:
                root.after(delay, root.destroy)
                return
            state["pass"] += 1
        root.after(delay, tick)

    root.bind("<Escape>", lambda e: root.destroy())
    root.bind("q", lambda e: root.destroy())
    tick()
    root.mainloop()


def dump_frames(frames, indices, version, out_dir):
    os.makedirs(out_dir, exist_ok=True)
    for text, idx in zip(frames, indices):
        make_qr(text, version).save(
            os.path.join(out_dir, f"frame_{idx:05d}.png"), scale=10, border=6)
    print(f"Wrote {len(frames)} PNGs to {out_dir}")


def main():
    ap = argparse.ArgumentParser(description="Send a binary file as a loop of QR codes.")
    ap.add_argument("file")
    ap.add_argument("--version", type=int, default=6, choices=sorted(ALNUM_CAP_H),
                    help="QR version, 4-15. Lower survives compression better but "
                         "needs more frames. Default 6.")
    ap.add_argument("--fps", type=float, default=2.0, help="Frames per second. Default 2.")
    ap.add_argument("--passes", type=int, default=0, metavar="N",
                    help="Stop automatically after N full loops through the frames, "
                         "then exit. The screen-capture receiver completes in about "
                         "one pass, so 3-5 gives comfortable margin with no back-channel. "
                         "Default 0 = loop forever until you press Esc.")
    ap.add_argument("--only", help="Replay only these frames, e.g. 7,19,55-61. Use the "
                                   "same --version as the original run.")
    ap.add_argument("--dump-dir", help="Write PNG frames here instead of opening a window.")
    args = ap.parse_args()

    payload_size = (ALNUM_CAP_H[args.version] // 3) * 2 - FRAME_OVERHEAD
    if payload_size < 8:
        sys.exit("QR version too small. Use --version 6 or higher.")

    blob, flags, digest = build_blob(args.file)
    session = session_from(digest)
    frames = chunk_blob(blob, payload_size, session, flags)
    indices = list(range(len(frames)))

    if args.only:
        indices = parse_only(args.only, len(frames))
        frames = [frames[i] for i in indices]

    raw = os.path.getsize(args.file)
    print(f"File        {args.file}  ({raw} bytes)")
    print(f"Encoded     {len(blob)} bytes  ({'gzip' if flags & FLAG_GZIP else 'raw — gzip did not help'})")
    print(f"QR          version {args.version}, ECC H, {payload_size} bytes/frame")
    print(f"Session     {session:04X}")
    if args.only:
        print(f"Replaying   {len(frames)} of {len(blob) // payload_size + 1} frames: {args.only}")
    else:
        pass_secs = len(frames) / args.fps
        print(f"Frames      {len(frames)}   one pass = {pass_secs:.0f}s at {args.fps} fps")
        if args.passes:
            print(f"Auto-stop   after {args.passes} passes (~{pass_secs * args.passes:.0f}s)")

    if args.dump_dir:
        dump_frames(frames, indices, args.version, args.dump_dir)
    else:
        stop = "after " + str(args.passes) + " passes" if args.passes else "Press Esc or q"
        print(f"\nFullscreen window opening. Stops {stop}.")
        show_loop(frames, indices, args.version, args.fps, session, args.passes)


if __name__ == "__main__":
    main()
