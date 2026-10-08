#!/usr/bin/env python3
# Enunțul personalizat. Acesta este SINGURUL loc în care se modifică textul (îl afișează "Run" și "Evaluate").
import sys
sys.stdout.reconfigure(encoding="utf-8")
from generate import *

rel = "\n".join(f"- `o{i + 1}` = 1 dacă {txt}, altfel 0" for i, (_, txt) in enumerate(TRIPLE))
tip = ("numere **cu semn**, în complement față de 2 (de la -8 la 7)" if SIGNED else "numere **fără semn** (de la 0 la 15)")
print(f"""# Comparator pe 4 biți
Implementați un comparator pe 4 biți (modulul `comp4`). Acesta are două intrări (`a`, `b`), considerate {tip}, și 3 ieșiri, fiecare calculând o relație diferită între `a` și `b`:

{rel}

**Hint-uri**
- Unei variabile îi poate fi atribuită valoarea unei expresii logice.
- Considerând experiența exercițiului 2, există vreo posibilitate să parametrizați comparatorul? (opțional; evaluarea testează varianta pe 4 biți)

Editați `comp4.v`. Apăsați „Run” pentru a simula proiectul și „Evaluate” pentru a fi notat.""")
