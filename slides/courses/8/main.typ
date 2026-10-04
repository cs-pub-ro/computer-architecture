#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(8, [Interrupt Systems])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = Interrupt Systems
  #include "irqs.typ"

  = Implementation
  #include "implementation.typ"

  = Q&A
  #slide[]
]