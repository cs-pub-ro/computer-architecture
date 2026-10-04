== Register

#grid(
  columns: (1fr, 2fr, 1fr),
  align: center,
  [Data Input (DI) \\ Write Enable (WE) \\ Output Enable (OE)],
  [#rect(stroke: 1pt, inset: 1em, width: 100%)[Register]],
  [Data Output (DO)],
)

== General-Purpose Registers (GR)

#figure(
  table(
    columns: 3,
    align: left,
    table.header([*Register*], [*Acronym*], [*Size*]),
    [Register A], [RA], [16-bit],
    [Register B], [RB], [16-bit],
    [Register C], [RC], [16-bit],
    [Stack Pointer Register], [SP], [16-bit],
    [Index Register A], [XA], [16-bit],
    [Index Register B], [XB], [16-bit],
    [Base Address A], [BA], [16-bit],
    [Base Address B], [BB], [16-bit],
  ),
)

== Register File (RF)

#grid(
  columns: (1fr, 2fr, 1fr),
  align: center,
  [Data input \\ Write enable \\ Output enable \\ Register address],
  [#rect(stroke: 1pt, inset: 1em, width: 100%)[Register File]],
  [RA \\ RB \\ RC \\ SP \\ XA \\ XB \\ BA \\ BB \\ Data output],
)

== Special-Purpose Registers

#figure(
  table(
    columns: 3,
    align: left,
    table.header([*Register*], [*Acronym*], [*Size*]),
    [Program Counter], [PC], [16-bit],
    [Instruction Register], [IR], [16-bit],
    [Memory Address Register], [MA], [16-bit],
    [Flags Register], [FR], [16-bit],
    [Operand Register 1], [T1], [16-bit],
    [Operand Register 2], [T2], [16-bit],
    [Input/Output Addressing Register], [IOA], [16-bit],
  ),
)

== Memory (M)

- Address width: 16 bits
- Data width: 16 bits

#grid(
  columns: (1fr, 2fr, 1fr),
  align: center,
  [Address (MA) \\ Memory Input (MI) \\ Write Enable (WE) \\ Output Enable (OE)],
  [#rect(stroke: 1pt, inset: 1.5em, width: 100%)[Memory]],
  [Memory Output (MO)],
)

== Arithmetic Logic Unit (ALU)

#grid(
  columns: (1fr, 2fr, 1fr),
  align: center,
  [Operand 1 (T1) \\ Operand 2 (T2) \\ Operation (OP) \\ Carry In (CI) \\ Output Enable (OE)],
  [#rect(stroke: 1pt, inset: 1.5em, width: 100%)[ALU]],
  [Result (R) \\ Flags (FR)],
)

== Internal Bus

#set text(size: 9pt)
#figure(
  table(
    columns: 12,
    align: center,
    table.header([*Source*], [*GR*], [*M*], [*T1*], [*T2*], [*IR*], [*PC*], [*IO*], [*IOA*], [*ALU*], [*MA*], [*FR*]),
    [GR], [X], [X], [X], [X], [-], [X], [X], [-], [-], [X], [-],
    [M], [X], [X], [X], [X], [X], [X], [X], [-], [-], [X], [X],
    [T1], [-], [-], [-], [-], [-], [-], [-], [-], [X], [-], [-],
    [T2], [-], [-], [-], [-], [-], [-], [-], [-], [X], [-], [-],
    [IR], [-], [-], [-], [-], [-], [-], [-], [X], [-], [-], [-],
    [PC], [X], [X], [-], [-], [-], [X], [-], [-], [-], [X], [-],
    [IO], [X], [X], [-], [-], [-], [-], [-], [-], [-], [-], [-],
    [IOA], [-], [-], [-], [-], [-], [-], [X], [-], [-], [-], [-],
    [ALU], [X], [X], [X], [X], [-], [X], [-], [-], [-], [X], [X],
    [MA], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-],
    [FR], [-], [X], [-], [-], [-], [-], [-], [-], [-], [-], [-],
  ),
)