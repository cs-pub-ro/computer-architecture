#!/usr/bin/zsh
set -euo pipefail

APT_TARGETS=()

# HDL simulation and waveform inspection.
APT_TARGETS+=("iverilog")
APT_TARGETS+=("verilator")
APT_TARGETS+=("gtkwave")

# Yosys runtime libraries not guaranteed by its build dependencies.
APT_TARGETS+=("libffi8")
APT_TARGETS+=("libreadline8t64")
APT_TARGETS+=("libtcl8.6")
APT_TARGETS+=("zlib1g")

export DEBIAN_FRONTEND=noninteractive
apt-get -q update
apt-get -q install -y --no-install-recommends "${APT_TARGETS[@]}"

yosys_dependencies=$(ldd /opt/yosys/bin/yosys 2>&1)
if [[ "$yosys_dependencies" == *'not found'* ]]; then
    print -u2 -- "$yosys_dependencies"
    print -u2 -- 'A Yosys runtime library is missing.'
    exit 1
fi

yosys -V
iverilog -V >/dev/null 2>&1
verilator --version
gtkwave --version >/dev/null 2>&1 || true

apt-get -q clean
rm -rf /var/lib/apt/lists/*
