== Problem

Using the memory-addressing and instruction-format tables, encode `MOV RA, [BA+XA+]` in hexadecimal.

The instruction register fields are:

#table(
  columns: 2,
  table.header([*IR bits*], [*Field*]),
  [0-6], [OPC],
  [7], [d],
  [8-9], [MOD],
  [10-12], [REG],
  [13-15], [RM],
  [next word], [immediate/data],
  [following word], [data],
)

The opcode table uses the following notation: each entry is `code = instruction`; `unassigned` marks an empty source cell.

=== IR1 = 0, IR3 = 0

#table(
  columns: 5,
  table.header([*OPC*], [*IR0=0, IR2=0*], [*IR0=0, IR2=1*], [*IR0=1, IR2=0*], [*second IR0=1 cell*]),
  [000], [000 = MOV], [000 = MOV], [000 = IN], [unassigned],
  [001], [001 = unassigned], [001 = unassigned], [001 = OUT], [unassigned],
  [010], [010 = PUSH], [010 = unassigned], [010 = PUSHF], [unassigned],
  [011], [011 = POP], [011 = unassigned], [011 = POPF], [unassigned],
  [100], [100 = CALL], [100 = unassigned], [100 = RET], [unassigned],
  [101], [101 = JMP], [101 = unassigned], [101 = IRET], [unassigned],
  [110], [110 = unassigned], [110 = unassigned], [110 = HLT], [unassigned],
  [111], [111 = unassigned], [111 = unassigned], [111 = unassigned], [unassigned],
)

=== IR1 = 0, IR3 = 1

#table(
  columns: 5,
  table.header([*OPC*], [*IR0=0, IR2=0*], [*IR0=0, IR2=1*], [*IR0=1, lower*], [*IR0=1, upper*]),
  [000], [000 = INC], [000 = unassigned], [0000 = JBE], [1000 = JBA],
  [001], [001 = DEC], [001 = unassigned], [0001 = JB/JC], [1001 = JAE/JNC],
  [010], [010 = NEG], [010 = unassigned], [0010 = JLE], [1010 = JG],
  [011], [011 = NOT], [011 = unassigned], [0011 = JL], [1011 = JGE],
  [100], [100 = SHL/SAL], [100 = unassigned], [0100 = JE/JZ], [1100 = JNE/JNZ],
  [101], [101 = SHR], [101 = unassigned], [0101 = JO], [1101 = JNO],
  [110], [110 = SAR], [110 = unassigned], [0110 = JS], [1110 = JNS],
  [111], [111 = unassigned], [111 = unassigned], [0111 = JPE], [1111 = JPO],
)

=== IR1 = 1, IR3 = 0

#table(
  columns: 5,
  table.header([*OPC*], [*IR0=0, IR2=0*], [*IR0=0, IR2=1*], [*IR0=1, IR2=0*], [*second IR0=1 cell*]),
  [000], [000 = unassigned], [000 = unassigned], [unassigned], [unassigned],
  [001], [001 = unassigned], [001 = unassigned], [unassigned], [unassigned],
  [010], [010 = CMP], [010 = CMP], [unassigned], [unassigned],
  [011], [011 = unassigned], [011 = unassigned], [unassigned], [unassigned],
  [100], [100 = TEST], [100 = TEST], [unassigned], [unassigned],
  [101], [101 = unassigned], [101 = unassigned], [unassigned], [unassigned],
  [110], [110 = unassigned], [110 = unassigned], [unassigned], [unassigned],
  [111], [111 = unassigned], [111 = unassigned], [unassigned], [unassigned],
)

=== IR1 = 1, IR3 = 1

#table(
  columns: 5,
  table.header([*OPC*], [*IR0=0, IR2=0*], [*IR0=0, IR2=1*], [*IR0=1, IR2=0*], [*second IR0=1 cell*]),
  [000], [000 = ADD], [000 = ADD], [unassigned], [unassigned],
  [001], [001 = ADC], [001 = ADC], [unassigned], [unassigned],
  [010], [010 = SUB], [010 = SUB], [unassigned], [unassigned],
  [011], [011 = SBB], [011 = SBB], [unassigned], [unassigned],
  [100], [100 = AND], [100 = AND], [unassigned], [unassigned],
  [101], [101 = OR], [101 = OR], [unassigned], [unassigned],
  [110], [110 = XOR], [110 = XOR], [unassigned], [unassigned],
  [111], [111 = unassigned], [111 = unassigned], [unassigned], [unassigned],
)

The memory-addressing modes are:

#table(
  columns: 5,
  table.header([*RM = IR13:15*], [*MOD = 00*], [*MOD = 01*], [*MOD = 10*], [*MOD = 11*]),
  [000], [#raw("[BA+XA]")], [#raw("[BA+XA+]")], [#raw("[BA+XA+Imm]")], [RA],
  [001], [#raw("[BA+XB]")], [#raw("[BA+XB+]")], [#raw("[BA+XB+Imm]")], [RB],
  [010], [#raw("[BB+XA]")], [#raw("[BB+XA+]")], [#raw("[BB+XA+Imm]")], [RC],
  [011], [#raw("[BB+XB]")], [#raw("[BB+XB+]")], [#raw("[BB+XB+Imm]")], [SP],
  [100], [#raw("[XA]")], [#raw("[BA+(-XA)]")], [#raw("[XA+Imm]")], [XA],
  [101], [#raw("[XB]")], [#raw("[BB+(-XA)]")], [#raw("[XB+Imm]")], [XB],
  [110], [#raw("[BA]")], [#raw("[Imm]")], [#raw("[BA+Imm]")], [BA],
  [111], [#raw("[BB]")], [#raw("[[Imm]]")], [#raw("[BB+Imm]")], [BB],
)

== Solution

The instruction is `MOV`, with source `[BA+XA+]` and destination `RA`.

Identify the opcode for `MOV`:

- `MOV` uses `OPC = 000` when $"IR"_1 = 0$, $"IR"_3 = 0$, and $"IR"_0 = 0$.
- There is no immediate value, so $"IR"_2 = 0$.
- The destination is `RA`, so $d = 1$ and `REG = 000`.

Find the addressing-mode fields for `[BA+XA+]`:

- `RM = IR13:15 = 000`.
- `MOD = IR8:9 = 01`.

The final fields are:

- `OPC`: `0000 000`
- `d`: `1`
- `MOD`: `01`
- `REG`: `000`
- `RM`: `000`

Therefore, the instruction is `0000 0001 0100 0000` in binary, or `0x0140` in hexadecimal.