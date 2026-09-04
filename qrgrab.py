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

It STAYS RUNNING. Leave one qrgrab open on the client for the whole session and
send as many files and folders from the far side as you like: each transfer is
written, verified and announced, then the receiver goes straight back to
scanning. Nothing has to be restarted between files.

Usage:
    python3 qrgrab.py                      # capture the primary monitor, stay up
    python3 qrgrab.py --monitor 2          # a specific monitor
    python3 qrgrab.py --fps 15 --out ./in  # grab rate and output folder
    python3 qrgrab.py --once               # old behaviour: exit after one file

The sender loops forever, so start this first or second -- it joins mid-stream.
Ctrl-C to stop; it prints everything received, and for any transfer left
unfinished, which frame indices are missing so you can replay just those with
  qrsendbin.py <file> --only 7,19,55-61

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
from collections import namedtuple

import numpy as np
from mss import mss as _mss_factory
try:
    from mss import MSS as _MSS
except Exception:
    _MSS = None

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

# The receiver runs on whatever client is driving the remote desktop -- macOS,
# Windows or Linux. A legacy Windows console (cp437/cp1252) cannot encode a
# tick mark or an arrow, and printing one raises UnicodeEncodeError. That used
# to cost at most one line on an already-finished run; now that a receiver is
# expected to stay up for hours it would take the whole session down mid
# transfer. So: never let stdout raise, and fall back to ASCII when the
# console can't prove it handles more.
if hasattr(sys.stdout, "reconfigure"):
    try:
        sys.stdout.reconfigure(errors="replace")
    except (ValueError, OSError):
        pass


def _console_handles(text):
    enc = getattr(sys.stdout, "encoding", None) or "ascii"
    try:
        text.encode(enc)
        return True
    except (UnicodeEncodeError, LookupError):
        return False


_FANCY = _console_handles("✅→…—")
OK = "✅" if _FANCY else "OK:"
ARROW = "→" if _FANCY else "->"
ELL = "…" if _FANCY else "..."
DASH = "—" if _FANCY else "--"

# Characters a Linux sender may legitimately put in a filename that Windows
# refuses to create. Both the saver and the auto-join build names through
# safe_name(), so a sanitised part still matches the manifest asking for it.
_WIN_BAD = '<>:"/\\|?*'
_WIN_RESERVED = ({"CON", "PRN", "AUX", "NUL"}
                 | {f"COM{i}" for i in range(1, 10)}
                 | {f"LPT{i}" for i in range(1, 10)})


def safe_name(name):
    """Return a basename the local filesystem will actually accept."""
    if os.name != "nt":
        return os.path.basename(name) or "received.bin"
    base = os.path.basename(name.replace("\\", "/")) or "received.bin"
    base = "".join("_" if (ch in _WIN_BAD or ord(ch) < 32) else ch for ch in base)
    base = base.rstrip(" .") or "received.bin"
    if base.split(".")[0].upper() in _WIN_RESERVED:
        base = "_" + base
    return base

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


Frame = namedtuple("Frame", "proto sid flags total idx payload")


def parse_frame(text: str):
    """Decode one QR string into a Frame, or None if it isn't one of ours.

    One parse serves both jobs the loop needs -- deciding which session a code
    belongs to, and collecting it -- so a frame is never decoded twice.
    """
    raw = b45_decode(text.strip())
    if not raw or len(raw) < 10:
        return None

    if raw[:2] == BIN_MAGIC:
        proto, hdr = "QRTX2", 9        # magic2 sid2 flags1 total2 idx2
    elif raw[:2] == TEXT_MAGIC:
        proto, hdr = "QRTX1", 8        # magic2 sid2 total2 idx2
    else:
        return None

    body_len = len(raw) - 2
    if crc16_ccitt(raw[:body_len]) != struct.unpack(">H", raw[body_len:])[0]:
        return None

    sid = struct.unpack(">H", raw[2:4])[0]
    if proto == "QRTX2":
        flags = raw[4]
        total, idx = struct.unpack(">HH", raw[5:9])
    else:
        flags = 0
        total, idx = struct.unpack(">HH", raw[4:8])
    if total == 0 or idx >= total:
        return None
    return Frame(proto, sid, flags, total, idx, raw[hdr:body_len])


