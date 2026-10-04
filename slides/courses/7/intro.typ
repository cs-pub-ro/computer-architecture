== I/O Components

- Input/output devices convert between the external world and the computer.
- Input/output interfaces connect devices to the computer.
- Input/output middleware manages data transfer; this function may be performed by the CPU.
- Device drivers let software communicate with I/O devices.
- I/O memory stores device data.

== Types of I/O Data

- Fixed block
- Variable block
- Character
- Hybrid

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