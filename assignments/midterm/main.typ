#import "../../labs/common/template.typ": handout-document

#show heading.where(level: 2): set heading(numbering: none, outlined: false)
#show heading.where(level: 3): set heading(numbering: none, outlined: false)
#show heading.where(level: 4): set heading(numbering: none, outlined: false)
#show: handout-document.with([AB Midterm Model: Worked Solutions], lang: "en")

= ALU Operations (4-bit)
#include "alu_result/sol.typ"

= ALU Operations with Registers
#include "alu_reg_flow/sol.typ"

= Moore Finite State Machine
#include "moore_fsm/sol.typ"

= Truth Table to Gate Name
#include "gate_table/sol.typ"

= Truth Table Output Identification
#include "table_output/sol.typ"