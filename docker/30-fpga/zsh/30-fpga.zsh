fpga_build() {
  if (( $# < 1 )); then
    SDC_log_error 'Usage: fpga_build <top-module> [verilog-source ...]'
    return 2
  fi

  local top="$1"
  shift
  if [[ ! "$top" =~ '^[A-Za-z_][A-Za-z0-9_$]*$' ]]; then
    SDC_log_error "Invalid Verilog top-module name: $top"
    return 2
  fi

  local -a sources
  if (( $# )); then
    sources=("$@")
  else
    for source_file in ./*.v(N); do
      [[ "${source_file:t}" == test_* ]] && continue
      sources+=("$source_file")
    done
  fi
  if (( ${#sources} == 0 )); then
    SDC_log_error 'No Verilog source files found.'
    return 2
  fi

  local xdc="${FPGA_XDC:-${top}.xdc}"
  local frequency="${FPGA_FREQ:-100}"
  if [[ ! "$frequency" =~ '^[0-9]+([.][0-9]+)?$' ]]; then
    SDC_log_error "Invalid FPGA target frequency in MHz: $frequency"
    return 2
  fi
  local part_database="${PRJXRAY_DB_DIR}/artix7/${FPGA_PART}/part.yaml"
  local part_without_speed="${FPGA_PART%-*}"
  local chipdb_file="${CHIPDB}/${part_without_speed}.bin"
  if [[ ! -r "$xdc" ]]; then
    SDC_log_error "Constraint file not found: $xdc"
    return 1
  fi
  if [[ ! -r "$part_database" || ! -r "$chipdb_file" ]]; then
    SDC_log_error "OpenXC7 database is missing for $FPGA_PART."
    return 1
  fi

  local temp_bit="${top}.bit.tmp.$$"
  local openxc7_xdc="${top}_openxc7.xdc"
  rm -f -- "${top}.bit" "$temp_bit"
  command sed -e 's/get_ports { /get_ports {/g' -e 's/ }]/}]/g' -e 's/];/]/g' \
    "$xdc" > "$openxc7_xdc" || return $?

  command yosys -p "synth_xilinx -flatten -abc9 -arch xc7 -top ${top}; write_json ${top}.json" "${sources[@]}" || return $?
  command nextpnr-xilinx --chipdb "$chipdb_file" --xdc "$openxc7_xdc" --freq "$frequency" \
     --json "${top}.json" --write "${top}_routed.json" --fasm "${top}.fasm" || return $?
  command fasm2frames --db-root "${PRJXRAY_DB_DIR}/artix7" --part "$FPGA_PART" \
    "${top}.fasm" > "${top}.frames" || return $?
  if command xc7frames2bit --part_file "$part_database" --part_name "$FPGA_PART" \
    --frm_file "${top}.frames" --output_file "$temp_bit"; then
    :
  else
    local result=$?
    rm -f -- "$temp_bit"
    return "$result"
  fi
  if [[ ! -s "$temp_bit" ]]; then
    SDC_log_error "Bitstream conversion did not create a nonempty file for $top."
    rm -f -- "$temp_bit"
    return 1
  fi
  command mv -f -- "$temp_bit" "${top}.bit" || return $?
}

fpga_flash() {
  if (( $# != 1 )); then
    SDC_log_error 'Usage: fpga_flash <bitstream.bit>'
    return 2
  fi
  if [[ ! -r "$1" ]]; then
    SDC_log_error "Bitstream not found: $1"
    return 1
  fi
  local -a privilege=()
  if (( EUID != 0 )); then
    privilege=(sudo)
  fi
  command "${privilege[@]}" openFPGALoader --board "$FPGA_BOARD" "$1"
}

fpga_detect() {
  local -a privilege=()
  if (( EUID != 0 )); then
    privilege=(sudo)
  fi
  command "${privilege[@]}" openFPGALoader --detect
}
