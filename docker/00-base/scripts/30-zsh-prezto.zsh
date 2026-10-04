#!/usr/bin/zsh
set -euo pipefail

zdotdir="${ZDOTDIR:-$HOME}"
prezto_dir="$zdotdir/.zprezto"

if [[ ! -d "$prezto_dir/.git" ]]; then
    git clone --depth 1 https://github.com/sorin-ionescu/prezto.git "$prezto_dir"
fi
git -C "$prezto_dir" submodule update --init --recursive --depth 1

setopt EXTENDED_GLOB
for rcfile in "$prezto_dir"/runcoms/^README.md(.N); do
    ln -sfn "$rcfile" "$zdotdir/.${rcfile:t}"
done

cat > "$zdotdir/.zpreztorc" <<'EOF'
zstyle ':prezto:module:prompt' theme 'steeef'
zstyle ':prezto:module:prompt' show-return-val 'yes'
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'history-substring-search' \
  'prompt' \
  'git'
EOF