class Session:
    """Collects frames for one transfer and reassembles when complete."""

    def __init__(self, fr: Frame):
        self.sid = fr.sid
        self.total = fr.total
        self.flags = fr.flags
        self.proto = fr.proto
        self.chunks = {}
        self.started = self.last = time.time()
        self.quiet = False   # a repeat of something already written

    def add(self, fr: Frame) -> bool:
        """Take one frame. Returns True if it was new."""
        self.last = time.time()
        if fr.total != self.total or fr.proto != self.proto:
            # Session ids are 16 bits of a content hash, so two unrelated files
            # can collide. A different frame count proves it isn't this file.
            return False
        if fr.idx in self.chunks:
            return False
        self.chunks[fr.idx] = fr.payload
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

    def decode_payload(self):
        """Return (name, content, err). Verifies the SHA-256 but writes nothing;
        the caller decides where the bytes land and how to handle collisions."""
        blob = b"".join(self.chunks[i] for i in range(self.total))
        # QRTX1 (text sender) always gzips and carries no flag; QRTX2 (binary)
        # sets bit 0 only when gzip actually helped.
        gzipped = (self.proto == "QRTX1") or bool(self.flags & 1)
        if gzipped:
            try:
                blob = gzip.decompress(blob)
            except OSError:
                return None, None, "gzip decompression failed -- frames corrupt"
        # manifest: PROTO \n name \n sha256 \n <content>
        # maxsplit=3 keeps any newlines inside the file content intact.
        parts = blob.split(b"\n", 3)
        if len(parts) < 4:
            return None, None, "payload manifest malformed"
        name = parts[1].decode(errors="replace")
        want = parts[2].decode(errors="replace")
        content = parts[3]
        got = hashlib.sha256(content).hexdigest()
        if got != want:
            return None, None, f"checksum mismatch (want {want[:12]}..., got {got[:12]}...)"
        return name, content, None


def is_piece(name):
    """True for the bookkeeping files of an auto-split transfer."""
    base = os.path.basename(name)
    return base.endswith(".qrmanifest") or (".qrpart" in base and "-of-" in base)


def save_bytes(out_dir, name, content, exact=False):
    """Write content to out_dir, never silently clobbering a different file.

    Returns (path, note) with note one of 'written', 'duplicate', 'renamed'.
    Running for hours means the same name can legitimately arrive twice, and
    losing the first copy to a same-named second transfer would be the worst
    possible failure for a tool whose whole job is moving files intact.

    exact=True keeps the literal filename: parts and manifests must keep theirs
    or the auto-join can't find them, and a re-arrived part is byte-identical
    by construction, so rewriting it costs nothing.
    """
    os.makedirs(out_dir, exist_ok=True)
    safe = safe_name(name)
    path = os.path.join(out_dir, safe)
    if os.path.exists(path):
        try:
            with open(path, "rb") as fh:
                old = fh.read()
        except OSError:
            old = None
        if old == content:
            return path, "duplicate"
        if not exact:
            stem, ext = os.path.splitext(safe)
            n = 2
            while os.path.exists(os.path.join(out_dir, f"{stem} ({n}){ext}")):
                n += 1
            path = os.path.join(out_dir, f"{stem} ({n}){ext}")
            with open(path, "wb") as fh:
                fh.write(content)
            return path, "renamed"
    with open(path, "wb") as fh:
        fh.write(content)
    return path, "written"


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


class Line:
    """Prints an updating status line with \\r, padding each write to the
    widest line seen so a shorter update fully erases the previous one.
    Without this, a short 'missing: none' printed over a long index list
    leaves stale characters behind on the terminal."""

    def __init__(self):
        self.width = 0

    def show(self, text):
        pad = max(0, self.width - len(text))
        self.width = max(self.width, len(text))
        print(text + " " * pad, end="\r", flush=True)

    def clear(self):
        if self.width:
            print(" " * self.width, end="\r", flush=True)
            self.width = 0

    def say(self, *args):
        """A permanent line that doesn't collide with the status line."""
        self.clear()
        print(*args, flush=True)


