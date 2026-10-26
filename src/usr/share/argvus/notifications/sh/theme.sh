#!/usr/bin/env bash

# Shared Dunst theme application used by the notification backend and the
# appearance theme switcher. The colours come from the theme build; the
# existing dunstrc remains the source of all unrelated Dunst behaviour, and
# only theme-owned color keys are updated here.

argvus_notifications_theme_value() {
  local file="$1"
  local name="$2"
  local fallback="$3"
  local value

  if [ -f "$file" ]; then
    value="$(sed -n "s|^${name}[[:space:]]*=[[:space:]]*\"\{0,1\}\([^\" ]*\)\"\{0,1\}.*|\1|p" "$file" | head -n1)"
    [ -n "$value" ] && {
      printf '%s\n' "$value"
      return 0
    }
  fi

  printf '%s\n' "$fallback"
}

argvus_notifications_set_dunst_value() {
  local file="$1"
  local section="$2"
  local key="$3"
  local value="$4"
  local temporary="${file}.theme.$$"

  awk -v section="[$section]" -v key="$key" -v value="    $key = \"$value\"" '
    /^\[/ { in_section = ($0 == section) }
    in_section && $0 ~ "^[[:space:]]*" key "[[:space:]]*=" {
      print value
      next
    }
    { print }
  ' "$file" >"$temporary" && mv -- "$temporary" "$file"
}

# The notification colours of the theme build (`argvus theme`), printed only
# when the build behind `generated/theme/current` was rendered for theme $1.
argvus_notifications_build_theme_file() {
  local config_home="${ARGVUS_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}}"
  local build="${ARGVUS_DATA_HOME:-$config_home/argvus/data}/generated/theme/current"
  local built_theme
  [ -r "$build/build.toml" ] || return 1
  built_theme="$(sed -n 's/^theme = "\(.*\)"$/\1/p' "$build/build.toml" | head -n 1)"
  if grep -q '^variant = "float"$' "$build/build.toml"; then
    built_theme="${built_theme}-float"
  fi
  [ -n "$built_theme" ] && [ "$built_theme" = "$1" ] && [ -f "$build/notifications/dunstrc.theme" ] || return 1
  printf '%s\n' "$build/notifications/dunstrc.theme"
}

argvus_notifications_apply_theme() {
  local theme="$1"
  local dunstrc="${2:-${ARGVUS_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}}/argvus/data/dunst/dunstrc}"
  local system_config="${ARGVUS_SYSTEM_CONFIG:-/usr/share/argvus}"
  local theme_file
  local highlight frame low_bg low_fg normal_bg normal_fg critical_bg critical_fg app_bg app_fg

  # The theme build has the notification colours of the theme and its accent.
  theme_file="$(argvus_notifications_build_theme_file "$theme")" || return 1

  if [ ! -f "$dunstrc" ]; then
    mkdir -p "${dunstrc%/*}"
    cp -- "$system_config/notifications/config/dunstrc" "$dunstrc"
  fi

  highlight="$(argvus_notifications_theme_value "$theme_file" highlight '#3590bd')"
  frame="$(argvus_notifications_theme_value "$theme_file" frame_color "$highlight")"
  low_bg="$(argvus_notifications_theme_value "$theme_file" low_background '#101010')"
  low_fg="$(argvus_notifications_theme_value "$theme_file" low_foreground '#aaaaaa')"
  normal_bg="$(argvus_notifications_theme_value "$theme_file" normal_background "$low_bg")"
  normal_fg="$(argvus_notifications_theme_value "$theme_file" normal_foreground "$low_fg")"
  critical_bg="$(argvus_notifications_theme_value "$theme_file" critical_background "$normal_bg")"
  critical_fg="$(argvus_notifications_theme_value "$theme_file" critical_foreground "$normal_fg")"
  app_bg="$(argvus_notifications_theme_value "$theme_file" app_background "$normal_bg")"
  app_fg="$(argvus_notifications_theme_value "$theme_file" app_foreground "$normal_fg")"

  argvus_notifications_set_dunst_value "$dunstrc" global highlight "$highlight"
  argvus_notifications_set_dunst_value "$dunstrc" global frame_color "$frame"

  argvus_notifications_set_dunst_value "$dunstrc" urgency_low background "$low_bg"
  argvus_notifications_set_dunst_value "$dunstrc" urgency_low foreground "$low_fg"
  argvus_notifications_set_dunst_value "$dunstrc" urgency_low frame_color "$frame"

  argvus_notifications_set_dunst_value "$dunstrc" urgency_normal background "$normal_bg"
  argvus_notifications_set_dunst_value "$dunstrc" urgency_normal foreground "$normal_fg"
  argvus_notifications_set_dunst_value "$dunstrc" urgency_normal frame_color "$frame"

  argvus_notifications_set_dunst_value "$dunstrc" urgency_critical background "$critical_bg"
  argvus_notifications_set_dunst_value "$dunstrc" urgency_critical foreground "$critical_fg"
  argvus_notifications_set_dunst_value "$dunstrc" urgency_critical frame_color "$frame"
  argvus_notifications_set_dunst_value "$dunstrc" urgency_critical highlight "$highlight"

  for section in hyprshot volume gpu-screen-recorder network spotify discord; do
    argvus_notifications_set_dunst_value "$dunstrc" "$section" background "$app_bg"
    argvus_notifications_set_dunst_value "$dunstrc" "$section" foreground "$app_fg"
    argvus_notifications_set_dunst_value "$dunstrc" "$section" frame_color "$frame"
    argvus_notifications_set_dunst_value "$dunstrc" "$section" highlight "$highlight"
  done
}
