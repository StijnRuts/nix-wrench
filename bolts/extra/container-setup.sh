#!/usr/bin/env bash
set -euo pipefail

version="${1:?Usage: $0 <version> <name> <config_name> <project_mount_target> [mounts_json]}"
name="${2:?Usage: $0 <version> <name> <config_name> <project_mount_target> [mounts_json]}"
config="${3:?Usage: $0 <version> <name> <config_name> <project_mount_target> [mounts_json]}"
project_mount_target="${4:?Usage: $0 <version> <name> <config_name> <project_mount_target> [mounts_json]}"
mounts_json="${5:-/dev/null}"

mounts_keys() {
  if [ -r "$mounts_json" ] && [ "$mounts_json" != "/dev/null" ]; then
    jq -r 'keys[]' "$mounts_json"
  fi
}

project_root="$(git rev-parse --show-toplevel 2>/dev/null || realpath .)"

container_status() {
  incus list "$name" --format=json | jq -r '.[0].status // "missing"'
}

add_mount() {
  local key="$1" source="$2" target="$3" shift="$4"
  case "$source" in
    ~/*) source="$HOME${source#~}" ;;
    ~) source="$HOME" ;;
  esac
  source=$(realpath -m "$source")
  if ! incus config device show "$name" "$key" >/dev/null 2>&1; then
    incus config device add "$name" "$key" disk \
      source="$source" path="$target" shift="$shift"
  fi
}

create_parent_dir() {
  local target="$1"
  local parent
  parent=$(dirname "$target")
  incus file create -p -t directory "$name${parent}"
}

if ! incus info "$name" >/dev/null 2>&1; then
  echo "*** Create container"
  incus init "images:nixos/$version" "$name"
  incus config set "$name" security.nesting=true

  echo "*** Configure networking"
  incus config device add "$name" eth0 nic network=incusbr0

  echo "*** Create mount parent directories"
  create_parent_dir "$project_mount_target"
  for key in $(mounts_keys); do
    target=$(jq -r --arg key "$key" '.[$key].target' "$mounts_json")
    create_parent_dir "$target"
  done

  echo "*** Mount project directory"
  add_mount project "$project_root" "$project_mount_target" true

  echo "*** Mount extra directories"
  for key in $(mounts_keys); do
    source=$(jq -r --arg key "$key" '.[$key].source' "$mounts_json")
    target=$(jq -r --arg key "$key" '.[$key].target' "$mounts_json")
    shift=$(jq -r --arg key "$key" '.[$key].shift' "$mounts_json")
    add_mount "$key" "$source" "$target" "$shift"
  done
fi

echo "*** Start container"
if [ "$(container_status)" != "Running" ]; then
  incus start "$name"
fi
incus wait "$name" status=running
incus wait "$name" ip
echo "Container is up"

echo "*** Ensure mounts are active"
needs_restart=false
if ! incus exec "$name" -- grep -q " $project_mount_target " /proc/mounts 2>/dev/null; then
  echo "Mount $project_mount_target not active, will restart container"
  incus exec "$name" -- rmdir "$project_mount_target" 2>/dev/null || true
  needs_restart=true
fi
for key in $(jq -r 'keys[]' "$mounts_json"); do
  target=$(jq -r --arg key "$key" '.[$key].target' "$mounts_json")
  if ! incus exec "$name" -- grep -q " $target " /proc/mounts 2>/dev/null; then
    echo "Mount $target not active, will restart container"
    incus exec "$name" -- rmdir "$target" 2>/dev/null || true
    needs_restart=true
  fi
done

if [ "$needs_restart" = true ]; then
  echo "*** Restart container to apply mounts"
  incus restart "$name"
  incus wait "$name" status=running
  incus wait "$name" ip
fi

echo "*** Update container"
incus exec "$name" -- nixos-rebuild switch \
  --flake "path:${project_mount_target}#$config"
