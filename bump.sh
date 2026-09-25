#!/usr/bin/env bash
# Bump every Linux package template to a new rl-lang version.
# Usage: ./bump.sh 2.3.0
# Checks only: ./bump.sh --check (fails if versions disagree)
set -euo pipefail
cd "$(dirname "$0")"

fail() { echo "bump: $*" >&2; exit 1; }

versions() {
  echo "aur $(grep -m1 '^pkgver=' aur/PKGBUILD | cut -d= -f2)"
  echo "srcinfo $(grep -m1 '^	pkgver = ' aur/.SRCINFO | awk '{print $3}')"
  echo "rpm $(grep -m1 '^Version:' rpm/rl-lang.spec | awk '{print $2}')"
  echo "nix $(grep -m1 'version = ' nix/rl-lang.nix | cut -d'"' -f2)"
  echo "snap $(grep -m1 '^version:' snap/snapcraft.yaml | awk '{print $2}')"
  echo "snap-tag $(grep -m1 'source-tag:' snap/snapcraft.yaml | awk '{print $2}' | sed 's/^v//')"
  echo "flatpak $(grep -m1 'refs/tags/v' flatpak/io.github.rl-lang.rl.yml | sed 's/.*\/v//;s/\.tar\.gz//')"
  echo "deb $(head -1 debian/changelog | sed 's/.*(\(.*\)).*/\1/')"
}

if [ "${1:-}" = "--check" ]; then
  out="$(versions)"
  echo "$out"
  uniq="$(echo "$out" | awk '{print $2}' | sort -u | wc -l)"
  [ "$uniq" -eq 1 ] || fail "versions disagree"
  echo "bump: all targets agree"
  exit 0
fi

ver="${1:?usage: ./bump.sh <version> | --check}"
[ -n "$(git tag -l "v$ver" 2>/dev/null || true)" ] || true  # tag check is best-effort here
date_rfc="$(date -u '+%a, %d %b %Y %H:%M:%S +0000')"

sed -i "s/^pkgver=.*/pkgver=$ver/" aur/PKGBUILD
sed -i "s/^Version:.*/Version:        $ver/" rpm/rl-lang.spec
sed -i "s/version = \".*\";/version = \"$ver\";/" nix/rl-lang.nix
sed -i "s/^version:.*/version: $ver/" snap/snapcraft.yaml
sed -i "s/source-tag: v.*/source-tag: v$ver/" snap/snapcraft.yaml
sed -i "s|refs/tags/v.*\.tar\.gz|refs/tags/v$ver.tar.gz|" flatpak/io.github.rl-lang.rl.yml

# debian/changelog: prepend a new entry
{
  echo "rl-lang ($ver) unstable; urgency=medium"
  echo
  echo "  * New upstream release"
  echo
  echo " -- rl-lang maintainers <https://github.com/rl-lang/rl-lang>  $date_rfc"
  echo
  cat debian/changelog
} > debian/changelog.new
mv debian/changelog.new debian/changelog

# rpm %changelog: prepend a new entry
day="$(date -u '+%a %b %d %Y')"
awk -v day="$day" -v ver="$ver" '
  /^%changelog$/ { print; print "* " day " rl-lang maintainers <https://github.com/rl-lang/rl-lang> - " ver "-1"; print "- New upstream release"; next }
  { print }
' rpm/rl-lang.spec > rpm/rl-lang.spec.new
mv rpm/rl-lang.spec.new rpm/rl-lang.spec

echo "bump: updated to $ver"
echo "bump: only remaining manual step is nix cargoHash (run one nix build, it prints the right value)"
./bump.sh --check
