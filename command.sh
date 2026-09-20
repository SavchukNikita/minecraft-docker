#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <minecraft-command> [arguments...]"
  echo "Example: $0 op PlayerName"
  exit 1
fi

server_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"
cd "$server_dir"
exec docker compose exec -T minecraft rcon-cli "$@"
