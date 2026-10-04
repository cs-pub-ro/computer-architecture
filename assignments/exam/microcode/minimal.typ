#import "tables.typ": microinstruction-matrix

== Problem

Given the maximum incompatible and maximum compatible classes below, find the minimum number of bits required for the micro-instruction coding.

#figure(microinstruction-matrix, caption: [Executed micro-operations for each micro-instruction])

The maximum incompatible classes are:

#table(
  columns: 11,
  table.header([$"MIC"$], [$mu O_0$], [$mu O_1$], [$mu O_2$], [$mu O_3$], [$mu O_4$], [$mu O_5$], [$mu O_6$], [$mu O_7$], [$mu O_8$], [$mu O_9$]),
  [$"MIC"_0$], [1], [1], [0], [1], [0], [0], [0], [0], [0], [0],
  [$"MIC"_1$], [1], [0], [1], [1], [1], [0], [0], [0], [0], [0],
  [$"MIC"_2$], [0], [1], [0], [1], [0], [1], [0], [1], [0], [0],
  [$"MIC"_3$], [0], [1], [0], [0], [0], [1], [0], [1], [1], [0],
  [$"MIC"_4$], [0], [0], [1], [1], [1], [1], [1], [0], [0], [0],
  [$"MIC"_5$], [0], [0], [0], [1], [1], [1], [1], [1], [0], [0],
  [$"MIC"_6$], [0], [0], [0], [0], [0], [1], [1], [0], [0], [1],
  [$"MIC"_7$], [0], [0], [0], [0], [0], [1], [0], [0], [1], [1],
)

The maximum compatible classes are:

#table(
  columns: 11,
  table.header([$"MCC"$], [$mu O_0$], [$mu O_1$], [$mu O_2$], [$mu O_3$], [$mu O_4$], [$mu O_5$], [$mu O_6$], [$mu O_7$], [$mu O_8$], [$mu O_9$]),
  [$"MCC"_0$], [1], [0], [0], [0], [0], [1], [0], [0], [0], [0],
  [$"MCC"_1$], [1], [0], [0], [0], [0], [0], [1], [0], [1], [0],
  [$"MCC"_2$], [1], [0], [0], [0], [0], [0], [0], [1], [0], [1],
  [$"MCC"_3$], [0], [1], [1], [0], [0], [0], [0], [0], [0], [1],
  [$"MCC"_4$], [0], [1], [0], [0], [1], [0], [0], [0], [0], [1],
  [$"MCC"_5$], [0], [1], [0], [0], [0], [0], [1], [0], [0], [0],
  [$"MCC"_6$], [0], [0], [1], [0], [0], [0], [0], [1], [0], [1],
  [$"MCC"_7$], [0], [0], [1], [0], [0], [0], [0], [0], [1], [0],
  [$"MCC"_8$], [0], [0], [0], [1], [0], [0], [0], [0], [1], [0],
  [$"MCC"_9$], [0], [0], [0], [1], [0], [0], [0], [0], [0], [1],
  [$"MCC"_(10)$], [0], [0], [0], [0], [1], [0], [0], [0], [1], [0],
)

== Solution

=== Associated Maximum Compatible Classes

The largest maximum incompatible classes are $"MIC"_4$ and $"MIC"_5$, each with cardinality 5. Choose $"MIC"_5$.

The associated maximum compatible classes for micro-operations in $"MIC"_5$ are:

$ {"MCC"_0, "MCC"_1, "MCC"_2, "MCC"_4, "MCC"_5, "MCC"_6, "MCC"_8, "MCC"_9, "MCC"_(10)} $

#table(
  columns: 11,
  table.header([$"MCC"$], [$mu O_0$], [$mu O_1$], [$mu O_2$], [$mu O_3$], [$mu O_4$], [$mu O_5$], [$mu O_6$], [$mu O_7$], [$mu O_8$], [$mu O_9$]),
  [$"MCC"_0$], [1], [0], [0], [0], [0], [1], [0], [0], [0], [0],
  [$"MCC"_1$], [1], [0], [0], [0], [0], [0], [1], [0], [1], [0],
  [$"MCC"_2$], [1], [0], [0], [0], [0], [0], [0], [1], [0], [1],
  [$"MCC"_4$], [0], [1], [0], [0], [1], [0], [0], [0], [0], [1],
  [$"MCC"_5$], [0], [1], [0], [0], [0], [0], [1], [0], [0], [0],
  [$"MCC"_6$], [0], [0], [1], [0], [0], [0], [0], [1], [0], [1],
  [$"MCC"_8$], [0], [0], [0], [1], [0], [0], [0], [0], [1], [0],
  [$"MCC"_9$], [0], [0], [0], [1], [0], [0], [0], [0], [0], [1],
  [$"MCC"_(10)$], [0], [0], [0], [0], [1], [0], [0], [0], [1], [0],
)

