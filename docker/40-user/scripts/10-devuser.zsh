#!/usr/bin/zsh
set -euo pipefail

if (( EUID != 0 )); then
    print -u2 -- 'This setup script must run as root.'
    exit 1
fi

user_home="/home/${DEV_USER}"
if ! getent group "$DEV_GID" >/dev/null; then
    groupadd --gid "$DEV_GID" "$DEV_USER"
fi

if getent passwd "$DEV_USER" >/dev/null; then
    occupant=$(getent passwd "$DEV_UID" | cut -d: -f1 || true)
    if [[ -n "$occupant" && "$occupant" != "$DEV_USER" ]]; then
        print -u2 -- "UID ${DEV_UID} is already used by ${occupant}."
        exit 1
    fi
    usermod --uid "$DEV_UID" --gid "$DEV_GID" --home "$user_home" \
        --shell /usr/bin/zsh "$DEV_USER"
elif getent passwd "$DEV_UID" >/dev/null; then
    old_user=$(getent passwd "$DEV_UID" | cut -d: -f1)
    usermod --login "$DEV_USER" --uid "$DEV_UID" --gid "$DEV_GID" \
        --home "$user_home" --move-home --shell /usr/bin/zsh "$old_user"
else
    useradd --create-home --uid "$DEV_UID" --gid "$DEV_GID" \
        --shell /usr/bin/zsh "$DEV_USER"
fi

for group in sudo plugdev dialout; do
    if ! getent group "$group" >/dev/null; then
        groupadd "$group"
    fi
    usermod --append --groups "$group" "$DEV_USER"
done

printf '%s ALL=(ALL) NOPASSWD:ALL\n' "$DEV_USER" > "/etc/sudoers.d/${DEV_USER}"
chmod 0440 "/etc/sudoers.d/${DEV_USER}"
visudo -c -f "/etc/sudoers.d/${DEV_USER}"
chsh -s /usr/bin/zsh "$DEV_USER"

mkdir -p "$user_home/.cargo/bin"
if [[ -d /opt/cargo/bin ]]; then
    for rust_proxy in /opt/cargo/bin/*(N); do
        ln -sfn "$rust_proxy" "$user_home/.cargo/bin/${rust_proxy:t}"
    done
fi
chown -R "$DEV_USER":"$(id -gn "$DEV_USER")" "$user_home"
