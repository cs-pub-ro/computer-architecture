#!/usr/bin/zsh
set -euo pipefail

stage="${1:?}"
[[ "$stage" =~ '^[a-zA-Z0-9_-]+$' ]] || exit 2

zdotdir="${ZDOTDIR:-$HOME}"
zshrc="$zdotdir/.zshrc"
mkdir -p "$zdotdir"
touch "$zshrc"

marker="# SDC runtime environment: ${stage}"
grep -Fq "$marker" "$zshrc" && exit 0

{
    print -r -- ""
    print -r -- "$marker"
    print -r -- "SDC_STAGE='${stage}'"
    cat <<'LOADER'
if [[ -n "${SDC_ROOT:-}" ]]; then
  SDC_STAGE_ROOT="${SDC_ROOT}/docker/${SDC_STAGE}"
  if [[ -d "$SDC_STAGE_ROOT/zsh" ]]; then
    for SDC_FILE in "$SDC_STAGE_ROOT"/zsh/*.zsh(N); do
      source "$SDC_FILE"
    done
  fi

  SDC_ENV_ROOT="$SDC_STAGE_ROOT/env"
  if [[ -d "$SDC_ENV_ROOT" ]]; then
    for SDC_FILE in "$SDC_ENV_ROOT"/*.zsh(N); do
      source "$SDC_FILE"
    done
  fi
fi
unset SDC_STAGE_ROOT SDC_ENV_ROOT SDC_FILE
LOADER
} >> "$zshrc"