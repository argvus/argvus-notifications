#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

bin="$tmp/bin"
mkdir -p "$bin" "$tmp/state"
cat >"$bin/dunstctl" <<'EOF'
#!/usr/bin/env sh
case "$1" in
  is-paused) cat "${DND_TEST_STATE:?}" ;;
  set-paused) printf '%s\n' "$2" >"${DND_TEST_STATE:?}" ;;
  *) exit 1 ;;
esac
EOF
chmod 755 "$bin/dunstctl"

config="$tmp/dunstrc"
printf 'highlight = #3590bd\n' >"$config"
state="$tmp/state/argvus/notifications/dnd"
mkdir -p "${state%/*}"
printf 'true\n' >"$state"
before="$(sha256sum "$config")"

PATH="$bin:$PATH" DND_TEST_STATE="$tmp/paused" XDG_STATE_HOME="$tmp/state" HOME="$tmp" \
  sh "$root/src/usr/bin/argvus-notifications" dnd restore

test "$(sha256sum "$config")" = "$before"
test "$(cat "$tmp/paused")" = true
printf 'DND theme invariance test passed\n'
