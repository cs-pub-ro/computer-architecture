# Verilog Toolchain

We use the open-source HDL tools installed in the course development container.
We run every command from the task directory or pass its path to `make -C`.

| Command | Result |
| --- | --- |
| `make build` | Compile the task testbench with Icarus Verilog. |
| `make run` | Run the simulation and write `build/test.vcd`. |
| `make simulation` | Run the simulation and open the waveform in GTKWave. |
| `make synth` | Synthesize the design and write JSON, DOT, and SVG artifacts under `build/`. |
| `make bitstream` | Synthesize, place and route, then create a `.bit` file using the task's XDC. |
| `make flash` | Build the bitstream and load it into the FPGA over USB. |
| `make clean` | Remove generated task artifacts. |

We use `make` or `make all` to compile only; these commands do not run a simulation or program hardware.
We open a waveform with `make simulation`, or pass `build/test.vcd` to GTKWave ourselves.
GTKWave requires the container to have access to a graphical display, including its display socket and authorization.
If the viewer cannot connect, `make run` still generates the VCD without requiring a graphical session.

We use `make synth` to inspect the synthesized circuit as `build/<top>_synth.svg`.
This target is headless and does not use the FPGA constraints.
The `.json` and `.dot` files are retained beside the SVG for further inspection.
The development image needs Graphviz for this target.
After changing the container tool installer, rebuild the image with `docker build -f docker/dev.Dockerfile --target sdc_dev_stage -t computer-architecture:dev docker` from the repository root and reopen the container.

We use `make bitstream` to build the task's `<top>.xdc` with the configured FPGA part.
The default target is a Nexys A7-100T (`xc7a100tcsg324-1`).
We can override `FPGA_PART`, `FPGA_BOARD`, or `FPGA_XDC` when invoking Make.
We can override the target clock frequency with `FPGA_FREQ`, which defaults to 100 MHz.
An alternate part must have its matching OpenXC7 database installed in the container.

We connect a supported FPGA board to a Linux host and pass its USB device through to the development container before running `make flash`.
The flash command loads the volatile FPGA configuration; it does not program persistent SPI flash.
We can run the FPGA helper's `fpga_detect` function from the container to check whether the board is visible.
Hardware access is not required for simulation, synthesis, or bitstream generation.

We use the VCD and testbench output to inspect simulations.
Most exercise testbenches are teaching examples rather than automated pass/fail graders, so a successful simulator exit confirms execution, not that an unfinished student design is correct.
The sequential LED display testbench checks its complete scan sequence and returns a failure for an incorrect result.

We can run the headless regression checks from the repository root:

```sh
bash chapters/verilog/common/check-toolchain.sh
```

We add `--fpga` to build the complete sequential LED display bitstream as an offline hardware-toolchain check.
The regression script never flashes a board.