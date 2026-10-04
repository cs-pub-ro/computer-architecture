#import "@preview/touying:0.6.1": speaker-note
#import "../../common/template.typ": ascii-figure

== Memory Hierarchy

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  [
    - The CPU requests data at specific memory addresses.
      - Hit: the data is found.
      - Miss: the data is not found.
    - For cache memory:
      - Cache hit or cache miss.
      - Hardware manages cache levels (L1, L2, L3).
      - Blocks or lines are the transfer units.
    - For virtual memory:
      - Page hit or page fault.
      - The operating system manages virtual memory.
      - Pages are the transfer units.
  ],
  [#ascii-figure(read("media/memheir.ascii"), width: 100%)],
)

#speaker-note[
  The memory hierarchy creates the illusion of a large, fast memory system.
]

== Memory Locality

The memory hierarchy creates the illusion of a large, fast memory system.

- *Temporal locality:* An accessed memory location is likely to be accessed again soon.
- *Spatial locality:* Nearby memory locations are likely to be accessed soon after an access.

A full-cache miss depends on main-memory latency (the time to retrieve the first byte) and bandwidth (the time to retrieve the complete line or block).

== CPU Execution Time

- *CPU execution time* = CPU clock cycles $times$ clock cycle time (CLKT)
- *CPU clock cycles* = instruction count (IC) $times$ cycles per instruction (CPI)
- *With memory hierarchy:* CPU clock cycles = (CPU clock cycles + memory stall cycles) $times$ clock cycle time
- *Memory stall cycles* = number of misses $times$ miss penalty
- *Memory stall cycles* = IC $times$ misses per instruction $times$ miss penalty
- *Misses per instruction* = miss rate $times$ memory accesses per instruction (separately for reads and writes)