all: build
.SUFFIXES:

build: build_project/build.xpr

SRCS = $(filter_out test_*.v, $(wildcard *.v)) $(wildcard *.xdc)

build_project/build.xpr:
	vivado -mode batch -source tcl_files/build.tcl
	tcl_files/gen_links.sh

run: build_project/build.xpr
	vivado -mode batch -source tcl_files/run.tcl

simulation: build_project/build.xpr
	vivado -mode batch -source tcl_files/simulation.tcl

vivado: build_project/build.xpr
	vivado build_project/build.xpr

.mak:
	mkdir .mak

.mak/bitstream.mak: $(SRCS) | build_project/build.xpr .mak
	echo $(SRCS)
	vivado -mode batch -source tcl_files/bitstream.tcl
	touch $@

bitstream: .mak/bitstream.mak

flash: bitstream
	ps aux | grep "hw_server" | grep -v grep >/dev/null || hw_server > /dev/null &
	vivado -mode batch -source tcl_files/flash.tcl

.PHONY: clean flash bitstream vivado simulation run
clean:
	rm -rf vivado*
	rm -rf build_project
	rm -rf .Xil
	rm -rf .mak