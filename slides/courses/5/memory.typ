== Direct Addressing

- The address is specified directly in the instruction (immediate).
- Example: `MOV RA, M[0x1234]`
- $"MA" = "0x1234"$

== Indirect Addressing from Memory

- The address is stored in memory.
- Example: `MOV RA, M[M[0x1234]]`
- Step 1: $"MA" = "0x1234"$
- Step 2: $"MA" = M["0x1234"]$ (indirect)

== Indirect Addressing from a Register

- The address is stored in a register.
- Example: `MOV RA, M[BA]`
- $"MA" = "BA"$

== Indirect Addressing from Base and Index Registers

- The address is the sum of two registers (base and index).
- Example: `MOV RA, M[BA + XA]`
- $"MA" = "BA" + "XA"$

== Base and Index with Post-Increment

- The address is the sum of a base and index register.
- The index register is incremented after the operation.
- Example: `MOV RA, M[BA + XA++]`
- $"MA" = "BA" + "XA"$

== Base and Index with Pre-Decrement

- The address is the sum of a base and index register.
- The index register is decremented before the operation; only XA is supported.
- Example: `MOV RA, M[BA + XA--]`
- $"MA" = "BA" + "XA" - 1$

== Indirect Addressing from Base and Immediate

- The address is the sum of a base register and an immediate value.
- Example: `MOV RA, M[BA + 0x1234]`
- $"MA" = "BA" + "0x1234"$

== Indirect Addressing from Index and Immediate

- The address is the sum of an index register and an immediate value.
- Example: `MOV RA, M[XA + 0x1234]`
- $"MA" = "XA" + "0x1234"$

== Indirect Addressing from Base, Index, and Immediate

- The address is the sum of a base register, index register, and immediate value.
- Example: `MOV RA, M[BA + XA + 0x1234]`
- $"MA" = "BA" + "XA" + "0x1234"$

== Immediate Addressing

- The value is specified directly in the instruction.
- Example: `MOV RA, 7`
- $"MA" = "PC" + 1$ or $"MA" = "PC" + 2$

== Direct Register Addressing

- The data is in the register specified by the instruction (RM).
- Example: `MOV RA, RB`

== Address Table for IR

#set text(size: 11pt)
#figure(
  table(
    columns: 5,
    align: center,
    table.header([*RM = IR[13:15]*], [*MOD = 00*], [*MOD = 01*], [*MOD = 10*], [*MOD = 11*]),
    [000], [[BA+XA]], [[BA+XA+]], [[BA+XA+Imm]], [RA],
    [001], [[BA+XB]], [[BA+XB+]], [[BA+XB+Imm]], [RB],
    [010], [[BB+XA]], [[BB+XA+]], [[BB+XA+Imm]], [RC],
    [011], [[BB+XB]], [[BB+XB+]], [[BB+XB+Imm]], [SP],
    [100], [[XA]], [[BA+(--XA)]], [[XA+Imm]], [XA],
    [101], [[XB]], [[BB+(--XA)]], [[XB+Imm]], [XB],
    [110], [[BA]], [[Imm]], [[BA+Imm]], [BA],
    [111], [[BB]], [[[Imm]]], [[BB+Imm]], [BB],
  ),
)