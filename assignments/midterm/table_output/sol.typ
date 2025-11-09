#let title = "Midterm Assignment"
#let subtitle = "Exercise: Truth Table Output Identification"
#let date = "November 2025"

#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 2cm, left: 2cm, right: 2cm),
)

#set text(font: "Libertinus Serif", size: 11pt)

// Title section
#align(center)[
  #text(size: 18pt, weight: "bold")[#title]

  #text(size: 14pt)[#subtitle]

  #text(size: 10pt)[#date]
]

#line(length: 100%, stroke: 0.5pt)

// Problem statement
== Problem

Given the following truth table, identify the output for the specified input combination.

#text(size: 10pt, style: "italic")[
  *Note:* Each student receives a different truth table with varying numbers of inputs based on their student ID.
]

=== Example: 3-Input Truth Table

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  align: center,
  stroke: 0.5pt,
  
  // Header
  text(weight: "bold", size: 11pt)[A],
  text(weight: "bold", size: 11pt)[B],
  text(weight: "bold", size: 11pt)[C],
  text(weight: "bold", size: 11pt)[Output],
  
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

Provide the output value (0 or 1) for the specified input combination.

#pagebreak()
== Solution Explanation

=== Truth Table Fundamentals

A truth table is a complete enumeration of all possible input combinations and their corresponding outputs:

- For $n$ inputs: There are exactly $2^n$ rows in the truth table
  - 2-input gates: $2^2 = 4$ rows
  - 3-input gates: $2^3 = 8$ rows
  - 4-input gates: $2^4 = 16$ rows

Each row is unique and represents one input combination.


=== How to Identify the Output

1. Locate the specified input combination in the truth table.
2. Read the corresponding output value from that row.

=== Example Exercise

Given the following truth table, identify the output for the input combination 0 1 0:

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  align: center,
  stroke: 0.5pt,
  
  // Header
  text(weight: "bold", size: 11pt)[A],
  text(weight: "bold", size: 11pt)[B],
  text(weight: "bold", size: 11pt)[C],
  text(weight: "bold", size: 11pt)[Output],
  
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

Answer: Enter the output value (0 or 1)

ANSWER: 0

== Key Concepts

- Truth tables are complete and deterministic
- Each input combination maps to a single output
- Identifying outputs involves locating the correct row based on inputs