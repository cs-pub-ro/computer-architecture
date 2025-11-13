#let title = "Midterm Assignment"
#let subtitle = "Exercise: Moore Finite State Machine (FSM)"
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

Given the following Moore FSM state transition diagram, trace through the FSM with the provided input sequence and determine the complete output sequence.

#text(size: 10pt, style: "italic")[
  *Note:* Each student receives a different FSM and input sequence based on their student ID.
]

In a Moore FSM:
- Output depends **ONLY** on the current state (not on the input)
- Each state has an associated output value
- Transitions occur based on input symbols

=== Example: 2-State Moore FSM

#table(
  columns: (1.5fr, 1fr, 1fr, 1fr),
  align: center,
  stroke: 0.5pt,
  
  // Header
  text(weight: "bold", size: 11pt)[Current State],
  text(weight: "bold", size: 11pt)[Output],
  text(weight: "bold", size: 11pt)[Input: 0],
  text(weight: "bold", size: 11pt)[Input: 1],
  
  // S0
  text(weight: "bold", size: 11pt)[S0],
  text(weight: "bold", size: 11pt, fill: rgb("#ffe0e0"))[A],
  [S0],
  [S1],
  
  // S1
  text(weight: "bold", size: 11pt)[S1],
  text(weight: "bold", size: 11pt, fill: rgb("#ffe0e0"))[B],
  [S1],
  [S0],
)

=== Answer Format

Enter the complete output sequence as a string of characters.

*Example Answer:* `ABBA`

Each character in the output sequence corresponds to the output of the state when each input is processed.

#pagebreak()

== Solution Explanation

=== Understanding Moore FSMs

A Moore Finite State Machine is defined by:

1. *Set of States*: Q = {S0, S1, S2, ..., SN}
2. *Input Alphabet*: Possible input symbols (usually binary: 0, 1) I
3. *Output Alphabet*: Possible output symbols (usually characters or binary) O
4. *Output Function*: $lambda(q in Q) -> o in O$ (maps each state to an output)
5. *Transition Function*: $delta(q in Q, i in I) -> q' in Q$ (maps current state and input to next state)
6. *Initial State*: S0

*Key Property*: Output depends ONLY on the current state. This distinguishes it from a Mealy FSM where output also depends on input.

=== How to Trace a Moore FSM

Follow these steps to trace through an input sequence:

1. Start at the initial state (S0)
2. For each input symbol:
   - Read the output value associated with the current state
   - Add this output to your sequence
   - Follow the transition arrow based on the current input
   - Move to the next state
3. Continue until all inputs are processed
4. Concatenate all outputs to get the final sequence

=== Worked Example

Given the FSM above with input sequence: `0110`

*Step-by-step trace:*

#table(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr),
  align: center,
  stroke: 0.5pt,
  fill: (x, y) => if y == 0 { rgb("#f0f0f0") } else { white },
  
  text(weight: "bold")[Step],
  text(weight: "bold")[Current State],
  text(weight: "bold")[State Output],
  text(weight: "bold")[Input],
  text(weight: "bold")[Next State],
  
  [0], [S0], text(weight: "bold", fill: rgb("#ffe0e0"))[A], [0], [S0],
  [1], [S0], text(weight: "bold", fill: rgb("#ffe0e0"))[A], [1], [S1],
  [2], [S1], text(weight: "bold", fill: rgb("#ffe0e0"))[B], [1], [S0],
  [3], [S0], text(weight: "bold", fill: rgb("#ffe0e0"))[A], [0], [S0],
  [4], [S0], text(weight: "bold", fill: rgb("#ffe0e0"))[A], [---], [---],
)

*Output sequence:* Concatenate the state outputs: \(A + A + B + A + A = \) *AABAA*


=== Tips for Solving

1. *Be systematic*: Create a trace table like the example
2. *Read carefully*: Make sure you're reading the correct transition
3. *Track state*: Keep track of which state you're in
4. *Output first*: Generate output BEFORE transitioning
5. *Verify*: Count your outputs match the input length plus one (for initial state)
6. *Check ordering*: Make sure outputs are in correct sequence order
