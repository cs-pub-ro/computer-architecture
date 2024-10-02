create_project build build_project -part xc7a100tcsg324-1 -force
import_files -force -fileset sources_1 -norecurse ../fulladder/fulladder.v ../fulladder/halfadder.v adder_4bits.v
import_files -force -fileset sim_1 -norecurse test_adder_4bits.v
import_files -force -fileset constrs_1 -norecurse adder_4bits.xdc
set_property top adder_4bits [get_fileset sources_1]
set_property top test_adder_4bits [get_fileset sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
