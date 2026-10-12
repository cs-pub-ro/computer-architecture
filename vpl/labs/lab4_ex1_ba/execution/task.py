#!/usr/bin/env python3
# Enunțul exercițiului. Acesta este SINGURUL loc în care se modifică textul: îl afișează
# atât "Run", cât și "Evaluate" (în consolă).
# Pentru pagina activității din Moodle:  python3 task.py > ASSIGNMENT.md
import sys
sys.stdout.reconfigure(encoding="utf-8")

print(r"""# Automat finit: recunoașterea secvenței „ba”
Se dorește proiectarea unui automat finit capabil să recunoască secvențe de tip „ba”. Automatul primește la intrare în mod continuu caractere codificate printr-un semnal de un bit (`i`: 0 = „a”, 1 = „b”), câte unul la fiecare front crescător al ceasului `clk`. Ieșirea `o` va fi activată (valoarea 1) atunci când la intrare am avut prezent un șir care se potrivește cu tiparul de căutare.

Implementați automatul în Verilog ca automat de tip Moore (ieșirea depinde doar de starea curentă): după frontul de ceas la care este citit un „a” imediat după un „b”, ieșirea `o` devine 1 și rămâne 1 până la frontul următor. Automatul nu are semnal de reset; starea inițială (niciun caracter citit) se stabilește la declararea registrului de stare.

**Hint-uri**
- Realizați pe hârtie schema automatului de stări, pentru a o folosi ulterior ca referință.
- Observați în Laboratorul 0 strategia abordată pentru implementarea unui automat ce recunoaște o secvență de caractere.
- Folosiți două blocuri `always`: unul secvențial (`always @(posedge clk)`, cu atribuiri non-blocante) pentru starea curentă și unul combinațional (`always @(*)`) pentru starea următoare și ieșire.

Module și porturi:
- `ba`: intrări `i`, `clk`; ieșire `o`

Editați `ba.v`. Apăsați „Run” pentru a simula proiectul cu `ba_test.v`. Apăsați „Evaluate” pentru a fi notat.""")
