#!/usr/bin/zsh
set -euo pipefail

APT_TARGETS=()

# Yosys parser generators and native build support.
APT_TARGETS+=("bison")
APT_TARGETS+=("flex")
APT_TARGETS+=("gawk")
APT_TARGETS+=("pkg-config")

# Yosys optional runtime integrations enabled by the course flow.
APT_TARGETS+=("libffi-dev")
APT_TARGETS+=("libreadline-dev")
APT_TARGETS+=("tcl-dev")
APT_TARGETS+=("zlib1g-dev")

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

git clone --depth 1 --recurse-submodules --shallow-submodules \
    --branch "$YOSYS_VERSION" https://github.com/YosysHQ/yosys.git "$build_root/yosys"
actual_commit=$(git -C "$build_root/yosys" rev-parse HEAD)
if [[ "$actual_commit" != "$YOSYS_COMMIT" ]]; then
    print -u2 -- "Yosys tag $YOSYS_VERSION resolved to unexpected commit $actual_commit"
    exit 1
fi

export CMAKE_POLICY_VERSION_MINIMUM=3.5
cmake -S "$build_root/yosys" -B "$build_root/build" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/yosys
cmake --build "$build_root/build" --parallel "${BUILD_JOBS:-$(nproc)}"
cmake --install "$build_root/build" --strip

/opt/yosys/bin/yosys -Q -p 'help synth_xilinx' >/dev/null
