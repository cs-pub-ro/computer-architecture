// Problem statement
== Problem

Given the following truth table, identify the Boolean gate name. The truth table represents a logic gate with 2, 3, or 4 inputs and a single output.

#text(size: 10pt, style: "italic")[
  *Note:* Each student receives a different truth table with varying numbers of inputs based on their student ID.
]

=== Example: 3-Input Truth Table

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  align: center,
  stroke: 0.5pt,
  
  table.header([*A*], [*B*], [*C*], [*Output*]),
  
  // Example truth table for 3-input AND
  [0], [0], [0], [0],
  [0], [0], [1], [0],
  [0], [1], [0], [0],
  [0], [1], [1], [0],
  [1], [0], [0], [0],
  [1], [0], [1], [0],
  [1], [1], [0], [0],
  [1], [1], [1], [1],
)

=== Answer Format

Provide the gate name in *CAPITAL LETTERS* only. Acceptable answers include:

#table(
  columns: (1fr, 2fr),
  align: left,
  stroke: 0.5pt,
  table.header([*Gate Names*], [*Boolean Expression*]),

  [AND], $ c=a and b $,
  [OR], $ c=a or b $,
  [XOR], $ c=a xor b $,
  [NAND], $ c=not (a and b) $,
  [NOR], $ c=not (a or b) $,
  [XNOR], $ c=not (a xor b) $,
)

== Solution

=== Truth Table Fundamentals

A truth table is a complete enumeration of all possible input combinations and their corresponding outputs:

- For $n$ inputs: There are exactly $2^n$ rows in the truth table
  - 2-input gates: $2^2 = 4$ rows
  - 3-input gates: $2^3 = 8$ rows
  - 4-input gates: $2^4 = 16$ rows

Each row is unique and represents one input combination.


=== 2-Input Gates Reference

#table(
  columns: (1.2fr, 1.2fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  align: center,
  stroke: 0.5pt,
  fill: (x, y) => if y == 0 { rgb("#f0f0f0") } else { white },
  
  table.header([*A*], [*B*], [*AND*], [*OR*], [*XOR*], [*NAND*], [*NOR*], [*XNOR*]),
  
  text(weight: "bold")[0], [0], [0], [0], [0], [1], [1], [1],
  text(weight: "bold")[0], [1], [0], [1], [1], [1], [0], [0],
  text(weight: "bold")[1], [0], [0], [1], [1], [1], [0], [0],
  text(weight: "bold")[1], [1], [1], [1], [0], [0], [0], [1],
)


=== How to Identify a Gate

1. Count the number of inputs to determine gate size category
2. Count the number of 1s in the output column to narrow options:
   - If only one 1: Could be AND
   - If mostly 1s: Could be OR, NAND, NOR
   - If alternating: Could be XOR or XNOR
3. Compare the output column with reference tables

=== Example Exercise

Given the following truth table, identify the Boolean gate name:

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  align: center,
  stroke: 0.5pt,
  
  table.header([*A*], [*B*], [*C*], [*Output*]),
  
  // Example truth table for 3-input AND
  [0], [0], [0], [0],
  [0], [0], [1], [0],
  [0], [1], [0], [0],
  [0], [1], [1], [0],
  [1], [0], [0], [0],
  [1], [0], [1], [0],
  [1], [1], [0], [0],
  [1], [1], [1], [1],
)

Answer: Enter the gate name in CAPITAL LETTERS:

Possible gates:

AND, OR, XOR, NAND, NOR, XNOR

ANSWER: AND

=== Key Concepts

- Truth tables are complete and deterministic
- Gate output pattern uniquely identifies the gate type
- Negated gates (NAND, NOR) are inverses of standard gates (AND, OR)
- Multi-input gates extend the same logic principles