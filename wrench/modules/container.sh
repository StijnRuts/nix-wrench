#!/usr/bin/env bash
set -euo pipefail

version="${1:?Usage: $0 <version> <name> <config_name>}"
name="${2:?Usage: $0 <version> <name> <config_name>}"
config="${3:?Usage: $0 <version> <name> <config_name>}"

project_root="$(git rev-parse --show-toplevel 2>/dev/null || realpath .)"

if ! incus info "$name" >/dev/null 2>&1; then
  echo "*** Create container"
  incus init "images:nixos/$version" "$name"
  incus config set "$name" security.nesting true

  echo "*** Mount project directory"
  incus config device add "$name" project disk \
    source="$project_root" path=/mnt/project # shift=true
fi

echo "*** Start container"
incus start "$name"
until incus exec "$name" -- true 2>/dev/null; do
  sleep 1
done
echo "Container is up"

echo "*** Update container"
incus exec "$name" -- nixos-rebuild switch \
  --flake "path:/mnt/project#$config"
