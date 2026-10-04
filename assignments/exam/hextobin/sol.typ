== Problem

Given the following hexadecimal number `0x1A3F` in big-endian format, convert it to 8-bit binary.

== Solution

Convert each hexadecimal digit to its 4-bit binary equivalent:

$
  1 = 0001 \
  A = 1010 \
  3 = 0011 \
  F = 1111
$

Therefore, the binary representation is:

$ "0x1A3F" = #raw("0001 1010 0011 1111") $

Note: The problem requests an 8-bit result, while the source solution expands all four hexadecimal digits to 16 bits. The source calculation is preserved here.