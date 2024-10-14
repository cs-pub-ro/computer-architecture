# Practică:

## 1. **Sumator elementar complet**, utilizând sumatoare elementare parțiale.
  Soluția se află în repo-ul materiei [GitHub](https://github.com/cs-pub-ro/computer-architecture/tree/main/chapters/verilog/basic/drills/tasks/fulladder). Implementarea unui sumator elementar parțial se poate găsi în fișierul `halfadder.v`, iar sumatorul elementar complet în `fulladder.v`. Observați modul în care sunt declarate sumatoarele elementare parțiale.
  ```verilog
  halfadder l_m_halfadder_0( .o_w_s(l_w_s0), .o_w_cout(l_w_c0), .i_w_a(i_w_a), .i_w_b(i_w_b) );
  halfadder l_m_halfadder_1( .o_w_s(o_w_s), .o_w_cout(l_w_c1), .i_w_a(i_w_cin), .i_w_b(l_w_s0) );
  ```
  Pentru a crea proiectul putem folosi comanda ```make build```. Pentru simulare ```make simluation``` și pentru a deschide întreg proiectul în Vivado și a avea posibilitatea de a încărca pe FPGA ```make vivado```.

## 2. **Sumator pe 4 biți**, cu două intrări și două ieșiri.
  Soluția se află în repo-ul materiei [GitHub](https://github.com/cs-pub-ro/computer-architecture/tree/main/chapters/verilog/basic/drills/tasks/adder_4bits). Rulați simulare (```make simluation```) și verificați corectitudinea sumatorului vizualizând semnalele în baza 10. 

## 3. **Sumator pe 6 biți**, cu două intrări și o ieșire.
  Soluția se află în repo-ul materiei [GitHub](https://github.com/cs-pub-ro/computer-architecture/tree/main/chapters/verilog/basic/drills/tasks/adder_6bits). Încărcați programul pe FPGA (```make vivado```), urmărind ghidul.

## 4. **Comparator** pe un bit.
  Acesta are două intrări și trei ieșiri (pentru mai mic, egal și mai mare). Soluția se află în repo-ul materiei [GitHub](https://github.com/cs-pub-ro/computer-architecture/tree/main/chapters/verilog/basic/drills/tasks/comparator). Simulați și încărcați pe FPGA.


## Test
  Aveți următorul tabel de adevăr:

  | a | b | c | f |
  | - | - | - | - |
  | 0 | 0 | 0 | 1 |
  | 0 | 0 | 1 | 0 |
  | 0 | 1 | 0 | 0 |
  | 0 | 1 | 1 | 0 |
  | 1 | 0 | 0 | 1 |
  | 1 | 0 | 1 | 1 |
  | 1 | 1 | 0 | 1 |
  | 1 | 1 | 1 | 0 |

  Intrările sunt: `a`, `b`, `c`, iar ieșirea este `f`. Implementați modulul Verilog definit de acest tabel de adevăr.
