#import "tables.typ": microinstruction-matrix

== Problem

Given micro-instructions $mu P(mu I)$ and their executed micro-operations $mu P(mu O)$, how many maximum compatibility classes are there?

The sets are $mu P(mu I) = {mu I_0, mu I_1, mu I_2, mu I_3, mu I_4, mu I_5, mu I_6}$ and $mu P(mu O) = {mu O_0, mu O_1, mu O_2, mu O_3, mu O_4, mu O_5, mu O_6, mu O_7, mu O_8, mu O_9}$.

#figure(microinstruction-matrix, caption: [Executed micro-operations for each micro-instruction])

== Solution

Two micro-operations are compatible if they do not occur in the same micro-instruction. OR the rows of the incompatibility matrix; zero-valued columns indicate micro-operations that can belong to the same compatibility class. The maximum compatibility classes are:

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

There are 11 maximum compatibility classes.