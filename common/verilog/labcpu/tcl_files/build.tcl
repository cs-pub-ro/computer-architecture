create_project build build_project -part xc7a100tcsg324-1 -force
import_files -force -fileset sources_1 -norecurse alu.v bus.v cpu.v cram.v register.v registers.v uc.v cram.data task0.v
import_files -force -fileset sim_1 -norecurse test_task0.v
import_files -force -fileset constrs_1 -norecurse task0.xdc
set_property top task0 [get_fileset sources_1]
set_property top test_task0 [get_fileset sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
