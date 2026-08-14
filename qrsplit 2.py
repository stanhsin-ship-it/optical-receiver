#!/usr/bin/env python3
"""
qrsplit.py -- chop a large file into small parts for optical QR transfer.

Optical QR suits small files. A big file becomes an impractical number of
frames in one session, so instead we split it into numbered parts, send each
part as its own normal session with qrsendbin.py, and rebuild it on the far
side with qrjoin.py.

    python3 qrsplit.py movie.bin --size 40k --out parts/

That writes, into parts/:
    movie.bin.qrpart001-of-012
    movie.bin.qrpart002-of-012
    ...
    movie.bin.qrmanifest        <- tiny JSON: original name, whole-file SHA-256

Then send every file in parts/ (the parts AND the manifest), one session each:

    for f in parts/*; do python3 qrsendbin.py "$f" --passes 3; done

...advancing to the next once the receiver shows "Done" for the current one.
On the receive side, qrjoin.py reads the manifest, checks every part arrived,
concatenates them in order, and verifies the whole-file checksum.

Choosing --size: at the default v6 QR, each part of S bytes is about S/46
frames, and one pass runs at 2 fps. 40k -> ~870 frames -> ~7 min per part.
Smaller parts finish faster individually and make re-sends cheaper if one part
is troublesome; larger parts mean fewer sessions to babysit.
"""

import argparse
import hashlib
import json
import os
import sys


def parse_size(s: str) -> int:
    s = s.strip().lower()
    mult = 1
    if s.endswith("k"):
        mult, s = 1024, s[:-1]
    elif s.endswith("m"):
        mult, s = 1024 * 1024, s[:-1]
    try:
        return int(float(s) * mult)
    except ValueError:
        sys.exit(f"Bad --size value: {s!r}. Use e.g. 40k, 256k, 1m, or a byte count.")


def read_input(path: str):
    """Return (content_bytes, name). A folder is packed into one deterministic
    .tar so a whole directory can be split and rebuilt as a single file."""
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
                arc = os.path.relpath(full, parent).replace(os.sep, "/")
                entries.append((full, arc))
        if not entries:
            sys.exit(f"Folder {path!r} has no files to split.")
        buf = io.BytesIO()
        with tarfile.open(fileobj=buf, mode="w") as tar:
            for full, arc in entries:
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


def main():
    ap = argparse.ArgumentParser(description="Split a large file or folder into parts for optical transfer.")
    ap.add_argument("file", help="File or folder to split. A folder is packed into one .tar first.")
    ap.add_argument("--size", default="40k",
                    help="Bytes per part. Accepts k/m suffixes. Default 40k "
                         "(~870 frames / ~7 min per part at default v6 + 2 fps).")
    ap.add_argument("--out", default="parts", help="Output folder. Default ./parts")
    args = ap.parse_args()

    part_size = parse_size(args.size)
    if part_size < 1024:
        sys.exit("--size is too small to be useful; use at least 1k.")

    data, name = read_input(args.file)
    if not data:
        sys.exit("Nothing to split (input is empty).")
    whole_sha = hashlib.sha256(data).hexdigest()
    total = (len(data) + part_size - 1) // part_size
    width = max(3, len(str(total)))

    os.makedirs(args.out, exist_ok=True)
    part_names = []
    for idx in range(total):
        chunk = data[idx * part_size:(idx + 1) * part_size]
        pname = f"{name}.qrpart{idx + 1:0{width}d}-of-{total}"
        with open(os.path.join(args.out, pname), "wb") as fh:
            fh.write(chunk)
        part_names.append(pname)

    manifest = {
        "format": "qrpack1",
        "name": name,
        "size": len(data),
        "sha256": whole_sha,
        "parts": total,
        "part_size": part_size,
        "part_width": width,
    }
    mname = f"{name}.qrmanifest"
    with open(os.path.join(args.out, mname), "w", encoding="utf-8") as fh:
        json.dump(manifest, fh, indent=2)

    print(f"Split {name} ({len(data)} bytes) into {total} parts of up to {part_size} bytes.")
    print(f"Output folder: {args.out}/")
    print(f"  {total} parts + 1 manifest ({mname})")
    print(f"  whole-file SHA-256: {whole_sha[:16]}…")
    print()
    print("Send every file in the folder, one session each (manifest too):")
    print(f'  for f in {args.out}/*; do python3 qrsendbin.py "$f" --passes 3; done')
    print()
    print("Then on the receiving machine, after all parts are captured:")
    print(f"  python3 qrjoin.py <received-folder> --out restored/")


if __name__ == "__main__":
    main()
