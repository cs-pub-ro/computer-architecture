# Circuite combinaționale

## 1. **Sumator elementar complet** (3p)  
Implementați și simulați un **comparator pe un bit**. Acesta are **două intrări** și **3 ieșiri** (`less`, `equal`, `greater`).  

**Hint:**  
- Respectați interfața cerută în scheletul de cod.

**Expected outcome:**  
- Comparatorul trebuie să seteze corect semnalele `less`, `equal`, `greater`.  
- Testați cu toate combinațiile de intrări.

---

## 2. **Sumator pe 4 biți** (4p)  
Implementați și simulați un **sumator pe 4 biți**, cu două intrări și o ieșire (`sum[3:0]`, `cout`).  

**Hints:**  
- Utilizați **atribuirea continuă** pentru implementare.  
- Atenție la dimensiunea semnalelor de ieșire.

**Expected outcome:**  
- Rezultatul trebuie să fie corect pentru toate combinațiile de intrări.  
- `cout` trebuie setat corect pentru depășirea capacității de 4 biți.

---

## 3. **Sumator parametrizat pe n biți** (3p)  
Implementați și simulați un **sumator parametrizat pe n biți**, cu două intrări și o ieșire (`sum[n-1:0]`, `cout`). Parametrizarea se va efectua asupra dimensiunii variabilelor.  

**Hint:**  
- Observați dependența între dimensiunea variabilelor de intrare și cea de ieșire. De câți parametri este nevoie?

**Expected outcome:**  
- Sumatorul trebuie să funcționeze corect pentru orice valoare de `n`.  
- Ieșirea `sum` și `cout` trebuie să fie dimensionate corect.