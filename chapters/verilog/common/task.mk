.DEFAULT_GOAL := all

TASK_DIR := $(CURDIR)
COMPILER ?= iverilog
INTERPRETER ?= vvp
SIMULATOR ?= gtkwave
YOSYS ?= yosys
DOT ?= dot
IVERILOG_FLAGS ?= -g2012 -Wall -Winfloop
SIM_TOP ?= test_$(TOP_MODULE)
TESTBENCH ?= test_$(TOP_MODULE).v
BUILD_DIR ?= build
BUILD_PATH := $(abspath $(BUILD_DIR))
SOURCES_ABS := $(foreach source,$(SOURCES),$(abspath $(source)))
FPGA_PART ?= xc7a100tcsg324-1
FPGA_BOARD ?= nexys_a7_100
FPGA_FREQ ?= 100
FPGA_XDC ?= $(TOP_MODULE).xdc
FPGA_XDC_PATH := $(abspath $(FPGA_XDC))

export FPGA_PART FPGA_BOARD FPGA_FREQ

.PHONY: all build run simulation synth bitstream flash clean help check-inputs check-build-dir check-fpga-inputs

all: build

check-build-dir:
	@case "$(BUILD_PATH)" in \
		"$(TASK_DIR)"/*|/tmp/verilog-task-build.*) ;; \
		*) echo "Refusing unsafe build directory: $(BUILD_PATH)" >&2; exit 1 ;; \
	esac

check-inputs:
	@for source in $(SOURCES) $(TESTBENCH); do \
		if [ ! -f "$$source" ]; then \
			echo "Verilog source not found: $$source" >&2; \
			exit 1; \
		fi; \
	done

build: check-build-dir check-inputs
	@mkdir -p "$(BUILD_PATH)"
	$(COMPILER) $(IVERILOG_FLAGS) -s "$(SIM_TOP)" -o "$(BUILD_PATH)/$(TOP_MODULE).vvp" $(SOURCES_ABS) "$(abspath $(TESTBENCH))"

run: build
	@rm -f "$(BUILD_PATH)/test.vcd"
	cd "$(BUILD_PATH)" && $(INTERPRETER) "$(TOP_MODULE).vvp"
	@test -s "$(BUILD_PATH)/test.vcd" || { echo "Simulation did not create a nonempty $(BUILD_PATH)/test.vcd" >&2; exit 1; }

simulation: run
	@if [ -z "$$DISPLAY" ] && [ -z "$$WAYLAND_DISPLAY" ]; then \
		echo 'No graphical display is available; configure container display forwarding to open GTKWave.' >&2; \
		exit 1; \
	fi
	command -v "$(SIMULATOR)" >/dev/null 2>&1 || { echo "Waveform viewer not found: $(SIMULATOR)" >&2; exit 1; }
	$(SIMULATOR) "$(BUILD_PATH)/test.vcd"

synth: check-build-dir check-inputs
	@mkdir -p "$(BUILD_PATH)"
	$(YOSYS) -p 'read_verilog $(SOURCES_ABS); hierarchy -check -top $(TOP_MODULE); synth -top $(TOP_MODULE) -flatten; check; write_json $(BUILD_PATH)/$(TOP_MODULE)_synth.json; show -format dot -prefix $(BUILD_PATH)/$(TOP_MODULE)_synth -viewer none'
	$(DOT) -Tsvg "$(BUILD_PATH)/$(TOP_MODULE)_synth.dot" -o "$(BUILD_PATH)/$(TOP_MODULE)_synth.svg"
	@test -s "$(BUILD_PATH)/$(TOP_MODULE)_synth.json" -a -s "$(BUILD_PATH)/$(TOP_MODULE)_synth.dot" -a -s "$(BUILD_PATH)/$(TOP_MODULE)_synth.svg"

check-fpga-inputs: check-build-dir
	@for source in $(SOURCES); do \
		if [ ! -f "$$source" ]; then echo "Verilog source not found: $$source" >&2; exit 1; fi; \
	done
	@test -r "$(FPGA_XDC_PATH)" || { echo "Constraint file not found: $(FPGA_XDC_PATH)" >&2; exit 1; }
	@command -v yosys >/dev/null 2>&1 && command -v nextpnr-xilinx >/dev/null 2>&1 && command -v fasm2frames >/dev/null 2>&1 && command -v xc7frames2bit >/dev/null 2>&1 || { echo "OpenXC7 tools are not available in PATH." >&2; exit 1; }
	@test -n "$$PRJXRAY_DB_DIR" -a -n "$$CHIPDB" || { echo "OpenXC7 database paths are not configured in the container." >&2; exit 1; }
	@part_without_speed=$${FPGA_PART%-*}; \
		test -r "$$PRJXRAY_DB_DIR/artix7/$(FPGA_PART)/part.yaml" || { echo "OpenXC7 part database not found for $(FPGA_PART)." >&2; exit 1; }; \
		test -r "$$CHIPDB/$$part_without_speed.bin" || { echo "OpenXC7 chip database not found for $(FPGA_PART)." >&2; exit 1; }

bitstream: check-fpga-inputs
	@mkdir -p "$(BUILD_PATH)"
	rm -f -- "$(BUILD_PATH)/$(TOP_MODULE).bit" "$(BUILD_PATH)/$(TOP_MODULE).bit.tmp"
	sed -e 's/get_ports { /get_ports {/g' -e 's/ }]/}]/g' -e 's/];/]/g' "$(FPGA_XDC_PATH)" > "$(BUILD_PATH)/$(TOP_MODULE)_openxc7.xdc"
	yosys -p "synth_xilinx -flatten -abc9 -arch xc7 -top $(TOP_MODULE); write_json $(BUILD_PATH)/$(TOP_MODULE).json" $(SOURCES_ABS)
	nextpnr-xilinx --chipdb "$$CHIPDB/$${FPGA_PART%-*}.bin" --xdc "$(BUILD_PATH)/$(TOP_MODULE)_openxc7.xdc" --freq "$(FPGA_FREQ)" --json "$(BUILD_PATH)/$(TOP_MODULE).json" --write "$(BUILD_PATH)/$(TOP_MODULE)_routed.json" --fasm "$(BUILD_PATH)/$(TOP_MODULE).fasm"
	fasm2frames --db-root "$$PRJXRAY_DB_DIR/artix7" --part "$(FPGA_PART)" "$(BUILD_PATH)/$(TOP_MODULE).fasm" > "$(BUILD_PATH)/$(TOP_MODULE).frames"
	xc7frames2bit --part_file "$$PRJXRAY_DB_DIR/artix7/$(FPGA_PART)/part.yaml" --part_name "$(FPGA_PART)" --frm_file "$(BUILD_PATH)/$(TOP_MODULE).frames" --output_file "$(BUILD_PATH)/$(TOP_MODULE).bit.tmp" && test -s "$(BUILD_PATH)/$(TOP_MODULE).bit.tmp" && mv -- "$(BUILD_PATH)/$(TOP_MODULE).bit.tmp" "$(BUILD_PATH)/$(TOP_MODULE).bit"
	@test -s "$(BUILD_PATH)/$(TOP_MODULE).bit" || { echo "FPGA build did not create a nonempty bitstream" >&2; exit 1; }

flash: bitstream
	@test -s "$(BUILD_PATH)/$(TOP_MODULE).bit" || { echo "Bitstream not found: $(BUILD_PATH)/$(TOP_MODULE).bit" >&2; exit 1; }
	@if [ "$$(id -u)" -eq 0 ]; then \
		openFPGALoader --board "$(FPGA_BOARD)" "$(BUILD_PATH)/$(TOP_MODULE).bit"; \
	else \
		sudo openFPGALoader --board "$(FPGA_BOARD)" "$(BUILD_PATH)/$(TOP_MODULE).bit"; \
	fi

clean:
	@$(MAKE) --no-print-directory check-build-dir
	rm -rf -- "$(BUILD_PATH)" build_project .Xil

help:
	@printf '%s\n' 'Targets: build, run, simulation, synth, bitstream, flash, clean, help' 'Simulation and synthesis artifacts: $(BUILD_PATH)' 'FPGA part: $(FPGA_PART); board: $(FPGA_BOARD); target frequency: $(FPGA_FREQ) MHz; constraints: $(FPGA_XDC_PATH)'