#!/usr/bin/env python3
# Enunțul personalizat. Acesta este SINGURUL loc în care se modifică textul (îl afișează "Run" și "Evaluate").
import sys
sys.stdout.reconfigure(encoding="utf-8")
from generate import *

print(f"""# UAL (unitate aritmetico-logică)
Implementați o unitate aritmetico-logică simplă (UAL), pe 4 biți, cu 2 operații. Modulul `ual` are operanzii `a` și `b` (4 biți, fără semn, extinși cu zero la 8 biți), intrarea de selecție `sel` de 1 bit și rezultatul `ual_out` pe 8 biți. Selecția dintre cele două operații se face astfel:

- `sel` = 0: {desc(PAIR[0], 8)}
- `sel` = 1: {desc(PAIR[1], 8)}

**Hint-uri**
- Câți biți au ieșirile operațiilor? Dar a UAL-ului?
- Pentru selecția dintre cele două rezultate se poate folosi atribuirea continuă sau se poate implementa un modul multiplexor 2:1.
- Puteți refolosi module din exercițiile anterioare: copiați-le în `ual.v`, care trebuie să fie autonom.

Editați `ual.v`. Apăsați „Run” pentru a simula proiectul și „Evaluate” pentru a fi notat.""")
