create_project build build_project -part xc7a100tcsg324-1 -force
import_files -force -fileset sources_1 -norecurse display_led7.v
import_files -force -fileset constrs_1 -norecurse display_led7.xdc
set_property top  display_led7.v [get_fileset sources_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
