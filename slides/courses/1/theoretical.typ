#import "../../common/template.typ": ascii-figure

== Regular Expressions and Combinational Logic

#ascii-figure(read("media/regular.ascii"))

- Regular expression: #raw("O = [a-zA-Z0-9]+")
- Combinational logic: $O = i_0 ⊕ i_1$
- Requires the complete input to produce an output

== Finite State Machine

#ascii-figure(read("media/fsm.ascii"))

- Has an internal state that can change
- Cannot access previous inputs

== Pushdown Automaton

#ascii-figure(read("media/stackfsm.ascii"))

- Has a stack for storing and accessing inputs again
- The stack is limited; an input that has been read, stored, and used cannot be used again

== Turing Machine Model

#ascii-figure(read("media/turing.ascii"))

- Has an infinite tape and can access previous inputs and outputs again