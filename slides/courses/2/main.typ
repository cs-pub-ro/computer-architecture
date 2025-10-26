#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "@preview/cetz:0.3.2"
#import "@preview/fletcher:0.5.5" as fletcher: node, edge
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.3.2": *
#import cosmos.clouds: *
#show: show-theorion

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#show: university-theme.with(
  aspect-ratio: "16-9",
  align: left + top,
  // config-common(handout: true),
  config-common(frozen-counters: (theorem-counter,)),  // freeze theorem counter for animation
  config-info(
    title: [Computer Architecture],
    subtitle: [Course no. 2 - Information Representation],
    author: [Ștefan-Dan Ciocîrlan],
    date: "2025-10-15",
    institution: [National University of Science and Technology POLITEHNICA Bucharest],
    logo: box(
      image("../../media/logoAC.svg", height: 1em), height: 1em
      )
  ),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(outline(title: none, indent: 1em))


= Information Representation

== Systems

  - Decimal
  - Binary
  - Hexadecimal

== Information Representation

#figure(
  table(
    columns: 3,
    align: center,
    table.header([*Decimal*], [*Binary*], [*Hexadecimal*]),
    [0], [0000], [0x0],
    [1], [0001], [0x1],
    [2], [0010], [0x2],
    [3], [0011], [0x3],
    [4], [0100], [0x4],
    [5], [0101], [0x5],
    [6], [0110], [0x6],
    [7], [0111], [0x7],
    [8], [1000], [0x8],
    [9], [1001], [0x9],
    [10], [1010], [0xA],
    [11], [1011], [0xB],
    [12], [1100], [0xC],
    [13], [1101], [0xD],
    [14], [1110], [0xE],
    [15], [1111], [0xF],
  ),
  caption: [Decimal, Binary, and Hexadecimal Values],
)


== Big Endian vs Little Endian
- Big Endian
  - Most significant byte first
  - Network byte order
  - Example: 0x12345678 is stored as 0x12 0x34 0x56 0x78
- Little Endian
  - Least significant byte first
  - Intel byte order
  - Example: 0x12345678 is stored as 0x78 0x56 0x34 0x12


= Textual Representation Systems

== Morse Code

#figure(
  image("./media/International_Morse_Code.png", width: 32%),
  caption: [Morse Code By Rhey T. Snodgrass & Victor F. Camp, 1922, Public Domain #link("https://commons.wikimedia.org/w/index.php?curid=3902977", [Wikipedia])],
)


=== Morse Code - Binary Storage
- Primary:
  - dots $1"'b1"$
  - space $1"'b0"$
- Secondary:
  - dash 3 dots $3"'b111"$
  - space inside letter between dash and dots $1"'b0"$
  - space between letters $3"'b000"$
  - space between words $7"'b0000000"$
=== Morse Code - Binary Tree
  #figure(
    image("./media/Morse_code_tree3.png", width: 90%),
    caption: [Morse Code Binary Tree],
  )


== ASCII
- American Standard Code for Information Interchange
- 7-bit encoding
- 128 characters
- 33 control characters
- 95 printable characters

=== ASCII Table

