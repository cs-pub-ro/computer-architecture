#!/usr/bin/env python3
# Enunțul exercițiului. Acesta este SINGURUL loc în care se modifică textul: îl afișează
# atât "Run", cât și "Evaluate" (în consolă).
# Pentru pagina activității din Moodle:  python3 task.py > ASSIGNMENT.md
import sys
sys.stdout.reconfigure(encoding="utf-8")

print(r"""# Automat Mealy
(Opțional - de implementat acasă) Implementați automatul de stări Mealy din figura din laborator, descris și de tabelul de mai jos. Intrarea `x` are 2 biți. Semnalul `rst_n` este activ pe low (0) și aduce automatul în starea S0 (resetul poate fi sincron sau asincron). Tabelul arată starea următoare pentru fiecare valoare a lui `x` și ieșirea `y`:

| stare | x=00 | x=01 | x=10 | x=11 | y |
|---|---|---|---|---|---|
| S0 | S0 | S1 | S2 | S0 | 0 |
| S1 | S2 | S0 | S3 | S1 | 0 |
| S2 | S3 | S0 | S1 | S2 | 1 dacă x=00, altfel 0 |
| S3 | S1 | S0 | S3 | S0 | 1 dacă x=00 sau x=10, altfel 0 |

**Hint-uri**
- La mașina Mealy, ieșirea depinde atât de starea curentă, cât și de intrare.
- Folosiți două blocuri `always`: unul secvențial, activ pe frontul ceasului (atribuiri non-blocante), și unul combinațional (`always @(*)`) pentru starea următoare și ieșire.

Module și porturi:
- `mealy_fsm`: intrări `x` [1:0], `rst_n`, `clk`; ieșire `y`

Editați `mealy_fsm.v`. Apăsați „Run” pentru a simula proiectul cu `mealy_fsm_test.v`. Apăsați „Evaluate” pentru a fi notat.""")
