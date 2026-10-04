#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(0, [Introduction])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = Course Presentation
  #include "objectives.typ"

  = Grading
  #include "grading.typ"

  = Rules
  #include "rules.typ"

  = Q&A
  #slide[]
]