#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(4, [Arithmetic Logic Unit (ALU)])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = ALU Structure
  #include "intro.typ"

  = Bitwise Operations
  #include "bitwise.typ"

  = Arithmetic Operations
  #include "number.typ"

  = Comparison Operations
  #include "comparison.typ"

  = Status Flags
  #include "flags.typ"

  = Q&A
  #slide[]
]