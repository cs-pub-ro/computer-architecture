
COMPILER=iverilog
INTERPRETER=vvp
SIMULATOR=gtkwave
FLAGS=-Wall -Winfloop

# TODO: use the command line to pass the following parameters
TOP_MODULE=cpu_debugger
OTHER_SOURCES=alu.v bus.v cpu.v control_unit.v cram.v state_display.v
RAM_DATA_FILE=cram.data
MEMORY_SOURCES=../memory/block_ram.v ../memory/block_dpram.v ../memory/register.v ../memory/regfile.v
CORE_SOURCES=../core/clock_divider.v ../core/debouncer.v ../core/led7hex.v

# compute the filenames
TOP_MODULE_FILE=$(TOP_MODULE).v
TOP_SIM_MODULE_FILE=test_${TOP_MODULE}.v
TOP_MODULE_BIN=$(TOP_MODULE).vvp

all: build

build:
	$(COMPILER) $(FLAGS) $(TOP_MODULE_FILE) $(TOP_SIM_MODULE_FILE) $(OTHER_SOURCES) $(MEMORY_SOURCES) $(CORE_SOURCES) -o $(TOP_MODULE_BIN)
	@echo "Build completed"

run: build
	$(INTERPRETER) $(TOP_MODULE_BIN)

clean:
	rm $(TOP_MODULE_BIN)

vivado:
	vivado -mode batch -source tcl_files/vivado.tcl

clean_vivado:
	rm -rf vivado*
	rm -rf build_project
	rm -rf .Xil