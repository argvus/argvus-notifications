#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

bin="$tmp/bin"
mkdir -p "$bin"
cat >"$bin/dunstctl" <<'EOF'
#!/usr/bin/env sh
case "$1" in
  is-paused) cat "${DND_TEST_STATE:?}" ;;
  set-paused)
    printf 'set-paused %s\n' "$2" >>"${DND_TEST_LOG:?}"
    printf '%s\n' "$2" >"${DND_TEST_STATE:?}"
    ;;
  close-all) printf 'close-all\n' >>"${DND_TEST_LOG:?}" ;;
  *) exit 1 ;;
esac
EOF
chmod 755 "$bin/dunstctl"

export PATH="$bin:$PATH"
export DND_TEST_STATE="$tmp/paused"
export DND_TEST_LOG="$tmp/commands"
export XDG_STATE_HOME="$tmp/state"
export HOME="$tmp"
export ARGVUS_NOTIFICATIONS_HELPER="$root/src/usr/share/argvus/notifications/sh/theme.sh"

printf 'false\n' >"$DND_TEST_STATE"
: >"$DND_TEST_LOG"
bash "$root/src/usr/bin/argvus-notifications" dnd on >/dev/null
test "$(cat "$DND_TEST_STATE")" = true
test "$(cat "$DND_TEST_LOG")" = "$(printf 'set-paused true\nclose-all')"
test "$(cat "$XDG_STATE_HOME/argvus/notifications/dnd")" = true

: >"$DND_TEST_LOG"
bash "$root/src/usr/bin/argvus-notifications" dnd off >/dev/null
test "$(cat "$DND_TEST_STATE")" = false
test "$(cat "$DND_TEST_LOG")" = 'set-paused false'

printf 'true\n' >"$DND_TEST_STATE"
printf 'true\n' >"$XDG_STATE_HOME/argvus/notifications/dnd"
: >"$DND_TEST_LOG"
bash "$root/src/usr/bin/argvus-notifications" dnd restore >/dev/null
test "$(cat "$DND_TEST_LOG")" = "$(printf 'set-paused true\nclose-all')"

printf 'DND behavior test passed\n'
