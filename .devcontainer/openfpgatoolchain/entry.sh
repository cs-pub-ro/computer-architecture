#!/bin/bash
yosys -p "synth_xilinx -flatten -nowidelut -arch xc7 -top $TOP; write_json $TOP.json" $(echo *.v)
/usr/bin/nextpnr-xilinx --chipdb /root/chipdb/xc7a100t.bin --xdc $TOP.xdc --json $TOP.json --write "${TOP}_routed.json" --fasm $TOP.fasm

source "${XRAY_DIR}/utils/environment.sh"

"${XRAY_UTILS_DIR}/fasm2frames.py" --db-root "${XRAY_DATABASE_DIR}/artix7" --part xc7a100tcsg324-1 $TOP.fasm > $TOP.frames
"${XRAY_TOOLS_DIR}/xc7frames2bit" --part_file "${XRAY_DATABASE_DIR}/artix7/xc7a100tcsg324-1/part.yaml" --part_name xc7a100tcsg324-1 --frm_file $TOP.frames --output_file $TOP.bit
