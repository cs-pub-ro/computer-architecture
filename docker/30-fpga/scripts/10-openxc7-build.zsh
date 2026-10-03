#!/usr/bin/zsh
set -euo pipefail

APT_TARGETS=()

# Native build tools for the openXC7 source toolchain.
APT_TARGETS+=("build-essential")
APT_TARGETS+=("cmake")
APT_TARGETS+=("pkg-config")
APT_TARGETS+=("bison")
APT_TARGETS+=("flex")
APT_TARGETS+=("gawk")

# Python, parser, and Java runtime requirements of Project X-Ray/FASM.
APT_TARGETS+=("python3-dev")
APT_TARGETS+=("python3-venv")
APT_TARGETS+=("default-jre-headless")
APT_TARGETS+=("pypy3")
APT_TARGETS+=("uuid-dev")

# Libraries used while compiling the Xilinx database engine.
APT_TARGETS+=("libboost-filesystem-dev")
APT_TARGETS+=("libboost-iostreams-dev")
APT_TARGETS+=("libboost-thread-dev")
APT_TARGETS+=("libboost-program-options-dev")
APT_TARGETS+=("libboost-python-dev")
APT_TARGETS+=("libeigen3-dev")
APT_TARGETS+=("libreadline-dev")
APT_TARGETS+=("zlib1g-dev")
APT_TARGETS+=("tcl-dev")
APT_TARGETS+=("libffi-dev")
APT_TARGETS+=("graphviz")
APT_TARGETS+=("xdot")

build_root=$(mktemp -d)
cleanup() {
    rm -rf "$build_root"
    apt-get -q clean || true
    rm -rf /var/lib/apt/lists/*
}
trap cleanup EXIT

export DEBIAN_FRONTEND=noninteractive
apt-get -q update
apt-get -q install -y --no-install-recommends "${APT_TARGETS[@]}"

git clone --depth 1 --branch "$OPENXC7_INSTALLER_VERSION" \
    https://github.com/openXC7/toolchain-installer.git "$build_root/toolchain-installer"
actual_commit=$(git -C "$build_root/toolchain-installer" rev-parse HEAD)
if [[ "$actual_commit" != "$OPENXC7_INSTALLER_COMMIT" ]]; then
    print -u2 -- "openXC7 installer $OPENXC7_INSTALLER_VERSION resolved to unexpected commit $actual_commit"
    exit 1
fi

export CMAKE_POLICY_VERSION_MINIMUM=3.5
INSTALL_PREFIX=/opt/openxc7 JOBS="${BUILD_JOBS:-$(nproc)}" \
    bash "$build_root/toolchain-installer/toolchain-sources-builder.sh" prjxray nextpnr

test -x /opt/openxc7/bin/nextpnr-xilinx
test -x /opt/openxc7/bin/bbasm
test -f /opt/openxc7/export.sh
