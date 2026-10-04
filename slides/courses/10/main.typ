#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(10, [Summer Practice, Bachelor's Degree and Mobility])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = Summer Practice
  #include "practice.typ"

  = Bachelor's Degree
  #include "bachelor.typ"

  = Mobility Programs
  #include "mobility.typ"

  = Q&A
  #slide[]
]