# FLAG-RAM
Implementati un modul ce va contine o memorie RAM (4 biti de adresare si 4 biti de date) si un registru de flag-uri ce va contine informatii despre ultimul cuvant citit din memoria RAM. Modulul ram este dat si prezent in fisierul "ram.v" (NU MODIFICATI, DOAR INSTANTIATI IN MODULUL VOSTRU). O implementare de registrul este prezenta in fisierul "register.v" (Folosirea lui este optionala).

Modulul de implementat are urmatoarele intrari:
 - i_w_clk - ceas
 - i_w_address -  adresa de memorie ram (4 biti)
 - i_w_data - data de intrare (4 biti)
 - i_w_we - daca se scrie in RAM
 - i_w_oe - daca se afiseaza din RAM
 - i_w_flags_out - daca se afiseaza valorea registrului flag (activ pozitiv 1'b1)

Ieșirea modulului este:
 - o_w_out - datele citite din RAM sau valoarea registrului flag (4 biti)

Ordinea de prioritate a operaților este (i_w_we > i_w_oe > i_w_flags_out).

Registrul flag va avea 4 biti si va avea de implementat 4 flag-uri. Veti afla flag-urile de implementat si pozitia lor dupa apasarea butonului "evaluate" din VPL.

Flag-uri posibile:
 - Z - if all bits are unset
 - S - if the sign bit is set (MSB)
 - E - if it has an even number of bits set
 - O - if it has an odd number of bits set
 - C2 - if the bit on the position 2 is clear
 - S2 - if the bit on the position 2 is set
 - G4 - if the data value is greater than 4
 - L4 - if the data value is lower than 4
 - POW - if the data value is a power of 2 (1,2,4,8)
 - SMAX - if the data value is the maximum signed value
 - SMIN - if the data value is the minimum signed value
 - MAX - if the data value is the maximum unsigned value
 - PAL - if the data value is a binary palindrome (0110 -1, 1010-0)
 - SB2 - if there are at least 2 consecutive bits set (1100-1, 0101-0)