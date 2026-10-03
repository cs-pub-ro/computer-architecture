tc() {
  if [[ -z "${SDC_ROOT:-}" ]]; then
    SDC_log_error 'Set SDC_ROOT to the mounted course repository before compiling.'
    return 2
  fi
  command typst compile --root "$SDC_ROOT" "$@"
}

tw() {
  if [[ -z "${SDC_ROOT:-}" ]]; then
    SDC_log_error 'Set SDC_ROOT to the mounted course repository before watching.'
    return 2
  fi
  command typst watch --root "$SDC_ROOT" "$@"
}
