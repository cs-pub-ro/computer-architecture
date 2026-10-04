== Problem

Given the I/O register values, main-memory addresses, and data below, determine the value on the data bus.

#figure(
  table(
    columns: 2,
    [*Register*], [*Value*],
    [SCDMA], [0x0192],
    [MADMA], [0x5678],
    [CNTDMA], [0x0005],
    [INITDMA], [0x0001],
    [SCIO0], [0x0000],
    [SCIO1], [0x0000],
    [SCIO2], [0x0000],
    [SCIO3], [0x0000],
  ),
  caption: [I/O register values],
)

#figure(
  table(
    columns: 2,
    [*Memory address*], [*Data*],
    [0x5678], [0x0000],
    [0x5679], [0x0001],
    [0x567a], [0x0002],
    [0x567b], [0x0003],
    [0x567c], [0x0004],
    [0x567d], [0x0005],
    [0x567e], [0x0006],
    [0x567f], [0x0007],
  ),
  caption: [Main-memory addresses and data],
)

The SCDMA register fields are:

#table(
  columns: 2,
  table.header([*Bit*], [*Field*]),
  [0], [SIO0], [1], [SIO1], [2], [SIO2], [3], [SIO3],
  [4], [X], [5], [X], [6], [SDMA], [7], [EOBT],
  [8], [EXTIRQ], [9], [X], [10], [PIRQ], [11], [ENIRQ],
  [12], [X], [13], [MT], [14], [DT], [15], [ENT],
)

- `SIO0-3`: I/O device status; 0 means functional, 1 means not functional.
- `SDMA`: DMA status; 0 means inactive, 1 means active.
- `EOBT`: end of block transfer; 0 means no, 1 means yes.
- `EXTIRQ`: external interrupt from an I/O device; 0 means no, 1 means yes.
- `PIRQ`: programmable CPU interrupt (testing); 0 means no, 1 means yes.
- `ENIRQ`: interrupt enable; 0 means enabled, 1 means disabled.
- `MT`: transfer mode; 0 means block, 1 means cycle stealing.
- `DT`: transfer direction; 0 means I/O to memory, 1 means memory to I/O.
- `ENT`: transfer enable; 0 means enabled, 1 means disabled.

The SCIOX register fields are:

#table(
  columns: 2,
  table.header([*Bit*], [*Field*]),
  [0], [S], [1], [C], [2], [X], [3], [X],
  [4], [X], [5], [X], [6], [X], [7], [X],
  [8], [X], [9], [X], [10], [X], [11], [ENIRQ],
  [12], [X], [13], [X], [14], [DT], [15], [X],
)

- `S`: I/O device status; 0 means functional, 1 means not functional.
- `C`: start transfer; 1 means start, 0 means stop.
- `ENIRQ`: interrupt enable; 0 means enabled, 1 means disabled.
- `DT`: transfer direction; 0 means I/O to memory, 1 means memory to I/O.

== Solution

DMA is initialized (`INITDMA = 0x0001`) at address `0x5678`, with a transfer count of `0x0005`.

The source solution treats the transfer as active with memory-to-I/O direction and selects the address obtained by adding the count to MADMA:

$ "Selected address" = #raw("0x5678") + #raw("0x0005") = #raw("0x567d") $

The data at address `0x567d` is `0x0005`. Therefore, the source solution gives the data-bus value as `0x0005`.

Note: The source describes DMA as active with `SDMA = 0`, but the register-field table defines `SDMA = 0` as inactive. The stated source result is preserved.