# Practice: Operators

  Soluția se află în repo-ul materiei [GitHub](https://github.com/cs-pub-ro/computer-architecture/tree/main/chapters/verilog/operators/drills/tasks). 

 - Implementați și simulați un comparator pe 4 biți. Acesta are două intrări și 3 ieșiri (pentru mai mic, egal și mai mare).
Hint: Unei variabile îi poate fi atribuită valoarea unei expresii logice.
Hint: Considerând experiența exercițiului 2, există vreo posibilitate să parametrizați comparatorul?
 - Implementați și simulați un multiplexor 4:1. Urmăriți diagrama de semnale generată:
Hint: Consultați laboratorul 0 pentru implementarea unui multiplexor 4:1.
Hint: Respectați interfața cerută în scheletul de cod.
   - Implementați multiplexorul folosind ecuația logică dedusă din tabelul de adevăr.
   - Implementați multiplexorul folosind operatorul condițional ‘?’
Hint: Operatorul poate apărea de mai multe ori într-o expresie. ex: assign x = (a == 0) ? 1 : ( (a == 1) ? : 2 : 0 );