#!/usr/bin/env python3
# Enunțul personalizat. Acesta este SINGURUL loc în care se modifică textul (îl afișează "Run" și "Evaluate").
import sys
sys.stdout.reconfigure(encoding="utf-8")
from generate import *

n = "~" if NEG else ""
rows = "\n".join(f"| {k // 2} | {k % 2} | {n}i{PERM[k]} |" for k in range(4))
print(f"""# Multiplexor 4:1
Implementați un multiplexor 4:1 (modulul `mux4_1`). Intrările de date sunt `i1`, `i2`, `i3`, `i4`, intrările de selecție sunt `s1`, `s2`, iar ieșirea este `out`.

| s2 | s1 | out |
|----|----|-----|
{rows}

Implementați multiplexorul în două moduri (în fișier lăsați una dintre variante, iar cealaltă o puteți păstra comentată):
1. folosind ecuația logică dedusă din tabelul de adevăr;
2. folosind operatorul condițional `?`.

**Hint-uri**
- Consultați Laboratorul 0 pentru implementarea unui multiplexor 4:1.
- Respectați interfața cerută.
- Operatorul `?` poate apărea de mai multe ori într-o expresie. Ex: `assign x = (a == 0) ? 1 : ( (a == 1) ? 2 : 0 );`

Editați `mux4_1.v`. Apăsați „Run” pentru a simula proiectul și „Evaluate” pentru a fi notat.""")
