#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "@preview/cetz:0.3.2"
#import "@preview/fletcher:0.5.5" as fletcher: node, edge
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.3.2": *
#import cosmos.clouds: *
#import "config.typ": *

#let cetz-canvas = touying-reducer.with(
  reduce: cetz.canvas,
  cover: cetz.draw.hide.with(bounds: true),
)
#let fletcher-diagram = touying-reducer.with(
  reduce: fletcher.diagram,
  cover: fletcher.hide,
)

#let course-theme(number, title, body, date: academic-year) = {
  show: show-theorion
  show: university-theme.with(
    aspect-ratio: "16-9",
    align: left + top,
    header-right: self => self.info.logo,
    config-common(
      frozen-counters: (theorem-counter,),
    ),
    config-info(
      title: [#course-title],
      subtitle: [Course no. #number - #title],
      author: [#lecturer],
      date: date,
      institution: [
        #align(center)[
          #grid(
            columns: (1fr,),
            row-gutter: 0.5cm,
            align: (center,),
            grid(
              columns: (2cm, 2cm, 4cm),
              column-gutter: 0.5cm,
              align: (center + horizon, center + horizon),
              image(university-logo, height: 2cm, fit: "contain"),
              image(faculty-logo, height: 2cm, fit: "contain"),
              image(current-department.logo, width: 4cm, fit: "contain"),
            ),
            align(center + horizon)[
              #set par(leading: 0.4em, spacing: 0em)
              #text(size: 10pt, weight: "bold")[#current-department.name] \
              #text(size: 10pt, weight: "bold")[#faculty-name] \
              #text(size: 10pt, weight: "bold")[#university-name]
            ],
          )
        ]
      ],
      logo: box(
        image(header-logo, height: 1em),
        height: 1em,
      ),
    ),
  )
  set heading(numbering: numbly("{1}.", default: "1.1"))
  set text(size: text-size)
  body
}

#let ascii-figure(src, font-size: 0.6em, width: 100%) = {
  let ascii-source = src.split("\n")
    .map(line => line.replace(regex(" +$"), ""))
    .join("\n")
    .replace(regex("\\n+$"), "")

  align(center)[
    #set text(font: "DejaVu Sans Mono", size: font-size)
    #utils.fit-to-width(
      width,
      raw(ascii-source, block: true),
      grow: false,
    )
  ]
}