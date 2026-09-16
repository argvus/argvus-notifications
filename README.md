# argvus-notifications

Dunst configuration, notification themes and notification integration for ARGVUS.

[![CI](https://github.com/argvus/argvus-notifications/actions/workflows/ci.yml/badge.svg)](https://github.com/argvus/argvus-notifications/actions/workflows/ci.yml)
[![Release](https://github.com/argvus/argvus-notifications/actions/workflows/release.yml/badge.svg)](https://github.com/argvus/argvus-notifications/actions/workflows/release.yml)
[![License](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)

This repository provides the notification payload owned by ARGVUS. Runtime
ownership stays connected to `argvus-sessionctl` and `argvus-session.target`.

## Build and install

On Arch Linux or a compatible distribution:

```sh
sudo pacman -S --needed base-devel git shellcheck
make validate
make build
make install
```

`make build` creates a deterministic source archive in `build/artifacts/` and
the package in `build/dist/`. `make install` installs the single package found
there.

For metadata-only checks:

```sh
makepkg -p packaging/arch/ci/PKGBUILD --printsrcinfo
makepkg -p packaging/arch/local/PKGBUILD --printsrcinfo
```

See [packaging/arch/README.md](packaging/arch/README.md) for the local and
release packaging workflow.

## Payload

The package installs Dunst configuration and themes under
`/usr/share/argvus/notifications/`, including the notification helper script.

## License

SPDX: `GPL-3.0-only`. See [LICENSE](LICENSE).
