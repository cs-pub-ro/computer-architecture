#import "../../common/template.typ": ascii-figure

== ALU Structure

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  [
    - An arithmetic logic unit (ALU) is a combinational circuit.
    - It performs arithmetic and logical operations.
    - A control input selects the operation.
    - It may include status flags.
    - ALUs vary in cycle time and complexity.
  ],
  [#ascii-figure(read("media/alu.ascii"), width: 100%)],
)