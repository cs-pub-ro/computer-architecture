all: build

build: build_project/build.xpr

build_project/build.xpr:
	vivado -mode batch -source tcl_files/build.tcl

run: build_project/build.xpr
	vivado -mode batch -source tcl_files/run.tcl

simulation: build_project/build.xpr
	vivado -mode batch -source tcl_files/simulation.tcl

clean:
	rm -rf vivado* 
	rm -rf build_project
	rm -rf .Xil