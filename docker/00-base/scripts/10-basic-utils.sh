#!/usr/bin/bash
set -euo pipefail

trap 'echo "ERROR at line $LINENO: basic utility installation failed" >&2' ERR

APT_TARGETS=()

# Everyday shell and file utilities.
APT_TARGETS+=("apt-utils")
APT_TARGETS+=("bash-completion")
APT_TARGETS+=("bzip2")
APT_TARGETS+=("ca-certificates")
APT_TARGETS+=("coreutils")
APT_TARGETS+=("file")
APT_TARGETS+=("gnupg")
APT_TARGETS+=("htop")
APT_TARGETS+=("less")
APT_TARGETS+=("moreutils")
APT_TARGETS+=("procps")
APT_TARGETS+=("psmisc")
APT_TARGETS+=("rsync")
APT_TARGETS+=("sudo")
APT_TARGETS+=("tar")
APT_TARGETS+=("tree")
APT_TARGETS+=("unzip")
APT_TARGETS+=("xz-utils")
APT_TARGETS+=("zip")

# Network inspection and connectivity tools.
APT_TARGETS+=("iproute2")
APT_TARGETS+=("iputils-ping")
APT_TARGETS+=("net-tools")
APT_TARGETS+=("netcat-openbsd")
APT_TARGETS+=("openssh-client")
APT_TARGETS+=("ssh")

# Native compilation and build systems.
APT_TARGETS+=("build-essential")
APT_TARGETS+=("cmake")
APT_TARGETS+=("ninja-build")
APT_TARGETS+=("pkg-config")

# Python runtime for course scripts and toolchain utilities.
APT_TARGETS+=("python3")
APT_TARGETS+=("python3-pip")
APT_TARGETS+=("python3-venv")
APT_TARGETS+=("python-is-python3")

# Shell, source control, debugging, and formatting.
APT_TARGETS+=("zsh")
APT_TARGETS+=("git")
APT_TARGETS+=("git-lfs")
APT_TARGETS+=("gdb")
APT_TARGETS+=("vim")
APT_TARGETS+=("nano")
APT_TARGETS+=("clang-format")
APT_TARGETS+=("shellcheck")
APT_TARGETS+=("wget")
APT_TARGETS+=("curl")
APT_TARGETS+=("locales")
APT_TARGETS+=("lsb-release")
APT_TARGETS+=("tzdata")

export DEBIAN_FRONTEND=noninteractive
apt-get -q update
apt-get -q install -y --no-install-recommends "${APT_TARGETS[@]}"
git lfs install --system
apt-get -q clean
rm -rf /var/lib/apt/lists/*
