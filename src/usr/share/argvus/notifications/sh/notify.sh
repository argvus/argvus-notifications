# shellcheck shell=sh
# shellcheck disable=SC1091
. /usr/share/argvus/lib/i18n.sh

# -- Notification abstraction (notify-send wrapper) ---------------------------

notify_send() {
  summary="$1"
  body="$2"
  notify-send "${summary}" "${body}"
}

notify_error() {
  notify_send "$(argvus_tr notifications error_title): $1" "$2"
}
