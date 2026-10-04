== Problem

Given the following hexadecimal number `0x1A3F` in big-endian format, convert it to decimal.

== Solution

Expand each digit according to its positional value:

$ "0x1A3F" = 1 times 16^3 + "A" times 16^2 + 3 times 16^1 + "F" times 16^0 $

where:

$
  "A" = 10 \
  "F" = 15
$

Calculate each term:

$
  1 times 16^3 = 1 times 4096 = 4096 \
  10 times 16^2 = 10 times 256 = 2560 \
  3 times 16^1 = 3 times 16 = 48 \
  15 times 16^0 = 15 times 1 = 15
$

Adding these values gives:

$ 4096 + 2560 + 48 + 15 = 6719 $

Therefore, the decimal representation is `0x1A3F = 6719`.