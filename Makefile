PREFIX ?= /usr
DESTDIR ?=

.DEFAULT_GOAL := help

.PHONY: help install uninstall validate build clean

help:
	@echo "Available targets:"
	@echo "  make build"
	@echo "  make install"
	@echo "  make uninstall"
	@echo "  make validate"

install:
	install -dm755 "$(DESTDIR)$(PREFIX)/share/argvus/notifications"
	cp -a src/usr/share/argvus/notifications/. "$(DESTDIR)$(PREFIX)/share/argvus/notifications/"
	find "$(DESTDIR)$(PREFIX)/share/argvus/notifications/sh" -type f -name '*.sh' -exec chmod 755 {} \;
	install -Dm644 LICENSE "$(DESTDIR)$(PREFIX)/share/licenses/argvus-notifications/LICENSE"

uninstall:
	rm -rf "$(DESTDIR)$(PREFIX)/share/argvus/notifications"
	rm -f "$(DESTDIR)$(PREFIX)/share/licenses/argvus-notifications/LICENSE"

validate:
	@test -f src/usr/share/argvus/notifications/config/dunstrc
	@if find src -name '*.sh' | grep -q .; then \
		for script in $$(find src -name '*.sh'); do sh -n "$$script"; done; \
		if command -v shellcheck >/dev/null 2>&1; then for script in $$(find src -name '*.sh'); do shellcheck -e SC1090 -e SC2034 "$$script"; done; else echo "shellcheck not found; skipping shell lint"; fi; \
	fi
	@echo "argvus-notifications validation ok"

.PHONY: build

build:
	@tools/build-local-package.sh

clean:
	rm -rf dist
	rm -f packaging/arch/*.zst packaging/arch/*.tar.gz