Join = namedtuple("Join", "manifest name ok detail missing total path parts")


def try_autojoin(out_dir, skip=()):
    """If a .qrmanifest and all its parts are present in out_dir, rebuild the
    original file, verify its whole-file SHA-256, and write it.

    skip holds manifests already rebuilt in this run: a long-lived receiver
    re-checks after every captured piece, and without this it would rebuild a
    finished file again on each one.
    """
    import glob
    import json

    results = []
    for mpath in sorted(glob.glob(os.path.join(out_dir, "*.qrmanifest"))):
        if mpath in skip:
            continue
        try:
            with open(mpath, encoding="utf-8") as fh:
                m = json.load(fh)
        except (json.JSONDecodeError, OSError):
            continue
        if m.get("format") != "qrpack1":
            continue
        name, total = m["name"], m["parts"]
        width = m.get("part_width", max(3, len(str(total))))
        # Stat every part before reading any. This runs after each captured
        # piece, and an abandoned transfer's parts sit in the folder for the
        # life of the process -- reading them all only to discover one is still
        # missing would make every later capture slower than the last.
        ppaths, missing = [], []
        for idx in range(1, total + 1):
            pname = f"{name}.qrpart{idx:0{width}d}-of-{total}"
            ppath = os.path.join(out_dir, safe_name(pname))
            if os.path.exists(ppath):
                ppaths.append(ppath)
            else:
                missing.append(idx)
        if missing:
            results.append(Join(mpath, name, False, f"missing parts {missing}",
                                len(missing), total, None, ()))
            continue
        chunks = []
        for ppath in ppaths:
            with open(ppath, "rb") as fh:
                chunks.append(fh.read())
        data = b"".join(chunks)
        if hashlib.sha256(data).hexdigest() != m["sha256"]:
            results.append(Join(mpath, name, False, "whole-file checksum failed",
                                0, total, None, ()))
            continue
        path, note = save_bytes(out_dir, name, data)
        # The pieces this rebuild consumed travel with the result, so
        # --clean-parts removes exactly those and never another transfer's.
        results.append(Join(mpath, name, True, note, 0, total, path, tuple(ppaths)))
    return results


