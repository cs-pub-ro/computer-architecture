#let title = "Midterm Assignment"
#let subtitle = "Exercise: ALU Operations (4-bit)"
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

Given two 4-bit operands (A and B) and an ALU operation, compute the 4-bit binary result.

#text(size: 10pt, style: "italic")[
  *Note:* Each student receives different operands and a randomly selected operation based on their student ID.
]

=== Example Problem

*Operation:* ADC (Add with Carry)

- A = 5 (`0101`)
- B = 3 (`0011`)
- Carry = 1

*Question:* What is the 4-bit result?

=== Answer Format

Enter the result as a *4-bit binary number* (e.g., `1001`).

- Do not include spaces
- Always provide exactly 4 bits
- Leading zeros must be included

#pagebreak()

== Solution Explanation

=== ALU Operations Overview

An Arithmetic Logic Unit (ALU) performs arithmetic and logical operations on binary operands. For this exercise, we work with 4-bit unsigned operands.

=== Operand Representation

- Operands are 4-bit unsigned integers
- Range: 0 to 15 (decimal) or `0000` to `1111` (binary)
- Results are truncated to 4 bits (overflow is discarded for the result)

=== Operations Reference

==== 1. ADC (Add with Carry)

*Description:* Full adder that adds two operands and a carry bit.

*Formula:* Result = (A + B + Carry) mod 16

*Example:*
- A = 5 (`0101`)
- B = 3 (`0011`)
- Carry = 1
- Calculation: 5 + 3 + 1 = 9 = `1001`
- *Result:* `1001`

---

==== 2. SBB1 (Subtract with Borrow 1)

*Description:* Subtracts operand B and carry bit from operand A.

*Formula:* Result = (A - B - Carry) mod 16

*Example:*
- A = 8 (`1000`)
- B = 3 (`0011`)
- Carry = 1
- Calculation: 8 - 3 - 1 = 4 = `0100`
- *Result:* `0100`

---

==== 3. SBB2 (Subtract with Borrow 2)

*Description:* Subtracts operand A and carry bit from operand B.

*Formula:* Result = (B - A - Carry) mod 16

*Example:*
- A = 3 (`0011`)
- B = 8 (`1000`)
- Carry = 1
- Calculation: 8 - 3 - 1 = 4 = `0100`
- *Result:* `0100`


---

==== 4. NOT (Bitwise NOT)

*Description:* Inverts each bit of operand A.

*Formula:* Result = ~A (bitwise complement)

*Example:*
- A = 5 (`0101`)
- Bitwise inversion: `1010`
- *Result:* `1010` (decimal 10)

*Note:* Operand B is ignored.


---

==== 5. AND (Bitwise AND)

*Description:* Performs logical AND between corresponding bits of A and B.

*Formula:* Result = A AND B

*Example:*
- A = 12 (`1100`)
- B = 10 (`1010`)
- Bitwise AND: `1000`
- *Result:* `1000` (decimal 8)

---

==== 6. OR (Bitwise OR)

*Description:* Performs logical OR between corresponding bits of A and B.

*Formula:* Result = A OR B

*Example:*
- A = 12 (`1100`)
- B = 10 (`1010`)
- Bitwise OR: `1110`
- *Result:* `1110` (decimal 14)

---

==== 7. XOR (Bitwise XOR)

*Description:* Performs exclusive OR between corresponding bits of A and B.

*Formula:* Result = A XOR B

*Example:*
- A = 12 (`1100`)
- B = 10 (`1010`)
- Bitwise XOR: `0110`
- *Result:* `0110` (decimal 6)

---

==== 8. SHL/SAL (Shift Left Logical/Arithmetic)

*Description:* Shifts bits of A left by one position. Bit 0 becomes 0.

*Formula:* Result = (A << 1) mod 16

*Example:*
- A = 5 (`0101`)
- Shift left: `1010`
- *Result:* `1010` (decimal 10)

*Note:* Operand B is ignored. Logical and arithmetic left shift produce identical results.


---

==== 9. SHR (Shift Right Logical)

*Description:* Shifts bits of A right by one position. Bit 3 becomes 0.

*Formula:* Result = A >> 1

*Example:*
- A = 10 (`1010`)
- Shift right logical: `0101`
- *Result:* `0101` (decimal 5)

*Note:* Operand B is ignored. Most significant bit becomes 0.


---

==== 10. SAR (Shift Right Arithmetic)

*Description:* Shifts bits of A right by one position with sign extension. Bit 3 (sign bit) is preserved.

*Formula:* Result = (A[3] remains, A >> 1)

*Example:*
- A = 10 (`1010`)
- Shift right arithmetic: `1101` (sign bit 1 preserved)
- *Result:* `1101` (decimal 13)

*Note:* Operand B is ignored. Most significant bit is duplicated (sign extension).

---

#pagebreak()

=== Worked Example

*Given:*
- Operation: XOR
- A = 12 (decimal) = `1100` (binary)
- B = 10 (decimal) = `1010` (binary)

*Step-by-step solution:*

#table(
  columns: (1fr, 1fr, 1fr),
  align: center,
  stroke: 0.5pt,
  fill: (x, y) => if y == 0 { rgb("#f0f0f0") } else { white },
  
  text(weight: "bold")[Bit Position],
  text(weight: "bold")[A XOR B],
  text(weight: "bold")[Result],
  
  [3], [`1` XOR `1`], [`0`],
  [2], [`1` XOR `0`], [`1`],
  [1], [`0` XOR `1`], [`1`],
  [0], [`0` XOR `0`], [`0`],
)

*Final Result:* `0110` (decimal 6)

---

=== Tips for Solving

1. *Convert to binary*: Always work with 4-bit binary representation
2. *Know your operations*: Memorize the behavior of each operation
3. *Bit-by-bit*: For logical operations, process each bit independently
4. *Truncate overflow*: Results are always 4 bits (modulo 16)
5. *Sign extension*: For SAR, preserve the sign bit (bit 3)
6. *Carry awareness*: For ADC, SBB1, SBB2, include the carry bit

---

=== Quick Reference Table

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