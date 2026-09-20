#!/usr/bin/env bash
set -euo pipefail

server_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"

if [[ "$server_dir" == "/" || ! -f "$server_dir/compose.yaml" ]]; then
  echo "Refusing to remove an invalid server directory: $server_dir"
  exit 1
fi

cd "$server_dir"
docker compose down --volumes --remove-orphans || true
cd "$(dirname -- "$server_dir")"
rm -rf -- "$server_dir"
