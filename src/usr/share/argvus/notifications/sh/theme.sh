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
  local built_theme="" is_float="" line
  [ -r "$build/build.toml" ] || return 1
  # Read with shell builtins: this runs on every login before Dunst starts.
  # The first `theme = "<id>"` line names the build; `variant = "float"` adds
  # the Float suffix, as `argvus theme` names its builds.
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      'theme = "'*'"')
        if [ -z "$built_theme" ]; then
          built_theme="${line#theme = \"}"
          built_theme="${built_theme%\"}"
        fi
        ;;
      'variant = "float"') is_float=1 ;;
    esac
  done <"$build/build.toml"
  if [ -n "$is_float" ]; then
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

  local -A theme_values=()
  argvus_notifications_read_theme_values "$theme_file" theme_values

  # An empty or missing key falls back, as the per-key lookup did.
  highlight="${theme_values[highlight]:-#3590bd}"
  frame="${theme_values[frame_color]:-$highlight}"
  low_bg="${theme_values[low_background]:-#101010}"
  low_fg="${theme_values[low_foreground]:-#aaaaaa}"
  normal_bg="${theme_values[normal_background]:-$low_bg}"
  normal_fg="${theme_values[normal_foreground]:-$low_fg}"
  critical_bg="${theme_values[critical_background]:-$normal_bg}"
  critical_fg="${theme_values[critical_foreground]:-$normal_fg}"
  app_bg="${theme_values[app_background]:-$normal_bg}"
  app_fg="${theme_values[app_foreground]:-$normal_fg}"

  local tab=$'\t'
  local assignments="global${tab}highlight${tab}${highlight}
global${tab}frame_color${tab}${frame}
urgency_low${tab}background${tab}${low_bg}
urgency_low${tab}foreground${tab}${low_fg}
urgency_low${tab}frame_color${tab}${frame}
urgency_normal${tab}background${tab}${normal_bg}
urgency_normal${tab}foreground${tab}${normal_fg}
urgency_normal${tab}frame_color${tab}${frame}
urgency_critical${tab}background${tab}${critical_bg}
urgency_critical${tab}foreground${tab}${critical_fg}
urgency_critical${tab}frame_color${tab}${frame}
urgency_critical${tab}highlight${tab}${highlight}"
  for section in hyprshot volume gpu-screen-recorder network spotify discord; do
    assignments+="
${section}${tab}background${tab}${app_bg}
${section}${tab}foreground${tab}${app_fg}
${section}${tab}frame_color${tab}${frame}
${section}${tab}highlight${tab}${highlight}"
  done

  argvus_notifications_set_dunst_values "$dunstrc" "$assignments"
}

# Reads the keys of a theme build file into the associative array named by $2,
# in one pass and without subprocesses. A key keeps its first value, which is
# what the sed lookup of argvus_notifications_theme_value returns.
argvus_notifications_read_theme_values() {
  local file="$1"
  local -n values="$2"
  local line key
  [ -f "$file" ] || return 0
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ "$line" =~ ^([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*\"?([^\"\ ]*) ]]; then
      key="${BASH_REMATCH[1]}"
      if [ -z "${values["$key"]+set}" ]; then
        values["$key"]="${BASH_REMATCH[2]}"
      fi
    fi
  done <"$file"
}

# Applies `section<TAB>key<TAB>value` lines to a dunstrc in one awk pass. The
# rule is the one of argvus_notifications_set_dunst_value: inside the exact
# `[section]` header, a `key =` line becomes `    key = "value"`, and a later
# assignment of the same key wins. The file is replaced only when the result
# differs, so an unchanged theme leaves dunstrc as it is.
argvus_notifications_set_dunst_values() {
  local file="$1"
  local assignments="$2"
  local temporary="${file}.theme.$$"

  if ! ARGVUS_DUNST_ASSIGNMENTS="$assignments" awk '
    BEGIN {
      count = split(ENVIRON["ARGVUS_DUNST_ASSIGNMENTS"], lines, "\n")
      for (i = 1; i <= count; i++) {
        if (split(lines[i], field, "\t") == 3) {
          wanted["[" field[1] "]", field[2]] = field[3]
        }
      }
    }
    /^\[/ { section = $0 }
    match($0, /^[[:space:]]*[^[:space:]=]+[[:space:]]*=/) {
      key = substr($0, RSTART, RLENGTH)
      sub(/^[[:space:]]*/, "", key)
      sub(/[[:space:]]*=$/, "", key)
      if ((section, key) in wanted) {
        print "    " key " = \"" wanted[section, key] "\""
        next
      }
    }
    { print }
  ' "$file" >"$temporary"; then
    rm -f -- "$temporary"
    return 1
  fi

  if cmp -s -- "$temporary" "$file"; then
    rm -f -- "$temporary"
  else
    mv -- "$temporary" "$file"
  fi
}
