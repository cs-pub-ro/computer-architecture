== Addition and Subtraction

A selector lets the same two's-complement hardware perform addition or subtraction.

$
  "result" = cases(x + y "if" "ADD", x + (-y) "if" "SUB")
$

== Adder

Hardware adder implementations include:
- Ripple-carry adder
- Carry-lookahead adder
  - Carry-skip adder (bypass)
  - Carry-select adder (multiplexer)

== Half Adder

A half adder is a combinational circuit that adds two bits and produces a sum and carry bit.

#figure(image("media/half-adder-gates.png", width: 70%), caption: [Half Adder])

== Full Adder

A full adder is a combinational circuit that adds three bits and produces a sum and carry bit.

#figure(image("media/full-adder-gates.png", width: 70%), caption: [Full Adder])

== Ripple-Carry Adder

The simplest adder is a chain of full adders. Each full adder's carry-out connects to the next full adder's carry-in.

#figure(image("media/ripple-carry.png", width: 70%), caption: [Ripple-Carry Adder])

== Let's Do Some Math

$
  sum[0] = a[0] xor b[0] xor c_"in"[0] \
  c_"in"[1] = c_"out"[0] = (a[0] and b[0]) or (c_"in"[0] and (a[0] xor b[0])) \
  sum[i] = a[i] xor b[i] xor c_"in"[i] \
  c_"in"[i+1] = c_"out"[i] = (a[i] and b[i]) or (c_"in"[i] and (a[i] xor b[i])) \
  G[i] = a[i] and b[i] \
  P[i] = a[i] xor b[i] \
  c_"in"[i+1] = c_"out"[i] = G[i] or (c_"in"[i] and P[i])
$

== Let's Do Some Math

$
  "Ripple Carry Adder gates for carry-out" = 3 times n \
  "Carry Lookahead Adder gates for carry-out" = 2 times n
$

== Carry-Lookahead Adder

A carry-lookahead adder reduces the time needed to calculate each full adder's carry-out. Its two main blocks are:
- Generate block
- Propagate block

$
  c_"out"[i] = G[i] or (P[i] and c_"in"[i]) \
  sum[i] = P[i] xor c_"in"[i]
$

== Carry-Lookahead Adder

#figure(
  rotate(90deg, reflow: true)[#image("media/adders_comparison.jpg", width: 90%)],
  caption: [Carry-Lookahead Adder vs. Ripple-Carry Adder],
)

== Let's Do Some Math

$
  c_(i+1) = c_"out"[i] = G[i] or (P[i] and c_"in"[i]) \
  c_(i+1) = G[i] or (P[i] and (G[i-1] or (P[i-1] and c_"in"[i-1]))) \
  c_(i+1) = G[i] or (P[i] and (G[i-1] or (P[i-1] and (G[i-2] or (P[i-2] and c_"in"[i-2]))))) \
  c_(i+1) = G[i] or (P[i] and G[i-1]) or (P[i] and P[i-1] and (G[i-2] or (P[i-2] and c_"in"[i-2]))) \
  c_(i+1) = G[i] or sum_(j=1)^i (product_(k=j)^i P[k] and G[j-1]) or (product_(k=0)^i P[k] and c_"in"[0]) \
  "Notation" \
  i >= j, quad P[i,j] = product_(k=j)^i P[k] \
  c_(i+1) = G[i] or sum_(j=1)^i (P[i,j] and G[j-1]) or (P[i,0] and c_"in"[0])
$

== Carry-Lookahead Adder Tree

#figure(image("media/cla_tree.jpg", width: 50%), caption: [Carry-Lookahead Adder Tree])

== Carry-Lookahead Adder: Kogge-Stone

#figure(image("media/Kogge-stone-8-bit.png", width: 60%), caption: [CLA Kogge-Stone])

== Carry-Lookahead Adder: Brent-Kung

#figure(image("media/Brent-kung-8-bit.png", width: 50%), caption: [CLA Brent-Kung])

== Carry-Skip Adder (Bypass)

