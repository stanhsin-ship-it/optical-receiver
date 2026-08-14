#!/usr/bin/env python3
"""
qrjoin.py -- reassemble a file split by qrsplit.py and sent over optical QR.

Point it at the folder where the receiver saved the captured parts (and the
manifest). It rebuilds every file it finds a manifest for, checks that all
parts arrived, concatenates them in order, and verifies the whole-file
SHA-256 from the manifest.

    python3 qrjoin.py received/ --out restored/

Each part was already checksum-verified frame-by-frame at capture time, so
this is the final whole-file check. If a part is missing, qrjoin tells you
exactly which one, so you can re-send just that single part.
"""

import argparse
import glob
import hashlib
import json
import os
import sys


def join_one(manifest_path, in_dir, out_dir):
    with open(manifest_path, encoding="utf-8") as fh:
        try:
            m = json.load(fh)
        except json.JSONDecodeError:
            print(f"  ! {os.path.basename(manifest_path)}: manifest is not valid JSON — "
                  "it may not have fully arrived. Re-send it.")
            return False

    if m.get("format") != "qrpack1":
        print(f"  ! {os.path.basename(manifest_path)}: unrecognised manifest format.")
        return False

    name = m["name"]
    total = m["parts"]
    width = m.get("part_width", max(3, len(str(total))))

    missing, chunks = [], []
    for idx in range(1, total + 1):
        pname = f"{name}.qrpart{idx:0{width}d}-of-{total}"
        ppath = os.path.join(in_dir, pname)
        if not os.path.exists(ppath):
            missing.append(idx)
            continue
        with open(ppath, "rb") as fh:
            chunks.append(fh.read())

    if missing:
        spec = ",".join(str(i) for i in missing)
        print(f"  ! {name}: missing {len(missing)} of {total} parts: {spec}")
        print(f"    Re-send just those, e.g. their files named "
              f"{name}.qrpart<NNN>-of-{total}")
        return False

    data = b"".join(chunks)
    got_sha = hashlib.sha256(data).hexdigest()
    if got_sha != m["sha256"]:
        print(f"  ! {name}: all parts present but whole-file checksum FAILED.")
        print(f"    want {m['sha256'][:16]}…, got {got_sha[:16]}…")
        print("    One part is corrupt. Re-capture the parts and try again.")
        return False

    if len(data) != m.get("size", len(data)):
        print(f"  ! {name}: size mismatch (expected {m['size']}, got {len(data)}).")
        return False

    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, name)
    with open(out_path, "wb") as fh:
        fh.write(data)
    print(f"  ✓ {name}  ({len(data)} bytes, {total} parts)  checksum verified → {out_path}")
    return True


def main():
    ap = argparse.ArgumentParser(description="Reassemble parts from qrsplit.py / optical transfer.")
    ap.add_argument("in_dir", help="Folder holding the received parts and .qrmanifest files.")
    ap.add_argument("--out", default="restored", help="Where to write rebuilt files. Default ./restored")
    args = ap.parse_args()

    if not os.path.isdir(args.in_dir):
        sys.exit(f"Not a folder: {args.in_dir}")

    manifests = sorted(glob.glob(os.path.join(args.in_dir, "*.qrmanifest")))
    if not manifests:
        sys.exit(f"No .qrmanifest files in {args.in_dir}. "
                 "Make sure the manifest was sent and captured too.")

    print(f"Found {len(manifests)} manifest(s) in {args.in_dir}/")
    ok = 0
    for mp in manifests:
        if join_one(mp, args.in_dir, args.out):
            ok += 1
    print(f"\nDone: {ok}/{len(manifests)} file(s) rebuilt into {args.out}/")
    return 0 if ok == len(manifests) else 1


if __name__ == "__main__":
    sys.exit(main())
