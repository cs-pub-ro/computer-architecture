== Dependency on Main Memory

- *Independent control memory:* Separate memory for fast microinstruction access.
- *Shared control memory:* Microinstructions share main memory and may contend with other accesses.
- *Cached control memory:* Caches microinstructions from main memory to reduce access cost.

== Control Memory Organization

- *Word-addressed:* Each address points to one microinstruction.
- *Page-addressed:* Each address points to a page of microinstructions, such as branch or subroutine sequences.
- *Block-addressed:* Each address points to a block of related microinstructions, reducing fetches.
- *Divided memory:* Stores unique microinstructions separately and keeps references in control memory.
- *Two-level memory:* Microinstructions reference nano-instructions that specify control signals.

== Microinstruction Format

Constraints:
- Parallelism between micro-operations
- Control signals for data flow
- Flexibility for future expansion
- Microinstruction size

== Microinstruction Format

- *Parallelism:* Allow simultaneous micro-operations.
- *Control-signal flexibility:* Support data flow, branches and hardware-specific operations.
- *Future expansion:* Allow new instructions and signals.
- *Microinstruction size:* Balance memory usage and instruction capability.

== Types of Microinstruction Coding

- *Horizontal:* Each bit represents a micro-operation; supports high parallelism.
- *Vertical:* Each microinstruction represents one micro-operation.
- *Minimal:* Fields group compatible operations, combining horizontal and vertical coding.
- *Residual:* Micro-operations reside in control registers and are modified by microinstructions.
- *Address:* A microinstruction references a micro-operation in separate memory.
- *Mixed:* Combines operation fields with an address for the next microinstruction.

== Execution of Microinstructions

Microinstructions execute in fetch and execute stages.
- *Sequential:* Execute in fixed order.
- *Parallel:* Fetch the next microinstruction while the current one executes.
- *Sequential-parallel:* Execute in parallel except at branches.

== Phases of Microinstruction Execution

- *Monophase:* All micro-operations execute in one phase.
- *Polyphase:* Micro-operations execute over multiple phases, allowing complex signal sequencing.
- Cycle time may be fixed or variable depending on microinstruction complexity.