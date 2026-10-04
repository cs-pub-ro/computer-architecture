ac_versions() {
  printf 'Ubuntu: '
  . /etc/os-release
  printf '%s\n' "$PRETTY_NAME"
  if [[ -r /etc/sdc-apt-snapshot ]]; then
    printf 'APT snapshot: %s\n' "$(< /etc/sdc-apt-snapshot)"
  else
    printf 'APT snapshot: %s\n' "${UBUNTU_SNAPSHOT:-disabled}"
  fi
  printf 'Architecture: %s\n' "$(dpkg --print-architecture)"

  local tool
  for tool in bash zsh git git-lfs gcc g++ make cmake python3 yosys verilator typst rustc cargo openFPGALoader; do
    if (( $+commands[$tool] )); then
      if [[ "$tool" == openFPGALoader ]]; then
        printf '%-12s %s\n' "$tool" "$(dpkg-query -W -f='${Version}' openfpgaloader 2>/dev/null || printf 'unknown')"
      else
        printf '%-12s %s\n' "$tool" "$(command "$tool" --version 2>&1 | sed -n '1p')"
      fi
    fi
  done
}
