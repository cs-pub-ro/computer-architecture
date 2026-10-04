#import "@preview/touying:0.6.1": speaker-note

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
  B_x = s b_(n-2) b_(n-3) dots b_1 b_0 \
  x = (-1)^s times sum_(i=0)^(n-2) b_i times 2^i
$

== One's Complement

A binary number representation using one's complement.

$
  B_x = s b_(n-2) b_(n-3) dots b_1 b_0 \
  x = cases(
    sum_(i=0)^(n-2) b_i times 2^i "if sign is positive",
    (-1) times sum_(i=0)^(n-2) overline(b_i) times 2^i "otherwise"
  )
$

== Two's Complement

A binary number representation using two's complement.

$
  B_x = s b_(n-2) b_(n-3) dots b_1 b_0 \
  x = cases(
    sum_(i=0)^(n-2) b_i times 2^i "if sign is positive",
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

Fractional numbers are written as $"Q"("ns", "ds")$, where $"ns"$ is the numerator size and $"ds"$ is the denominator size.

$
  B_x = s n_("ns"-2) n_("ns"-3) dots n_1 n_0 d_("ds"-1) d_("ds"-2) dots d_1 d_0 \
  x = (-1)^s times frac(sum_(i=0)^("ns"-2) n_i times 2^i, sum_(i=0)^("ds"-1) d_i times 2^i)
$

== Fractional

== Fixed Point

Fixed-point numbers are written as $"FP"("is", "fs")$, where $"is"$ is the integer-part size and $"fs"$ is the fractional-part size.

$
  B_x = s i_("is"-2) i_("is"-3) dots i_1 i_0 f_("fs"-1) f_("fs"-2) dots f_1 f_0 \
  x = cases(
    sum_(j=0)^("is"-2) i_j times 2^j + sum_(j=0)^("fs"-1) f_j times 2^(j-"fs") "if sign is positive",
    (-1) times (sum_(j=0)^("is"-2) overline(i_j) times 2^j + sum_(j=0)^("fs"-1) overline(f_j) times 2^(j-"fs") + frac(1, 2^"fs")) "otherwise"
  )
$

== Simple Floating Point

Simple floating-point numbers are written as $"FloatP"("es", "fs")$, where $"es"$ is the exponent size and $"fs"$ is the fraction size (mantissa).

$ x = (-1)^"sign" times 2^"exponent" times 1."fraction" $

$
  B_x = s e_("es"-1) e_("es"-2) dots e_1 e_0 m_("fs"-1) m_("fs"-2) dots m_1 m_0 \
  "bias" = 2^("es"-1) - 1 \
  e = sum_(i=0)^("es"-1) e_i times 2^i - "bias" \
  x = (-1)^s times cases(
    0 "if all" e_i = 0 "and all" m_i = 0,
    2^e times (1 + frac(sum_(i=0)^("fs"-1) m_i times 2^i, 2^"fs")) "otherwise"
  )
$

== IEEE 754 Floating Point

IEEE 754 floating-point numbers are written as $"IEEE754"("es", "fs")$, where $"es"$ is the exponent size and $"fs"$ is the fraction size (mantissa).

$
  x = (-1)^s times cases(
    0 "if all" e_i = 0 "and all" m_i = 0,
    2^(e+1) times frac(sum_(i=0)^("fs"-1) m_i times 2^i, 2^"fs") "if all" e_i = 0 "and some" m_i != 0,
    infinity "if all" e_i = 1 "and all" m_i = 0,
    "sNaN" "if all" e_i = 1 "and" m_("fs"-1) = 0 "and some lower fraction bit is 1",
    "qNaN" "if all" e_i = 1 "and" m_("fs"-1) = 1,
    2^e times (1 + frac(sum_(i=0)^("fs"-1) m_i times 2^i, 2^"fs")) "otherwise"
  )
$

== Morris Floating Point

The Morris floating-point representation uses $"Morris"("s", "g")$, where $"s"$ is the size and $"g"$ is the exponent-size field.

$
  B_x = G_(g-1) G_(g-2) dots G_1 G_0 s_e e_("es"-1) e_("es"-2) dots e_1 e_0 s_f m_("fs"-1) m_("fs"-2) dots m_1 m_0 \
  G = sum_(i=0)^(g-1) G_i times 2^i \
  "es" = G + 1 \
  e = (-1)^(s_e) times sum_(i=0)^("es"-1) e_i times 2^i \
  x = (-1)^(s_f) times cases(
    0 "if all bits are 0",
    "NR" "if all bits are 1",
    2^e times (1 + frac(sum_(i=0)^("fs"-1) m_i times 2^i, 2^"fs")) "otherwise"
  )
$

#speaker-note[
  The first $g$ bits represent $G$, which determines the exponent size $"es" = G + 1$. The next bit is the exponent sign, followed by the exponent magnitude. The fraction has its own sign bit and fraction bits. The value is $2^"exponent" times (-1)^"fraction sign" times (1 + frac(f, 2^"fs"))$. Zero is represented by all zero bits; error cases use all one bits.
]

