# Optical Receiver

Transfer files between computers by displaying a sequence of QR codes on one
screen and capturing them from another screen. It is useful for air-gapped
machines and remote-desktop sessions such as NoMachine.

The sender turns a file or folder into QR frames. The receiver watches a
monitor, collects the frames, verifies the SHA-256 checksum, and writes the
original file. Folders are packed as a `.tar` archive and unpacked after a
successful transfer.

## Quick start

Install the sender dependency on the computer that has the file:

```bash
python3 -m pip install segno
```

Install receiver dependencies on the computer that can see the QR codes:

```bash
python3 -m pip install opencv-python-headless mss numpy pyzbar
```

`pyzbar` needs the ZBar system library. On Ubuntu/Debian, install it with:

```bash
sudo apt install libzbar0
```

Start the receiver first. It saves completed files in `./received`:

```bash
python3 qrgrab.py --monitor 2
```

Then display the file on the sending computer:

```bash
python3 qrsendbin.py report.xlsx --passes 3
```

When the receiver prints `Checksum verified`, the transfer is complete.

## Common commands

```bash
# Send a folder; the receiver restores it as a folder.
python3 qrsendbin.py ./project --passes 3

# Use a slower frame rate for a low-quality remote-desktop connection.
python3 qrsendbin.py firmware.bin --fps 1 --passes 3

# Write received files somewhere else.
python3 qrgrab.py --monitor 2 --out ./incoming

# Keep received folder archives instead of unpacking them.
python3 qrgrab.py --monitor 2 --no-untar
```

If the receiver reports missing frames, replay only those frames on the sender:

```bash
python3 qrsendbin.py report.xlsx --only 7,27,60-62
```

Use the same QR version as the original transfer when using `--only`.

## Notes

- `qrgrab.py` accepts QR codes anywhere on the selected monitor and continues
  listening for additional transfers until you stop it with Ctrl+C.
- `qrsendgui.py` provides a graphical sender if you prefer not to use the
  command line.
- Transfer integrity is checked with SHA-256. This tool does **not** encrypt
  files or authenticate the sender; do not use it for secrets unless the
  environment is already trusted.

For a Chinese quick-start guide, see [光學傳檔使用指南.md](光學傳檔使用指南.md).
