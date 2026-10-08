#!/usr/bin/env python3
# Enunțul personalizat. Acesta este SINGURUL loc în care se modifică textul (îl afișează "Run" și "Evaluate").
import sys
sys.stdout.reconfigure(encoding="utf-8")
from generate import *

print(f"""# Trecere de pietoni semaforizată
Se dorește realizarea unei treceri de pietoni semaforizate. Duratele de timp pentru pietoni sunt: roșu - **{G + Y}** sec, verde - **{PG}** sec. Ceasul `clk` are frecvența de 1 Hz, deci o secundă înseamnă un ciclu de ceas.

Semafoarele pentru mașini au trei faze. Automatul `fsm_trecere` stabilește, în fiecare stare, culorile și durata fazei `T` (în secunde), pe care o încarcă în numărătorul `counter` (furnizat). Când numărătorul își încheie numărătoarea (`done` = 1), automatul trece în faza următoare:

| fază | mașini | pietoni | T |
|---|---|---|---|
| 0 (inițială) | verde (`m_verde`) | roșu (`p_rosu`) | {G} |
| 1 | galben (`m_galben`) | roșu (`p_rosu`) | {Y} |
| 2 | roșu (`m_rosu`) | verde (`p_verde`) | {PG} |

După faza 2 se revine în faza 0. Modulul `trecere` conectează automatul `fsm_trecere` cu numărătorul `counter` (`T` merge către numărător, `done` se întoarce la automat). Automatul nu are semnal de reset și pornește în faza 0.

**Hint**
- Consultați Laboratorul 0 pentru diagrama de tranziție a unui automat similar și propuneți o diagramă de tranziție pretabilă cerinței noastre.

Module și porturi:
- `trecere`: intrare `clk`; ieșiri `p_rosu`, `p_verde`, `m_rosu`, `m_galben`, `m_verde`
- `fsm_trecere`: intrări `done`, `clk`; ieșiri `p_rosu`, `p_verde`, `m_rosu`, `m_galben`, `m_verde`, `T` [7:0]
- `counter` (furnizat): intrări `T` [7:0], `clk`; ieșire `done`

Editați `trecere.v`, `fsm_trecere.v`. Fișiere furnizate (nu le modificați): `counter.v`. Apăsați „Run” pentru a simula proiectul cu `trecere_test.v` și „Evaluate” pentru a fi notat.""")
