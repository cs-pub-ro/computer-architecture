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

  command yosys -p "synth_xilinx -flatten -abc9 -arch xc7 -top ${top}; write_json ${top}.json" "${sources[@]}"
  command nextpnr-xilinx --chipdb "$chipdb_file" --xdc "$xdc" \
    --json "${top}.json" --write "${top}_routed.json" --fasm "${top}.fasm"
  command fasm2frames --db-root "${PRJXRAY_DB_DIR}/artix7" --part "$FPGA_PART" \
    "${top}.fasm" > "${top}.frames"
  command xc7frames2bit --part_file "$part_database" --part_name "$FPGA_PART" \
    --frm_file "${top}.frames" --output_file "${top}.bit"
}

fpga_flash() {
  if (( $# != 1 )); then
    SDC_log_error 'Usage: fpga_flash <bitstream.bit>'
    return 2
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
