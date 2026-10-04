vsim() {
  command iverilog -Wall -Winfloop "$@"
}

vrun() {
  command vvp "$@"
}

vwave() {
  command gtkwave "$@" &!
}

vlint() {
  command verilator --lint-only --Wall "$@"
}
