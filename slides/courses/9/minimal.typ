== Engineering Minimal Microinstruction Coding

- Finding the minimum-cost coding is NP-complete.
- Minimize microinstruction word size while respecting ROM sizes of $2^n$.
- Assume monophase microinstructions.

== Problem Definition

- A micro-operation is `μO_i`.
- A microinstruction is a set of operations: `μI_i = {μO_0, μO_1, ..., μO_|Ii|}`.
- `μP(μI)` is the set of unique microinstructions in a program.
- `μP(μO)` is the set of micro-operations used by the program.

== Compatible Class of Micro-Operations

- `μO_i` and `μO_j` are compatible if no microinstruction contains both; they cannot execute in parallel.
- `CC(μO_i)` contains the operations in `μP(μO)` that are compatible with `μO_i`.
- A maximum compatible class (MCC) cannot be extended with another compatible operation.

== Cost of a Compatible Class

- Cost of a compatible class: `C(CC_i) = ceil(log2(|CC_i| + 1))`.
- Total microinstruction cost: `C(μI) = sum(i=0..k, C(CC_i))`, where `k` is the number of classes.
- Each compatible class corresponds to a microinstruction field.

== Approximate Minimal-Coding Algorithm

- Identify all maximum compatible classes `MCC(μO_i)`.
- Select a set of classes that minimizes `C(μI)`.

== Incompatible Classes

- `IC(μO_i)` contains operations incompatible with `μO_i`.
- A maximum incompatible class (MIC) cannot be extended with another incompatible operation.
- `AMCC(μO_j)` denotes the maximum compatible classes associated with an operation in an MIC.

== Algorithm Properties

- For every `MIC_i`, the union of its associated maximum compatible classes covers `μP(μO)`.
- Fewer than `|MIC_i|` compatible classes cannot cover the full operation set.

== Cost Properties

- For a partition into $q$ fields, minimum cost occurs when $q-1$ fields represent one micro-operation each and the last field represents the remaining operations.
- Adding more fields cannot produce a lower cost than a solution with fewer fields.

== Algorithm Steps

+ Find all maximum incompatible classes.
+ Select the largest MIC by cardinality.
+ Find its associated maximum compatible classes.
+ Build a table of operations versus compatible classes.
+ Identify essential classes containing unique operations.
+ Remove essential classes and add them to the solution.
+ Select remaining classes that cover all operations at minimum cost.

== Example Microinstruction Program

#figure(
  block[
    #set text(size: 24pt)
    #table(
    columns: 11,
    align: center,
    table.header([*μI*], [*μO0*], [*μO1*], [*μO2*], [*μO3*], [*μO4*], [*μO5*], [*μO6*], [*μO7*], [*μO8*], [*μO9*]),
    [μI0], [1], [1], [0], [1], [0], [0], [0], [0], [0], [0],
    [μI1], [1], [0], [1], [0], [1], [0], [0], [0], [0], [0],
    [μI2], [0], [1], [0], [0], [0], [1], [0], [1], [1], [0],
    [μI3], [0], [0], [0], [1], [1], [0], [1], [1], [0], [0],
    [μI4], [0], [0], [1], [1], [1], [1], [1], [0], [0], [0],
    [μI5], [0], [0], [0], [0], [0], [1], [0], [0], [1], [1],
    [μI6], [0], [0], [0], [0], [0], [0], [1], [0], [0], [1],
    ),
  ]
)

== Solution: Maximum Incompatible Classes

An operation pair is incompatible if it appears in the same microinstruction. Intersecting rows of the incompatibility matrix yields the maximum incompatible classes.

#figure(
  table(
    columns: 11,
    align: center,
    table.header([*MIC*], [*O0*], [*O1*], [*O2*], [*O3*], [*O4*], [*O5*], [*O6*], [*O7*], [*O8*], [*O9*]),
    [MIC(O0)], [1], [1], [0], [1], [0], [0], [0], [0], [0], [0],
    [MIC(O1)], [1], [0], [1], [1], [1], [0], [0], [0], [0], [0],
    [MIC(O2)], [0], [1], [0], [1], [0], [1], [0], [1], [0], [0],
    [MIC(O3)], [0], [1], [0], [0], [0], [1], [0], [1], [1], [0],
    [MIC(O4)], [0], [0], [1], [1], [1], [1], [1], [0], [0], [0],
    [MIC(O5)], [0], [0], [0], [1], [1], [1], [1], [1], [0], [0],
    [MIC(O6)], [0], [0], [0], [0], [0], [1], [1], [0], [0], [1],
    [MIC(O7)], [0], [0], [0], [0], [0], [1], [0], [0], [1], [1],
  ),
)

