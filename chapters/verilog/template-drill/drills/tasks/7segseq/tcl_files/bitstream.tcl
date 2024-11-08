open_project build_project/build.xpr
update_compile_order -fileset sources_1
reset_runs synth_1
reset_runs impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_runs impl_1