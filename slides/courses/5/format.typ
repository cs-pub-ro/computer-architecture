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

#set text(size: 12pt)
#figure(
  table(
    columns: 4,
    align: left,
    table.header([*IR3*], [*IR0 = 0, IR2 = 0*], [*IR0 = 0, IR2 = 1*], [*IR0 = 1, IR2 = 0*]),
    [0, transfer/control], [MOV, PUSH, POP, CALL, JMP], [MOV], [IN, OUT, PUSHF, POPF, RET, IRET, HLT],
    [1, one operand], [INC, DEC, NEG, NOT, SHL/SAL, SHR, SAR], [ ], [JBE/JBA, JB/JC/JAE/JNC, JLE/JG, JL/JGE, JE/JZ/JNE/JNZ, JO/JNO, JS/JNS, JPE/JPO],
  ),
)

== Opcode Map: $"IR"_1 = 1$

#figure(
  table(
    columns: 3,
    align: left,
    table.header([*IR3*], [*IR0 = 0, IR2 = 0*], [*IR0 = 0, IR2 = 1*]),
    [0, compare/test], [CMP, TEST], [CMP, TEST],
    [1, arithmetic/logical], [ADD, ADC, SUB, SBB, AND, OR, XOR], [ADD, ADC, SUB, SBB, AND, OR, XOR],
  ),
)