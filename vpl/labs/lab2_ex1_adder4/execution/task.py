#!/usr/bin/env python3
# Enunțul exercițiului. Acesta este SINGURUL loc în care se modifică textul: îl afișează
# atât "Run", cât și "Evaluate" (în consolă).
# Pentru pagina activității din Moodle:  python3 task.py > ASSIGNMENT.md
import sys
sys.stdout.reconfigure(encoding="utf-8")

print(r"""# Sumator pe 4 biți (atribuire continuă)
Sumatorul pe 4 biți. Implementați un sumator pe 4 biți, cu două intrări și o ieșire (`sum`), folosind atribuirea continuă. Testați-l cu modulul de test din `adder4_test.v`, urmărind valorile afișate în consolă la „Run”.

**Hint-uri**
- Utilizați atribuirea continuă (`assign`) pentru implementare.
- Atenție la dimensiunea semnalelor de ieșire.
- Puteți modifica modulul de test pentru a stimula sumatorul în cât mai multe situații: situații obișnuite de adunare, dar și situații speciale (ex. carry = 1). Variabilele pe care le atribuiți în modulul de test sunt de tip `reg`.

Module și porturi:
- `adder4`: intrări `a` [3:0], `b` [3:0]; ieșiri `sum` [4:0]

Editați `adder4.v`. Apăsați „Run” pentru a simula proiectul cu `adder4_test.v`. Apăsați „Evaluate” pentru a fi notat.""")
