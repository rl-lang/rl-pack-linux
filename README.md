# rl-pack-linux

Linux packaging for [rl-lang](https://github.com/rl-lang/rl-lang):
deb, rpm, AUR, Gentoo overlay, Nix, Snap, and Flatpak.

## For users

| Format | Status | Install |
|--------|--------|---------|
| Debian / Ubuntu | PPA pending | `sudo apt install rl-lang` |
| Fedora | COPR pending | `sudo dnf install rl-lang` |
| Arch | needs AUR push | `yay -S rl-lang` |
| Gentoo | overlay ready (copy `gentoo/`) | `emerge rl-lang` |
| Nix | live | `nix run github:rl-lang/rl-pack-linux` |
| Snap | store pending | `sudo snap install rl --classic` |
| Flatpak | Flathub pending | `flatpak install flathub io.github.rl-lang.rl` |

Every format ships the full binary set:
`rl`, `rlc`, `rlt`, `rlrepl`, `rlsp`, `rldocs`, `rlm`.

## For maintainers

One command bumps all seven targets:

```bash
./bump.sh 2.3.0
./fetch-hashes.sh 2.3.0   # refreshes tarball hashes from the release
./bump.sh --check   # CI runs this
```

Then fill in the real hashes (`nix` hash/cargoHash, flatpak sha256),
test, and submit per [PUBLISHING.md](PUBLISHING.md).

## Layout

| Dir | Target |
|-----|--------|
| `debian/` | `.deb` source package (PPA) |
| `rpm/` | `.spec` file (COPR) |
| `aur/` | `PKGBUILD` plus `.SRCINFO` (AUR) |
| `gentoo/` | overlay tree (`dev-lang/rl-lang`, metadata, profiles) |
| `nix/` | `rl-lang.nix` plus `flake.nix` |
| `snap/` | `snapcraft.yaml` (Snap Store) |
| `flatpak/` | manifest (Flathub) |

## License

MIT or Apache 2.0 at your option.
