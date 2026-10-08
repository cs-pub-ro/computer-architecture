# Automat Moore
(Opțional - de implementat acasă) Implementați automatul de stări Moore din figura din laborator, descris și de tabelul de mai jos. Intrarea `x` are 1 bit. Semnalul `rst_n` este activ pe low (0) și aduce automatul în starea S0 (resetul poate fi sincron sau asincron). Ieșirea `y` este 1 doar în starea S2 (starea cu cerc dublu în figură).

| stare | x=0 | x=1 | y |
|---|---|---|---|
| S0 | S0 | S1 | 0 |
| S1 | S2 | S2 | 0 |
| S2 | S1 | S0 | 1 |

**Hint-uri**
- La mașina Moore, ieșirea depinde doar de starea curentă.
- Folosiți blocuri `always` separate pentru partea secvențială (starea curentă, atribuiri non-blocante) și pentru cea combinațională (starea următoare și ieșirea).

Module și porturi:
- `moore_fsm`: intrări `x`, `rst_n`, `clk`; ieșire `y`

Editați `moore_fsm.v`. Apăsați „Run” pentru a simula proiectul cu `moore_fsm_test.v`. Apăsați „Evaluate” pentru a fi notat.
