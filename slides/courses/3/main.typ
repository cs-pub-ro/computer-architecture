#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(3, [Memory])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = Memory Hierarchy
  #include "hierarchy.typ"

  = Cache Memory
  #include "cache.typ"

  = Virtual Memory
  #include "virtual.typ"

  = Q&A
  #slide[]
]