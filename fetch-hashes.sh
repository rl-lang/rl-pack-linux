#!/usr/bin/env bash
# Refresh source-tarball hashes for a released rl-lang version.
# Usage: ./fetch-hashes.sh 2.3.0
# Run AFTER ./bump.sh <version>. Fills aur, nix hash, flatpak sha256.
# nix cargoHash still needs one real nix build (it prints the value).
set -euo pipefail
cd "$(dirname "$0")"
ver="${1:?usage: ./fetch-hashes.sh <version>}"

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
curl -fsSL "https://github.com/rl-lang/rl-lang/archive/refs/tags/v$ver.tar.gz" -o "$tmp/src.tar.gz"
hex="$(sha256sum "$tmp/src.tar.gz" | awk '{print $1}')"
sri="$(python3 -c "import base64,sys; print('sha256-' + base64.b64encode(bytes.fromhex(sys.argv[1])).decode())" "$hex")"

sed -i "s/^sha256sums=(.*/sha256sums=('$hex')/" aur/PKGBUILD
sed -i "s|^\(\t\)\?sha256sums = .*|\1sha256sums = $hex|" aur/.SRCINFO
sed -i "s|hash = \"sha256-.*\";|hash = \"$sri\";|" nix/rl-lang.nix
sed -i "s|sha256: .*|sha256: $hex|" flatpak/io.github.rl-lang.rl.yml

echo "fetch-hashes: src $hex"
./bump.sh --check