=== Essential Compatible Classes

An essential compatible class contains a micro-operation that occurs in no other compatible class. The source identifies $"MCC"_0$ and $"MCC"_6$ as essential, so begin with $S = {"MCC"_0, "MCC"_6}$.

#table(
  columns: 6,
  [$"MCC"$], [$mu O_1$], [$mu O_3$], [$mu O_4$], [$mu O_6$], [$mu O_8$],
  [$"MCC"_1$], [0], [0], [0], [1], [1],
  [$"MCC"_2$], [0], [0], [0], [0], [0],
  [$"MCC"_4$], [1], [0], [1], [0], [0],
  [$"MCC"_5$], [1], [0], [0], [1], [0],
  [$"MCC"_8$], [0], [1], [0], [0], [1],
  [$"MCC"_9$], [0], [1], [0], [0], [0],
  [$"MCC"_(10)$], [0], [0], [1], [0], [1],
)

$"MCC"_2$ and $"MCC"_9$ contain no micro-operation unique to those classes, so remove them. The remaining table makes $"MCC"_8$ essential; add it to obtain $S = {"MCC"_0, "MCC"_6, "MCC"_8}$.

#table(
  columns: 6,
  [$"MCC"$], [$mu O_1$], [$mu O_3$], [$mu O_4$], [$mu O_6$], [$mu O_8$],
  [$"MCC"_1$], [0], [0], [0], [1], [1],
  [$"MCC"_4$], [1], [0], [1], [0], [0],
  [$"MCC"_5$], [1], [0], [0], [1], [0],
  [$"MCC"_8$], [0], [1], [0], [0], [1],
  [$"MCC"_(10)$], [0], [0], [1], [0], [1],
)

=== Candidate Solutions

#table(
  columns: 4,
  [$"MCC"$], [$mu O_1$], [$mu O_4$], [$mu O_6$],
  [$"MCC"_1$], [0], [0], [1],
  [$"MCC"_4$], [1], [1], [0],
  [$"MCC"_5$], [1], [0], [1],
  [$"MCC"_(10)$], [0], [1], [0],
)

The possible additions are ${"MCC"_1, "MCC"_4}$, ${"MCC"_4, "MCC"_5}$, and ${"MCC"_5, "MCC"_(10)}$. The complete candidate sets are:

- $S_0 = {"MCC"_0, "MCC"_6, "MCC"_8, "MCC"_1, "MCC"_4}$
- $S_1 = {"MCC"_0, "MCC"_6, "MCC"_8, "MCC"_4, "MCC"_5}$
- $S_2 = {"MCC"_0, "MCC"_6, "MCC"_8, "MCC"_5, "MCC"_(10)}$

The selected compatible classes and their cardinalities are:

#table(
  columns: 12,
  table.header([$"MCC"$], [$mu O_0$], [$mu O_1$], [$mu O_2$], [$mu O_3$], [$mu O_4$], [$mu O_5$], [$mu O_6$], [$mu O_7$], [$mu O_8$], [$mu O_9$], [$|"MCC"|$]),
  [$"MCC"_0$], [1], [0], [0], [0], [0], [1], [0], [0], [0], [0], [2],
  [$"MCC"_1$], [1], [0], [0], [0], [0], [0], [1], [0], [1], [0], [3],
  [$"MCC"_4$], [0], [1], [0], [0], [1], [0], [0], [0], [0], [1], [3],
  [$"MCC"_5$], [0], [1], [0], [0], [0], [0], [1], [0], [0], [0], [2],
  [$"MCC"_6$], [0], [0], [1], [0], [0], [0], [0], [1], [0], [1], [3],
  [$"MCC"_8$], [0], [0], [0], [1], [0], [0], [0], [0], [1], [0], [2],
  [$"MCC"_(10)$], [0], [0], [0], [0], [1], [0], [0], [0], [1], [0], [2],
)

The solution costs are:

- $C(S_0) = {(mu O_2, mu O_7, mu O_9), (mu O_0, mu O_6, mu O_8), (mu O_1, mu O_4), (mu O_3), (mu O_5)} = 8$
- $C(S_1) = {(mu O_2, mu O_7, mu O_9), (mu O_0, mu O_5), (mu O_1, mu O_6), (mu O_8, mu O_3), (mu O_4)} = 9$
- $C(S_2) = {(mu O_2, mu O_7, mu O_9), (mu O_1, mu O_6), (mu O_0, mu O_5), (mu O_3, mu O_8), (mu O_4)} = 9$

The minimal microinstruction coding is $S_0 = {"MCC"_0, "MCC"_6, "MCC"_8, "MCC"_1, "MCC"_4}$, with a cost of 8.