def main():
    ap = argparse.ArgumentParser(
        description="Screen-capture receiver for optical QR transfer. "
                    "Stays running and accepts one transfer after another.")
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
    ap.add_argument("--once", action="store_true",
                    help="Exit after the first completed file (the old behaviour). "
                         "By default the receiver keeps running and takes transfer "
                         "after transfer until you press Ctrl-C.")
    ap.add_argument("--forget", type=float, default=900.0, metavar="SECS",
                    help="Drop a half-collected session that has not been seen for "
                         "this long, reporting its missing frames. Default 900.")
    ap.add_argument("--clean-parts", action="store_true",
                    help="After a split transfer is rebuilt and its checksum "
                         "verified, delete the .qrpart pieces and manifest.")
    args = ap.parse_args()

    detector = cv2.QRCodeDetector()
    period = 1.0 / args.fps
    last_report = 0.0
    last_sweep = time.time()
    grabbed = 0
    prev = None          # previous grayscale grab, for the settled-frame gate
    stable = not args.no_stable
    line = Line()

    # Several transfers can be in flight across one screen loop, so sessions are
    # tracked by id rather than one at a time. That also means a half-collected
    # transfer no longer blocks the next one, and a session interrupted by other
    # traffic resumes where it left off when it comes round again.
    sessions = {}        # sid -> Session, in progress
    completed = {}       # sid -> basename already written, for quiet repeats
    joined = set()       # manifest paths already rebuilt
    received = []        # paths written this run
    seen_parts = set()

    _open = _MSS if _MSS is not None else _mss_factory
    with _open() as sct:
        if args.monitor >= len(sct.monitors):
            sys.exit(f"Monitor {args.monitor} not found. Available: 1..{len(sct.monitors)-1}")
        mon = sct.monitors[args.monitor]
        print(f"Capturing monitor {args.monitor}  {mon['width']}x{mon['height']}"
              f"  at {args.fps:g} fps  (decoder: {_DECODER})")
        if _DECODER == "opencv":
            print("Note: using OpenCV. pyzbar decodes marginal frames more "
                  "reliably - install libzbar0 + pyzbar if frames stall.")
        print(f"Writing to {os.path.abspath(args.out)}")
        print("Waiting for QR signal. Fill the captured area with the sending window.")
        print("Exits after one file (--once).\n" if args.once else
              "Stays up for transfer after transfer. Ctrl-C to stop.\n")

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

                touched = None
                now = time.time()
                for t in decode_frame(img, detector):
                    fr = parse_frame(t)
                    if fr is None:
                        continue

                    # A finished transfer stays on screen -- the sender loops it
                    # until you stop it -- so its frames arrive over and over.
                    # They are collected again anyway, and the duplicate is
                    # dropped at the write instead of here.
                    #
                    # Skipping them by session id looks cheaper and is wrong. A
                    # session id is 16 bits of sha256(content) with no filename
                    # in it, so two transfers that share one identical part --
                    # v1 and v2 of an archive, where most parts didn't change --
                    # share that part's id. Ignoring an id we have already seen
                    # drops that part from the second transfer, which then waits
                    # for a piece that never comes. Nor can a time window tell
                    # the two cases apart: back-to-back sends look exactly like
                    # a loop. Only the content can, and that means collecting it.
                    #
                    # What a repeat does buy is silence: a session we have
                    # already written announces nothing and draws no progress.
                    sess = sessions.get(fr.sid)
                    if sess is None:
                        sess = sessions[fr.sid] = Session(fr)
                        sess.quiet = fr.sid in completed
                        if not sess.quiet:
                            line.say(f"\nSignal locked: session {fr.sid:04X}, {fr.proto}, "
                                     f"{fr.total} frames"
                                     f"{', gzip' if fr.flags & 1 else ''}")
                    if sess.add(fr) and not sess.quiet:
                        touched = sess

                if touched is not None:
                    tag = f"{touched.sid:04X} " if len(sessions) > 1 else ""
                    line.show("  " + tag + draw_bar(len(touched.chunks), touched.total)
                              + "   missing: " + (touched.missing_spec() or "none"))

                for sid, sess in list(sessions.items()):
                    if not sess.complete:
                        continue
                    del sessions[sid]
                    prev = None          # writing took time; re-baseline the gate
                    name, content, err = sess.decode_payload()

                    if err:
                        line.say(f"\nSession {sid:04X}: reassembly failed -- {err}")
                        line.say("  Left open for re-collection on its next showing; "
                                 f"or replay --only {sess.missing_spec() or '(all)'}")
                        continue

                    # A write can fail on the client for reasons that have
                    # nothing to do with the transfer -- a full disk, a synced
                    # folder locked by the OS. Losing one file is acceptable;
                    # losing a receiver that has been up for hours is not.
                    try:
                        if is_piece(name):
                            # Part of an auto-split transfer: save the piece, then see
                            # whether the whole file can be rebuilt yet.
                            completed[sid] = safe_name(name)
                            path, note = save_bytes(args.out, name, content, exact=True)
                            if note == "duplicate":
                                # Same piece round again on a later pass. Nothing
                                # on disk changed, so there is nothing to rejoin
                                # and nothing worth printing.
                                continue
                            seen_parts.add(os.path.basename(path))
                            kind = "manifest" if name.endswith(".qrmanifest") else "part"
                            line.say(f"Captured {kind}: {os.path.basename(path)}")

                            joins = list(try_autojoin(args.out, joined))
                            finished = False
                            for j in joins:
                                if not j.ok:
                                    continue
                                joined.add(j.manifest)
                                size = os.path.getsize(j.path)
                                line.say(f"\n{OK} Rebuilt {j.name} ({size:,} bytes) from "
                                         f"{j.total} parts. Checksum verified {ARROW} {j.path}")
                                if j.name.endswith(".tar"):
                                    line.say("   It's a folder archive; unpack with:  "
                                             f"tar xf {os.path.basename(j.path)}")
                                received.append(j.path)
                                finished = True
                                if args.clean_parts:
                                    removed = 0
                                    for p in list(j.parts) + [j.manifest]:
                                        try:
                                            os.remove(p)
                                            removed += 1
                                        except OSError:
                                            pass
                                    line.say(f"   Cleaned up {removed} piece(s).")
                            if finished and args.once:
                                return 0
                            if finished:
                                line.say(f"   {len(received)} transfer(s) received. "
                                         f"Waiting for the next one{ELL}")
                                continue

                            pending = [f"{j.name}: {j.detail}" for j in joins if not j.ok]
                            line.show(("  waiting for more parts" + ELL + " " + "; ".join(pending))
                                      if pending else "  waiting for manifest" + ELL)
                            continue

                        # An ordinary single-file transfer.
                        seen_before = sid in completed      # read before recording
                        path, note = save_bytes(args.out, name, content)
                        completed[sid] = safe_name(name)
                        if note == "duplicate":
                            # Say it once, so a deliberate re-send gets an
                            # acknowledgement, but a sender looping the same
                            # file all afternoon does not fill the terminal.
                            if not seen_before:
                                line.say(f"\nReceived {name} again {DASH} byte-identical "
                                         f"to {path}, kept the existing copy.")
                            continue
                        else:
                            line.say(f"\n{OK} Received {os.path.basename(path)} "
                                     f"({len(content):,} bytes). Checksum verified {ARROW} {path}")
                            if note == "renamed":
                                line.say(f"   (kept as {os.path.basename(path)}: a different "
                                         f"file called {name} was already here)")
                        received.append(path)
                        if args.once:
                            return 0
                        line.say(f"   {len(received)} transfer(s) received. "
                                 f"Waiting for the next one{ELL}")
                    except OSError as exc:
                        line.say(f"\nCould not write {name}: {exc}")
                        line.say("  Nothing was marked done, so it will be "
                                 "re-collected on its next showing.")
                        completed.pop(sid, None)
                        continue

                now = time.time()

                # Bound memory and surface abandoned transfers: a session nobody
                # has shown us in --forget seconds is over, finished or not.
                if now - last_sweep > 30:
                    last_sweep = now
                    for sid, s in list(sessions.items()):
                        if now - s.last > args.forget:
                            del sessions[sid]
                            line.say(f"\nDropping stale session {sid:04X}: "
                                     f"{len(s.chunks)}/{s.total} frames after "
                                     f"{args.forget:.0f}s of silence.")
                            line.say(f"  Replay the gaps with:  qrsendbin.py <file> "
                                     f"--only {s.missing_spec()}")

                if now - last_report > 3 and not sessions:
                    tail = f", {len(received)} received" if received else ""
                    line.show(f"  {ELL}scanning ({grabbed} grabs, no signal yet{tail})")
                    last_report = now

                dt = period - (time.time() - t0)
                if dt > 0:
                    time.sleep(dt)

        except KeyboardInterrupt:
            line.clear()
            print("\nStopped.")
            if received:
                print(f"Received {len(received)} file(s) into {os.path.abspath(args.out)}:")
                for p in received:
                    print(f"  {os.path.basename(p)}  ({os.path.getsize(p):,} bytes)")
            for sid, s in sessions.items():
                miss = s.missing_spec()
                if miss:
                    print(f"Session {sid:04X}: {len(s.chunks)}/{s.total} frames captured.")
                    print(f"  Replay the gaps with:  qrsendbin.py <file> --only {miss}")
            if seen_parts:
                for j in try_autojoin(args.out, joined):
                    if not j.ok:
                        print(f"{j.name}: incomplete {DASH} {j.detail}. Re-send the missing "
                              f"part(s); captured pieces stay in {args.out}/.")
            if not received and not sessions:
                print("No signal was locked.")
            return 130


if __name__ == "__main__":
    sys.exit(main())
