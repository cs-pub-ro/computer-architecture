# Didactic Computer

This current folder represents an implementation in RHDL of the Didactic Computer.
This is usable both as an interactive simulation, a checker and is also compilable into synthetizable verilog code.

## Installation

You first need to install rust, `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`.

Next step assumes your working directory computer-architecture/:
you need to run the following commands: `cargo install didasm --path didasm/`, `cargo install cd-rhdl --path chapters/rhdl/cd-rhdl`

Optionally, you may copy watch_mem.py to a path in $PATH (`cp chapters/rhdl/cd-rhdl/watch_mem.py $HOME/.cargo/bin/watch_mem_cd`)

Now you can simply run cd-rhdl!

## Usage

As an argument you may give it the name of an assembly file (defaults to test.asm in the current directory, the one in the project is a sample showing what is possible to assemble).
Recommended workflow is:
1. you assemble the file with the assembler (`didasm test.asm cram.data`); check the errors in case any exist
2. run `cd-rhdl test.asm`
3. run in a separate terminal `mem_watch_cd` and press `c` and `d` on the cd-rhdl window for continuous dump to `mem.dump`. Highlight what addresses you are interested in with `/<hex-number>` (example `/20` to highlight address 0x20)
4. use `right` and `left` to advance/go back one clock cycle, use `n` and `p` to go to the decode stage of the next/previous instruction
5. press `q` to exit

