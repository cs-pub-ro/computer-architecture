== Assembly Language

- Low-level programming language
- Directly related to machine code
- In most cases, each instruction corresponds to one machine-code instruction

== Advantages

- Direct access to hardware
- High performance
- Small code size
- Full control over the system

== Disadvantages

- Difficult to write, read, maintain, debug and port
- Time-consuming

== Position of Code

- Independent (absolute/PIC)
- Relative to the current instruction (PC-relative)
- External to the code (libraries)

== Mnemonics

*Instruction:*

```text
[Label:] Operation [List of Operands] [; Comment]
```

*Variables:*

```text
name type size [value/expression] [; Comment]
```

== Data Types

- DB byte: 8 bits
- DW word: 16 bits
- DD double word: 32 bits
- DQ quad word: 64 bits
- DT ten bytes: 80 bits

== Constants

- Binary: `10101B`
- Octal: `1234Q`
- Decimal: `1234D`
- Hexadecimal: `1234H` (first digit must be 0-9)
- Character: `'A'`

== DUP Operator

```gas
var DB 10 DUP(?)
var DB 10 DUP(0)
var DB 5 DUP(5 DUP(5 DUP(0)))
```

== Sections

- `.data`
- `.text`
- `.rodata`
- `.section`
- `.global`
- `.extern`

== Directives

- `.equ`
- `=`
- `.asci`
- `.include`

== Code Example

```gas
VEC DW 10 DUP(0); 10 words initialized with 0
SUM DW 0; 1 word initialized with 0
SIZE EQU 10; SIZE = 10

MAIN:
    MOV BA, VEC; BA = VEC
    XOR XA, XA; XA = 0

    INIT_LOOP:
        MOV [BA + XA+], XA; VEC[XA++] = XA
        CMP XA, 10; Compare XA with 10
        JL INIT_LOOP; If XA < 10, jump to INIT_LOOP
```

== Code Example

```gas
    MOV BA, VEC; BA = VEC
    XOR XA, XA; XA = 0
    MOV RA, XA; RA = XA

    SUM_LOOP:
        ADD RA, [BA + XA+]; RA += VEC[XA++]
        CMP XA, 10; Compare XA with 10
        JL SUM_LOOP; If XA < 10, jump to SUM_LOOP

    MOV SUM, RA; SUM = RA
    HALT:
        HLT; Stop the program
```