#!/usr/bin/zsh
set -euo pipefail

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8
ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
printf '%s\n' "$TZ" > /etc/timezone
