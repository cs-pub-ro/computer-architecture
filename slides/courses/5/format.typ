== Instruction Format

#figure(
  table(
    columns: 16,
    align: center,
    table.cell(colspan: 16, [*Instruction Register (IR)*]),
    [*0*], [*1*], [*2*], [*3*], [*4*], [*5*], [*6*], [*7*], [*8*], [*9*], [*10*], [*11*], [*12*], [*13*], [*14*], [*15*],
    table.cell(colspan: 7, [OPC]), [d], table.cell(colspan: 2, [MOD]), table.cell(colspan: 3, [REG]), table.cell(colspan: 3, [RM]),
    table.cell(colspan: 16, [immediate/data]),
    table.cell(colspan: 16, [data]),
  ),
)

- *OPC:* Operation code
- *d:* Destination (0 = RM, 1 = REG)
- *MOD:* Addressing mode
- *REG:* Register or operation-code extension
- *RM:* Register/memory

== Opcode Fields

- $"IR"_0$: 0 addresses memory; 1 addresses a register.
- $"IR"_1$: 0 selects one address; 1 selects two addresses.
- $"IR"_2$: 0 means no immediate data; 1 means immediate data.
- When $"IR"_1 = 0$, $"IR"_3$ selects data transfer/flow control (0) or a one-operand instruction (1).
- When $"IR"_1 = 1$, $"IR"_3$ selects whether the result is saved.

== Opcode Map: $"IR"_1 = 0$

#block[
  #set text(size: 14pt)
  #figure(
    table(
      columns: (0.3fr, 0.3fr, 0.7fr, 0.7fr, 0.7fr, 0.7fr),
      align: left,
      inset: 3pt,
      table.header(
        table.cell(rowspan: 2, [*IR1*]),
        table.cell(rowspan: 2, [*IR3*]),
        table.cell(colspan: 2, [*IR0 = 0*]),
        table.cell(colspan: 2, [*IR0 = 1*]),
        [*IR2 = 0*], [*IR2 = 1*],
        table.cell(colspan: 2, [*IR2 = 0*]),
      ),
      table.cell(rowspan: 16, [0]), table.cell(rowspan: 8, [0]), [000 = MOV], [000 = MOV], [000 = IN], [ ],
      [001 = ], [001 = ], [001 = OUT], [ ],
      [010 = PUSH], [010 = ], [010 = PUSHF], [ ],
      [011 = POP], [011 = ], [011 = POPF], [ ],
      [100 = CALL], [100 = ], [100 = RET], [ ],
      [101 = JMP], [101 = ], [101 = IRET], [ ],
      [110 = ], [110 = ], [110 = HLT], [ ],
      [111 = ], [111 = ], [111 = ], [ ],
      table.cell(rowspan: 8, [1]), [000 = INC], [000 = ], [0000 = JBE], [1000 = JBA],
      [001 = DEC], [001 = ], [0001 = JB/JC], [1001 = JAE/JNC],
      [010 = NEG], [010 = ], [0010 = JLE], [1010 = JG],
      [011 = NOT], [011 = ], [0011 = JL], [1011 = JGE],
      [100 = SHL/SAL], [100 = ], [0100 = JE/JZ], [1100 = JNE/JNZ],
      [101 = SHR], [101 = ], [0101 = JO], [1101 = JNO],
      [110 = SAR], [110 = ], [0110 = JS], [1110 = JNS],
      [111 = ], [111 = ], [0111 = JPE], [1111 = JPO],
    ),
  )
]

== Opcode Map: $"IR"_1 = 1$

#block[
  #set text(size: 14pt)
  #figure(
    table(
      columns: (0.3fr, 0.3fr, 0.7fr, 0.7fr, 0.7fr, 0.7fr),
      align: left,
      inset: 3pt,
      table.header(
        table.cell(rowspan: 2, [*IR1*]),
        table.cell(rowspan: 2, [*IR3*]),
        table.cell(colspan: 2, [*IR0 = 0*]),
        table.cell(colspan: 2, [*IR0 = 1*]),
        [*IR2 = 0*], [*IR2 = 1*],
        table.cell(colspan: 2, [*IR2 = 0*]),
      ),
      table.cell(rowspan: 16, [1]), table.cell(rowspan: 8, [0]), [000 = ], [000 = ], [ ], [ ],
      [001 = ], [001 = ], [ ], [ ],
      [010 = CMP], [010 = CMP], [ ], [ ],
      [011 = ], [011 = ], [ ], [ ],
      [100 = TEST], [100 = TEST], [ ], [ ],
      [101 = ], [101 = ], [ ], [ ],
      [110 = ], [110 = ], [ ], [ ],
      [111 = ], [111 = ], [ ], [ ],
      table.cell(rowspan: 8, [1]), [000 = ADD], [000 = ADD], [ ], [ ],
      [001 = ADC], [001 = ADC], [ ], [ ],
      [010 = SUB], [010 = SUB], [ ], [ ],
      [011 = SBB], [011 = SBB], [ ], [ ],
      [100 = AND], [100 = AND], [ ], [ ],
      [101 = OR], [101 = OR], [ ], [ ],
      [110 = XOR], [110 = XOR], [ ], [ ],
      [111 = ], [111 = ], [ ], [ ],
    ),
  )
]