#figure(
  image("media/BCSAdder16Bit.png", width: 90%),
  caption: [CSA 16-bit by Tibor89, CC BY-SA 3.0, https://commons.wikimedia.org/w/index.php?curid=31748842],
)

== Carry-Select Adder (Multiplexer)

#figure(image("media/Carry-select-adder-fixed-size.png", width: 90%), caption: [CSelectA 16-bit])

== Multiplication

$
  P = M times R \
  P = sum_(i=0)^(n-1) (M times R[i] times 2^i) \
  P = sum_(i=0)^(n-1) ((M and {n times R[i]}) << i)
$

== Let's Do Some Math

$
  P = M times R \
  P = M times "8'b0111_0011" \
  P = M times (2^6 + 2^5 + 2^4 + 2^1 + 2^0) \
  P = M times (2^7 - 2^5 + 2^2 - 2^0)
$

== Booth's Algorithm

Booth's algorithm multiplies signed binary numbers in two's-complement form and reduces the number of required additions.

$
  abs(M) = abs(R) = n \
  abs(P) = 2 times n + 1 \
  abs(M_+) = abs(M_-) = 2 times n + 1 \
  M_+ = M << (n + 1) \
  M_- = -M << (n + 1) \
  -M = overline(M) + 1 \
  abs(-M) = n \
  M_+ = {M, 0} \
  M_- = {-M, 0} \
  P = {0, R, "1'b0"}
$

== Booth's Algorithm

Booth's algorithm steps:

$
  P = {0, R, "1'b0"} \
  "for n steps" \
  cases(
    "if" P[1:0] = "2'b01": P = P + M_+,
    "if" P[1:0] = "2'b10": P = P + M_-,
    "otherwise": P = P
  ) \
  P = P >>> 1 \
  "end for" \
  "result" = P[(2 times n):1]
$

== DIV/MOD Debate

Integer division is a debated issue in computer engineering. These equations define integer division:

$
  "Dividend" = "Divisor" times "Quotient" + "Remainder" \
  "Remainder" = "Dividend" - "Divisor" times "Quotient"
$

For example, for $(-5) / 2$, one option is $-5 = 2 times (-3) + 1$, while another is $-5 = 2 times (-2) + (-1)$. For $5 / (-2)$, the choices are $5 = (-2) times (-3) + (-1)$ and $5 = (-2) times (-2) + 1$.

== DIV/MOD Debate

We can categorize division operations as follows:
- *Truncated division:* $"Quotient" = "trunc"("Dividend" / "Divisor")$. Remainder and dividend have the same sign.
- *Floored division:* $"Quotient" = "floor"("Dividend" / "Divisor")$. Remainder and divisor have the same sign.
- *Euclidean division:* Remainder is always positive; quotient is $"sign"("Divisor") times "floor"("Dividend" / abs("Divisor"))$.
- *Round division:* $"Quotient" = "round"("Dividend" / "Divisor")$.
- *Ceiling division:* $"Quotient" = "ceil"("Dividend" / "Divisor")$. Remainder and divisor have opposite signs.

== Let's Do Some Math for Unsigned Numbers

$
  Q = "Dividend" \
  M = "Divisor" \
  R = "Remainder", "Quotient" \
  abs(Q) = abs(M) = n \
  abs(R) = 2 times n \
  R = {0, Q} \
  abs(M_+) = abs(M_-) = 2 times n \
  M_+ = M << n \
  M_- = -M << n \
  -M = overline(M) + 1 \
  abs(-M) = n \
  M_+ = {M, 0} \
  M_- = {-M, 0}
$

== Non-Restoring Division for Unsigned Numbers

$
  R = {0, Q} \
  "for n steps" \
  R = R << 1 \
  "if" R[2 times n - 1] = "1'b1": R = R + M_+ \
  "if" R[2 times n - 1] = "1'b0": R = R + M_- \
  "if" R[2 times n - 1] = "1'b1": R[0] = 0 \
  "if" R[2 times n - 1] = "1'b0": R[0] = 1 \
  "end for" \
  "if" R[2 times n - 1] = "1'b1": R = R + M_+ \
  "Quotient" = R[n-1:0] \
  "Remainder" = R[2 times n-1:n]
$