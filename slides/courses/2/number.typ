#import "@preview/touying:0.6.1": speaker-note

#let brown = rgb("#8B4513")

== Unary

Number of consecutive 1 bits, terminated by a 0 bit.

$
  B_x = b_(n-1) b_(n-2) dots b_1 b_0 \
  b_i = cases(1 "if" x >= i + 1, 0 "otherwise")
$

== Binary

The number representation in base 2.

$
  B_x = b_(n-1) b_(n-2) dots b_1 b_0 \
  x = sum_(i=0)^(n-1) b_i times 2^i
$

== Sign Magnitude

A binary number representation system with a sign bit.

$
  B_x = #text(fill: red)[$s$] b_(n-2) b_(n-3) dots b_1 b_0 \
  x = (-1)^#text(fill: red)[$s$] times sum_(i=0)^(n-2) b_i times 2^i
$

== One's Complement

A binary number representation using one's complement.

$
  B_x = #text(fill: red)[$s$] b_(n-2) b_(n-3) dots b_1 b_0 \
  x = cases(
    sum_(i=0)^(n-2) b_i times 2^i "if" #text(fill: red)[$"sign"$] "is positive",
    (-1) times sum_(i=0)^(n-2) overline(b_i) times 2^i "otherwise"
  )
$

== Two's Complement

A binary number representation using two's complement.

$
  B_x = #text(fill: red)[$s$] b_(n-2) b_(n-3) dots b_1 b_0 \
  x = cases(
    sum_(i=0)^(n-2) b_i times 2^i "if" #text(fill: red)[$"sign"$] "is positive",
    (-1) times ((sum_(i=0)^(n-2) overline(b_i) times 2^i) + 1) "otherwise"
  )
$

== Bias

The binary number representation with a bias.

$
  B_x = b_(n-1) b_(n-2) dots b_1 b_0 \
  "bias" = 2^(n-1) - 1 \
  x = sum_(i=0)^(n-1) b_i times 2^i - "bias"
$

== Unary Negative

$
  B_x = b_(n-1) b_(n-2) dots b_1 b_0 \
  b_i = cases(
    1 "if" (x >= i and x >= 0) or (abs(x) <= i and x < 0),
    0 "otherwise"
  )
$

== Fractional

