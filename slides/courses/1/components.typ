#import "../../common/template.typ": ascii-figure

== Memory

Types of memory:
- Registers
- Buffer (cache)
- Main memory (RAM)
- Auxiliary/external memory (HDD, SSD), which may be part of the I/O subsystem

Properties:
- Every location contains the same number of bits
- Every location has a unique address
- The address space is homogeneous; all memory locations are equivalent

== Memory

#ascii-figure(read("media/memwrite.ascii"))

- Memory access time depends on address length
- Read/write cycle time depends on word length

== Central Processing Unit

Components:
- Arithmetic Logic Unit (ALU)
- Control unit

Types of ALU:
- Single-bus ALU
- Single-bus ALU with an accumulator
- Three-bus ALU

== Control Unit

- Decodes instructions and generates control signals
- Fetches the instruction from the address in the program counter (PC)
- Can be implemented as:
  - A microprogrammed control unit
  - A hardwired control unit (finite state machine)
- Depends on the instruction set

== Instruction Set

Instruction types:
- Data transfer
- Arithmetic operations
- Logical and shift operations
- Comparison operations
- Control flow

Each instruction has an opcode and operand specifiers.

== Input/Output Subsystem

The input/output subsystem converts formats and speeds between the CPU and peripheral devices.

== Programming Languages

#ascii-figure(read("media/plcomp.ascii"))

Programming languages create the illusion of a hierarchy of virtual computers.