#!/usr/bin/zsh
set -euo pipefail

case "$TARGETARCH" in
    amd64)
        rustup_target=x86_64-unknown-linux-gnu
        rustup_sha256="$RUSTUP_SHA256_AMD64"
        ;;
    arm64)
        rustup_target=aarch64-unknown-linux-gnu
        rustup_sha256="$RUSTUP_SHA256_ARM64"
        ;;
    *)
        print -u2 -- "Unsupported Rust target architecture: $TARGETARCH"
        exit 2
        ;;
esac

if [[ ${#rustup_sha256} -ne 64 || "$rustup_sha256" == *[^[:xdigit:]]* ]]; then
    print -u2 -- "A valid rustup SHA-256 is required for $TARGETARCH."
    exit 2
fi

export RUSTUP_HOME=/opt/rustup
export CARGO_HOME=/opt/cargo

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
rustup_url="https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${rustup_target}/rustup-init"
curl -fsSL --retry 3 "$rustup_url" -o "$tmpdir/rustup-init"
printf '%s  %s\n' "$rustup_sha256" "$tmpdir/rustup-init" | sha256sum --check --status
chmod 0755 "$tmpdir/rustup-init"
"$tmpdir/rustup-init" -y --profile minimal \
    --default-toolchain "$RUST_VERSION" --no-modify-path

/opt/cargo/bin/rustup component add rustfmt clippy rust-src
/opt/cargo/bin/rustc --version
/opt/cargo/bin/cargo --version
