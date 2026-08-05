#!/usr/bin/env bash
set -euo pipefail

name="${1:?Usage: $0 <name> <config_name> <project_mount_target>}"
config="${2:?Usage: $0 <name> <config_name> <project_mount_target>}"
project_mount_target="${3:?Usage: $0 <name> <config_name> <project_mount_target>}"

project_root="$(git rev-parse --show-toplevel 2>/dev/null || realpath .)"

echo "*** Rebuild on file changes"
watchexec \
  --watch "$project_root" \
  --postpone \
  --restart \
  -- incus exec "$name" \
  -- nixos-rebuild switch \
  --flake "path:${project_mount_target}#$config"
