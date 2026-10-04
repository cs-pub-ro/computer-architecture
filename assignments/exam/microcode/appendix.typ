#import "tables.typ": microinstruction-matrix

== Input

The worked example uses micro-instructions $mu P(mu I)$ and micro-operations $mu P(mu O)$:

$mu P(mu I) = {mu I_0, mu I_1, mu I_2, mu I_3, mu I_4, mu I_5, mu I_6}$

$mu P(mu O) = {mu O_0, mu O_1, mu O_2, mu O_3, mu O_4, mu O_5, mu O_6, mu O_7, mu O_8, mu O_9}$

#figure(microinstruction-matrix, caption: [Micro-operations executed by each micro-instruction])

== Maximum Incompatible Classes

Two micro-operations are incompatible if they occur in the same micro-instruction. Their incompatibility matrix is:

#table(
  columns: 11,
  table.header([$mu O$], [$mu O_0$], [$mu O_1$], [$mu O_2$], [$mu O_3$], [$mu O_4$], [$mu O_5$], [$mu O_6$], [$mu O_7$], [$mu O_8$], [$mu O_9$]),
  [$mu O_0$], [1], [1], [1], [1], [1], [0], [0], [0], [0], [0],
  [$mu O_1$], [1], [1], [0], [1], [0], [1], [0], [1], [1], [0],
  [$mu O_2$], [1], [0], [1], [1], [1], [1], [1], [0], [0], [0],
  [$mu O_3$], [1], [1], [1], [1], [1], [1], [1], [1], [0], [0],
  [$mu O_4$], [1], [0], [1], [1], [1], [1], [1], [1], [0], [0],
  [$mu O_5$], [0], [1], [1], [1], [1], [1], [1], [1], [1], [1],
  [$mu O_6$], [0], [0], [1], [1], [1], [1], [1], [1], [0], [1],
  [$mu O_7$], [0], [1], [0], [1], [1], [1], [1], [1], [1], [0],
  [$mu O_8$], [0], [1], [0], [0], [0], [1], [0], [1], [1], [1],
  [$mu O_9$], [0], [0], [0], [0], [0], [1], [1], [0], [1], [1],
)

To form an incompatible class, select micro-operations and AND their rows. A 1 in the result means the micro-operation is incompatible with the selected members and can be added to the class. When no more operations can be added, the class is maximum.

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

The highest cardinality is 5, attained by $"MIC"_4$ and $"MIC"_5$.

== Maximum Compatible Classes

Two micro-operations are compatible if they do not occur in the same micro-instruction. OR the rows of the incompatibility matrix; the columns containing 0 identify operations that can appear together. The maximum compatibility classes are:

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

== Associated Classes

Choose the maximum incompatible class with the greatest cardinality. Both $"MIC"_4$ and $"MIC"_5$ have cardinality 5; choose $"MIC"_5$.

The associated maximum compatible classes for operations in $"MIC"_5$ are:

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

== Essential Compatible Classes

An essential compatible class contains an operation that occurs in no other compatible class. $"MCC"_0$ and $"MCC"_6$ are essential; add them to the solution set: $S = {"MCC"_0, "MCC"_6}$.

#table(
  columns: 6,
  table.header([$"MCC"$], [$mu O_1$], [$mu O_3$], [$mu O_4$], [$mu O_6$], [$mu O_8$]),
  [$"MCC"_1$], [0], [0], [0], [1], [1],
  [$"MCC"_2$], [0], [0], [0], [0], [0],
  [$"MCC"_4$], [1], [0], [1], [0], [0],
  [$"MCC"_5$], [1], [0], [0], [1], [0],
  [$"MCC"_8$], [0], [1], [0], [0], [1],
  [$"MCC"_9$], [0], [1], [0], [0], [0],
  [$"MCC"_(10)$], [0], [0], [1], [0], [1],
)

Remove the essential classes and their covered operations. $"MCC"_2$ and $"MCC"_9$ contain no unique operation and can also be removed:

#table(
  columns: 6,
  table.header([$"MCC"$], [$mu O_1$], [$mu O_3$], [$mu O_4$], [$mu O_6$], [$mu O_8$]),
  [$"MCC"_1$], [0], [0], [0], [1], [1],
  [$"MCC"_4$], [1], [0], [1], [0], [0],
  [$"MCC"_5$], [1], [0], [0], [1], [0],
  [$"MCC"_8$], [0], [1], [0], [0], [1],
  [$"MCC"_(10)$], [0], [0], [1], [0], [1],
)

This makes $"MCC"_8$ essential. Add it to the solution set: $S = {"MCC"_0, "MCC"_6, "MCC"_8}$.

== Remaining Classes and Costs

The remaining cover problem is:

#table(
  columns: 4,
  table.header([$"MCC"$], [$mu O_1$], [$mu O_4$], [$mu O_6$]),
  [$"MCC"_1$], [0], [0], [1],
  [$"MCC"_4$], [1], [1], [0],
  [$"MCC"_5$], [1], [0], [1],
  [$"MCC"_(10)$], [0], [1], [0],
)

The possible additions are ${"MCC"_1, "MCC"_4}$, ${"MCC"_4, "MCC"_5}$, and ${"MCC"_5, "MCC"_(10)}$. Therefore, the candidate sets are:

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

The costs are:

- $C(S_0) = {(mu O_2, mu O_7, mu O_9), (mu O_0, mu O_6, mu O_8), (mu O_1, mu O_4), (mu O_3), (mu O_5)} = 8$
- $C(S_1) = {(mu O_2, mu O_7, mu O_9), (mu O_0, mu O_5), (mu O_1, mu O_6), (mu O_8, mu O_3), (mu O_4)} = 9$
- $C(S_2) = {(mu O_2, mu O_7, mu O_9), (mu O_1, mu O_6), (mu O_0, mu O_5), (mu O_3, mu O_8), (mu O_4)} = 9$

The minimum-cost microinstruction coding is $S_0 = {"MCC"_0, "MCC"_6, "MCC"_8, "MCC"_1, "MCC"_4}$, with a cost of 8.