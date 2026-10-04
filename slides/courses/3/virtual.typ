== Virtual Memory

Benefits of virtual memory:
- Efficient memory management
- Enhanced protection
- Shared memory
- Process relocation
- Faster process creation and startup without loading the entire process into memory

Translating a virtual address into a physical address is called address translation. The operating system manages virtual memory.

== Allocation Policies

- *Paged virtual memory:* Virtual memory is divided into fixed-size pages.
- *Segmented virtual memory:* Virtual memory is divided into variable-sized segments based on logical divisions.
- *Combined virtual memory:* Virtual memory is divided into segments whose sizes are multiples of the page size.

The miss penalty is the time needed to retrieve a page from disk. To reduce misses, the operating system uses a fully associative design, allowing pages to be placed anywhere in main memory.

== TLB vs. MMU

- *Translation Lookaside Buffer (TLB)*
  - A specialized cache that speeds up virtual-to-physical address translation.
  - Stores recent translations for quick access.
  - Checked first during address translation.
  - Very fast, but limited in size.
- *Memory Management Unit (MMU)*
  - Hardware that manages memory and caching operations.
  - Translates virtual addresses to physical addresses using page tables.
  - Manages page faults and enforces memory protection.
  - More complex and integrated into the CPU.

== TLB vs. MMU

#figure(
  table(
    columns: 3,
    align: left,
    table.header([*Component*], [*Function*], [*Characteristics*]),
    [TLB], [Caches recent address translations], [Fast, limited size],
    [MMU], [Manages memory and performs address translations], [Complex, integrated into the CPU],
  ),
)