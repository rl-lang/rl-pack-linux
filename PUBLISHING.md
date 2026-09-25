# Publishing (Linux)

Step-by-step notes for each target. Run `./bump.sh <version>` and
`./fetch-hashes.sh <version>` first, then follow the section you need.

## Debian / Ubuntu (PPA)

1. Install tools: `sudo apt install build-essential devscripts debhelper`
2. Copy `debian/*` into `debian/` of a source tree, or build the source
   package directly from this repo layout.
3. Build: `dpkg-buildpackage -us -uc`
4. Upload to your PPA: `dput ppa:your/ppa ../*.changes`
5. Users install: `sudo apt install rl-lang`

## Fedora (COPR)

1. Install tools: `sudo dnf install rpm-build`
2. Build: `rpmbuild -ba rpm/rl-lang.spec`
3. Create a COPR repo at `copr.fedorainfracloud.org` and upload the SRPM.
4. Users enable the repo and install: `sudo dnf install rl-lang`

## Arch Linux (AUR)

1. Regenerate metadata: `cd aur && makepkg --printsrcinfo > .SRCINFO`
2. Test locally: `makepkg -si`
3. Push to the AUR:
   ```
   git clone ssh://aur@aur.archlinux.org/rl-lang.git
   cp aur/PKGBUILD rl-lang/
   cd rl-lang
   makepkg -si  # test
   git add -A && git commit -m "v2.2.1"
   git push
   ```
3. Users install: `yay -S rl-lang` or `paru -S rl-lang`

## Gentoo

`gentoo/` is a complete overlay tree. Copy it into place:

1. `cp -r gentoo /var/db/repos/rl-pack-linux` (or into your own
   overlay's root).
2. Manifest: `ebuild /var/db/repos/rl-pack-linux/dev-lang/rl-lang/rl-lang-9999.ebuild manifest`
3. Test: `emerge --pretend rl-lang`
4. To register it with eselect, add a repos.conf entry pointing
   `location` at the copy.

For a versioned release ebuild, copy the 9999 ebuild to
`rl-lang-<version>.ebuild`, drop the git source, and use a tarball
URL instead.

## Nix

**nixpkgs:**

1. Fork `NixOS/nixpkgs`.
2. Add `pkgs/by-name/rl/rl-lang/package.nix` using `nix/rl-lang.nix`
   as base.
3. Update `hash` and `cargoHash` with actual values.
4. Test with `nix-build -A rl-lang`.
5. Submit a PR to nixpkgs.

**flake (this repo):**

```
nix run github:rl-lang/rl-pack-linux
```

## Snap

1. Install snapcraft: `sudo snap install snapcraft --classic`
2. Build: `cd snap && snapcraft`
3. Test: `sudo snap install rl_*.snap --classic`
4. Publish: `snapcraft login` then `snapcraft upload rl_*.snap`
5. Users install: `sudo snap install rl --classic`
   (if the `rl` name is taken in the store, register `rl-lang` and
   rename `name:` in `snapcraft.yaml`).

## Flatpak

1. Generate cargo sources:
   ```
   wget https://raw.githubusercontent.com/flatpak/flatpak-builder-tools/master/cargo/flatpak-cargo-generator.py
   python3 flatpak-cargo-generator.py Cargo.lock -o cargo-sources.json
   ```
2. Update `sha256` in `flatpak/io.github.rl-lang.rl.yml`.
3. Build: `flatpak-builder --force-clean build-dir flatpak/io.github.rl-lang.rl.yml`
4. Test: `flatpak-builder --run build-dir flatpak/io.github.rl-lang.rl.yml rl`
5. Submit to Flathub: fork `flathub/io.github.rl-lang.rl`, add the
   manifest, submit a PR.
6. Users install: `flatpak install flathub io.github.rl-lang.rl`
