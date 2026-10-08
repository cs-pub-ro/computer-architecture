#!/usr/bin/env python3
# Enunțul exercițiului. Acesta este SINGURUL loc în care se modifică textul: îl afișează
# atât "Run", cât și "Evaluate" (în consolă).
# Pentru pagina activității din Moodle:  python3 task.py > ASSIGNMENT.md
import sys
sys.stdout.reconfigure(encoding="utf-8")

print(r"""# Sumator pe 4 biți
Implementați un sumator pe 4 biți, cu două intrări și două ieșiri (suma `sum` și transportul `c_out`). Verificați corectitudinea sumatorului urmărind valorile afișate în consolă la „Run” (în baza 10).

**Hint-uri**
- Consultați Laboratorul 0 pentru implementarea unui sumator pe mai multe biți.
- Folosiți sumatorul implementat la exercițiul 1. Fișierul `adder4.v` trebuie să fie autonom, deci copiați în el modulele din exercițiul 1.
- Puteți modifica modulul de test pentru a încerca și alte valori de intrare.

Module și porturi:
- `adder4`: intrări `a` [3:0], `b` [3:0]; ieșiri `sum` [3:0], `c_out`

Editați `adder4.v`. Apăsați „Run” pentru a simula proiectul cu `adder4_test.v`. Apăsați „Evaluate” pentru a fi notat.""")
