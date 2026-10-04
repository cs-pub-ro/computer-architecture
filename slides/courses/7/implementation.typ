== Lab CPU

- Port-mapped I/O
- The first 256 addresses are reserved for I/O.
- Dedicated `IN` and `OUT` instructions access devices.
- Devices connect to the CPU through a bus.
- The CPU polls I/O devices.
- Each device's status and command registers map to the same I/O address; data registers map to the next address.
- The design can be changed to memory-mapped I/O or DMA.

== Lab I/O

#image("media/io.png", width: 70%)

== Lab I/O DMA

Eight DMA registers are mapped into I/O space, starting at address `0x08`.

#figure(
  table(
    columns: 3,
    align: left,
    table.header([*Address*], [*Name*], [*Function*]),
    [0x08], [SCIO0], [Status/command register for I/O device 0],
    [0x09], [SCIO1], [Status/command register for I/O device 1],
    [0x0A], [SCIO2], [Status/command register for I/O device 2],
    [0x0B], [SCIO3], [Status/command register for I/O device 3],
    [0x0C], [SCDMA], [Status/command register for DMA],
    [0x0D], [MADMA], [Memory address register for DMA],
    [0x0E], [CNTDMA], [DMA count register],
    [0x0F], [INITDMA], [DMA initialization register],
  ),
)

== Architecture with DMA

#image("media/dma.png", width: 90%)

== SCDMA Register

#figure(
  table(
    columns: 16,
    align: center,
    table.header([*0*], [*1*], [*2*], [*3*], [*4*], [*5*], [*6*], [*7*], [*8*], [*9*], [*10*], [*11*], [*12*], [*13*], [*14*], [*15*]),
    [SIO0], [SIO1], [SIO2], [SIO3], [X], [X], [SDMA], [EOBT], [EXTIRQ], [X], [PIRQ], [ENIRQ], [X], [MT], [DT], [ENT],
  ),
)

- `SIO0-3`: I/O device status (0 = functional, 1 = not functional)
- `SDMA`: DMA active (0 = inactive, 1 = active)
- `EOBT`: End of block transfer (0 = not ended, 1 = ended)
- `EXTIRQ`: External I/O interrupt (0 = none, 1 = present)
- `PIRQ`: CPU-programmable interrupt (0 = none, 1 = present; testing)
- `ENIRQ`: Interrupt enable (0 = disabled, 1 = enabled)
- `MT`: Transfer mode (0 = block, 1 = cycle stealing)
- `DT`: Transfer direction (0 = I/O to memory, 1 = memory to I/O)
- `ENT`: Transfer enable (0 = disabled, 1 = enabled)