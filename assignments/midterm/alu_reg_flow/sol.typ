#let title = "Midterm Assignment"
#let subtitle = "Exercise: ALU Operations with Register File"
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

Given a register file with 8 registers, each containing initial 4-bit values, execute a sequence of 5 ALU operations. Each operation reads from source register(s), performs an ALU operation, and writes the result to a destination register. Finally, determine the value of a specific register after all operations complete. The first register of every operation is the destination register, with the exception of SBB2 (second register is the destination register). The initial carry bit (C) is 0.

#text(size: 10pt, style: "italic")[
  *Note:* Each student receives different initial register values and a different sequence of random operations based on their student ID.
]

=== Example Problem

*Initial Register Values:*


#table(
  columns: (1.5fr, 2fr, 1.5fr),
  align: left,
  stroke: 0.5pt,
  fill: (x, y) => if y == 0 { rgb("#f0f0f0") } else { white },
  
  text(weight: "bold")[Register],
  text(weight: "bold")[Value(Decimal)],
  text(weight: "bold")[Value(Binary)],

  [RA], [12], [1100],
  [RB], [5], [0101],
  [RC], [8], [1000],
  [IS], [3], [0011],
  [XA], [7], [0111],
  [XB], [14], [1110],
  [BA], [2], [0010],
  [BB], [9], [1001],
)


*Operation Sequence:*


 + AND RA, RB  
 + OR RB, RC
 + XOR RC, IS
 + SHL RA
 + NOT RB


*Question:* What is the binary value of register RA?

 + $"RA"<- 1100 and 0101 = 0100$
 + $"RB"<- 0101 or 1000 = 1101$
 + $"RC"<- 1000 xor 0011 = 1011$
 + $"RA"<- 0100 << 1 = 1000$
 + $"RB"<- not 1101 = 0010$

*Answer:* `1000`

=== Answer Format

Enter the result as a *4-bit binary number* (e.g., `1010`).

- Do not include spaces
- Always provide exactly 4 bits
- Leading zeros must be included

#pagebreak()

== Solution Explanation

=== Understanding the Execution Model

*Dataflow per operation:*

```
Source Register(s) → ALU Operation → Destination Register
(Read values)       (Compute)        (Write result)
```

*Important:* After an operation writes to a register, subsequent operations can read the new value.

=== Execution Trace Example

Starting with the example above, let's trace step-by-step:

==== Initial State
```
RA=12 (1100)  RB=5 (0101)  RC=8 (1000)  IS=3 (0011)
XA=7 (0111)   XB=14(1110)  BA=2 (0010)  BB=9 (1001)
```

==== Step 1: AND RA, RB

- Read RA = 12 = `1100`
- Read RB = 5 = `0101`
- Execute AND: `1100` AND `0101` = `0100`
- Write to RA: RA = 4

*State after Step 1:*
```
RA=4 (0100)   RB=5 (0101)  RC=8 (1000)  IS=3 (0011)
XA=7 (0111)   XB=14(1110)  BA=2 (0010)  BB=9 (1001)
```

==== Step 2: OR RB, RC

- Read RB = 5 = `0101`
- Read RC = 8 = `1000`
- Execute OR: `0101` OR `1000` = `1101`
- Write to RB: RB = 13

*State after Step 2:*
```
RA=4 (0100)   RB=13(1101)  RC=8 (1000)  IS=3 (0011)
XA=7 (0111)   XB=14(1110)  BA=2 (0010)  BB=9 (1001)
```

==== Step 3: XOR RC, IS

- Read RC = 8 = `1000`
- Read IS = 3 = `0011`
- Execute XOR: `1000` XOR `0011` = `1011`
- Write to RC: RC = 11

*State after Step 3:*
```
RA=4 (0100)   RB=13(1101)  RC=11(1011)  IS=3 (0011)
XA=7 (0111)   XB=14(1110)  BA=2 (0010)  BB=9 (1001)
```

==== Step 4: SHL RA

- Read RA = 4 = `0100`
- Execute SHL: `0100` << 1 = `1000`
- Write to RA: RA = 8, set C = 0

*State after Step 4:*
```
RA=8 (1000)   RB=13(1101)  RC=11(1011)  IS=3 (0011)
XA=7 (0111)   XB=14(1110)  BA=2 (0010)  BB=9 (1001)
```

==== Step 5: NOT RB

- Read RB = 13 = `1101`
- Execute NOT: ~`1101` = `0010`
- Write to RB: RB = 2

*Final State after Step 5:*
```
RA=8 (1000)   RB=2 (0010)  RC=11(1011)  IS=3 (0011)
XA=7 (0111)   XB=14(1110)  BA=2 (0010)  BB=9 (1001)
```

=== Answer Determination

*Question:* What is the final value of register RA?

From the final state above: RA = 8 = `1000`

*Answer:* `1000`


#pagebreak()


=== ALU Quick Reference Table

#table(
  columns: (1.5fr, 2fr, 1.5fr),
  align: left,
  stroke: 0.5pt,
  fill: (x, y) => if y == 0 { rgb("#f0f0f0") } else { white },
  
  text(weight: "bold")[Operation],
  text(weight: "bold")[Formula],
  text(weight: "bold")[Uses B?],
  
  [ADC], [(A + B + C) mod 16], [Yes],
  [SBB1], [(A - B - C) mod 16], [Yes],
  [SBB2], [(B - A - C) mod 16], [Yes],
  [NOT], [~A], [No],
  [AND], [A AND B], [Yes],
  [OR], [A OR B], [Yes],
  [XOR], [A XOR B], [Yes],
  [SHL/SAL], [(A << 1) mod 16], [No],
  [SHR], [A >> 1], [No],
  [SAR], [A >>> 1 with sign ext.], [No],
)

=== Carry Bit (C)

How to compute the carry bit after each operation:
- *ADC*: Set if (A + B + C) ≥ 16
- *SBB1*: Set if A < (B + C)
- *SBB2*: Set if B < (A + C)
- *SHL/SAL*: Set if the most significant bit (bit 3) of A is 1 before the shift
- *SHR*: Set if the least significant bit (bit 0) of A is 1 before the shift
- *SAR*: Set if the least significant bit (bit 0) of A is 1 before the shift
- *Other operations*: Carry bit is cleared (0)

=== Carrying out ALU Operations

When performing ALU operations, follow these guidelines:
1. *Convert to binary*: Always work with 4-bit binary representation
2. *Know your operations*: Memorize the behavior of each operation
3. *Bit-by-bit*: For logical operations, process each bit independently
4. *Truncate overflow*: Results are always 4 bits (modulo 16)
5. *Sign extension*: For SAR, preserve the sign bit (bit 3)
6. *Carry awareness*: For ADC, SBB1, SBB2, include the carry bit


