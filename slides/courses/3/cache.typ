== Cache Memory Properties

- Miss rate
- Average memory access time
- Hit time
- Miss penalty
- Cache size
- Block size
- Associativity

== Cache Memory Performance

- Block placement
- Block identification
- Block replacement
- Write strategy

== Block Placement

- A cache contains $n$ blocks.
- RAM contains $m$ blocks, usually with $m >> n$.

Three main strategies are used for block placement:

- *Direct mapped (1-way set associative):* $p_("cache") = p_("ram") mod n$
- *Fully associative (n-way set associative):* any cache block can hold the RAM block
- *k-way set associative:* $p_("cache") in "set" (p_("ram") mod frac(n, k))$

== Block Identification

#figure(
  table(
    columns: 3,
    align: center,
    table.cell(colspan: 3, [*Address*]),
    table.cell(colspan: 2, [*Block Address*]), [*Block Offset*],
    [*Tag*], [*Index*], [*Block Offset*],
  ),
)

- *Tag:* Identifies the block in memory.
- *Index:* Identifies the set within the cache.
- *Block offset:* Specifies the byte within the block.
- A valid bit indicates whether the block contains valid data.
- Increasing associativity reduces index bits but increases tag bits.
- Increasing the number of sets raises hardware complexity.

== Block Replacement

- When a block must be replaced, the cache controller chooses which block to evict.
- Replacement policies include:
  - Random
  - LRU (least recently used), which can be expensive and is often only partially implemented
  - FIFO (first in, first out)

== Write Strategy

*Write strategy:*
- *Write through:* Write to both cache and RAM (L1 and L2).
- *Write back:* Write to cache and mark the block dirty; write to RAM only when the block is replaced (L3).

*Allocation policy:*
- *Write allocate:* Load the block into cache and write to it (used with write back).
- *No write allocate:* Write directly to RAM (used with write through).

== Write Buffer

*Write buffer (victim buffer):*
- Stores write operations.
- Has a fixed size (usually 8-16 entries). The CPU waits when it is full.
- Helps avoid write stalls.
- Must handle reads that access a block with a pending write.

== Types of Misses

- *Compulsory (cold start):* The first access to a block.
- *Capacity:* The cache is too small.
- *Conflict:* Too many blocks map to the same set.
- *Coherence:* Another cache modifies the block.

== Cache Memory Benchmarks

- Average memory access time (AMAT) = hit time + miss rate $times$ miss penalty
- Hit time: time taken to access the cache
- Miss penalty: time taken to access main memory
- Miss rate: ratio of misses to total accesses
- CPU execution time
- Power consumption