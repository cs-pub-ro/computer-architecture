# Circuite secvențiale

## 1. **Registru elementar** (5p)

Implementați modulul `Register`, care simulează funcționarea unui registru real.  

**Hints:**  
- Semnalele `oe` și `we` reprezintă **Output Enable** și **Write Enable**.  
- `oe` controlează ieșirea registrului:  
  - dacă `oe = 1`, ieșirea este activă și afișează valoarea memorată;  
  - dacă `oe = 0`, ieșirea este `0`.  
  Acest semnal trebuie să fie **asincron**.  
- `we` controlează scrierea în registru:  
  - dacă `we = 1`, valoarea de la intrare este memorată;  
  - dacă `we = 0`, valoarea nu se modifică.  
  Acest semnal trebuie să fie **sincron** (la tranziția ceasului).  
- Semnalul `disp_out` este folosit pentru afișare/debugging și arată mereu valoarea memorată (independent de `oe`).  
- Semnalul de reset `rst_n` este activ pe `0`.  
- Puteți folosi operatorul condițional (`? :`) pentru implementare.  

**Expected outcome:**  
- Registrul memorează corect valorile la scriere și controlează ieșirea conform semnalelor `oe` și `we`.  
- Ieșirea `disp_out` reflectă permanent valoarea internă a registrului.  
- La reset (`rst_n = 0`), registrul revine la valoarea inițială.

---

## 2. **Automat secvențial pentru multiplicare și afișare** (5p)

Pornind de la interfața modulului `sequential_multiplier` din scheletul de cod, implementați un **automat de stări** care să utilizeze instanțe parametrizate ale modulului `Register`.  

**Funcționalități cerute:**  
- La activarea semnalului `write`, valorile semnalelor `a` și `b` sunt scrise în registrele corespunzătoare.  
- La activarea semnalului `multiply`, valorile sunt extrase, înmulțite, iar rezultatul este memorat într-un al treilea registru.  
- La activarea semnalului `display`, semnalul `out` va primi valoarea din al treilea registru.  
- **Prioritate semnale:**  
  1. `write` > 2. `multiply` > 3. `display`.  

**Expected outcome:**  
- Automat de stări funcțional, cu tranziții corecte între scriere, multiplicare și afișare.  
- Rezultatul multiplicării este salvat și disponibil la afișare.  
- Simulările validează că prioritățile sunt respectate.
