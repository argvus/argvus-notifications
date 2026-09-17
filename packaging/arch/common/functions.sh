#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2154
# srcdir, pkgdir, pkgname, and pkgver are supplied by makepkg.

# GitHub source archives use <repository>-v<version> as their top-level
# directory, while the local builder creates <pkgname>-<pkgver>. Normalize
# both forms before check() and package() run.
arch_normalize_source_tree() {
	local expected="${srcdir}/${pkgname}-${pkgver}"
	local -a roots=()

	while IFS= read -r -d '' root; do
		roots+=("$root")
	done < <(find "$srcdir" -mindepth 1 -maxdepth 1 -type d -print0)

	if (( ${#roots[@]} != 1 )); then
		printf 'error: expected exactly one extracted source directory in %s\n' "$srcdir" >&2
		return 1
	fi

	if [[ "${roots[0]}" != "$expected" ]]; then
		[[ ! -e "$expected" ]] || {
			printf 'error: source destination already exists: %s\n' "$expected" >&2
			return 1
		}
		mv -- "${roots[0]}" "$expected"
	fi
}

arch_check_notifications_payload() {
	local source_root="${srcdir}/${pkgname}-${pkgver}"

	test -f "${source_root}/src/usr/share/argvus/notifications/config/dunstrc"
	test -x "${source_root}/src/usr/share/argvus/notifications/sh/notify.sh"
	test -x "${source_root}/src/usr/bin/argvus-notifications"
	test -n "$(find "${source_root}/src/usr/share/argvus/notifications/config/themes" \
		-type f -name '*.theme' -print -quit)"
}

arch_package_notifications_payload() {
	local source_root="${srcdir}/${pkgname}-${pkgver}"

	install -dm755 "${pkgdir}"
	cp -a "${source_root}/src/." "${pkgdir}/"
	install -Dm755 "${source_root}/src/usr/bin/argvus-notifications" \
		"${pkgdir}/usr/bin/argvus-notifications"
	find "${pkgdir}/usr/share/argvus/notifications" -type f -name '*.sh' \
		-exec chmod 755 {} +
	install -Dm644 "${source_root}/LICENSE" \
		"${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
