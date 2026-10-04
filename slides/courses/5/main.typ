#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(5, [CPU Architecture])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = CPU Components
  #include "components.typ"

  = Architecture
  #include "architecture.typ"

  = Instruction Set Architecture (ISA)
  #include "isa.typ"

  = Instruction Coding
  #include "format.typ"

  = Memory Addressing
  #include "memory.typ"

  = Execution
  #include "execution.typ"

  = Q&A
  #slide[]
]