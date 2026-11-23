#!/bin/sh
set -eu

cd "$(dirname "$0")"
crate=hex-0.4.3
checksum=7f24254aa9a54b5c858eaee2f5bccdb46aaf0e486a595ed5fd8f86ba55232a70

mkdir -p .patched
staging=$(mktemp -d .patched/.prepare.XXXXXX)
trap 'rm -rf "$staging"' EXIT
trap 'exit 1' HUP INT TERM

archive="$staging/$crate.crate"
curl --fail --silent --show-error --location --connect-timeout 10 --max-time 30 \
    --output "$archive" "https://static.crates.io/crates/hex/$crate.crate"
printf '%s  %s\n' "$checksum" "$archive" | shasum -a 256 -c -
tar -xzf "$archive" -C "$staging"
patch -d "$staging/$crate" -p1 -F 0 -f < "patches/$crate.patch"

if [ -d ".patched/$crate" ]; then
    if ! diff -qr "$staging/$crate" ".patched/$crate"; then
        printf 'Generated crate differs. Remove .patched/%s and rerun prepare.sh.\n' "$crate" >&2
        exit 1
    fi
else
    mv "$staging/$crate" .patched/
fi
