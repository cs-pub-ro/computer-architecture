#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "../../common/template.typ": course-theme

#course-theme(7, [Input/Output Systems])[
  #title-slide()

  == Outline <touying:hidden>
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))

  = I/O System Overview
  #include "intro.typ"

  = Data Transfer Methods
  #include "types.typ"

  = I/O Implementation
  #include "implementation.typ"

  = UART
  #include "uart.typ"

  = Q&A
  #slide[]
]