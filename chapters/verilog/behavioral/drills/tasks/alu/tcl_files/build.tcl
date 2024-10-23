create_project build build_project -part xc7a100tcsg324-1 -force
import_files -force -fileset sources_1 -norecurse adder.v task2.v ../multiplier/multiplier.v
import_files -force -fileset sim_1 -norecurse test_task2.v
import_files -force -fileset constrs_1 -norecurse task2.xdc
set_property top task2 [get_fileset sources_1]
set_property top test_task2 [get_fileset sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
