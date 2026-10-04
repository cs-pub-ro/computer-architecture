== Problem

Given the register values, main-memory addresses and data, and immediate value below, find the MA register value for each addressing mode:

- Direct addressing
- Indirect addressing
- Indirect addressing from a register
- Indirect addressing from base and index registers
- Indirect addressing from base and index registers with index increment after
- Indirect addressing from base and index registers with index decrement before
- Indirect addressing from base and immediate
- Indirect addressing from index and immediate
- Indirect addressing from base, index, and immediate
- Immediate addressing
- Direct register addressing

Register values:

#figure(
  table(
    columns: 2,
    [*Register*], [*Hex value*],
    [RA], [0x1000],
    [RB], [0x2000],
    [RC], [0x3000],
    [SP], [0x4000],
    [XA], [0x0004],
    [XB], [0x0008],
    [BA], [0x7000],
    [BB], [0x8000],
    [PC], [0x0100],
  ),
  caption: [Register values in hexadecimal],
)

Immediate value: `0x0096`.

Main memory:

#figure(
  table(
    columns: 2,
    [*Address*], [*Value*],
    [0x0096], [0x4321],
    [0x1000], [0x1234],
    [0x2000], [0x5678],
    [0x3000], [0x9ABC],
    [0x4000], [0xDEF0],
    [0x4500], [0x6000],
    [0x5000], [0x1111],
    [0x6000], [0x2222],
    [0x7000], [0x3333],
    [0x8000], [0x4444],
  ),
  caption: [Main-memory values],
)

== Solution

Calculate the MA register value for each addressing mode.

=== Direct Addressing

$ "MA" = "Immediate value" = #raw("0x0096") $

=== Indirect Addressing

$ "MA" = "MM"["Immediate value"] = #raw("0x4321") $

=== Indirect Addressing from a Register

Using RA:

$ "MA" = "RA" = #raw("0x1000") $

=== Indirect Addressing from Base and Index Registers

Using BA and XA:

$ "MA" = "BA" + "XA" = #raw("0x7000") + #raw("0x0004") = #raw("0x7004") $

=== Base and Index with Increment After

Using BA and XA:

$ "MA" = "BA" + "XA" = #raw("0x7000") + #raw("0x0004") = #raw("0x7004") $

$ "XA" = "XA" + 1 = #raw("0x0005") $

=== Base and Index with Decrement Before

Using BA and XA:

$ "XA" = "XA" - 1 = #raw("0x0003") $

$ "MA" = "BA" + "XA" = #raw("0x7000") + #raw("0x0003") = #raw("0x7003") $

=== Base and Immediate

Using BA:

$ "MA" = "BA" + "Immediate value" = #raw("0x7000") + #raw("0x0096") = #raw("0x7096") $

=== Index and Immediate

Using XA:

$ "MA" = "XA" + "Immediate value" = #raw("0x0004") + #raw("0x0096") = #raw("0x009A") $

=== Base, Index, and Immediate

Using BA and XA:

$ "MA" = "BA" + "XA" + "Immediate value" = #raw("0x7000") + #raw("0x0004") + #raw("0x0096") = #raw("0x709A") $

=== Immediate Addressing

$ "MA" = "PC" + "Immediate value" = #raw("0x0100") + #raw("0x0096") = #raw("0x0196") $

=== Direct Register Addressing

This mode does not use a memory address:

$ "MA" = 0 $