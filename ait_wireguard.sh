#!/usr/bin/env bash

set -e

DOWNLOAD_DIR="$HOME/Downloads"
PREFIX="Default_Peer"
TARGET="/etc/wireguard/wireguard-ait.conf"

# 1. Find today's Default_Peer file (newest)
CONFIG_FILE=$(
  find "$DOWNLOAD_DIR" \
    -maxdepth 1 \
    -type f \
    -iname "${PREFIX}*" \
    -daystart -mtime 0 \
    -printf '%T@ %p\n' |
    sort -nr |
    head -1 |
    cut -d' ' -f2-
)

if [[ -z "$CONFIG_FILE" ]]; then
  echo "No Default_Peer file downloaded today"
  exit 1
fi

echo "Found config: $CONFIG_FILE"

# 2. Comment out DNS if exists
if grep -qE '^[[:space:]]*DNS[[:space:]]*=' "$CONFIG_FILE"; then
  sed -i 's/^[[:space:]]*DNS[[:space:]]*=/# DNS =/g' "$CONFIG_FILE"
  echo "DNS entry commented out"
fi

# 3. Install to /etc/wireguard
echo "Installing to $TARGET"
sudo install -m 600 "$CONFIG_FILE" "$TARGET"
sudo wg-quick up wireguard-ait

# 4. Delete source file ONLY after success
rm -f "$CONFIG_FILE"
echo "Source file removed from Downloads"

echo "WireGuard config ready: $TARGET"
