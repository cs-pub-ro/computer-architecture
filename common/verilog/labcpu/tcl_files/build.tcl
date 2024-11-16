create_project build build_project -part xc7a100tcsg324-1 -force
import_files -force -fileset sources_1 -norecurse state_display.v cpu_debugger_top.v
import_files -force -fileset constrs_1 -norecurse cpu_debugger_top.xdc
set_property top cpu_debugger_top.v [get_fileset sources_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1