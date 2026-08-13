#!/usr/bin/env python3
"""
qrgrab.py -- screen-capture receiver for the optical QR file transfer.

Runs on the NoMachine CLIENT (your laptop or desktop), not the Linux box and
not a phone. It grabs the screen, finds the QR code anywhere in the frame with
OpenCV, and rebuilds the file. Because it reads pixels straight from the
framebuffer there is no lens, no blur, and no secure-origin requirement -- the
only quality loss is whatever NoMachine already applied.

It accepts both senders:
    qrsend.py    / qrrecv.html    -> proto QRTX1, magic 'QT'  (text)
    qrsendbin.py / qrrecvbin.html -> proto QRTX2, magic 'QB'  (binary, may gzip)

Usage:
    python3 qrgrab.py                      # capture the primary monitor
    python3 qrgrab.py --monitor 2          # a specific monitor
    python3 qrgrab.py --fps 15 --out ./in  # grab rate and output folder

The sender loops forever, so start this first or second -- it joins mid-stream.
It stops on its own once every frame is in and the SHA-256 checks out.
Ctrl-C to quit early; it prints which frame indices are still missing so you
can replay just those with  qrsendbin.py --only ...

Requires: opencv-python-headless (or opencv-python), mss, numpy.
    pip install opencv-python-headless mss numpy --user
"""

import argparse
import gzip
import hashlib
import os
import struct
import sys
import time

import numpy as np
from mss import mss

# Two decoders, chosen at startup. pyzbar (the ZBar library) is markedly more
# robust on marginal codes than OpenCV -- in testing it read frames OpenCV
# silently failed on, which on a loop would stall forever. So it's preferred.
# OpenCV is the fallback when the ZBar system library isn't installed.
_DECODER = None
try:
    from pyzbar.pyzbar import decode as _zbar_decode, ZBarSymbol
    _DECODER = "pyzbar"
except Exception:
    pass

import cv2  # always used for colour conversion / resize, and as decode fallback
if _DECODER is None:
    _DECODER = "opencv"

BASE45_CHARSET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:"
B45_REV = {c: i for i, c in enumerate(BASE45_CHARSET)}

# proto -> (magic bytes, header length after magic incl. crc trailer, has flags)
#   QT: magic(2) session(2) total(2) idx(2) payload CRC16(2)      -> overhead 10
#   QB: magic(2) session(2) flags(1) total(2) idx(2) payload CRC16(2) -> overhead 11
TEXT_MAGIC = b"QT"
BIN_MAGIC = b"QB"


def b45_decode(s: str):
    out = bytearray()
    i = 0
    n = len(s)
    while i < n:
        left = n - i
        if left >= 3:
            try:
                c, d, e = B45_REV[s[i]], B45_REV[s[i + 1]], B45_REV[s[i + 2]]
            except KeyError:
                return None
            v = c + d * 45 + e * 45 * 45
            if v > 0xFFFF:
                return None
            out += bytes((v >> 8, v & 0xFF))
            i += 3
        elif left == 2:
            try:
                c, d = B45_REV[s[i]], B45_REV[s[i + 1]]
            except KeyError:
                return None
            v = c + d * 45
            if v > 0xFF:
                return None
            out.append(v)
            i += 2
        else:
            return None
    return bytes(out)


def crc16_ccitt(data: bytes) -> int:
    crc = 0xFFFF
    for byte in data:
        crc ^= byte << 8
        for _ in range(8):
            crc = ((crc << 1) ^ 0x1021) & 0xFFFF if crc & 0x8000 else (crc << 1) & 0xFFFF
    return crc


