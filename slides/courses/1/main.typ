#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(1, [Digital Computer Structure])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = The Computer: An Information Processing System
  #include "intro.typ"

  = Theoretical Model of the Digital Computer
  #include "theoretical.typ"

  = Structural Model of the Digital Computer
  #include "structural.typ"

  = Functional Model of the Digital Computer
  #include "functional.typ"

  = Functional Units of the Digital Computer
  #include "components.typ"

  = Q&A
  #slide[]
]