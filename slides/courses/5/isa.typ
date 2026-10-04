== Instruction Set Architecture (ISA)

Instruction types:
- Data transfer
- Arithmetic
- Logical and bit manipulation
- Flow control

== Data Transfer

#figure(
  table(
    columns: 3,
    align: left,
    table.header([*Goal*], [*Acronym*], [*Description*]),
    [General], [MOV], [Move data from source to destination],
    [General], [PUSH], [Push data onto the stack],
    [General], [POP], [Pop data from the stack],
    [I/O], [IN], [Input data from an I/O port],
    [I/O], [OUT], [Output data to an I/O port],
    [Flags], [PUSHF], [Push flags onto the stack],
    [Flags], [POPF], [Pop flags from the stack],
  ),
)

== Arithmetic

#figure(
  table(
    columns: 3,
    align: left,
    table.header([*Goal*], [*Acronym*], [*Description*]),
    [Addition], [ADD], [Add two operands],
    [Addition], [ADC], [Add two operands with carry],
    [Addition], [INC], [Increment an operand],
    [Subtraction], [SUB], [Subtract source from destination],
    [Subtraction], [SBB], [Subtract with borrow],
    [Subtraction], [DEC], [Decrement an operand],
    [Subtraction], [NEG], [Negate an operand (two's complement)],
    [Subtraction], [CMP], [Compare two operands],
  ),
)

== Logical and Bit Manipulation

#figure(
  table(
    columns: 3,
    align: left,
    table.header([*Goal*], [*Acronym*], [*Description*]),
    [Logic], [AND], [Bitwise AND],
    [Logic], [OR], [Bitwise OR],
    [Logic], [XOR], [Bitwise XOR],
    [Logic], [NOT], [One's complement],
    [Logic], [TEST], [Bitwise AND without storing the result],
    [Shift], [SHL/SAL], [Shift left],
    [Shift], [SHR], [Shift right],
    [Shift], [SAR], [Arithmetic shift right],
  ),
)

== Flow Control


#figure(
  block[
    #set text(size: 10pt)
    #table(
    columns: 3,
    align: left,
    table.header([*Goal*], [*Acronym*], [*Description*]),
    [Jump], [JMP], [Jump to an address],
    [Jump], [CALL], [Call a subroutine],
    [Jump], [RET], [Return from a subroutine],
    [Jump], [IRET], [Return from an interrupt subroutine],
    [Jump], [HLT], [Halt the processor],
    [Conditional], [JA], [Jump above (C or Z = 0)],
    [Conditional], [JAE], [Jump above or equal (C = 0)],
    [Conditional], [JB], [Jump below (C)],
    [Conditional], [JBE], [Jump below or equal (C or Z)],
    [Conditional], [JC], [Jump if carry],
    [Conditional], [JE], [Jump if equal],
    [Conditional], [JG], [Jump if greater ((S xor O) or Z = 0)],
    [Conditional], [JGE], [Jump if greater or equal (S xor O = 0)],
    [Conditional], [JL], [Jump if less (S xor O = 1)],
    [Conditional], [JLE], [Jump if less or equal ((S xor O) or Z = 1)],
    [Conditional], [JNC], [Jump if not carry],
    [Conditional], [JNE], [Jump if not equal],
    [Conditional], [JNO], [Jump if not overflow],
    [Conditional], [JPO], [Jump if parity odd],
    [Conditional], [JNS], [Jump if not sign],
    [Conditional], [JO], [Jump if overflow],
    [Conditional], [JPE], [Jump if parity even],
    [Conditional], [JS], [Jump if sign],
  ),
  ],
)