class Session:
    """Collects frames for one transfer and reassembles when complete."""

    def __init__(self):
        self.sid = None
        self.total = None
        self.flags = 0
        self.proto = None
        self.chunks = {}

    def offer(self, text: str) -> bool:
        """Feed one decoded QR string. Returns True if it added a new frame."""
        raw = b45_decode(text.strip())
        if not raw or len(raw) < 10:
            return False

        if raw[:2] == BIN_MAGIC:
            proto, hdr = "QRTX2", 9        # magic2 sid2 flags1 total2 idx2
        elif raw[:2] == TEXT_MAGIC:
            proto, hdr = "QRTX1", 8        # magic2 sid2 total2 idx2
        else:
            return False

        body_len = len(raw) - 2
        if crc16_ccitt(raw[:body_len]) != struct.unpack(">H", raw[body_len:])[0]:
            return False

        sid = struct.unpack(">H", raw[2:4])[0]
        if proto == "QRTX2":
            flags = raw[4]
            total, idx = struct.unpack(">HH", raw[5:9])
        else:
            flags = 0
            total, idx = struct.unpack(">HH", raw[4:8])
        if idx >= total:
            return False

        if self.sid is None:
            self.sid, self.total, self.flags, self.proto = sid, total, flags, proto
            print(f"\nSignal locked: session {sid:04X}, {proto}, {total} frames"
                  f"{', gzip' if flags & 1 else ''}")
        elif sid != self.sid:
            return False  # a different file; ignore until reset

        if idx in self.chunks:
            return False
        self.chunks[idx] = raw[hdr:body_len]
        return True

    @property
    def complete(self):
        return self.total is not None and len(self.chunks) == self.total

    def missing_spec(self):
        if self.total is None:
            return ""
        gaps = [i for i in range(self.total) if i not in self.chunks]
        if not gaps:
            return ""
        runs, a, b = [], gaps[0], gaps[0]
        for g in gaps[1:]:
            if g == b + 1:
                b = g
                continue
            runs.append(str(a) if a == b else f"{a}-{b}")
            a = b = g
        runs.append(str(a) if a == b else f"{a}-{b}")
        return ",".join(runs)

    def assemble(self, out_dir):
        blob = b"".join(self.chunks[i] for i in range(self.total))
        # QRTX1 (text sender) always gzips and carries no flag; QRTX2 (binary)
        # sets bit 0 only when gzip actually helped.
        gzipped = (self.proto == "QRTX1") or bool(self.flags & 1)
        if gzipped:
            try:
                blob = gzip.decompress(blob)
            except OSError:
                return None, "gzip decompression failed -- frames corrupt"
        # manifest: PROTO \n name \n sha256 \n <content>
        # maxsplit=3 keeps any newlines inside the file content intact.
        parts = blob.split(b"\n", 3)
        if len(parts) < 4:
            return None, "payload manifest malformed"
        proto, name, want = parts[0].decode(errors="replace"), \
            parts[1].decode(errors="replace"), parts[2].decode(errors="replace")
        content = parts[3]
        got = hashlib.sha256(content).hexdigest()
        if got != want:
            return None, f"checksum mismatch (want {want[:12]}…, got {got[:12]}…)"
        os.makedirs(out_dir, exist_ok=True)
        safe = os.path.basename(name) or "received.bin"
        path = os.path.join(out_dir, safe)
        with open(path, "wb") as fh:
            fh.write(content)
        return path, None


def decode_frame(gray, detector):
    """Return a list of decoded QR strings found in a grayscale image.

    pyzbar: one call finds every QR anywhere in the frame and is the more
    forgiving reader. opencv: multi, then single, then a 2x upscale for codes
    whose modules came through a little soft.
    """
    if _DECODER == "pyzbar":
        out = []
        for sym in _zbar_decode(gray, symbols=[ZBarSymbol.QRCODE]):
            try:
                out.append(sym.data.decode("ascii"))
            except UnicodeDecodeError:
                pass  # our frames are always Base45/ASCII; anything else isn't ours
        return out

    hits = []
    ok, texts, _pts, _straight = detector.detectAndDecodeMulti(gray)
    if ok and texts:
        hits += [t for t in texts if t]
    if not hits:
        t, _, _ = detector.detectAndDecode(gray)
        if t:
            hits.append(t)
    if not hits:
        big = cv2.resize(gray, None, fx=2, fy=2, interpolation=cv2.INTER_CUBIC)
        t, _, _ = detector.detectAndDecode(big)
        if t:
            hits.append(t)
    return hits


def draw_bar(got, total, width=32):
    filled = int(width * got / total) if total else 0
    return "[" + "#" * filled + "." * (width - filled) + f"] {got}/{total}"


