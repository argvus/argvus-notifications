#!/usr/bin/env bash

# Shared Dunst theme application used by the notification backend and the
# appearance theme switcher. The existing dunstrc remains the source of all
# unrelated Dunst behaviour; only theme-owned color keys are updated here.

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

argvus_notifications_accent_override() {
  local config_home="${ARGVUS_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}}"
  local accent_file="$config_home/argvus/.accent-color"
  local accent

  [ -s "$accent_file" ] || return 0
  accent="$(sed -n '1{s/\r$//;s/^[[:space:]]*//;s/[[:space:]]*$//;p;}' "$accent_file")"
  case "$accent" in
    \#*) accent="${accent#\#}" ;;
  esac
  case "$accent" in
    ??????)
      case "$accent" in
        *[!0-9A-Fa-f]*) return 0 ;;
      esac
      printf '#%s\n' "$accent"
      ;;
  esac
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

argvus_notifications_theme_name() {
  case "$1" in
    argvus-onedark|argvus-onedark-float|argvus-dracula|argvus-dracula-float|argvus-dark-aether|argvus-dark-aether-float|argvus-dark-silver|argvus-dark-silver-float|\
      argvus-dark-slate|argvus-dark-slate-float|argvus-dark-universe|argvus-dark-universe-float|\
      argvus-light-veil|argvus-light-veil-float|argvus-frost|argvus-frost-float|argvus-catppuccin-latte|argvus-catppuccin-latte-float|argvus-gruvbox-dark-medium|argvus-gruvbox-dark-medium-float|argvus-rosepine|argvus-rosepine-float|argvus-tokyo-night|argvus-tokyo-night-float)
      printf '%s\n' "$1"
      ;;
    *)
      return 1
      ;;
  esac
}

argvus_notifications_apply_theme() {
  local theme="$1"
  local dunstrc="${2:-${ARGVUS_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}}/argvus/dunst/dunstrc}"
  local config_home="${ARGVUS_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}}"
  local system_config="${ARGVUS_SYSTEM_CONFIG:-/usr/share/argvus}"
  local user_themes="$config_home/argvus/dunst/themes"
  local system_themes="$system_config/notifications/config/themes"
  local theme_file=''
  local candidate
  local base_theme
  local highlight frame low_bg low_fg normal_bg normal_fg critical_bg critical_fg app_bg app_fg
  local accent_override

  theme="$(argvus_notifications_theme_name "$theme")" || return 1
  base_theme="${theme%-float}"

  for candidate in \
    "$user_themes/$theme/dunstrc.theme" \
    "$user_themes/$base_theme/dunstrc.theme" \
    "$system_themes/$theme/dunstrc.theme" \
    "$system_themes/$base_theme/dunstrc.theme"; do
    if [ -f "$candidate" ]; then
      theme_file="$candidate"
      break
    fi
  done
  [ -n "$theme_file" ] || return 1

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
  accent_override="$(argvus_notifications_accent_override || true)"
  if [ -n "$accent_override" ]; then
    highlight="$accent_override"
    frame="$accent_override"
  fi

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
