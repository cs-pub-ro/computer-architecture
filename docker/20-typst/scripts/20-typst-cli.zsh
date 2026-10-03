#!/usr/bin/zsh
set -euo pipefail

case "$TARGETARCH" in
    amd64)
        typst_target=x86_64-unknown-linux-musl
        typst_sha256="$TYPST_SHA256_AMD64"
        ;;
    arm64)
        typst_target=aarch64-unknown-linux-musl
        typst_sha256="$TYPST_SHA256_ARM64"
        ;;
    *)
        print -u2 -- "Unsupported Typst target architecture: $TARGETARCH"
        exit 2
        ;;
esac

if [[ ${#typst_sha256} -ne 64 || "$typst_sha256" == *[^[:xdigit:]]* ]]; then
    print -u2 -- "A valid SHA-256 is required for Typst $TARGETARCH."
    exit 2
fi

archive="typst-${typst_target}.tar.xz"
url="https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/${archive}"
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

curl -fsSL --retry 3 "$url" -o "$tmpdir/$archive"
printf '%s  %s\n' "$typst_sha256" "$tmpdir/$archive" | sha256sum --check --status
tar -xJf "$tmpdir/$archive" -C "$tmpdir" --strip-components=1
install -m 0755 "$tmpdir/typst" /usr/local/bin/typst
typst --version
