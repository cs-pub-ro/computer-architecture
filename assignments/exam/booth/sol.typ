== Problem

For the 16-bit Booth's algorithm, how many additions are required for $M times R$, where $M = 13$ and $R = 11$?

== Solution

Convert $R$ to binary:

$ R = 11_10 = #raw("0000 0000 0000 1011")_2 $

Express $R$ in Booth's algorithm form:

$ R = 2^4 - 2^3 + 2^2 - 2^0 $

Therefore, the number of additions required is 4.