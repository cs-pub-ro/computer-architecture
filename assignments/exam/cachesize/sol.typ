== Problem

A single-level direct-mapped cache has the following characteristics:

- Main-memory access time: $L_("MM") = 120$ cycles
- Main-memory byte-transfer time: $"BT"_("MM") = 12$ cycles/byte
- Cache hit time: $H_C = 4$ cycles
- Cache miss rate: $"MR"_C = 0.05$
- Cache block size: $"BS"_C = 16$ bytes
- Cache size: $S_C = 64 times 1024$ bytes

What is the AMAT speedup if the cache size is increased to $S_("NC") = 128 times 1024$ bytes, reducing the miss rate to $"MR"_("NC") = 0.02$ and increasing the hit time to $H_("NC") = 6$ cycles?

== Solution

Calculate the initial miss penalty:

$ "Initial miss penalty" = L_("MM") + "BS"_C times "BT"_("MM") $

$ "Initial miss penalty" = 120 + 16 times 12 = 312 "cycles" $

Calculate the initial AMAT:

$ "Initial AMAT" = H_C + "MR"_C times "miss penalty" $

$ "Initial AMAT" = 4 + 0.05 times 312 = 19.6 "cycles" $

Calculate the new miss penalty:

$ "New miss penalty" = L_("MM") + "BS"_C times "BT"_("MM") $

$ "New miss penalty" = 120 + 16 times 12 = 312 "cycles" $

Calculate the new AMAT:

$ "New AMAT" = H_("NC") + "MR"_("NC") times "miss penalty" $

$ "New AMAT" = 6 + 0.02 times 312 = 12.24 "cycles" $

Calculate the speedup:

$ "Speedup" = "Initial AMAT" / "New AMAT" = 19.6 / 12.24 approx 1.60 $

Therefore, the source solution reports an AMAT speedup of approximately 1.60.