== Solution: Maximum Compatible Classes

#figure(
  table(
    columns: 11,
    align: center,
    table.header([*MCC*], [*O0*], [*O1*], [*O2*], [*O3*], [*O4*], [*O5*], [*O6*], [*O7*], [*O8*], [*O9*]),
    [MCC0], [1], [0], [0], [0], [0], [1], [0], [0], [0], [0],
    [MCC1], [1], [0], [0], [0], [0], [0], [1], [0], [1], [0],
    [MCC2], [1], [0], [0], [0], [0], [0], [0], [1], [0], [1],
    [MCC3], [0], [1], [1], [0], [0], [0], [0], [0], [0], [1],
    [MCC4], [0], [1], [0], [0], [1], [0], [0], [0], [0], [1],
    [MCC5], [0], [1], [0], [0], [0], [0], [1], [0], [0], [0],
    [MCC6], [0], [0], [1], [0], [0], [0], [0], [1], [0], [1],
    [MCC7], [0], [0], [1], [0], [0], [0], [0], [0], [1], [0],
    [MCC8], [0], [0], [0], [1], [0], [0], [0], [0], [1], [0],
    [MCC9], [0], [0], [0], [1], [0], [0], [0], [0], [0], [1],
    [MCC10], [0], [0], [0], [0], [1], [0], [0], [0], [1], [0],
  ),
)

== Solution: Essential Compatible Classes

Select essential classes that contain an operation found in no other class. In this example, `S = {MCC_0, MCC_6}`.

#figure(
  table(
    columns: 6,
    align: center,
    table.header([*MCC*], [*O1*], [*O3*], [*O4*], [*O6*], [*O8*]),
    [MCC1], [0], [0], [0], [1], [1],
    [MCC2], [0], [0], [0], [0], [0],
    [MCC4], [1], [0], [1], [0], [0],
    [MCC5], [1], [0], [0], [1], [0],
    [MCC8], [0], [1], [0], [0], [1],
    [MCC9], [0], [1], [0], [0], [0],
    [MCC10], [0], [0], [1], [0], [1],
  ),
)

== Solution: Remaining Compatible Classes

MCC2 and MCC9 contain no unique operations and can be removed. MCC8 is then essential, so `S = {MCC_0, MCC_6, MCC_8}`.

#figure(
  table(
    columns: 6,
    align: center,
    table.header([*MCC*], [*O1*], [*O3*], [*O4*], [*O6*], [*O8*]),
    [MCC1], [0], [0], [0], [1], [1],
    [MCC4], [1], [0], [1], [0], [0],
    [MCC5], [1], [0], [0], [1], [0],
    [MCC8], [0], [1], [0], [0], [1],
    [MCC10], [0], [0], [1], [0], [1],
  ),
)

== Solution: Remaining Compatible Classes

#figure(
  table(
    columns: 4,
    align: center,
    table.header([*MCC*], [*O1*], [*O4*], [*O6*]),
    [MCC1], [0], [0], [1],
    [MCC4], [1], [1], [0],
    [MCC5], [1], [0], [1],
    [MCC10], [0], [1], [0],
  ),
)

Possible additions are {MCC1, MCC4}, {MCC4, MCC5}, or {MCC5, MCC10}.

== Solution: Minimal Microinstruction Coding

#figure(
  table(
    columns: 12,
    align: center,
    table.header([*MCC*], [*O0*], [*O1*], [*O2*], [*O3*], [*O4*], [*O5*], [*O6*], [*O7*], [*O8*], [*O9*], [*Size*]),
    [MCC0], [1], [0], [0], [0], [0], [1], [0], [0], [0], [0], [2],
    [MCC1], [1], [0], [0], [0], [0], [0], [1], [0], [1], [0], [3],
    [MCC4], [0], [1], [0], [0], [1], [0], [0], [0], [0], [1], [3],
    [MCC5], [0], [1], [0], [0], [0], [0], [1], [0], [0], [0], [2],
    [MCC6], [0], [0], [1], [0], [0], [0], [0], [1], [0], [1], [3],
    [MCC8], [0], [0], [0], [1], [0], [0], [0], [0], [1], [0], [2],
    [MCC10], [0], [0], [0], [0], [1], [0], [0], [0], [1], [0], [2],
  ),
)

== Solution: Minimal Microinstruction Coding

- `C(S_0) = 8`
- `C(S_1) = 9`
- `C(S_2) = 9`
- The minimal solution is `S_0 = {MCC_0, MCC_6, MCC_8, MCC_1, MCC_4}`.