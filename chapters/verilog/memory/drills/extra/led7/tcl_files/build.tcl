create_project build build_project -part xc7a100tcsg324-1 -force
import_files -force -fileset sources_1 -norecurse sequential_led7.v
import_files -force -fileset constrs_1 -norecurse sequential_led7.xdc
set_property top sequential_led7 [get_fileset sources_1]
update_compile_order -fileset sources_1
