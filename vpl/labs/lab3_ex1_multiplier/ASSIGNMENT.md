# Multiplicator pe 4 biți
Implementați un multiplicator pe 4 biți **fără a folosi operatorul `*`** (înmulțire). Interfața modulului: ieșirea `prod` și intrările `a` și `b`.

**Hint-uri**
- Folosiți convenția Verilog pentru interfața modulului (mai întâi ieșirile, apoi intrările). Câți biți are ieșirea?
- Înmulțiți pe hârtie, în baza 2, numerele 1001 și 1011. Transpuneți în limbajul Verilog algoritmul folosit.

**Precizare**: evaluarea verifică și că operatorul `*` nu apare în cod (`always @(*)` este permis); în caz contrar nota este 0.

Module și porturi:
- `multiplier`: intrări `a` [3:0], `b` [3:0]; ieșiri `prod` [7:0]

Editați `multiplier.v`. Apăsați „Run” pentru a simula proiectul cu `multiplier_test.v`. Apăsați „Evaluate” pentru a fi notat.