def main():
    ap = argparse.ArgumentParser(description="Screen-capture receiver for optical QR transfer.")
    ap.add_argument("--monitor", type=int, default=1,
                    help="Monitor number as mss sees it (1 = primary). Default 1.")
    ap.add_argument("--fps", type=float, default=15.0,
                    help="Screen grabs per second. Default 15 -- well above the "
                         "2 fps sender, so every frame is caught on the first pass.")
    ap.add_argument("--out", default="./received", help="Output folder. Default ./received")
    ap.add_argument("--scale", type=float, default=1.0,
                    help="Downscale factor before detection, e.g. 0.5 on a 4K screen "
                         "to speed up. QR must stay large enough to decode. Default 1.0.")
    ap.add_argument("--no-stable", action="store_true",
                    help="Disable the settled-frame gate. By default a frame is only "
                         "decoded once two consecutive grabs match, which rejects "
                         "codes caught mid-repaint by NoMachine. Turn off only if the "
                         "screen never holds a code still.")
    args = ap.parse_args()

    detector = cv2.QRCodeDetector()
    sess = Session()
    period = 1.0 / args.fps
    last_report = 0.0
    grabbed = 0
    prev = None          # previous grayscale grab, for the settled-frame gate
    stable = not args.no_stable

    with mss() as sct:
        if args.monitor >= len(sct.monitors):
            sys.exit(f"Monitor {args.monitor} not found. Available: 1..{len(sct.monitors)-1}")
        mon = sct.monitors[args.monitor]
        print(f"Capturing monitor {args.monitor}  {mon['width']}x{mon['height']}"
              f"  at {args.fps:g} fps  (decoder: {_DECODER})")
        if _DECODER == "opencv":
            print("Note: using OpenCV. pyzbar decodes marginal frames more "
                  "reliably — install libzbar0 + pyzbar if frames stall.")
        print("Waiting for QR signal. Fill the captured area with the sending window.")
        print("Ctrl-C to stop.\n")

        try:
            while True:
                t0 = time.time()
                frame = np.asarray(sct.grab(mon))          # BGRA
                grabbed += 1
                img = cv2.cvtColor(frame, cv2.COLOR_BGRA2GRAY)
                if args.scale != 1.0:
                    img = cv2.resize(img, None, fx=args.scale, fy=args.scale,
                                     interpolation=cv2.INTER_AREA)

                # Settled-frame gate: NoMachine repaints in pieces, so an
                # instantaneous grab can catch a QR half-updated. Decoding only
                # when this grab equals the last one guarantees the code has
                # stopped changing -- the single biggest win for stability.
                # The desktop behind the code is static, so equality effectively
                # tests "is the QR the same as a moment ago".
                if stable:
                    settled = prev is not None and img.shape == prev.shape \
                        and np.array_equal(img, prev)
                    prev = img
                    if not settled:
                        dt = period - (time.time() - t0)
                        if dt > 0:
                            time.sleep(dt)
                        continue

                added = False
                for t in decode_frame(img, detector):
                    if sess.offer(t):
                        added = True
                if added:
                    print("  " + draw_bar(len(sess.chunks), sess.total)
                          + "   missing: " + (sess.missing_spec() or "none"),
                          end="\r", flush=True)

                if sess.complete:
                    path, err = sess.assemble(args.out)
                    print()
                    if err:
                        print("Reassembly failed:", err)
                        print("Reset the sender and capture again, or replay --only",
                              sess.missing_spec() or "(all)")
                        return 1
                    size = os.path.getsize(path)
                    print(f"Done. Wrote {path}  ({size} bytes). Checksum verified.")
                    return 0

                now = time.time()
                if now - last_report > 3 and sess.sid is None:
                    print(f"  …scanning ({grabbed} grabs, no signal yet)", end="\r", flush=True)
                    last_report = now

                dt = period - (time.time() - t0)
                if dt > 0:
                    time.sleep(dt)

        except KeyboardInterrupt:
            print("\n\nStopped.")
            if sess.sid is None:
                print("No signal was locked.")
            else:
                miss = sess.missing_spec()
                if miss:
                    print(f"Session {sess.sid:04X}: {len(sess.chunks)}/{sess.total} frames.")
                    print(f"Replay the gaps with:  qrsendbin.py <file> --only {miss}")
                else:
                    print("All frames were present but assembly never ran -- rerun.")
            return 130


if __name__ == "__main__":
    sys.exit(main())
