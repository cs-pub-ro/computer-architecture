== Problem

Given this UART configuration, what is the maximum data rate?

- Baud rate: 115200
- Data bits: 8
- Stop bits: 1
- Parity: none
- Flow control: none

== Solution

The baud rate is 115200 bits per second. Each frame contains one start bit, eight data bits, no parity bit, and one stop bit:

$ "Bits per frame" = 1 + 8 + 0 + 1 = 10 "bits" $

The maximum data rate is:

$ "Maximum data rate" = (115200 times 8) / 10 = 92160 "bps" $

Therefore, the maximum data rate is 92160 bits per second.