#figure(
  table(
    columns: 8,
    align: center,
    table.header([*Hex*], [*Char*], [*Hex*], [*Char*], [*Hex*], [*Char*], [*Hex*], [*Char*]),
    [0x00], [NUL], [0x10], [DLE], [0x20], [Space], [0x30], [0],
    [0x01], [SOH], [0x11], [DC1], [0x21], [!], [0x31], [1],
    [0x02], [STX], [0x12], [DC2], [0x22], ["], [0x32], [2],
    [0x03], [ETX], [0x13], [DC3], [0x23], [\#], [0x33], [3],
    [0x04], [EOT], [0x14], [DC4], [0x24], [\$], [0x34], [4],
    [0x05], [ENQ], [0x15], [NAK], [0x25], [%], [0x35], [5],
    [0x06], [ACK], [0x16], [SYN], [0x26], [&], [0x36], [6],
    [0x07], [BEL], [0x17], [ETB], [0x27], ['], [0x37], [7],
    [0x08], [BS], [0x18], [CAN], [0x28], [(], [0x38], [8],
    [0x09], [TAB], [0x19], [EM], [0x29], [)], [0x39], [9],
    [0x0A], [LF], [0x1A], [SUB], [0x2A], [\*], [0x3A], [:],
    [0x0B], [VT], [0x1B], [ESC], [0x2B], [+], [0x3B], [;],
    [0x0C], [FF], [0x1C], [FS], [0x2C], [,], [0x3C], [<],
    [0x0D], [CR], [0x1D], [GS], [0x2D], [-], [0x3D], [=],
    [0x0E], [SO], [0x1E], [RS], [0x2E], [.], [0x3E], [>],
    [0x0F], [SI], [0x1F], [US], [0x2F], [/], [0x3F], [?],
  ),
  caption: [ASCII Table with Characters and Hexadecimal Values],
)


  #figure(
    table(
      columns: 8,
      align: center,
      table.header([*Hex*], [*Char*], [*Hex*], [*Char*], [*Hex*], [*Char*], [*Hex*], [*Char*]),
      [0x40], [\@], [0x50], [P], [0x60], [\`], [0x70], [p],
      [0x41], [A], [0x51], [Q], [0x61], [a], [0x71], [q],
      [0x42], [B], [0x52], [R], [0x62], [b], [0x72], [r],
      [0x43], [C], [0x53], [S], [0x63], [c], [0x73], [s],
      [0x44], [D], [0x54], [T], [0x64], [d], [0x74], [t],
      [0x45], [E], [0x55], [U], [0x65], [e], [0x75], [u],
      [0x46], [F], [0x56], [V], [0x66], [f], [0x76], [v],
      [0x47], [G], [0x57], [W], [0x67], [g], [0x77], [w],
      [0x48], [H], [0x58], [X], [0x68], [h], [0x78], [x],
      [0x49], [I], [0x59], [Y], [0x69], [i], [0x79], [y],
      [0x4A], [J], [0x5A], [Z], [0x6A], [j], [0x7A], [z],
      [0x4B], [K], [0x5B], [\[], [0x6B], [k], [0x7B], [\{],
      [0x4C], [L], [0x5C], [\\], [0x6C], [l], [0x7C], [|],
      [0x4D], [M], [0x5D], [\]], [0x6D], [m], [0x7D], [\}],
      [0x4E], [N], [0x5E], [\^], [0x6E], [n], [0x7E], [\~],
      [0x4F], [O], [0x5F], [\_], [0x6F], [o], [0x7F], [DEL],
    ),
    caption: [ASCII Table with Characters and Hexadecimal Values],
  )


== Unicode

  - 16-bit encoding
  - Contains ASCII

  === Unicode Table

  #figure(
    table(
      columns: 17,
      align: center,
      table.header([*Hex*], [0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [A], [B], [C], [D], [E], [F]),
      [0x0000], [NUL], [SOH], [STX], [ETX], [EOT], [ENQ], [ACK], [BEL], [BS], [TAB], [LF], [VT], [FF], [CR], [SO], [SI],
      [0x0010], [DLE], [DC1], [DC2], [DC3], [DC4], [NAK], [SYN], [ETB], [CAN], [EM], [SUB], [ESC], [FS], [GS], [RS], [US],
      [0x0020], [Space], [!], ["], [\#], [\$], [%], [&], ['], [(], [)], [\*], [+], [,], [-], [.], [/],
      [0x0030], [0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [:], [;], [<], [=], [>], [?],
      [0x0040], [\@], [A], [B], [C], [D], [E], [F], [G], [H], [I], [J], [K], [L], [M], [N], [O],
      [0x0050], [P], [Q], [R], [S], [T], [U], [V], [W], [X], [Y], [Z], [\[], [\\], [\]], [\^], [\_],
      [0x0060], [\`], [a], [b], [c], [d], [e], [f], [g], [h], [i], [j], [k], [l], [m], [n], [o],
      [0x0070], [p], [q], [r], [s], [t], [u], [v], [w], [x], [y], [z], [\{], [|], [\}], [\~], [DEL],
    ),
    caption: [Unicode Table with Characters and Hexadecimal Values],
  )


  === UTF-8
  - Unicode Transformation Format
  - 21-bit encoding
  - Variable-width encoding (1-4 bytes)

  #figure(
    table(
      columns: 3,
      align: center,
      table.header([*Bytes*], [*Binary Format*], [*Range*]),
      [1 byte], [0xxxxxxx], [U+0000 to U+007F],
      [2 bytes], [110xxxxx 10xxxxxx], [U+0080 to U+07FF],
      [3 bytes], [1110xxxx 10xxxxxx 10xxxxxx], [U+0800 to U+FFFF],
      [4 bytes], [11110xxx 10xxxxxx 10xxxxxx 10xxxxxx], [U+10000 to U+10FFFF],
    ),
    caption: [UTF-8 Encoding Scheme],
  )


= Number Representation Systems

== Integer

- Unary: Number of consecutive 1 bits with 0 as the last bit
  $
    B_x = #text(black)[$b_(n-1) b_(n-2) ... b_1 b_0$] \
    b_i = cases(
      1 "if" x >= i+1,
      0 "otherwise"
    )
  $

- Binary: The number representation in base 2
  $
    B_x = #text(black)[$b_(n-1) b_(n-2) ... b_1 b_0$] \
    x = sum_(i=0)^(n-1) b_i times 2^i
  $

- Signed magnitude: The binary number representation system with a sign bit
  $
    B_x = #text(red)[$s$] #text(black)[$b_(n-2) b_(n-3) ... b_1 b_0$] \
    x = (-1)^#text(red)[$s$] times sum_(i=0)^(n-2) b_i times 2^i
  $

- One's complement: The bynary number representation with one's complement
  $
    B_x = #text(red)[$s$] #text(black)[$b_(n-2) b_(n-3) ... b_1 b_0$] \
    x = cases(
      sum_(i=0)^(n-2) b_i times 2^i  "if" #text(red)[$s$] > 0,
      (-1) times sum_(i=0)^(n-2) overline(b_i) times 2^i  "otherwise"
    )
  $
- Two's complement: The binary number representation with two's complement
  $
    B_x = #text(red)[$s$] #text(black)[$b_(n-2) b_(n-3) ... b_1 b_0$] \
    x = cases(
      sum_(i=0)^(n-2) b_i times 2^i "if" #text(red)[$s$] > 0,
      (-1) times ((sum_(i=0)^(n-2) overline(b_i) times 2^i) + 1) "otherwise"
    )
  $
- Bias ($beta$): The binary number representation with bias
  $
    B_x = #text(black)[$b_(n-1) b_(n-2) ... b_1 b_0$] \
    beta = 2^(n-1) - 1 \
    x = (sum_(i=0)^(n-1) b_i times 2^i) - beta
  $
- Unary negative:
  $
    B_x = #text(black)[$b_(n-1) b_(n-2) ... b_1 b_0$] \
    b_i = cases(
      1 "if" (x >= i and x >= 0) "or" (|x| <= i and x < 0),
      0 "otherwise"
    )
  $

== Rational Numbers
- Fractional: Fractional numbers as $Q("ns", "ds")$, where $"ns"$ is the numerator size and $"ds"$ is the denominator size.
  $
    B_x = #text(red)[$s$] #text(black)[$n_("ns"-2) n_("ns"-3) ... n_1 n_0$] #text(orange)[$d_("ds"-1) d_("ds"-2) ... d_1 d_0$] \
    x = (-1)^#text(red)[$s$] times frac(sum_(i=0)^("ns"-2) n_i times 2^i, #text(orange)[$sum_(i=0)^("ds"-1) d_i times 2^i$])
  $

- Fixed Point: Fixed point numbers as $"FP"("is", "fs")$, where $"is"$ is the integer part size and $"fs"$ is the fractional part size.
  $
    B_x = #text(red)[$s$] #text(black)[$i_("is"-2) i_("is"-3) ... i_1 i_0$] #text(orange)[$f_("fs"-1) f_("fs"-2) ... f_1 f_0$] \
    x = cases(
      (sum_(j=0)^("is"-2) i_j times 2^j) + #text(orange)[$(sum_(j=0)^("fs"-1) f_j times 2^(j-"fs"))$] "if" #text(red)[$s$] > 0,
      (-1) times ((sum_(j=0)^("is"-2) overline(i_j) times 2^j) + #text(orange)[$(sum_(j=0)^("fs"-1) overline(f_j) times 2^(j-"fs"))$] + frac(1, #text(orange)[$2^"fs"$])) "otherwise"
    )
  $
- Floating Point: Simple floating point numbers as $"FloatP"("es", "fs")$, where $"es"$ is the exponent size and $"fs"$ is the fractional part size (mantissa).
  $ x = (-1)^"sign" times 2^"exponent" times 1."mantissa" $ 

  $
    B_x = #text(red)[$s$] #text(green)[$e_("es"-1) e_("es"-2) ... e_1 e_0$] #text(orange)[$m_("fs"-1) m_("fs"-2) ... m_1 m_0$] \
    beta = 2^("es"-1) - 1 \
    e = #text(green)[$(sum_(i=0)^("es"-1) e_i times 2^i)$] - beta \
    x = (-1)^#text(red)[$s$] times cases(
      0 "if" (forall i<"es" e_i = 0 and forall i<"fs" m_i = 0),
      2^(#text(green)[$e$]) times (1 + #text(orange)[$(frac(sum_(i=0)^("fs"-1) m_i times 2^i, 2^"fs"))$]) "otherwise"
    )
  $

=== IEEE754 Floating Point
IEEE754 Floating Point: IEEE754 floating point numbers as $"IEEE754"("es", "fs")$, where $"es"$ is the exponent size and $"fs"$ is the fractional part size (mantissa).
  $
    B_x = #text(red)[$s$] #text(green)[$e_("es"-1) e_("es"-2) ... e_1 e_0$] #text(orange)[$m_("fs"-1) m_("fs"-2) ... m_1 m_0$] \
    beta = 2^("es"-1) - 1 \
    e = #text(green)[$(sum_(i=0)^("es"-1) e_i times 2^i)$] - beta 
  $
  #set math.cases(gap: .5em)
  $
    x = (-1)^#text(red)[$s$] times cases(
      0 "if" (forall i<"es" e_i = 0 and forall i<"fs" m_i = 0),
      2^(#text(green)[$e$] + 1) times #text(orange)[$(frac(sum_(i=0)^("fs"-1) m_i times 2^i, 2^"fs"))$] "if" (forall i<"es" e_i = 0 and exists i<"fs" m_i != 0),
      infinity "if" (forall i<"es" e_i = 1 and forall i<"fs" m_i = 0),
      "sNaN" "if" (forall i<"es" e_i = 1 and m_("fs"-1) = 0 and exists i<"fs"-1 space m_i != 0),
      "qNaN" "if" (forall i<"es" e_i = 1 and m_("fs"-1) = 1),
      2^(#text(green)[$e$]) times (1 + #text(orange)[$(frac(sum_(i=0)^("fs"-1) m_i times 2^i, 2^"fs"))$]) "otherwise"
    )
  $


// #slide[
//   == Morris Floating Point
// ]

// #slide[
//   == Posit
//   $Posit(size, es)$ is given by $size$ and exponent size ($es$).
//   $
//     "Binary"_x = color(red)(s) color(black)(b_(size-2) b_(size-3) ... b_1 b_0)\
//     "AbsoluteBits"_x = cases(
//       overline("Binary"_x) + 1\, & "if" color(red)("sign") "negative",
//       "Binary"_x\, & "otherwise"
//     )\
//     "AbsoluteBits"_x = color(red)(0) color(blue)(r_0 r_1 ... r_(rs-2) overline(r_(rs-1))) color(forestgreen)(e_(es-1) e_(es-2) ... e_1 e_0) color(orange)(m_(fs-1) m_(fs-2) ... m_1 m_0)\
//     k = cases(
//       color(blue)(rs) - 2\, & "if" color(blue)(r_0 = 1),
//       -(color(blue)(rs) - 1)\, & "otherwise"
//     )\
//     e = color(blue)(k) times 2^es + color(forestgreen)(sum_(i=0)^(es-1) e_i times 2^i)\
//     x = (-1)^color(red)(s) times cases(
//       0\, & "all bits of Binary"_x "0",
//       NaR\, & "first bit 1 and the rest 0 for Binary"_x,
//       2^color(forestgreen)(e) times (1 + color(orange)(frac(sum_(i=0)^(fs-1) m_i times 2^i, 2^fs)))\, & "otherwise"
//     )
//   $
// ]


= Theorems

== Prime numbers

#definition[
  A natural number is called a #highlight[_prime number_] if it is greater
  than 1 and cannot be written as the product of two smaller natural numbers.
]
#example[
  The numbers $2$, $3$, and $17$ are prime.
  @cor_largest_prime shows that this list is not exhaustive!
]

#theorem(title: "Euclid")[
  There are infinitely many primes.
]
#pagebreak(weak: true)
#proof[
  Suppose to the contrary that $p_1, p_2, dots, p_n$ is a finite enumeration
  of all primes. Set $P = p_1 p_2 dots p_n$. Since $P + 1$ is not in our list,
  it cannot be prime. Thus, some prime factor $p_j$ divides $P + 1$. Since
  $p_j$ also divides $P$, it must divide the difference $(P + 1) - P = 1$, a
  contradiction.
]

#corollary[
  There is no largest prime number.
] <cor_largest_prime>
#corollary[
  There are infinitely many composite numbers.
]

#theorem[
  There are arbitrarily long stretches of composite numbers.
]

#proof[
  For any $n > 2$, consider $
    n! + 2, quad n! + 3, quad ..., quad n! + n
  $
]


= Others

== Side-by-side

#slide(composer: (1fr, 1fr))[
  First column.
][
  Second column.
]


== Multiple Pages

#lorem(200)


#show: appendix

= Appendix

== Appendix

Please pay attention to the current slide number.