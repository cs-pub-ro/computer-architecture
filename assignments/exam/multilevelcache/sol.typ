== Problem

A single-level direct-mapped cache has these characteristics:

- Main-memory access time: $L_("MM") = 170$ cycles
- Main-memory byte-transfer time: $"BT"_("MM") = 24$ cycles/byte
- L1 hit time: $H_C = 6$ cycles
- L1 miss rate: $"MR"_C = 0.08$
- L1 block size: $"BS"_C = 256$ bytes
- L1 cache size: $S_C = 32 times 1024$ bytes

What is the AMAT speedup after adding a second, 2-way set-associative cache that is accessed only when L1 misses? The second cache has a hit time of 36 cycles, miss rate 0.40, block size 256 bytes, and size 512 KB.

== Solution

Calculate the initial miss penalty:

$ "Initial miss penalty" = L_("MM") + "BS"_C times "BT"_("MM") $

$ "Initial miss penalty" = 170 + 256 times 24 = 6314 "cycles" $

Calculate the initial AMAT:

$ "Initial AMAT" = H_C + "MR"_C times "Initial miss penalty" $

$ "Initial AMAT" = 6 + 0.08 times 6314 = 511.12 "cycles" $

Calculate the miss penalty for the second cache:

$ "C2 miss penalty" = L_("MM") + "BS"_("C2") times "BT"_("MM") $

$ "C2 miss penalty" = 170 + 256 times 24 = 6314 "cycles" $

Calculate the AMAT for the second cache:

$ "C2 AMAT" = H_("C2") + "MR"_("C2") times "C2 miss penalty" $

$ "C2 AMAT" = 36 + 0.40 times 6314 = 2561.6 "cycles" $

Calculate the AMAT with both cache levels:

$ "New AMAT" = H_C + "MR"_C times "C2 AMAT" $

$ "New AMAT" = 6 + 0.08 times 2561.6 = 210.928 "cycles" $

Calculate the speedup:

$ "Speedup" = "Initial AMAT" / "New AMAT" = 511.12 / 210.928 approx 2.42 $

Therefore, the AMAT speedup is approximately 2.42.