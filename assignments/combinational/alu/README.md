# ALU
Implementați un ALU.

Intările ALU sunt:
 - i_w_op1 - primul operand (4 biți)
 - i_w_op2 - al doilea operand (4 biți)
 - i_w_opsel - operația selectată pentru a fi executată de către ALU (2 biți)

Ieșirea ALU este:
 - o_w_out - rezultatul operației între cei doi operanzi (4 biți)

Apăsați butonul "evaluate" din VPL pentru a afla operațile pe care trebuie sa le implementați pentru fiecare valoare a intrării i_w_opsel.

Operatiile posibile sunt:
 - ADDITION - Adunare între cei doi operanzi
 - SUBTRACTION - Scaderea celui de al doilea operand din primul operand
 - MULTIPLY - Înmulțirea celor doi operanzi și reținerea în rezultat a celor mai puți semnificativi 4 biți
 - DIVIDE - Împărțirea primului operand de către al doilea operand
 - MODULUS - Restul împărțirii primului operand de către al doilea operand
 - LEFT_SHIFT - Shiftarea la stânga a primului operand cu valoarea celui de al doilea operand
 - RIGHT_SHIFT - Shiftarea la dreapta a primului operand cu valoarea celui de al doilea operand
 - ARITHMETIC_RIGHT_SHIFT -Shiftarea aritmetică la dreapta a primului operand cu valoarea celui de al doilea operand
 - BITWISE_NAND - ȘI-NU între biți celor doi operanzi pe aceleași poziții
 - BITWISE_NOR - SAU_NU între biți celor doi operanzi pe aceleași poziții
 - BITWISE_AND - ȘI între biți celor doi operanzi pe aceleași poziții
 - BITWISE_OR - SAU între biți celor doi operanzi pe aceleași poziții
 - BITWISE_XOR - SAU-EXCLUSIV între biți celor doi operanzi pe aceleași poziții
 - COMPARE_EQUAL - Dacă cei doi operazi sunt egali rezultatul va avea valoarea 4'd1 astfel 4'd0.
 - COMPARE_LESS_THAN - Dacă primul operand este mai mic ca al doilea operand rezultatul va avea valoarea 4'd1 astfel 4'd0.
 - COMPARE_GREATER_THAN - Dacă primul operand este mai mare ca al doilea operand rezultatul va avea valoarea 4'd1 astfel 4'd0.

