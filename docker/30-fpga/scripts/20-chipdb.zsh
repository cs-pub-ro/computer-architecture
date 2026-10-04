#!/usr/bin/zsh
set -euo pipefail

source /opt/openxc7/export.sh
part_without_speed="${FPGA_PART%-*}"
bba_file="$(mktemp --suffix=.bba)"
trap 'rm -f "$bba_file"' EXIT

mkdir -p /opt/openxc7/chipdb
python3 "$NEXTPNR_XILINX_DIR/share/nextpnr/himbaechel/uarch/xilinx/gen/xilinx_gen.py" \
    --xray "$PRJXRAY_DB_DIR/artix7" \
    --device xc7a100t \
    --bba "$bba_file"
"$NEXTPNR_XILINX_DIR/bin/bbasm" -l "$bba_file" \
    "/opt/openxc7/chipdb/${part_without_speed}.bin"
test -s "/opt/openxc7/chipdb/${part_without_speed}.bin"
