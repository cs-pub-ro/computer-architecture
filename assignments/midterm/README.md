# AB Midterm

This directory contains the Computer Architecture midterm assignment and its worked-solution sources.

The combined English handout includes these five existing solutions:

1. ALU Operations (4-bit)
2. ALU Operations with Registers
3. Moore Finite State Machine
4. Truth Table to Gate Name
5. Truth Table Output Identification

## Build

From the repository root, use:

```sh
make -C assignments/midterm pdf
make -C assignments/midterm check
make -C assignments/midterm preview
```

The PDF is written to `assignments/midterm/build/midterm-model.pdf`. Preview watches `main.typ` and the included Typst sources. Run `make -C assignments/midterm clean` to remove the generated build directory.