Fractional numbers are written as $"Q"(#text(fill: purple)[$"ns"$], #text(fill: purple)[$"ds"$])$, where #text(fill: purple)[$"ns"$] is the numerator size and #text(fill: purple)[$"ds"$] is the denominator size.

$
  B_x = #text(fill: red)[$s$] n_(#text(fill: purple)[$"ns"$]-2) n_(#text(fill: purple)[$"ns"$]-3) dots n_1 n_0 d_(#text(fill: purple)[$"ds"$]-1) d_(#text(fill: purple)[$"ds"$]-2) dots d_1 d_0 \
  x = (-1)^#text(fill: red)[$s$] times frac(sum_(i=0)^(#text(fill: purple)[$"ns"$]-2) n_i times 2^i, sum_(i=0)^(#text(fill: purple)[$"ds"$]-1) d_i times 2^i)
$

== Fractional

== Fixed Point

Fixed-point numbers are written as $"FP"(#text(fill: purple)[$"is"$], #text(fill: purple)[$"fs"$])$, where #text(fill: purple)[$"is"$] is the integer-part size and #text(fill: purple)[$"fs"$] is the fractional-part size.

$
  B_x = #text(fill: red)[$s$] i_(#text(fill: purple)[$"is"$]-2) i_(#text(fill: purple)[$"is"$]-3) dots i_1 i_0 f_(#text(fill: purple)[$"fs"$]-1) f_(#text(fill: purple)[$"fs"$]-2) dots f_1 f_0 \
  x = cases(
    sum_(j=0)^(#text(fill: purple)[$"is"$]-2) i_j times 2^j + sum_(j=0)^(#text(fill: purple)[$"fs"$]-1) f_j times 2^(j-#text(fill: purple)[$"fs"$]) "if" #text(fill: red)[$"sign"$] "is positive",
    (-1) times (sum_(j=0)^(#text(fill: purple)[$"is"$]-2) overline(i_j) times 2^j + sum_(j=0)^(#text(fill: purple)[$"fs"$]-1) overline(f_j) times 2^(j-#text(fill: purple)[$"fs"$]) + frac(1, 2^#text(fill: purple)[$"fs"$])) "otherwise"
  )
$

== Simple Floating Point

Simple floating-point numbers are written as $"FloatP"(#text(fill: purple)[$"es"$], #text(fill: purple)[$"fs"$])$, where #text(fill: purple)[$"es"$] is the exponent size and #text(fill: purple)[$"fs"$] is the fraction size (mantissa).

$ x = (-1)^#text(fill: red)[$"sign"$] times 2^#text(fill: green)[$"exponent"$] times 1."fraction" $

$
  B_x = #text(fill: red)[$s$] #text(fill: green)[$e_("es"-1) e_("es"-2) dots e_1 e_0$] m_(#text(fill: purple)[$"fs"$]-1) m_(#text(fill: purple)[$"fs"$]-2) dots m_1 m_0 \
  "bias" = 2^(#text(fill: purple)[$"es"$]-1) - 1 \
  #text(fill: green)[$e$] = sum_(i=0)^(#text(fill: purple)[$"es"$]-1) #text(fill: green)[$e_i$] times 2^i - "bias" \
  x = (-1)^#text(fill: red)[$s$] times cases(
    0 "if all" e_i = 0 "and all" m_i = 0,
    2^#text(fill: green)[$e$] times (1 + frac(sum_(i=0)^(#text(fill: purple)[$"fs"$]-1) m_i times 2^i, 2^#text(fill: purple)[$"fs"$])) "otherwise"
  )
$

== IEEE 754 Floating Point

IEEE 754 floating-point numbers are written as $"IEEE754"(#text(fill: purple)[$"es"$], #text(fill: purple)[$"fs"$])$, where #text(fill: purple)[$"es"$] is the exponent size and #text(fill: purple)[$"fs"$] is the fraction size (mantissa).

$
  x = (-1)^#text(fill: red)[$s$] times cases(
    0 "if all" #text(fill: green)[$e_i$] = 0 "and all" m_i = 0,
    2^(#text(fill: green)[$e$]+1) times frac(sum_(i=0)^(#text(fill: purple)[$"fs"$]-1) m_i times 2^i, 2^#text(fill: purple)[$"fs"$]) "if all" #text(fill: green)[$e_i$] = 0 "and some" m_i != 0,
    infinity "if all" #text(fill: green)[$e_i$] = 1 "and all" m_i = 0,
    #text(fill: brown)[$"sNaN"$] "if all" #text(fill: green)[$e_i$] = 1 "and" m_(#text(fill: purple)[$"fs"$]-1) = 0 "and some lower fraction bit is 1",
    #text(fill: brown)[$"qNaN"$] "if all" #text(fill: green)[$e_i$] = 1 "and" m_(#text(fill: purple)[$"fs"$]-1) = 1,
    2^#text(fill: green)[$e$] times (1 + frac(sum_(i=0)^(#text(fill: purple)[$"fs"$]-1) m_i times 2^i, 2^#text(fill: purple)[$"fs"$])) "otherwise"
  )
$

== Morris Floating Point

The Morris floating-point representation uses $"Morris"(#text(fill: purple)[$"s"$], #text(fill: purple)[$"g"$])$, where #text(fill: purple)[$"s"$] is the size and #text(fill: purple)[$"g"$] is the exponent-size field.

$
  B_x = G_(#text(fill: purple)[$g$]-1) G_(#text(fill: purple)[$g$]-2) dots G_1 G_0 #text(fill: red)[$s_e$] #text(fill: green)[$e_("es"-1) e_("es"-2) dots e_1 e_0$] #text(fill: red)[$s_f$] m_(#text(fill: purple)[$"fs"$]-1) m_(#text(fill: purple)[$"fs"$]-2) dots m_1 m_0 \
  G = sum_(i=0)^(#text(fill: purple)[$g$]-1) G_i times 2^i \
  #text(fill: purple)[$"es"$] = G + 1 \
  #text(fill: green)[$e$] = (-1)^(#text(fill: red)[$s_e$]) times sum_(i=0)^(#text(fill: purple)[$"es"$]-1) #text(fill: green)[$e_i$] times 2^i \
  x = (-1)^(#text(fill: red)[$s_f$]) times cases(
    0 "if all bits are 0",
    #text(fill: brown)[$"NR"$] "if all bits are 1",
    2^#text(fill: green)[$e$] times (1 + frac(sum_(i=0)^(#text(fill: purple)[$"fs"$]-1) m_i times 2^i, 2^#text(fill: purple)[$"fs"$])) "otherwise"
  )
$

#speaker-note[
  The first #text(fill: purple)[$g$] bits represent $G$, which determines the exponent size #text(fill: purple)[$"es"$] = G + 1. The next bit is the #text(fill: red)[exponent sign], followed by the #text(fill: green)[exponent magnitude]. The fraction has its own #text(fill: red)[sign] bit and fraction bits. The value is $2^#text(fill: green)[$"exponent"$] times (-1)^#text(fill: red)[$"fraction sign"$] times (1 + frac(f, 2^#text(fill: purple)[$"fs"$]))$. Zero is represented by all zero bits; error cases use all one bits.
]

== Posit

The $"Posit"(#text(fill: purple)[$"size"$], #text(fill: purple)[$"es"$])$ format is determined by its total size and exponent-size parameter #text(fill: purple)[$"es"$].

$
  B_x = #text(fill: red)[$s$] b_(#text(fill: purple)[$"size"$]-2) b_(#text(fill: purple)[$"size"$]-3) dots b_1 b_0 \
  "AbsoluteBits"_x = cases(overline(B_x) + 1 "if negative", B_x "otherwise") \
  #text(fill: green)[$e$] = k times 2^#text(fill: purple)[$"es"$] + sum_(i=0)^(#text(fill: purple)[$"es"$]-1) #text(fill: green)[$e_i$] times 2^i \
  x = (-1)^#text(fill: red)[$s$] times cases(
    0 "if all bits are 0",
    #text(fill: brown)[$"NaR"$] "if the first bit is 1 and the rest are 0",
    2^#text(fill: green)[$e$] times (1 + frac(sum_(i=0)^(#text(fill: purple)[$"fs"$]-1) m_i times 2^i, 2^#text(fill: purple)[$"fs"$])) "otherwise"
  )
$

== Until Now

#figure(
  block[
    #set text(size: 11pt)
    #table(
    columns: 5,
    align: (left, left, left, left, left),
    table.header([*Set*], [*Representation*], [*Precision*], [*Interpretation*], [*Example*]),
    [$NN$], [Unary], [IP], [$NN$], [11111],
    [$NN$], [Base 2], [IP], [$NN$], [101],
    [$ZZ$], [Sign magnitude], [IP], [$ZZ$], [0101 / 1101],
    [$ZZ$], [One's complement], [IP], [$ZZ$], [0101 / 1010],
    [$ZZ$], [Two's complement], [IP], [$ZZ$], [0101 / 1011],
    [$ZZ$], [Bias], [IP], [$y - "bias"$], [1111],
    [$QQ$], [Fractional], [IP], [$QQ$], [0101/1],
    [$QQ$], [Fixed point], [IP], [$x / 2^y$], [0101.000],
    [$RR$], [Floating point], [IP], [$x times 2^y$], [010.010],
    [$RR$], [IEEE 754], [IP], [Exponent and fraction fields], [01001010],
    [$RR$], [Morris], [IP], [Variable exponent field], [0101001],
    [$RR$], [Posit], [IP], [Regime, exponent, and fraction], [0101100],
  ),
  ],
  caption: [Overview of Number Representation Systems],
)

== Hidden Exponent Bit

- Morris hidden exponent bit:

  $#text(fill: red)[$s_f$] #text(fill: purple)[$G_("g"-1) G_("g"-2)$] dots #text(fill: red)[$s_e$] #text(fill: green)[$e_("es"-1) e_("es"-2)$] dots e_0 f_(#text(fill: purple)[$"fs"$]-1) f_(#text(fill: purple)[$"fs"$]-2) dots f_0$
- Morris hidden exponent bit with bias $G$:

  $#text(fill: red)[$s$] #text(fill: purple)[$G_("g"-1) G_("g"-2)$] dots #text(fill: green)[$e_("es"-1) e_("es"-2)$] dots e_0 f_(#text(fill: purple)[$"fs"$]-1) f_(#text(fill: purple)[$"fs"$]-2) dots f_0$
- Morris hidden exponent bit with unary $G$:

  $#text(fill: red)[$s$] r_0 r_1 dots r_(#text(fill: purple)[$"rs"$]-2) overline(r_(#text(fill: purple)[$"rs"$]-1)) #text(fill: green)[$e_("es"-1) e_("es"-2)$] dots e_0 f_(#text(fill: purple)[$"fs"$]-1) f_(#text(fill: purple)[$"fs"$]-2) dots f_0$

== Morris Hidden Exponent Bit

The main problem with Morris floating-point numbers is that the same number can have multiple representations. One solution borrows the hidden bit concept from the mantissa. The $g$ field represents $G$ and indicates the position of the most significant set bit in the exponent. If the exponent size is $G + 1$, its minimum absolute value is 2 when $G = 0$.

== Morris Hidden Exponent Bit

$ #text(fill: purple)[$"es"$] = G - 1 $

$
  "exponent" = cases(
    (-1)^#text(fill: red)[$"exponent sign"$] times (2^#text(fill: purple)[$"es"$] + #text(fill: green)[$"binary exponent"$]) "if" #text(fill: purple)[$"es"$] != -1,
    0 "if" #text(fill: purple)[$"es"$] = -1
  )
$

$
  "value" = cases(
    0 "if all bits are 0",
    "NR" "if the first bit is 1 and the rest are 0",
    (-1)^#text(fill: red)[$s$] times 2^#text(fill: green)[$"exponent"$] times (1 + frac(f, 2^#text(fill: purple)[$"fs"$])) "otherwise"
  )
$

== Morris Hidden Exponent Bit with Bias G

The exponent can still have multiple values when $"es" = -1$, because the exponent sign does not matter. A bias value $g$ solves the sign issue: the sign of $G$ becomes the exponent sign and $"es" = abs(G) - 1$. Negating the exponent bits when $G$ is negative also makes binary comparison easier to implement in hardware.

== Morris Hidden Exponent Bit with Bias G

$ "bias" = 2^(#text(fill: purple)[$g$]-1) - 1, quad G = #text(fill: green)[$"binary G"$] - "bias", quad #text(fill: purple)[$"es"$] = abs(G) - 1 $

$
  #text(fill: green)[$"exponent"$] = cases(
  "signum"(G) times (2^#text(fill: purple)[$"es"$] + #text(fill: green)[$"binary exponent"$]) "if" #text(fill: purple)[$"es"$] != -1,
  0 "if" #text(fill: purple)[$"es"$] = -1
  )
$

== Morris Hidden Exponent Bit with Unary G

$
  #text(fill: green)[$"exponent size"$] = cases(-k - 1 "if" k < 0, k - 1 "if" k >= 0)
$

$
  k = cases(-"NoC0" "if" r_0 = 0, "NoC1" - 1 "if" r_0 = 1)
$

$
  "exponent" = cases(
    "signum"(k) times (2^#text(fill: purple)[$"es"$] + #text(fill: green)[$"binary exponent"$]) "if" #text(fill: purple)[$"es"$] != -1,
    0 "if" #text(fill: purple)[$"es"$] = -1
  )
$

== Addition

#image("media/add.jpg", width: 100%)

== Multiplication

#image("media/mul.jpg", width: 100%)