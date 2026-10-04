== Status Flags

- Zero flag (Z)
- Carry flag (C)
- Sign flag (S)
- Overflow flag (O)
- Parity flag (P)

== Mathematical Operations

$
  Z = not |"result" \
  C = "result"[n+1] \
  S = "result"[n] \
  O = "operation-defined" \
  P = not xor("result")
$

== Overflow Flag

- Adding two positive numbers produces a negative number.
- Adding two negative numbers produces a positive number.
- Multiplication produces a result that exceeds the available bits.
- Subtracting a positive number from a negative number produces a positive number.