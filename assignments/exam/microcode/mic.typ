#import "tables.typ": microinstruction-matrix

== Problem

Given micro-instructions $mu P(mu I)$ and their executed micro-operations $mu P(mu O)$, find the highest cardinality among the maximum incompatibility classes.

The sets are $mu P(mu I) = {mu I_0, mu I_1, mu I_2, mu I_3, mu I_4, mu I_5, mu I_6}$ and $mu P(mu O) = {mu O_0, mu O_1, mu O_2, mu O_3, mu O_4, mu O_5, mu O_6, mu O_7, mu O_8, mu O_9}$.

#figure(microinstruction-matrix, caption: [Executed micro-operations for each micro-instruction])

== Solution

Two micro-operations are incompatible if they occur in the same micro-instruction. The incompatibility matrix is:

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

Form maximum incompatibility classes by ANDing the relevant rows. A micro-operation can be added to a class when the resulting entries remain 1 for the members of the class. The resulting maximum incompatibility classes are:

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