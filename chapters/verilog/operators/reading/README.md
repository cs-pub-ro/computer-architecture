# Descriere comportamentală

Laboratorul curent va prezenta elementele Verilog folosite pentru descrierea comportamentală. Aceasta poate descrie **ce face** circuitul și nu **cum** va fi acesta implementat. Mai mult, vom completa un modul funcțional cu un modul de testare, astfel încât să avem posibilitatea de a verifica implementarea pe care o concepem.

## Assign


Deși partiționarea circuitelor în cadrul unei arhitecturi duce la simplificarea implementării unui modul, implementarea acestuia la nivel de porți logice este rareori folosită, întrucât aceasta devine complicată și dificil de înțeles.

Primul pas este reprezentat de ușurarea modalității de scriere a unei funcții logice. Pentru aceasta, Verilog oferă o instrucțiune numită **atribuire continuă**. Aceasta folosește cuvântul cheie ''assign'' și “atribuie” unei variabile de tip ''wire'', valoarea expresiei aflată în partea dreaptă a semnului egal. Atribuirea are loc la fiecare moment de timp, deci orice schimbare a valorii expresiei din partea dreaptă se va propaga imediat.
În partea stângă a unei atribuiri continue se poate afla orice variabilă declarată de tip wire sau orice ieșire a modulului care nu are altă declarație (ex. reg). Expresiile din partea dreaptă pot fi formate din orice variabile sau porturi de intrare și de ieșire și orice operatori suportați de Verilog. 

Bazându-ne pe circuitul descris în figura de mai jos, acesta se poate scrie sub formă de atribuiri continue în următoarea formă:


| Simbol                                | Cod                                                                 |
|---------------------------------------|---------------------------------------------------------------------|
| ![Gates](../media/gates.png) | ```wire y1, y2; xor(out, y1, y2); and(y1, in1, in2); nand(y2, in3, in4, in5); ``` |

### Exemplu atribuire continuă

```verilog
module my_beautiful_module (
    output out,
    input  i1,i2,i3,i4,i5);        

          assign y1 = i1 & i2;
          assign y2 = ~(i3 & i4 & i5);

          assign out = y1 ^ y2;

endmodule
```

sau, mai concis:

```verilog
module my_beautiful_module (
    output out,
    input  i1,i2,i3,i4,i5);        

          assign out = (i1 & i2) ^  (~(i3 & i4 & i5));

endmodule
```

Se poate observa că o atribuire continuă este mult mai ușor de scris, de înțeles și de modificat decât o descriere echivalentă bazată pe instanțierea de primitive. Circuitul descris de o atribuire continuă poate fi însă relativ ușor sintetizat ca o serie de porți logice care implementează expresia dorită, unii operatori având o corespondență directă cu o poartă logică.

Este o eroare să folosiți aceeași variabilă destinație pentru mai multe atribuiri continue. Ele vor încerca simultan să modifice variabila, lucru ce nu este posibil în hardware.


## Constante


Pentru specificarea valorilor întregi este folosită următoarea sintaxă:

''[size]['radix] constant_value''

  - numerele conțin doar caracterele bazei lor și caracterul '_' 
  - pentru a ușura citirea, se poate folosi caracterul '_' ca delimitator 
  - caracterul '?' specifică impedanță mare (z) 
  - caracterul 'x' specifică valoare necunoscută 
  - se poate specifica dimensiunea numărului în biți, dar și baza acestuia (b,B,d,D,h,H,o,O - binar, zecimal, hexa, octal) 

```verilog
8'b1;         //binar, pe 8 biti, echivalent cu 1 sau 8'b00000001
8'b1010_0111; //binar, echivalent cu 167 sau 8'b10100111
4'b10;        //binar, pe 4 biti, echivalent cu 2 sau 4'b0010 etc. 
126;          //scriere in decimal
16'habcd;     //scriere in hexazecimal
```


## Operatori


Descrierea comportamentală la nivelul fluxului de date, descrisă anterior, presupune în continuare cunoașterea schemei hardware la nivelul porților logice sau, măcar, expresia logică. Deși reprezintă o variantă mai simplă decât utilizarea primitivelor, nu este cea mai facilă. 

Pentru a ușura implementarea, Verilog pune la dispoziție mai multe tipuri de operatori. Unii dintre aceștia sunt cunoscuți din limbajele de programare precum C, C++, Java și au aceeași funcționalitate. Alții sunt specifici limbajului Verilog și sunt folosiți în special pentru a descrie ușor circuite logice. Cu ajutorul acestora putem simplifica implementarea, apelând la construcții folosind limbajul de nivel înalt.

Tabelul de mai jos conține operatorii suportați de Verilog, împreună cu nivelul lor de precedență.

| Simbol                              | Funcție                        | Precedență |
|-------------------------------------|--------------------------------|------------|
| `! ~ + -` (unari)                   | Complement, Semn               | 1          |
| `**`                                | Ridicare la putere             | 2          |
| `* / %`                             | Înmulțire, Împărțire, Modulo   | 3          |
| `+ -` (binari)                      | Adunare, Scădere               | 4          |
| `<< >> <<< >>>`                     | Shiftare                       | 5          |
| `< <= > >= == !=`                   | Relaționali                    | 6          |
| `& ~& ^ ~^ ^~ | ~|`                 | Reducere                       | 7          |
| `&& ||`                             | Logici                         | 8          |
| `?:`                                | Condițional                    | 9          |
| `{,}`                               | Concatenare                    |            |

În continuare sunt prezentați operatorii mai neobișnuiți suportați de Verilog:

  - Operatorii de shiftare aritmetică; realizează shiftarea cu păstrarea bitului de semn, pentru variabilele declarate ca fiind cu semn.
    ```verilog
    wire signed[7:0] a, x, y;
    assign x = a >>> 1;  // dacă bitul de semn al lui a este 0, bitul nou
                         //introdus este 0 
                         // dacă bitul de semn al lui a este 1, bitul nou
                         // introdus este 1
    assign y = a <<< 1;  // bitul nou introdus este tot timpul 0,
                         //asemănător cu operatorul << 
    ```

  - Operatorii de reducere; se aplică pe un semnal de mai mulți biți și realizează operația logică între toți biții semnalului
    ```verilog
    wire[7:0] a; 
    wire x, y, z;
    assign x = &a;  // realizeaza AND între toți biții lui a 
    assign y = ~&a; // realizează NAND între toți biții lui a 
    assign z = ~^a; // realizeaza XNOR între toți biții lui a, 
                    // echivalent cu ^~
    ```

  - Operatorul de concatenare; realizează concatenarea a două sau mai multe semnale, într-un semnal de lățime mai mare.
    ```verilog
    wire[3:0] a, b;
    wire[9:0] x; 
    
    // biții 9:6 din x vor fi egali cu biții 3:0 ai lui b
    // biții 5:4 din x vor fi egali cu 01
    // biții 3:2 din x vor fi egali cu biții 2:1 ai lui a 
    // biții 1:0 din x vor fi egali cu 00
    assign x = {b, 2'b01, a[2:1], 2'b00};
    ```
