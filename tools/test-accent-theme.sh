#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

config_home="$tmp/config"
mkdir -p "$config_home/argvus/data"
printf '%s\n' argvus-dark >"$config_home/argvus/data/.active-theme"

export ARGVUS_CONFIG_HOME="$config_home"
export ARGVUS_SYSTEM_CONFIG="$root/src/usr/share/argvus"
source "$root/src/usr/share/argvus/notifications/sh/theme.sh"

# The theme build of the active theme carries its colours and the accent.
build="$config_home/argvus/data/generated/theme/builds/argvus-dark-sticky-test"
mkdir -p "$build/notifications"
ln -s builds/argvus-dark-sticky-test "$config_home/argvus/data/generated/theme/current"
printf 'theme = "argvus-dark"\nvariant = "sticky"\n' >"$build/build.toml"
cat >"$build/notifications/dunstrc.theme" <<'THEME'
highlight = "#51B2B6"
frame_color = "#51B2B6"
low_background = "#101010"
low_foreground = "#AAAAAA"
normal_background = "#123456"
normal_foreground = "#EEEEEE"
THEME

dunstrc="$config_home/argvus/data/dunst/dunstrc"
argvus_notifications_apply_theme argvus-dark "$dunstrc"
grep -Fq 'highlight = "#51B2B6"' "$dunstrc"
grep -Fq 'frame_color = "#51B2B6"' "$dunstrc"
grep -Fq 'background = "#123456"' "$dunstrc"

# A build of another theme is never used, and the dunstrc is left as it is.
cp -- "$dunstrc" "$tmp/before"
if argvus_notifications_apply_theme argvus-light "$dunstrc"; then
  printf 'a theme build of argvus-dark was used for argvus-light\n' >&2
  exit 1
fi
cmp -s "$dunstrc" "$tmp/before"

printf 'Dunst theme build test passed\n'
