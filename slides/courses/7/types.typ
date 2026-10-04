#import "@preview/touying:0.6.1": speaker-note

== Introduction

- I/O systems use different transfer methods to move data between the CPU, memory and I/O devices.
- Choosing an appropriate method can improve performance and resource use.

== Programmed I/O (Polling)

- *How it works:* The CPU actively checks the device's status register.
- *Characteristics:*
  - The CPU performs each data transfer directly.
  - The CPU waits, which can waste time.
- *Best for:* Simple or low-throughput devices such as keyboards.
- *Drawbacks:* Inefficient for high-speed devices or when CPU availability matters.

#speaker-note[
  The CPU performs every word transfer and repeatedly reads the status register.
]

== Interrupt-Driven I/O

- *How it works:* The device interrupts the CPU when it is ready to transfer data.
- *Characteristics:*
  - Reduces CPU waiting time.
  - Requests are handled through prioritized interrupts.
- *Best for:* Timely data handling, such as network interfaces.
- *Drawbacks:* High interrupt rates can overwhelm the CPU.

== Direct Memory Access (DMA)

- *How it works:* A DMA controller transfers data between an I/O device and memory without routing each word through the CPU.
- *Characteristics:*
  - Reduces CPU involvement in large transfers.
  - Supports high-speed transfers.
- *Best for:* High-throughput devices transferring large blocks, such as disk drives.
- *Drawbacks:* Requires a DMA controller.

#speaker-note[
  The CPU starts the transfer and checks whether it has completed; the DMA controller moves the data.
]

== CPU Tasks in a DMA Transfer

+ *Configure the DMA controller*
  - Set source and destination addresses.
  - Set transfer length and mode:
    - *Burst mode:* Transfers large chunks while blocking the CPU.
    - *Cycle stealing:* Transfers small chunks while sharing the bus; DMA has priority.
    - *Transparent mode:* Transfers when the CPU is not using the bus.
  - Enable a completion interrupt.
+ *Start the transfer* by issuing the command.
+ *Handle completion interrupts* and update status.
+ *Handle errors* by diagnosing and recovering from the reported error.

== Memory-Mapped I/O

- *How it works:* I/O devices share the main-memory address space.
- *Characteristics:*
  - Devices are accessed through memory addresses.
  - Simplifies the programming model.
- *Best for:* Systems that benefit from unified memory and I/O access, such as embedded systems.
- *Drawbacks:* Memory address conflicts are possible.

== Channel I/O

- *How it works:* Dedicated I/O processors (channels) handle complex I/O tasks independently.
- *Characteristics:*
  - Channels have their own instructions and operate without continuous CPU involvement.
  - Common in mainframes.
- *Best for:* High-performance systems with many I/O requests.
- *Drawbacks:* Additional hardware and complexity.

== Channel I/O Operation

+ *Set up the channel program:* The CPU specifies the I/O operations and transfer details; the program is loaded into channel control memory.
+ *Execute the program:* The CPU starts the channel processor, which runs independently.
+ *Complete the program:* The channel processor signals the CPU, which checks the result.

== Channel I/O vs. DMA

- Can handle interrupts and errors, except fatal errors.
- Can handle multiple devices and operations concurrently.
- Uses the same bus-sharing methods as DMA.

== Isolated I/O (Port-Mapped I/O)

- *How it works:* I/O has a separate address space accessed through dedicated instructions.
- *Characteristics:*
  - Avoids conflicts between memory and I/O addresses.
  - Uses instructions such as x86 `IN` and `OUT`.
- *Best for:* Systems with a separate I/O instruction set, such as x86 PCs.
- *Drawbacks:* Adds CPU design complexity.

== Co-Processor I/O

- A dedicated co-processor manages I/O independently and reduces the main CPU's workload.
- It can handle complex tasks such as formatting, error checking and signal processing.
- The CPU performs setup and initialization; the co-processor reports completion or errors.
- Use cases include GPUs, DSPs, multimedia, AI and scientific computing.

== Summary of Data Transfer Methods

#figure(
  block[
    #set text(size: 22pt)
    #table(
    columns: 4,
    align: left,
    table.header([*Method*], [*CPU Involvement*], [*Best For*], [*Examples*]),
    [Programmed I/O], [High], [Simple devices], [Keyboards, mice],
    [Interrupt-driven], [Moderate], [Timely handling], [Network cards],
    [DMA], [Low], [High throughput], [Disk drives, GPUs],
    [Memory-mapped I/O], [Moderate], [Unified memory and I/O], [Embedded systems],
    [Channel I/O], [Low], [Complex I/O], [Mainframes],
    [Port-mapped], [Moderate], [Separate I/O instructions], [x86 PCs],
    [Co-processor], [Very low], [High performance], [GPUs, DSPs],
    ),
  ]
)