#!/usr/bin/env python3
# Enunțul personalizat. Acesta este SINGURUL loc în care se modifică textul (îl afișează "Run" și "Evaluate").
import sys
sys.stdout.reconfigure(encoding="utf-8")
from generate import *

rel = "\n".join(f"- `o{i + 1}` = 1 dacă {txt}, altfel 0" for i, (_, txt) in enumerate(TRIPLE))
print(f"""# Comparator pe 1 bit
Implementați un comparator pe un bit (modulul `comp1`). Acesta are două intrări (`a`, `b`) și 3 ieșiri, fiecare calculând o relație diferită între `a` și `b`:

{rel}

**Hint**
- Respectați interfața cerută (numele modulului și ale porturilor).

Editați `comp1.v`. Apăsați „Run” pentru a simula proiectul și „Evaluate” pentru a fi notat.""")
