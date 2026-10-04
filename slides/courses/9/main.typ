#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(9, [Microcoded CPU])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = Microcoded Concepts
  #include "basic.typ"

  = Implementation
  #include "implementation.typ"

  = Minimal Microinstruction Coding
  #include "minimal.typ"

  = Q&A
  #slide[]
]