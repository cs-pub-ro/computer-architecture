# Trecere de pietoni semaforizată
Se dorește realizarea unei treceri de pietoni semaforizate. Duratele de timp ale culorilor (pentru pietoni și pentru mașini) diferă de la student la student și se afișează în consolă la „Run”. Ceasul `clk` are frecvența de 1 Hz, deci o secundă înseamnă un ciclu de ceas.

Automatul `fsm_trecere` stabilește, în fiecare stare, culorile și durata fazei `T` (în secunde), pe care o încarcă în numărătorul `counter` (furnizat). Când `done` = 1, automatul trece în faza următoare. Modulul `trecere` conectează automatul cu numărătorul. Automatul nu are semnal de reset și pornește în faza 0.

**Hint**
- Consultați Laboratorul 0 pentru diagrama de tranziție a unui automat similar și propuneți o diagramă de tranziție pretabilă cerinței noastre.

Editați `trecere.v`, `fsm_trecere.v`. Fișiere furnizate (nu le modificați): `counter.v`. Valorile specifice fiecărui student se afișează în consolă la „Run” și „Evaluate”. Apăsați „Run” pentru a simula proiectul cu `trecere_test.v`. Apăsați „Evaluate” pentru a fi notat.
