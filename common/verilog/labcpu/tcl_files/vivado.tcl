create_project build build_project -part xc7a100tcsg324-1 -force
import_files -force -fileset sources_1 -norecurse cpu_debugger.v alu.v bus.v control_unit.v cpu.v cram.data cram.v state_display.v ../core/clock_divider.v ../core/debouncer.v ../memory/block_ram.v ../memory/block_dpram.v ../memory/register.v ../memory/regfile.v
import_files -force -fileset sim_1 -norecurse test_cpu_debugger.v
import_files -force -fileset constrs_1 -norecurse cpu_debugger.xdc
set_property top cpu_debugger [get_fileset sources_1]
set_property top test_cpu_debugger [get_fileset sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
start_gui