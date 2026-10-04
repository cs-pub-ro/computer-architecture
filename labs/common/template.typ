#import "config.typ": *

#let callout(kind: "note", body) = block(
  width: 100%,
  breakable: true,
  inset: 10pt,
  stroke: (left: 2pt + rgb("#2e74b5")),
  fill: rgb("#f1f5f8"),
  [
    #strong(if kind == "important" { "Important" } else if kind == "info" { "Informație" } else { "Notă" })
    #parbreak()
    #body
  ],
)

#let handout-document(title, body, lang: language) = {
  set document(title: title, author: lecturer)
  set page(
    paper: "a4",
    margin: (left: 2.5cm, right: 2cm, top: 2cm, bottom: 2cm),
    numbering: "1",
    number-align: right,
  )
  set text(font: body-font, size: 12pt, lang: lang)
  set par(justify: true, leading: 0.65em, spacing: 0.8em)
  set heading(numbering: "1.1.")
  show heading: set par(justify: false)
  show heading.where(level: 1): set text(size: 20pt, weight: "bold")
  show heading.where(level: 2): set text(size: 16pt, weight: "bold")
  show heading.where(level: 3): set text(size: 14pt, weight: "bold")
  set figure(gap: 0.4em)
  let figure-label = if lang == "en" { [Figure] } else { [Figura] }
  let table-label = if lang == "en" { [Table] } else { [Tabelul] }
  show figure.where(kind: image): set figure(supplement: figure-label)
  show figure.where(kind: table): set figure(supplement: table-label)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set block(breakable: true)
  show figure.caption: set text(style: "italic", size: 10pt)
  set table(inset: 5pt, stroke: 0.5pt + gray)
  set raw(tab-size: 4)
  show raw: set text(font: code-font, size: 9pt)
  show raw.where(block: true): it => context layout(size => {
    let line-width = calc.max(..it.text.split("\n").map(line =>
      measure(text(font: code-font, size: 9pt, line.replace("\t", "    "))).width
    ))
    set text(size: calc.min(9pt, 9pt * (size.width / calc.max(1pt, line-width))))
    block(width: 100%, breakable: true, it)
  })

  let current-university = if lang == "en" { university-name-en } else { university-name }
  let current-faculty = if lang == "en" { faculty-name-en } else { faculty-name }
  let current-department = if lang == "en" { department-name-en } else { department-name }

  grid(
    columns: (auto, 1fr, auto),
    align: center + horizon,
    column-gutter: 1cm,
    university-logo,
    faculty-logo,
    department-logo,
  )
  align(center)[
    #set par(justify: false, spacing: 0.3em)
    #text(size: 10pt)[#current-university \ #current-faculty \ #current-department]
    #v(0.5em)
    #text(size: 18pt, weight: "bold")[#course-title]
    #parbreak()
    #text(size: 16pt, weight: "bold")[#title]
    #parbreak()
    #text(size: 10pt)[#lecturer · #academic-year]
  ]
  outline(title: if lang == "en" { [Contents] } else { [Cuprins] }, depth: 2, indent: 1em)
  v(1em)
  body
}

#let lab-document(number, title, body) = handout-document(
  [Laborator #number: #title],
  body,
)