#!/usr/bin/env python3
# Enunțul exercițiului. Acesta este SINGURUL loc în care se modifică textul: îl afișează
# atât "Run", cât și "Evaluate" (în consolă).
# Pentru pagina activității din Moodle:  python3 task.py > ASSIGNMENT.md
import sys
sys.stdout.reconfigure(encoding="utf-8")

print(r"""# Multiplicator secvențial
1. Implementați modulul `register` pornind de la declarația din fișierul `register.v`. Semnalele `oe` și `we` reprezintă Output Enable, respectiv Write Enable.
   - `oe` controlează ieșirea registrului. Când `oe` este high, ieșirea este activă având valoarea memorată de registru. Când `oe` este low, ieșirea va fi 0. Acest semnal trebuie să fie asincron: modificarea lui va avea efect imediat asupra ieșirii și nu se va aștepta tranziția semnalului de ceas.
   - `we` controlează scrierea în registru. Când `we` este high, registrul va memora valoarea aflată în semnalul de intrare. Când `we` este low, valoarea registrului nu se va modifica, ignorând practic semnalul de intrare. Acest semnal trebuie să fie sincron: modificarea valorii memorate de registru se face doar în momentul tranziției semnalului de ceas.
   - Semnalul `disp_out` este folosit pentru afișare/debugging pe display, iar valoarea acestuia trebuie să fie cea memorată de registru în momentul curent. Acest semnal nu trebuie să fie afectat de `oe`, valoarea disponibilă pe `disp_out` fiind în orice moment egală cu valoarea memorată de registru.
   - Semnalul de reset `rst_n` este activ pe low (0).
   - *Hint*: Puteți folosi operatorul condițional.
2. Parametrizați modulul `register` (parametrul `width`) astfel încât data de intrare și ieșire din registru să aibă o dimensiune configurabilă.
   - *Hint*: Utilizați construcția de limbaj `parameter`.
3. Pornind de la interfața modulului `sequential_multiplier` din schelet, implementați un automat de stări care să folosească instanțe parametrizate ale modulului `register` pentru a îndeplini următoarele funcționalități:
   - La activarea semnalului `write` să se scrie pe câte un registru (parametrizat corespunzător) valorile semnalelor `a` și `b`.
   - La activarea semnalului `multiply` să fie extrase valorile din cele două registre, să se înmulțească și să se adauge pe un al treilea registru.
   - La activarea semnalului `display`, semnalul `out` să primească valoarea aflată pe cel de-al treilea registru.
   - Prioritatea celor trei semnale este dată de ordinea în care au fost descrise (ex: dacă `write` este activ, se ignoră semnalele `multiply` și `display`; dacă `multiply` este activ, se ignoră semnalul `display`).

**Precizări**: parametrii lui `sequential_multiplier` sunt `a_width` (8), `b_width` (4) și `product_width` (= `a_width + b_width`, lipsește din schelet și trebuie declarat). Ordinea porturilor lui `register` este cea din fișierul `register.v`.

Module și porturi:
- `register` (parametru `width`): intrări `clk`, `rst_n`, `oe`, `we`, `in`; ieșiri `out`, `disp_out`
- `sequential_multiplier`: intrări `clk`, `rst_n`, `a` [7:0], `b` [3:0], `write`, `multiply`, `display`; ieșire `out` [11:0]

Editați `register.v`, `sequential_multiplier.v`. Apăsați „Run” pentru a simula proiectul cu `sequential_multiplier_test.v`. Apăsați „Evaluate” pentru a fi notat.""")
