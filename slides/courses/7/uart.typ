== Introduction to UART

- Universal Asynchronous Receiver-Transmitter
- Hardware communication protocol
- Used for asynchronous serial communication

== Setting Up UART

- Connect two devices using TX and RX lines.
- Match voltage levels (3.3 V or 5 V).
- Agree on a baud rate (9600, 19200, 38400, 57600 or 115200).
- Agree on the data format (for example, 8E1: 8 data bits, even parity, 1 stop bit).
- Choose flow control:
  - Hardware: RTS/CTS (Request to Send/Clear to Send)
  - Software: XON/XOFF (ASCII 0x11 and 0x13)
  - None

== UART Data Format

#figure(
  image("media/UART.png", width: 90%),
  caption: [By EidenNor, CC BY-SA 4.0, https://commons.wikimedia.org/w/index.php?curid=118379174],
)

== Transmission of Data Bits

#image("media/uart_timing.png", width: 80%)