#!/usr/bin/env python3
# Enunțul exercițiului. Acesta este SINGURUL loc în care se modifică textul: îl afișează
# atât "Run", cât și "Evaluate" (în consolă).
# Pentru pagina activității din Moodle:  python3 task.py > ASSIGNMENT.md
import sys
sys.stdout.reconfigure(encoding="utf-8")

print(r"""# Sumator elementar complet
Implementați și simulați un sumator elementar complet (`full_adder`), utilizând sumatoare elementare parțiale (`half_adder`). Descrierea este structurală: folosiți primitive (`and`, `or`, `xor`), `wire`-uri și instanțierea de module.

**Hint**
- Consultați Laboratorul 0 pentru implementare.

Module și porturi:
- `half_adder`: intrări `a`, `b`; ieșiri `sum`, `c_out`
- `full_adder`: intrări `a`, `b`, `c_in`; ieșiri `sum`, `c_out`

Editați `full_adder.v`. Apăsați „Run” pentru a simula proiectul cu `full_adder_test.v`. Apăsați „Evaluate” pentru a fi notat.""")