== Posit

The $"Posit"("size", "es")$ format is determined by its total size and exponent-size parameter $"es"$.

$
  B_x = s b_("size"-2) b_("size"-3) dots b_1 b_0 \
  "AbsoluteBits"_x = cases(overline(B_x) + 1 "if negative", B_x "otherwise") \
  e = k times 2^"es" + sum_(i=0)^("es"-1) e_i times 2^i \
  x = (-1)^s times cases(
    0 "if all bits are 0",
    "NaR" "if the first bit is 1 and the rest are 0",
    2^e times (1 + frac(sum_(i=0)^("fs"-1) m_i times 2^i, 2^"fs")) "otherwise"
  )
$

== Until Now

#set text(size: 11pt)
#figure(
  table(
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
  caption: [Overview of Number Representation Systems],
)

== Hidden Exponent Bit

- Morris hidden exponent bit:

  $s_f G_(g-1) G_(g-2) dots G_0 s_e e_("es"-1) e_("es"-2) dots e_0 f_("fs"-1) f_("fs"-2) dots f_0$
- Morris hidden exponent bit with bias $G$:

  $s G_(g-1) G_(g-2) dots G_0 e_("es"-1) e_("es"-2) dots e_0 f_("fs"-1) f_("fs"-2) dots f_0$
- Morris hidden exponent bit with unary $G$:

  $s r_0 r_1 dots r_("rs"-2) overline(r_("rs"-1)) e_("es"-1) e_("es"-2) dots e_0 f_("fs"-1) f_("fs"-2) dots f_0$

== Morris Hidden Exponent Bit

The main problem with Morris floating-point numbers is that the same number can have multiple representations. One solution borrows the hidden bit concept from the mantissa. The $g$ field represents $G$ and indicates the position of the most significant set bit in the exponent. If the exponent size is $G + 1$, its minimum absolute value is 2 when $G = 0$.

== Morris Hidden Exponent Bit

$ "es" = G - 1 $

$
  "exponent" = cases(
    (-1)^"exponent sign" times (2^"es" + "binary exponent") "if" "es" != -1,
    0 "if" "es" = -1
  )
$

$
  "value" = cases(
    0 "if all bits are 0",
    "NR" "if the first bit is 1 and the rest are 0",
    (-1)^s times 2^"exponent" times (1 + frac(f, 2^"fs")) "otherwise"
  )
$

== Morris Hidden Exponent Bit with Bias G

The exponent can still have multiple values when $"es" = -1$, because the exponent sign does not matter. A bias value $g$ solves the sign issue: the sign of $G$ becomes the exponent sign and $"es" = abs(G) - 1$. Negating the exponent bits when $G$ is negative also makes binary comparison easier to implement in hardware.

== Morris Hidden Exponent Bit with Bias G

$ "bias" = 2^(g-1) - 1, quad G = "binary G" - "bias", quad "es" = abs(G) - 1 $

$
  "exponent" = cases(
    "signum"(G) times (2^"es" + "binary exponent") "if" "es" != -1,
    0 "if" "es" = -1
  )
$

== Morris Hidden Exponent Bit with Unary G

$
  "exponent size" = cases(-k - 1 "if" k < 0, k - 1 "if" k >= 0)
$

$
  k = cases(-"NoC0" "if" r_0 = 0, "NoC1" - 1 "if" r_0 = 1)
$

$
  "exponent" = cases(
    "signum"(k) times (2^"es" + "binary exponent") "if" "es" != -1,
    0 "if" "es" = -1
  )
$

== Addition

#image("media/add.jpg", width: 100%)

== Multiplication

#image("media/mul.jpg", width: 100%)