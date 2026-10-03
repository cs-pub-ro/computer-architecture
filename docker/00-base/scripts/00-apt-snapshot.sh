#!/usr/bin/bash
set -euo pipefail

trap 'echo "ERROR at line $LINENO: apt snapshot setup failed" >&2' ERR
export DEBIAN_FRONTEND=noninteractive

if [[ "${UBUNTU_SNAPSHOT:-none}" == "none" ]]; then
    printf '%s\n' 'disabled by build configuration' > /etc/sdc-apt-snapshot
    echo "Ubuntu archive snapshots disabled."
    exit 0
fi

if [[ ! "${UBUNTU_SNAPSHOT}" =~ ^[0-9]{8}T[0-9]{6}Z$ ]]; then
    echo "UBUNTU_SNAPSHOT must use YYYYMMDDTHHMMSSZ or be set to none." >&2
    exit 2
fi

apt-get update
apt-get install -y --no-install-recommends ca-certificates gnupg ubuntu-keyring
apt-get clean
rm -rf /var/lib/apt/lists/*

test -s /usr/share/keyrings/ubuntu-archive-keyring.gpg

if grep -q 'ports.ubuntu.com' /etc/apt/sources.list.d/ubuntu.sources; then
    rm -f /etc/apt/apt.conf.d/50snapshot
    printf '%s\n' 'unavailable: Ubuntu ports archive does not publish snapshot metadata' > /etc/sdc-apt-snapshot
    echo "Ubuntu snapshot service does not expose the configured ports archive; using live packages for $(dpkg --print-architecture)."
    apt-get update
    apt-get clean
    rm -rf /var/lib/apt/lists/*
    exit 0
fi

printf 'APT::Snapshot "%s";\n' "$UBUNTU_SNAPSHOT" > /etc/apt/apt.conf.d/50snapshot

apt-get update 2>&1 | tee /tmp/apt-snapshot-update.log
if ! grep -q 'snapshot.ubuntu.com' /tmp/apt-snapshot-update.log; then
    echo "APT did not use snapshot.ubuntu.com; refusing an unpinned archive." >&2
    exit 1
fi
printf '%s\n' "$UBUNTU_SNAPSHOT" > /etc/sdc-apt-snapshot
rm -f /tmp/apt-snapshot-update.log
