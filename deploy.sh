#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <user@server-ip-or-hostname>"
  echo "Example: $0 root@203.0.113.10"
  exit 1
fi

remote_host="$1"
# Relative paths are created in the remote user's home directory; an absolute
# path can be supplied through REMOTE_DIR when a different location is needed.
remote_dir="${REMOTE_DIR:-minecraft-server}"

if [[ ! -f .env ]]; then
  echo "No .env found. Copy .env.example to .env and adjust the server settings first."
  exit 1
fi

echo "Uploading configuration and mods to ${remote_host}:${remote_dir} ..."
ssh "$remote_host" "mkdir -p '$remote_dir/mods' '$remote_dir/data'"
rsync -az --progress -e ssh compose.yaml .env command.sh uninstall.sh "${remote_host}:${remote_dir}/"
rsync -az --progress -e ssh mods/ "${remote_host}:${remote_dir}/mods/"

echo "Upload finished. On the VPS run: cd ${remote_dir} && docker compose up -d"
