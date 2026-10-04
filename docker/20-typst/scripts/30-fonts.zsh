#!/usr/bin/zsh
set -euo pipefail

APT_TARGETS=()

# Font discovery and redistributable serif, monospace, and Unicode families.
APT_TARGETS+=("fontconfig")
APT_TARGETS+=("fonts-liberation")
APT_TARGETS+=("fonts-dejavu-core")
APT_TARGETS+=("fonts-noto-core")
APT_TARGETS+=("fonts-noto-mono")

export DEBIAN_FRONTEND=noninteractive
apt-get -q update
apt-get -q install -y --no-install-recommends "${APT_TARGETS[@]}"
fc-cache -f /usr/share/fonts
fc-list | grep -i 'Liberation Serif' >/dev/null
apt-get -q clean
rm -rf /var/lib/apt/lists/*
