#!/usr/bin/env python3
# Enunțul personalizat. Acesta este SINGURUL loc în care se modifică textul (îl afișează "Run" și "Evaluate").
import sys
sys.stdout.reconfigure(encoding="utf-8")
from generate import *

print(f"""# Sumator pe {N} biți
Implementați un sumator pe **{N} biți**, cu două intrări (`a`, `b`, pe {N} biți fiecare) și o ieșire (`sum`), în modulul `adder`. Câți biți va avea ieșirea? De ce? Declarați singuri porturile modulului.

**Hint**
- Folosiți atât sumatoare pe 1 bit, cât și sumatoare pe 4 biți. Fișierul `adder.v` trebuie să fie autonom: copiați în el modulele din exercițiile anterioare.

Editați `adder.v`. Apăsați „Run” pentru a simula proiectul și „Evaluate” pentru a fi notat.""")
