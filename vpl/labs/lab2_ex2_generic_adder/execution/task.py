#!/usr/bin/env python3
# Enunțul exercițiului. Acesta este SINGURUL loc în care se modifică textul: îl afișează
# atât "Run", cât și "Evaluate" (în consolă).
# Pentru pagina activității din Moodle:  python3 task.py > ASSIGNMENT.md
import sys
sys.stdout.reconfigure(encoding="utf-8")

print(r"""# Sumator parametrizat
Implementați un sumator parametrizat pe n biți, cu două intrări și o ieșire. Parametrizarea se va efectua asupra dimensiunii variabilelor. Parametrul se numește `op_width` (numele este folosit de modulul de test).

**Hint-uri**
- De câți parametri este nevoie? Observați dependența între dimensiunea variabilelor de intrare și cea de ieșire.
- Modulul de test instanțiază un sumator pe 6 biți; adăugați stimuli corespunzători pentru a-i testa întreaga plajă de valori.

Module și porturi:
- `generic_adder` (parametru `op_width`, implicit `1`): intrări `a`, `b` [op_width-1:0]; ieșire `sum` [op_width:0]

Editați `generic_adder.v`. Apăsați „Run” pentru a simula proiectul cu `generic_adder_test.v`. Apăsați „Evaluate” pentru a fi notat.""")
