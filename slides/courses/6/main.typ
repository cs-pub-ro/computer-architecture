#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(6, [Programming Languages])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = Assembly Language
  #include "assembly.typ"

  = Compilation
  #include "compilation.typ"

  = Q&A
  #slide[]
]