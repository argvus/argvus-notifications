#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

config_home="$tmp/config"
mkdir -p "$config_home/argvus/data"
printf '%s\n' argvus-dark >"$config_home/argvus/data/.active-theme"
printf '%s\n' '#51B2B6' >"$config_home/argvus/data/.accent-color"

export ARGVUS_CONFIG_HOME="$config_home"
export ARGVUS_SYSTEM_CONFIG="$root/src/usr/share/argvus"
source "$root/src/usr/share/argvus/notifications/sh/theme.sh"

dunstrc="$config_home/argvus/data/dunst/dunstrc"
argvus_notifications_apply_theme argvus-dark "$dunstrc"

grep -Fq 'highlight = "#51B2B6"' "$dunstrc"
grep -Fq 'frame_color = "#51B2B6"' "$dunstrc"

printf '%s\n' 'invalid' >"$config_home/argvus/data/.accent-color"
argvus_notifications_apply_theme argvus-dark "$dunstrc"
grep -Fq 'highlight = "#3590bd"' "$dunstrc"
grep -Fq 'frame_color = "#3590bd"' "$dunstrc"

printf 'Dunst custom accent test passed\n'
