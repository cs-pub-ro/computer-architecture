create_project build build_project -part xc7a100tcsg324-1 -force
import_files -force -fileset sources_1 -norecurse adder_6bits.v ../adder_4bits/adder_4bits.v ../fulladder/fulladder.v ../fulladder/halfadder.v
import_files -force -fileset sim_1 -norecurse test_adder_6bits.v
import_files -force -fileset constrs_1 -norecurse adder_6bits.xdc
set_property top adder_6bits [get_fileset sources_1]
set_property top test_adder_6bits [get_fileset sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
