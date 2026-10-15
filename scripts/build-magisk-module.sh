#!/bin/sh
#### Build a flashable Magisk / KernelSU / APatch module zip of Online Nandroid
#### Usage: scripts/build-magisk-module.sh [output.zip]
set -e
root=$(cd "$(dirname "$0")/.." && pwd)
version=$(cat "$root/version")
out=${1:-$root/OnlineNandroid-v$version-magisk.zip}
case "$out" in /*) ;; *) out="$PWD/$out" ;; esac
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
cp -r "$root/magisk/." "$tmp/"
mkdir -p "$tmp/system/bin"
cp "$root/onandroid" "$tmp/system/bin/onandroid"
chmod 755 "$tmp/system/bin/onandroid"
sed -i "s/^version=.*/version=v$version/" "$tmp/module.prop"
rm -f "$out"
(cd "$tmp" && zip -qr9 "$out" .)
echo "Built $out"
