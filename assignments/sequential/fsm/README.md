# FSM
Se dorește proiectarea unui FSM capabil să recunoască o SECVENTA de caractere data.

FSM va avea ca intrări:
 - i_w_in pe 2 biti, valoarea 2'd0 reprezinta caracterul 'a', 2'd1 caracterul 'b', 2'd2 caracterul 'c', 2'd3 caracterul 'd'
 - i_w_clk - ceas
 - i_w_reset - reset (activ 0) va reseta starea automatului

FSM va avea ca iesire:
 - o_w_out - daca sirul primit la intrare pana in acest moment respecta SECVENTA data.

Veti afla SECVENTA de caractere dupa apasarea butonului "evaluate" din VPL.

SECVENTA poate sa fie o expresie regulata formata dintr-un singur grup si un singur operator special, exemple:
 - a(bc)+
 - a(ab)*