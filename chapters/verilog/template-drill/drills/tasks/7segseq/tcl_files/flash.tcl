open_project build_project/build.xpr
open_hw_manager
connect_hw_server -url [exec uname -n]:3121 -allow_non_jtag
current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210292B40A57A]
set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/Digilent/210292B40A57A]
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
set_property PROBES.FILE {} [lindex [get_hw_devices] 0]
set_property FULL_PROBES.FILE {} [lindex [get_hw_devices] 0]
set_property PROGRAM.FILE [lindex [exec tcl_files/get_bit.sh] 0] [lindex [get_hw_devices] 0]
program_hw_devices [lindex [get_hw_devices] 0]
