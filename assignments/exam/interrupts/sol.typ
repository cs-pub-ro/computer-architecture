== Problem

Given the interrupt requests, request times, and service times below, determine the order in which the CPU completes the interrupts.

#figure(
  table(
    columns: 3,
    table.header([*Address*], [*Name*], [*Type*]),
    [0x0], [Reserved], [Internal interrupt],
    [0x1], [Software interrupt (INT)], [Internal interrupt],
    [0x2], [ALU overflow], [Internal interrupt],
    [0x3], [Loss of voltage (power off)], [External non-maskable interrupt],
    [0x4], [Level 0], [External maskable interrupt],
    [0x5], [Level 1], [External maskable interrupt],
    [0x6], [Level 2], [External maskable interrupt],
    [0x7], [Level 3], [External maskable interrupt],
    [0x8], [Level 4], [External maskable interrupt],
    [0x9], [Level 5], [External maskable interrupt],
    [0xA], [Level 6], [External maskable interrupt],
    [0xB], [Level 7], [External maskable interrupt],
  ),
  caption: [Interrupts],
)

Registers at time 0:

#figure(
  table(
    columns: 4,
    [*REQINT*], [*MEXTINT*], [*RUNINT*], [*FR*],
    [0x00], [0x00], [0x00], [I flag enabled],
  ),
  caption: [Initial register values],
)

Interrupt service times:

#figure(
  table(
    columns: 2,
    table.header([*Request type*], [*Service cycles*]),
    [External maskable interrupt, level 0], [30],
    [External maskable interrupt, level 1], [20],
    [External maskable interrupt, level 2], [10],
    [External maskable interrupt, level 3], [40],
    [External maskable interrupt, level 4], [20],
    [External maskable interrupt, level 5], [30],
    [External maskable interrupt, level 6], [10],
    [External maskable interrupt, level 7], [20],
    [External non-maskable interrupt], [5],
    [ALU overflow], [10],
    [Software interrupt], [10],
  ),
  caption: [Service time for each interrupt type],
)

Request times:

#figure(
  table(
    columns: 3,
    table.header([*Cycles from time 0*], [*Request type*], [*Name*]),
    [10], [External maskable interrupt, level 5], [A],
    [30], [External maskable interrupt, level 3], [B],
    [50], [External maskable interrupt, level 7], [C],
    [60], [External maskable interrupt, level 1], [D],
    [100], [External non-maskable interrupt], [E],
    [140], [ALU overflow], [F],
    [150], [Software interrupt], [G],
  ),
  caption: [Interrupt request times],
)

== Solution

External maskable interrupts are enabled. The scheduling proceeds as follows:

- Cycle 10: No interrupt is active; external maskable level 5, A, begins.
- Cycle 30: A has run for 20 of 30 cycles. Higher-priority level 3, B, preempts it.
- Cycle 50: B has run for 20 of 40 cycles. Lower-priority level 7, C, is queued.
- Cycle 60: B has run for 30 of 40 cycles. Higher-priority level 1, D, preempts it.
- Cycle 80: D finishes after 20 cycles; B resumes with 10 cycles remaining.
- Cycle 90: B finishes; A resumes with 10 cycles remaining.
- Cycle 100: A finishes. Non-maskable interrupt E takes priority over queued C.
- Cycle 105: E finishes; C begins.
- Cycle 125: C finishes.
- Cycle 140: ALU overflow F begins.
- Cycle 150: F finishes; software interrupt G begins.
- Cycle 160: G finishes.

The source solution gives the completion order as D, B, A, E, C, F, G. If $X = 3$, the third completed interrupt is A.

#table(
  columns: 8,
  table.header([*Cycle*], [*A*], [*B*], [*C*], [*D*], [*E*], [*F*], [*G*]),
  [10], [A], [], [], [], [], [], [],
  [30], [P1], [A], [], [], [], [], [],
  [50], [P1], [A], [Q1], [], [], [], [],
  [60], [P2], [P1], [Q1], [A], [], [], [],
  [80], [P1], [A], [Q1], [F], [], [], [],
  [90], [A], [F], [Q1], [F], [], [], [],
  [100], [F], [F], [Q1], [F], [A], [], [],
  [105], [F], [F], [A], [F], [F], [], [],
  [125], [F], [F], [F], [F], [F], [], [],
  [140], [F], [F], [F], [F], [F], [A], [],
  [150], [F], [F], [F], [F], [F], [F], [A],
  [160], [F], [F], [F], [F], [F], [F], [F],
)