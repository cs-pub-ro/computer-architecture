# Circuite combinaționale

Circuitele logice combinaționale aplică funcții logice pe semnalele de intrare pentru a obține semnalele de ieșire. Valorile de ieșire depind doar de valorile de intrare, iar când starea unei intrări se schimbă, acest lucru se reflectă imediat la ieșirile circuitului.

![Diagrama bloc pentru un circuit combinațional cu n intrări și m ieșiri](../media/circuit-comb.png)



Logica combinațională poate fi reprezentată prin:
  - diagrame structurale la nivel de porți logice
  - tabele de adevăr
  - expresii booleene (funcții logice)

Circuitele combinaționale sunt folosite în procesoare în cadrul componentelor de calcul, iar cele mai des întâlnite sunt:
  - multiplexoarele și demultiplexoarele
  - codificatoarele și decodificatoarele
  - sumatoarele
  - comparatoarele
  - memoriile ROM (read-only, nu păstrează stare)

Un exemplu de folosire a sumatoarelor este în cadrul Unităților Aritmetice-Logice (UAL) din interiorul procesoarelor.

## Porți logice

Porțile logice reprezintă componentele de bază disponibile în realizarea circuitelor combinaționale. Ele oglindesc operațiile din algebra booleană, algebră care stă la baza teoriei circuitelor combinaționale. În sunt prezentate cele mai întâlnite porți logice împreună cu operația booleană pe care o implementează.

<table>
  <tr>
    <td>Denumire</td>
    <td>Simbol</td>
    <td>Operator</td>
    <td colspan='3'> Tabel de adevăr </td>
  </tr>
  <tr>
    
  </tr>
</table>


|  Denumire                             | Simbol                        |  Operator  |  <td colspan='3'> Tabel de adevăr </td>  |
|:-:|:-:|:-:|:-:|:-:|:-:|
|Inversor (NOT)|![](../media/gate-not.png)|f = !a |  <td colspan='2'>a  |  f  |
||| <td colspan='2'>  0 |  1  |
||| <td colspan='2'>  1 |  0  |

|  Poarta SAU \\ (OR)                   |  ![](../media/gate-not.png)        |  f = a %%||%% b     |  a  |  b  |  f  |
|                                   |                                     |                 |  0  |  0  |  0  |
|                                   |                                     |                 |  0  |  1  |  1  |
|                                   |                                     |                 |  1  |  0  |  1  |
|                                   |                                     |                 |  1  |  1  |  1  |
|  Poarta ŞI \\ (AND)                   |  ![](../media/gate-not.png)       |  f = a && b         |  a  |  b  |  f  |
|                                   |                                     |                 |  0  |  0  |  0  |
|                                   |                                     |                 |  0  |  1  |  0  |
|                                   |                                     |                 |  1  |  0  |  0  |
|                                   |                                     |                 |  1  |  1  |  1  |
|  Poarta \\ SAU-NU \\ (NOR)            |  ![](../media/gate-not.png)       |  f = !(a %%||%% b)  |  a  |  b  |  f  |
|                                   |                                     |                 |  0  |  0  |  1  |
|                                   |                                     |                 |  0  |  1  |  0  |
|                                   |                                     |                 |  1  |  0  |  0  |
|                                   |                                     |                 |  1  |  1  |  0  |
|  Poarta \\ ŞI-NU \\ (NAND)            |  ![](../media/gate-not.png)     |  f = !(a && b)      |  a  |  b  |  f  |
|                                   |                                     |                 |  0  |  0  |  1  |
|                                   |                                     |                 |  0  |  1  |  1  |
|                                   |                                     |                 |  1  |  0  |  1  |
|                                   |                                     |                 |  1  |  1  |  0  |
|  Poarta \\ SAU EXCLUSIV \\ (XOR)      |  ![](../media/gate-not.png)      |  f = a %%^%% b      |  a  |  b  |  f  |
|                                   |                                     |                 |  0  |  0  |  0  |
|                                   |                                     |                 |  0  |  1  |  1  |
|                                   |                                     |                 |  1  |  0  |  1  |
|                                   |                                     |                 |  1  |  1  |  0  |
|  Poarta \\ SAU EXCLUSIV NU \\ (XNOR)  |  ![](../media/gate-not.png)      |  f = !(a %%^%% b)   |  a  |  b  |  f  |
|                                   |                                     |                 |  0  |  0  |  1  |
|                                   |                                     |                 |  0  |  1  |  0  |
|                                   |                                     |                 |  1  |  0  |  0  |
|                                   |                                     |                 |  1  |  1  |  1  |
Porțile logice de bază


