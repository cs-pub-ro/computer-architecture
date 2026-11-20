; This is an inline comment, anything written here is regarded as text and will not make it into the final binary representation
@pragma ADDRESS_LEN(16) ; Optional, sets the address length of the ram (specific to this assembler only). default is 10 => 1024 words, max is 16 => 65536
a EQU 5 ; We define a to be constant value 5
xor ra,ra ; mov ra,0 but faster
loop_start: ; Relative location address to jump to. Within this example it will be replaced with 1
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
