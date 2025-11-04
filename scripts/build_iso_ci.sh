#!/usr/bin/env bash
set -e
set -o pipefail

WORKDIR="$PWD/work"
OUTPUT_DIR="$PWD/output"
ISO_NAME="denos-$(date +%Y%m%d).iso"

echo "[1] Preparing base system..."
bash scripts/01_denos_pre_reqs.sh "$WORKDIR"

echo "[2] Setting up chroot..."
bash scripts/02_denos_debootstrap.sh "$WORKDIR"

echo "[3] Customizing inside chroot..."
# Run inside chroot
chroot "$WORKDIR/chroot" /bin/bash -c "/scripts/03_denos_chroot.sh"

echo "[2] Setting up chroot..."
bash scripts/04_denos_MakeSquashfs.sh"$WORKDIR"

echo "[4] Finalizing ISO..."
bash scripts/05_denos_BiosUEFI_ISO.sh "$WORKDIR" "$OUTPUT_DIR/$ISO_NAME"

echo "[✓] Build complete: $OUTPUT_DIR/$ISO_NAME"

