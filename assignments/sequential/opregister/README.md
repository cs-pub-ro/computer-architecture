# Operation Register
Sa se implementeze un registru multifunctional.

Intrarile registrului sunt:
 - i_w_clk - ceas
 - i_w_reset - reset (activ pe 0)
 - i_w_data - date de intrare (4 biți)
 - i_w_we - daca se scrie in registru
 - i_w_oe - daca se afiseaza in registru
 - i_w_opsel - selectie asupra unui operatii pe registru (2 biți)

Iesirea registrului este:
 - o_w_out este activa doar cand i_w_oe este activ (1), altfel  o_w_out va avea valoarea 4'b0000. (4 biți)

Prioritatea funcțiilor registrului sunt: i_w_we, i_w_oe, i_w_opsel. (daca i_w_we si i_w_oe sunt active in acelasi timp se va face doar scrierea in registru a valorii i_w_data)

Operatiile pe care va trebui sa le implementati in functie de valoarea i_w_opsel le veti afla doar dupa apasarea butonului "evaluate" din VPL.

Operatiile posibile sunt: 
 - SHR1 - Shift right by one
 - SHL1 - Shift left by one
 - SAR1 - Shift right arithmetic by one
 - ROTR1 - Rotate right by one
 - ROTL1 - Rotate left by one
 - REDUCE_BITWISE_OR - OR all bits
 - REDUCE_BITWISE_XOR - XOR all bits
 - REDUCE_BITWISE_AND - AND all bits
 - NEG - Two's complement
 - NOT - One's Complement
 - INC - Increment by one
 - DEC - Decrement by one