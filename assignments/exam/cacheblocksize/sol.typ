== Problem

A single-level direct-mapped cache has the following characteristics:

- Main-memory access time: $L_("MM") = 120$ cycles
- Main-memory byte-transfer time: $"BT"_("MM") = 12$ cycles/byte
- Cache hit time: $H_C = 4$ cycles
- Cache miss rate: $"MR"_C = 0.05$
- Cache block size: $"BS"_C = 16$ bytes
- Cache size: $S_C = 64 times 1024$ bytes

What is the AMAT speedup if the block size is increased to $"BS"_("NC") = 64$ bytes, reducing the miss rate to $"MR"_("NC") = 0.03$, and the hit time becomes $H_("NC") = 2$ cycles?

== Solution

Calculate the initial miss penalty:

$ "Initial miss penalty" = L_("MM") + "BS"_C times "BT"_("MM") $

$ "Initial miss penalty" = 120 + 16 times 12 = 312 "cycles" $

Calculate the initial AMAT:

$ "Initial AMAT" = H_C + "MR"_C times "miss penalty" $

$ "Initial AMAT" = 4 + 0.05 times 312 = 19.6 "cycles" $

Calculate the new miss penalty:

$ "New miss penalty" = L_("MM") + "BS"_("NC") times "BT"_("MM") $

$ "New miss penalty" = 120 + 64 times 12 = 888 "cycles" $

Calculate the new AMAT. The source solution uses a miss rate of 0.02 in this calculation, despite the 0.03 stated in the problem:

$ "New AMAT" = H_("NC") + 0.02 times 888 = 19.76 "cycles" $

Calculate the speedup:

$ "Speedup" = "Initial AMAT" / "New AMAT" = 19.6 / 19.76 approx 0.992 $

Therefore, the source solution reports an AMAT speedup of approximately 0.992.