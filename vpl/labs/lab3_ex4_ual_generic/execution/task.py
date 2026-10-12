#!/usr/bin/env python3
# Enunțul personalizat. Acesta este SINGURUL loc în care se modifică textul (îl afișează "Run" și "Evaluate").
import sys
sys.stdout.reconfigure(encoding="utf-8")
from generate import *

print(f"""# UAL parametrizat
Pentru o utilizare mai generală, implementați un UAL cu operanzi cu dimensiune variabilă. Modulul `ual` are parametrul `width` cu valoarea implicită **{W}**, operanzii `a` și `b` pe `width` biți (fără semn, extinși cu zero la `2*width` biți), intrarea de selecție `sel` și rezultatul `ual_out` pe `2*width` biți. Operațiile sunt altele decât la exercițiul anterior:

- `sel` = 0: {desc(PAIR[0], "2*width")}
- `sel` = 1: {desc(PAIR[1], "2*width")}

**Hint**
- Pentru a-l implementa, este necesară implementarea unui multiplicator parametrizat - atenție la dimensiunea semnalelor! Dacă refolosiți module, copiați-le (parametrizate) în `ual.v`.

Editați `ual.v`. Apăsați „Run” pentru a simula proiectul și „Evaluate” pentru a fi notat.""")
