# Didactic assembler 0.1
To install, just do ```make install``` while inside the dockerfile.

## Usage
```didasm <input-file> <output-file>```

This will output hex representation of the instructions
The representation is reversed, because when parsing the ram has the word order ```[15:0]``` instead of ```[0:15]``` like it is usually done in the classroom while decoding.
For a clearer view of the instruction grouping in the right order, pass ```--beautiful``` as an optional command line argument (it has to be the 3rd argument specifically).
If by contrast the 3rd argument is ```--quiet```, the only thing that will be outputed is the binary.
By default if no option is passed, only the original code is commented above the hex value it represents

Supports all instructions from the [ISA description document](../chapters/microprogramable_cpu/control-unit/reading/Biblia.pdf), but does not fully support all the different syntaxes for memory addressing.
Currently the differences consist in small tweaks such as the impossibility of distinguishing between an immediate value and a displacement in memory (depls), so the direct addressing is done using the cheatsheet syntax (```[depls]```), and indirect is done using (```[[depls]]```).

Also, it only currently supports the addressing mode syntax from the cheatsheet.

## Example program
Assembly usually has this syntax:
```asm
; This is an inline comment, anything written here is regarded as text and will not make it into the final binary representation
a EQU 5 ; We define a to be constant value 5
xor ra,ra ; mov ra,0 but faster
loop_start: ; Relative location in address to jump to. Within this example it will be replaced with 1
    add [b], ra ; equivalent to add [0x3F1], ra (see explanations later)
    inc ra
    cmp ra, a ; After preprocessing will be cmp ra, 5
    jne loop_start ; For conditional jumps relative offsets are used

end: ; 
    out 0 ; We share the result with the outside world
    hlt

0x03F0: ; Placing numbers instead of identifiers for labels represent what will be written at an arbitrary memory address (specific to this assembler only!)
4 ; Any number without an instruction can be converted into a 16bit word (specific to this assembler only!)
b: 15  ; Since b is the next word after address 0x03F0, this will be translated to 0x03F1.
```
