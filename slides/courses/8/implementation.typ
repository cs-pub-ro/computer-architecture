== Implementation for the Lab CPU

*Interrupt types:*
- Internal, non-maskable:
  - ALU overflow
  - Software interrupt using the `INT` instruction
- External, non-maskable:
  - Loss of voltage (power off)
  - Dedicated hardware line `cinm`
- External, maskable:
  - Eight I/O device interrupts
  - Shared hardware line `cintr`

== IVT Implementation

#figure(
  table(
    columns: 3,
    align: left,
    table.header([*Address*], [*Name*], [*Type*]),
    [0x0], [Reserved], [Internal interrupt],
    [0x1], [Software interrupt (`INT`)], [Internal interrupt],
    [0x2], [ALU overflow], [Internal interrupt],
    [0x3], [Loss of voltage (power off)], [External non-maskable interrupt],
    [0x4], [Level 0], [External maskable interrupt],
    [0x5], [Level 1], [External maskable interrupt],
    [0x6], [Level 2], [External maskable interrupt],
    [0x7], [Level 3], [External maskable interrupt],
    [0x8], [Level 4], [External maskable interrupt],
    [0x9], [Level 5], [External maskable interrupt],
    [0xA], [Level 6], [External maskable interrupt],
    [0xB], [Level 7], [External maskable interrupt],
  ),
)

== Interrupt Instructions

The flags register (FR) adds an `I` bit to enable or disable interrupts.

- `EI`: Enable interrupts (`sei`)
- `DI`: Disable interrupts (`cli`)
- `INT`: Generate a software interrupt
- `RETI`: Return from interrupt

== Architecture

#image("media/isarchitecture.png", width: 80%)

== Architecture Signals

- `ip`: Software interrupt
- `id`: ALU overflow interrupt
- `inm`: External non-maskable interrupt (from `cinm`)
- `cintr_i`: External maskable interrupt from device *i*
- `ai`: External maskable interrupt active
- `intr`: Interrupt request to the CPU
- `sie` / `cie`: Enable / disable external maskable interrupts

== Architecture Components

- `REQINT`: Requested external maskable interrupts (`REQINT_i = 1` means interrupt *i* is requested)
- `MEXTINT`: Maskable external interrupt register (`MEXTINT_i = 1` means interrupt *i* is masked)
- `RUNINT`: Currently running interrupts (`RUNINT_i = 1` means level *i* is running)
- Priority logic determines whether a pending interrupt outranks the running interrupt.
- `INTADDR`: Computes the ISR address.
- `INTPC`: Stores the address for the current ISR.

== Handling External Maskable Interrupts

+ Check `REQINT` for requests.
+ Check that external maskable interrupts are enabled (`I` in FR).
+ Filter out interrupts masked in `MEXTINT`.
+ Select the highest-priority unmasked interrupt.
+ Compare its priority with active interrupts in `RUNINT`.
+ Send the request to the CPU using `intr` and wait for acknowledgement (`ai`).
+ Set the corresponding `RUNINT` bit and clear the `REQINT` bit.
+ Compute the ISR address and store it in `INTPC`.

== Handling External Non-Maskable Interrupts

+ Check the `inm` signal for a request.
+ Verify that no higher-priority interrupt is running.
+ Compute the ISR address and store it in `INTPC`.

== Handling ALU Overflow

+ Check the `id` signal for an overflow interrupt.
+ Verify that no higher-priority interrupt is running.
+ Compute the ISR address and store it in `INTPC`.
+ The ISR must clear the overflow flag in FR.

== Handling Software Interrupts

+ Check the `ip` signal for a request.
+ Verify that no higher-priority interrupt is running.
+ Compute the ISR address and store it in `INTPC`.

== CPU Interrupt Acknowledgement

+ Save FR on the stack.
+ Disable external maskable interrupts; the ISR can use `EI` to re-enable them.
+ Save the current PC on the stack.
+ Execute the jump instruction at the address in `INTPC`.