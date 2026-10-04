== I/O Components

- Input/output devices convert between the external world and the computer.
- Input/output interfaces connect devices to the computer.
- Input/output middleware manages data transfer; this function may be performed by the CPU.
- Device drivers let software communicate with I/O devices.
- I/O memory stores device data.

== Types of I/O Data

- *Fixed block:* Transfers data in equal-sized units; suitable when devices and buffers use a known block size (e.g., disk sectors).
- *Variable block:* Transfers blocks whose length can change; the receiver uses a length field or delimiter to find the end (e.g., network packets).
- *Character:* Transfers individual characters or bytes in sequence; suitable for text-oriented or serial devices (e.g., keyboards and UARTs).
- *Hybrid:* Combines character/byte streams with block transfers, such as variable-length messages carried in buffered blocks.

== I/O Registers

- Control
- Status
- Data

== Communication with I/O

- Through status registers (polling)
- Through hardware interrupts:
  - Save the context.
  - Jump to the interrupt handler.
  - Restore the context.
  - Return from the interrupt.