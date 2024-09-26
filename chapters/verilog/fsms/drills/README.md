# Practice: Automate Finite

 - Se dorește proiectarea unui automat finit capabil să recunoască secvențe de tip “ba”. Automatul primește la intrare în mod continuu caractere codificate printr-un semnal de un bit (caracterele posibile sunt “a” și “b”). Ieșirea automatului va consta dintr-un semnal care va fi activat (valoarea 1) atunci când la intrare am avut prezent un șir care se potrivește cu tiparul de căutare.
Implementați automatul în Verilog.
Hint: Realizați pe hârtie schema automatului de stări, pentru a o folosi ulterior ca referință.
Hint: Observați în laboratorul 0 strategia abordată pentru implementarea unui automat ce recunoaște o secvență de caractere.
Simulați automatul folosind modulul de test din scheletul de cod. Eliminați semnalele nerelevante (is și count) din diagrama de semnale. Adăugați starea automatului și starea următoare a automatului la diagrama de semnale.
Hint: Semnalele pot fi eliminate din diagrama de semnale cu click dreapta→Delete pe semnalul care se dorește a fi eliminat.
Hint: Semnale noi pot fi adăugate la diagrama de semnale prin drag-and-drop din fereastra Simulation Objects for …, care conține toate semnalele modulului selectat în fereastra Instance and Process Name.
Hint: Simularea trebuie repornită prin Simulation→Restart urmat de Simulation→Run pentru a vedea comportamentul semnalelor adăugate.
Urmăriți diagrama de semnale și codul automatului și explicați comportamentul. Urmăriți și explicați funcționarea modulului de test.
 - Se dorește realizarea unei treceri de pietoni semaforizate. Duratele de timp pentru cele 2 culori vor fi: roșu - 60 sec, verde - 30 sec.
Implementați și simulați în Verilog automatul necesar. Ce rol are modulul trecere din fișierul trecere.v?
Hint: Consultați laboratorul 0 pentru diagrama de tranziție a unui automat similar și propuneți o diagramă de tranziție pretabilă cerinței noastre
Explicați codul numărătorului din fișierul counter.v.
Hint: Urmăriți comportarea acestuia pe diagrama de semnale.
