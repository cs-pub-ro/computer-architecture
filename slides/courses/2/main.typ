#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(2, [Information Representation])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = Information Representation
  #include "intro.typ"

  = Textual Representation Systems
  #include "text.typ"

  = Number Representation Systems
  #include "number.typ"

  = Q&A
  #slide[]
]