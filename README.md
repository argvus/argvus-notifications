# argvus-notifications

Dunst configuration, notification themes and notification integration for ARGVUS.

[![CI](https://github.com/argvus/argvus-notifications/actions/workflows/ci.yml/badge.svg)](https://github.com/argvus/argvus-notifications/actions/workflows/ci.yml)
[![Release](https://github.com/argvus/argvus-notifications/actions/workflows/release.yml/badge.svg)](https://github.com/argvus/argvus-notifications/actions/workflows/release.yml)
[![License](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)
[![Language: Shell](https://img.shields.io/badge/Shell-POSIX-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform: Arch Linux | Wayland](https://img.shields.io/badge/platform-Arch%20Linux%20%7C%20Wayland-1793D1?logo=archlinux&logoColor=white)](https://archlinux.org/)
[![Pull requests](https://img.shields.io/github/issues-pr/argvus/argvus-notifications)](https://github.com/argvus/argvus-notifications/pulls)
[![Issues](https://img.shields.io/github/issues/argvus/argvus-notifications)](https://github.com/argvus/argvus-notifications/issues)
[![Last commit](https://img.shields.io/github/last-commit/argvus/argvus-notifications)](https://github.com/argvus/argvus-notifications/commits/main)
[![Docs](https://img.shields.io/badge/docs-project-blue)](./docs/)

This repository provides the notification payload owned by ARGVUS. Runtime
ownership stays connected to `argvus sessionctl` and `argvus-session.target`.

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
makepkg -p packaging/arch/remote/PKGBUILD --printsrcinfo
makepkg -p packaging/arch/local/PKGBUILD --printsrcinfo
```

See [packaging/arch/README.md](packaging/arch/README.md) for the local and
release packaging workflow.

## Payload

The package installs Dunst configuration and themes under
`/usr/share/argvus/notifications/`, including the notification helper script.

## Contributing and policies

- [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) — contribution workflow
- [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — private vulnerability reports
- [Code of Conduct](https://github.com/argvus/.github/blob/main/policies/CODE_OF_CONDUCT.md) — community standards
- [AI usage policy](https://github.com/argvus/.github/blob/main/policies/IA_USAGE.md) — rules for AI-assisted contributions

## License

SPDX: `GPL-3.0-only`. See [LICENSE](LICENSE).
