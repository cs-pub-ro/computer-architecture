create_project build build_project -part xc7a100tcsg324-1 -force
import_files -force -fileset sources_1 -norecurse led7.v
import_files -force -fileset sim_1 -norecurse test_led7.v
import_files -force -fileset constrs_1 -norecurse led7.xdc
set_property top led7 [get_fileset sources_1]
set_property top test_led7 [get_fileset sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
