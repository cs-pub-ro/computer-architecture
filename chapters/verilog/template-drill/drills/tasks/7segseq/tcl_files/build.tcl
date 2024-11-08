create_project build build_project -part xc7a100tcsg324-1 -force
import_files -force -fileset sources_1 -norecurse [exec ls | grep \\.v | grep -v test_]
import_files -force -fileset sim_1 -norecurse [exec ls | grep "test_.*\\.v"]
import_files -force -fileset constrs_1 -norecurse [exec ls | grep \\.xdc]
set_property top fsm_top [get_fileset sources_1]
set_property top test_task0 [get_fileset sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
