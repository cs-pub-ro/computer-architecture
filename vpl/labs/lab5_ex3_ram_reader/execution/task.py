#!/usr/bin/env python3
# Enunțul exercițiului. Acesta este SINGURUL loc în care se modifică textul: îl afișează
# atât "Run", cât și "Evaluate" (în consolă).
# Pentru pagina activității din Moodle:  python3 task.py > ASSIGNMENT.md
import sys
sys.stdout.reconfigure(encoding="utf-8")

print(r"""# Citire din RAM
Vi se pune la dispoziție un RAM de tip Block Memory Generator, instanțiat în modulul `ram_reader` (fișierul `ram.v` este modelul de simulare al RAM-ului din proiectul ISE, cu conținutul din `ram.mif`). Completați modulul astfel încât să puteți gestiona citirea din memorie de la o adresă `am_out` în momentul în care semnalul `read` este activ (1). Rezultatul citirii apare pe ieșirea `ram_out`.

**Precizare**: datele de la adresa `am_out` trebuie să fie disponibile pe `ram_out` în cel mult un ciclu de ceas după activarea lui `read`.

Module și porturi:
- `ram_reader`: intrări `clk`, `rst`, `read`, `am_out` [9:0]; ieșire `ram_out` [15:0]

Editați `ram_reader.v`. Fișiere furnizate (nu le modificați): `ram.v`. Apăsați „Run” pentru a simula proiectul cu `ram_reader_test.v`. Apăsați „Evaluate” pentru a fi notat.""")
