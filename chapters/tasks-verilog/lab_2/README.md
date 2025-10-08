# Circuite combinaționale și secvențiale

## 1. **Multiplicator pe 4 biți** (3p)  
Implementați și simulați un **multiplicator pe 4 biți** fără a folosi operatorul `*`.  

**Hints:**  
- Folosiți convenția Verilog pentru interfața modulului. Câți biți are ieșirea?  
- Înmulțiți pe hârtie, în baza 2, numerele `1001` și `1011`. Transpuneți în Verilog algoritmul folosit.

**Expected outcome:**  
- Multiplicatorul trebuie să genereze rezultatul corect pentru toate combinațiile de intrări.  
- Dimensiunea semnalului de ieșire trebuie să fie corectă (`out[7:0]` pentru 4 biți x 4 biți).

---

## 2. **Unitate aritmetico-logică (UAL) pe 4 biți** (4p)  
Implementați o **UAL simplă** cu **2 operații**: adunare și înmulțire. Folosiți o **intrare de selecție de 1 bit** pentru a alege între cele două operații:  

- `0` → adunare  
- `1` → înmulțire  

**Hints:**  
- Câți biți au ieșirea sumatorului și a multiplicatorului? Dar a UAL-ului?  
- Pentru selecția dintre ieșiri se poate folosi atribuirea continuă sau un modul multiplexor 2:1.  
- Pentru utilizare generală, implementați un UAL cu operatori parametrizați pe dimensiune variabilă.  
- Atenție la dimensiunea semnalelor atunci când implementați multiplicatorul parametrizat.

**Expected outcome:**  
- UAL-ul trebuie să execute corect atât adunarea, cât și înmulțirea.  
- Intrarea de selecție trebuie să comute între operații fără erori.  
- Semnalele de ieșire trebuie dimensionate corect pentru orice dimensiune a operandului.

---

## 3. **Automat finit pentru recunoașterea secvențelor “ba”** (3p)  
Se dorește proiectarea unui **automat finit** care recunoaște secvențe de tip “ba”. Automatul primește la intrare în mod continuu caractere codificate printr-un semnal de un bit (caracterele posibile sunt "a" și "b"). Ieșirea automatului va consta dintr-un semnal care va fi activat (valoarea 1) atunci când la intrare am avut prezent un șir care se potrivește cu tiparul de căutare.

**Hints:**  
- Realizați schema automatului pe hârtie înainte de implementare.  
- Observați strategia din laboratorul 0 pentru implementarea unui automat de recunoaștere a secvențelor.  
- Adăugați starea curentă și starea următoare a automatului la diagrama de semnale.

**Expected outcome:**  
- Automat recunoaște corect toate aparițiile secvenței “ba”.  
- Diagrama de semnale reflectă comportamentul stărilor automatului.
