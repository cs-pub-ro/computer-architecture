== Information Representation

- Decimal
- Binary
- Hexadecimal

== Information Representation

#figure(
  table(
    columns: 3,
    align: center,
    table.header([*Decimal*], [*Binary*], [*Hexadecimal*]),
    [0], [0000], [0x0],
    [1], [0001], [0x1],
    [2], [0010], [0x2],
    [3], [0011], [0x3],
    [4], [0100], [0x4],
    [5], [0101], [0x5],
    [6], [0110], [0x6],
    [7], [0111], [0x7],
    [8], [1000], [0x8],
    [9], [1001], [0x9],
    [10], [1010], [0xA],
    [11], [1011], [0xB],
    [12], [1100], [0xC],
    [13], [1101], [0xD],
    [14], [1110], [0xE],
    [15], [1111], [0xF],
  ),
  caption: [Decimal, Binary, and Hexadecimal Values],
)

== Big Endian vs. Little Endian

- Big Endian
  - Most significant byte first
  - Network byte order
  - Example: 0x12345678 is stored as 0x12 0x34 0x56 0x78
- Little Endian
  - Least significant byte first
  - Intel byte order
  - Example: 0x12345678 is stored as 0x78 0x56 0x34 0x12