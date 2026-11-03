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
  reload)
    printf 'reload %s\n' "$*" >>"${DND_TEST_LOG:?}"
    if [ -n "${DND_TEST_RELOAD_GATE:-}" ]; then
      : >"${DND_TEST_RELOAD_STARTED:?}"
      while [ ! -e "$DND_TEST_RELOAD_GATE" ]; do sleep 0.01; done
    fi
    printf 'false\n' >"${DND_TEST_STATE:?}"
    [ "${DND_TEST_RELOAD_FAIL:-false}" = false ]
    ;;
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

# Theme changes while DND is active are recorded without reloading Dunst.
printf 'true\n' >"$DND_TEST_STATE"
printf 'true\n' >"$XDG_STATE_HOME/argvus/notifications/dnd"
: >"$DND_TEST_LOG"
bash "$root/src/usr/bin/argvus-notifications" theme reload "$tmp/theme-config" >/dev/null
test "$(cat "$DND_TEST_STATE")" = true
test ! -s "$DND_TEST_LOG"
test -e "$XDG_STATE_HOME/argvus/notifications/theme-reload-pending"

# Turning DND off applies the current config before finishing the transition.
: >"$DND_TEST_LOG"
bash "$root/src/usr/bin/argvus-notifications" dnd off >/dev/null
test "$(cat "$DND_TEST_STATE")" = false
test "$(cat "$DND_TEST_LOG")" = "$(printf 'reload reload\nset-paused false')"
test ! -e "$XDG_STATE_HOME/argvus/notifications/theme-reload-pending"

# When DND is off, a theme change reloads its supplied config immediately.
: >"$DND_TEST_LOG"
bash "$root/src/usr/bin/argvus-notifications" theme reload "$tmp/theme-config" >/dev/null
test "$(cat "$DND_TEST_LOG")" = "reload reload $tmp/theme-config"

# A failed pending reload restores DND and retains the pending work.
printf 'true\n' >"$DND_TEST_STATE"
printf 'true\n' >"$XDG_STATE_HOME/argvus/notifications/dnd"
bash "$root/src/usr/bin/argvus-notifications" theme reload "$tmp/theme-config" >/dev/null
: >"$DND_TEST_LOG"
export DND_TEST_RELOAD_FAIL=true
if bash "$root/src/usr/bin/argvus-notifications" dnd off >/dev/null 2>&1; then
  printf 'DND was disabled despite a failed theme reload\n' >&2
  exit 1
fi
unset DND_TEST_RELOAD_FAIL
test "$(cat "$DND_TEST_STATE")" = true
test "$(cat "$XDG_STATE_HOME/argvus/notifications/dnd")" = true
test -e "$XDG_STATE_HOME/argvus/notifications/theme-reload-pending"
test "$(cat "$DND_TEST_LOG")" = "$(printf 'reload reload\nset-paused true\nclose-all')"

# Serialize a theme reload and a concurrent DND activation.
bash "$root/src/usr/bin/argvus-notifications" dnd off >/dev/null
printf 'false\n' >"$DND_TEST_STATE"
printf 'false\n' >"$XDG_STATE_HOME/argvus/notifications/dnd"
export DND_TEST_RELOAD_GATE="$tmp/release-reload"
export DND_TEST_RELOAD_STARTED="$tmp/reload-started"
bash "$root/src/usr/bin/argvus-notifications" theme reload "$tmp/theme-config" >/dev/null &
reload_pid=$!
attempt=0
while [ ! -e "$DND_TEST_RELOAD_STARTED" ] && [ "$attempt" -lt 100 ]; do
  sleep 0.01
  attempt=$((attempt + 1))
done
if [ ! -e "$DND_TEST_RELOAD_STARTED" ]; then
  : >"$DND_TEST_RELOAD_GATE"
  wait "$reload_pid" || true
  printf 'theme reload did not start\n' >&2
  exit 1
fi
bash "$root/src/usr/bin/argvus-notifications" dnd on >/dev/null &
dnd_pid=$!
sleep 0.05
: >"$DND_TEST_RELOAD_GATE"
wait "$reload_pid"
wait "$dnd_pid"
unset DND_TEST_RELOAD_GATE DND_TEST_RELOAD_STARTED
test "$(cat "$DND_TEST_STATE")" = true
test "$(cat "$XDG_STATE_HOME/argvus/notifications/dnd")" = true

# A new Dunst process loads the latest config before DND is restored.
printf 'true\n' >"$DND_TEST_STATE"
printf 'true\n' >"$XDG_STATE_HOME/argvus/notifications/dnd"
: >"$XDG_STATE_HOME/argvus/notifications/theme-reload-pending"
: >"$DND_TEST_LOG"
bash "$root/src/usr/bin/argvus-notifications" dnd restore >/dev/null
test "$(cat "$DND_TEST_LOG")" = "$(printf 'set-paused true\nclose-all')"
test ! -e "$XDG_STATE_HOME/argvus/notifications/theme-reload-pending"

printf 'DND behavior test passed\n'
