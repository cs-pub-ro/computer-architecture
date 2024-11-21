# Practice: Debouncer


  Soluția se află în repo-ul materiei [GitHub](https://github.com/cs-pub-ro/computer-architecture/tree/main/chapters/verilog/operators/drills/tasks). 
  
  - Se dorește proiectarea unui automat finit capabil să recunoască secvențe de tip "ba". Automatul primește la intrare în mod continuu caractere codificate printr-un semnal de un bit (caracterele posibile sunt "a" și "b"). Ieșirea automatului va consta dintr-un semnal care va fi activat (valoarea 1) atunci când la intrare am avut prezent un șir care se potrivește cu tiparul de căutare.
    - Implementați automatul în Verilog.
      * _Hint_: Realizați pe hârtie schema automatului de stări, pentru a o folosi ulterior ca referință. 
    - Simulați automatul folosind modulul de test din scheletul de cod. Eliminați semnalele nerelevante (_is_ și _count_) din diagrama de semnale. Adăugați starea automatului și starea următoare a automatului la diagrama de semnale.
      * _Hint_: Semnalele pot fi eliminate din diagrama de semnale cu _click dreapta->Delete_ pe semnalul care se dorește a fi eliminat.
      * _Hint_: Semnale noi pot fi adăugate la diagrama de semnale prin _drag-and-drop_ din fereastra _Simulation Objects for ..._, care conține toate semnalele modulului selectat în fereastra _Instance and Process Name_.
      * _Hint_: Simularea trebuie repornită prin _Simulation->Restart_ urmat de _Simulation->Run_ pentru a vedea comportamentul semnalelor adăugate.
    - Urmăriți diagrama de semnale și codul automatului și explicați comportamentul. Urmăriți și explicați funcționarea modulului de test.
  - Se dorește realizarea unei treceri de pietoni semaforizate. Duratele de timp pentru cele 2 culori vor fi: roșu - 60 sec, verde - 30 sec.
    - Implementați și simulați în Verilog automatul necesar. Ce rol are modulul _trecere_ din fișierul _trecere.v_?
    - Explicați codul numărătorului din fișierul _counter.v_.
      * _Hint_: Urmăriți comportarea acestuia pe diagrama de semnale.

