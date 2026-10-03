SDC_log_info() {
  print -r -- "SDC: $*"
}

SDC_log_warn() {
  print -u2 -r -- "SDC warning: $*"
}

SDC_log_error() {
  print -u2 -r -- "SDC error: $*"
}
