# Didactic assembler 0.1
To install, just do ```make install``` while inside the dockerfile.

## Usage
```didasm <input-file> <output-file>```

This will output binary representation of the instructions, and shall be read using $readmemb instead of $readmemh
The representation is reversed, because when parsing the ram has the word order ```[15:0]``` instead of ```[0:15]``` like it is usually done in the classroom while decoding

Supports all instructions from the Bible.pdf, but does not fully support all the different syntaxes for memory addressing.
Currently the differences consist in small tweaks such as the impossibility of distinguishing between an immediate value and a displacement in memory (depls), so the direct addressing is done using the cheatsheet syntax (```[depls]```), and indirect is done using (```[[depls]]```).

Also, it only currently supports the addressing mode syntax from the cheatsheet.

## Labels for relative jumps
Assembly usually has this syntax:
```
xor ra,ra ; mov ra,0 but faster
loop_start:
    add rb, ra
    inc ra
    cmp ra, 5
    jne loop_start

end:
    out 0 ; We share the result with the outside world
    hlt
```
