#!/usr/bin/zsh
set -euo pipefail

APT_TARGETS=()

# FPGA programming utility and USB inspection.
APT_TARGETS+=("openfpgaloader")
APT_TARGETS+=("usbutils")

# Runtime libraries used by the source-built openXC7 executables.
APT_TARGETS+=("libboost-filesystem1.83.0")
APT_TARGETS+=("libboost-iostreams1.83.0")
APT_TARGETS+=("libboost-program-options1.83.0")
APT_TARGETS+=("libboost-python1.83.0")
APT_TARGETS+=("libboost-thread1.83.0")
APT_TARGETS+=("libffi8")
APT_TARGETS+=("libgomp1")
APT_TARGETS+=("libreadline8t64")
APT_TARGETS+=("libtcl8.6")
APT_TARGETS+=("zlib1g")

export DEBIAN_FRONTEND=noninteractive
apt-get -q update
apt-get -q install -y --no-install-recommends "${APT_TARGETS[@]}"

source /opt/openxc7/export.sh
export PATH="/opt/openxc7/bin:/opt/openxc7/venv/bin:$PATH"

nextpnr_dependencies=$(ldd /opt/openxc7/bin/nextpnr-himbaechel 2>&1)
if [[ "$nextpnr_dependencies" == *'not found'* ]]; then
    print -u2 -- "$nextpnr_dependencies"
    print -u2 -- 'An openXC7 runtime library is missing.'
    exit 1
fi

nextpnr-xilinx --version
openFPGALoader --help >/dev/null 2>&1
print -- "openFPGALoader $(dpkg-query -W -f='${Version}' openfpgaloader)"
apt-get -q clean
rm -rf /var/lib/apt/lists/*
