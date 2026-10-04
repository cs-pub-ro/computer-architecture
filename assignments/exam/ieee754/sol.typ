== Problem

Given the hexadecimal string `0x44490100`, find its value in the 32-bit IEEE 754 floating-point representation.

== Solution

Convert the hexadecimal string to binary:

$ "0x44490100" = #raw("0100 0100 0100 1001 0000 0001 0000 0000") $

Identify the sign bit, exponent, and mantissa:

- Sign bit: `0` (positive)
- Exponent: `10001000`
- Mantissa: `10010010000000100000000`

Convert the exponent to decimal and apply the 32-bit bias of 127:

$ "Exponent" = 10001000_2 = 136_10 $

$ "Unbiased exponent" = 136 - 127 = 9 $

Add the implicit leading 1 to the mantissa:

$ "Mantissa" = 1.10010010000000100000000_2 $

Calculate the value:

$ "Value" = (-1)^"sign" times 1."mantissa" times 2^"exponent" $

$ "Value" = (-1)^0 times 1.10010010000000100000000_2 times 2^9 $

$ "Value" = 1 times 1100100100.000001_2 = 804_10 + 2^(-6) = 804.015625_10 $

Therefore, the value is $804.015625$.