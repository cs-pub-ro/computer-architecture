== Problem

For an X-bit adder of type Y, calculate the total number of gates and the number of gates on the path to the carry-out. Y can be a Ripple Carry Adder, Carry Lookahead Kogge-Stone, or Carry Lookahead Brent-Kung adder.

== Solution

The worked calculations below use a 32-bit adder.

=== Ripple Carry Adder

Each full adder uses 2 XOR gates for the sum, plus 2 AND gates and 1 OR gate for the carry-out.

$ "Total gates" = 32 times (2 + 2 + 1) = 160 "gates" $

$ "Gates on carry-out path" = 32 times (2 + 1) = 96 "gates" $

=== Carry Lookahead Adder

Each bit generates and propagates:

$ G_i = A_i and B_i "(one AND gate per bit)" $

$ P_i = A_i xor B_i "(one XOR gate per bit)" $

The sum is computed as:

$ S_i = P_i xor C_i $

This requires $n$ additional XOR gates. The carry equation is:

$ C_(i+1) = G_i or (P_i and C_i) $

=== Kogge-Stone CLA

The Kogge-Stone adder is a parallel-prefix adder with $ceil(log_2(n))$ levels for propagating P and G. At each level $k$:

$ G_i^((k)) = G_i^((k-1)) or (P_i^((k-1)) and G_(i-2^(k-1))^((k-1))) $

$ P_i^((k)) = P_i^((k-1)) and P_(i-2^(k-1))^((k-1)) $

Each P operation uses one AND gate, and each G operation uses one AND and one OR gate. The number of operations at level $k$ is $n - 2^(k-1)$, for a total of three gates per operation. The carry-out path has three gates per level: one AND for P, and one AND plus one OR for G.

For $n = 32$, the total number of carry gates is:

$ "Carry gates" = sum_(i=1)^(log_2(n)) (n - 2^(i-1)) times 3 $

$ = 3 times n times log_2(n) - 3 times (2^(log_2(n)) - 1) $

$ = 3 times n times log_2(n) - 3 times (n - 1) $

$ = 3 times 32 times 5 - 3 times 32 + 3 = 387 "gates" $

Adding the $n$ generate gates, $n$ propagate gates, and $n$ sum gates gives:

$ "Total gates" = n + n + n + 387 = 3 times 32 + 387 = 483 "gates" $

The carry-out path is:

$ "Carry-out path" = 2 times ceil(log_2(n)) + 1 = 2 times 5 + 1 = 11 "gates" $

=== Brent-Kung CLA

The Brent-Kung adder has a tree with depth $log_2(n)$ for the carry signals followed by depth $log_2(n)$ for the sum. For the first $log_2(n)$ levels, each operation uses one AND gate for P and one AND plus one OR gate for G, with $n / 2^k$ operations at level $k$. For the following $log_2(n) - 1$ levels, the same three gates are used, with $n / 2^k - 1$ operations per level.

The total number of carry gates is:

$ "Carry gates" = sum_(i=1)^(log_2(n)) (n / 2^i) times 3 + sum_(i=1)^(log_2(n)-1) (n / 2^i - 1) times 3 $

$ = 3 times n times sum_(i=1)^(log_2(n)) (1 / 2^i) + 3 times sum_(i=1)^(log_2(n)-1) (n / 2^i - 1) $

$ = 3 times n times (1 - 1 / 2^(log_2(n))) + 3 times (n times (1 - 1 / 2^(log_2(n)-1)) - (log_2(n) - 1)) $

$ = 3 times n - 3 + 3 times n times (1 - 2 / n) - 3 times (log_2(n) - 1) $

$ = 3 times n - 3 + 3 times n - 6 - 3 times log_2(n) + 3 $

$ = 6 times n - 6 - 3 times log_2(n) $

For $n = 32$:

$ "Carry gates" = 6 times 32 - 6 - 3 times 5 = 171 "gates" $

Adding the $n$ generate gates, $n$ propagate gates, and $n$ sum gates gives:

$ "Total gates" = n + n + n + 171 = 3 times 32 + 171 = 267 "gates" $

The carry-out path is:

$ "Carry-out path" = 2 times log_2(n) + 1 = 2 times 5 + 1 = 11 "gates" $