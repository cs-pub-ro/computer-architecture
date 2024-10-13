# Circuite secvențiale

Spre deosebire de circuitele logice combinaționale, cele secvențiale (eng: _sequential logic_) nu mai depind exclusiv de valoarea curentă a intrărilor, ci și de stările anterioare ale circuitului. 

Logica secvențială poate fi de două tipuri: **sincronă** și asincronă. În primul caz, cel cu care vom lucra și la laborator, este folosit un semnal de ceas care comandă elementul/elementele de memorare, acestea schimbându-și starea doar la impulsurile de ceas. În al doilea caz, ieșirile se modifică atunci când se modifică și intrările, neexistând un semnal de ceas pentru elementele de memorare. Circuitele secvențiale asincrone sunt mai greu de proiectat deoarece pot apărea probleme de sincronizare. Din această cauză ele sunt folosite mai rar. 

În continuare ne vom referi doar la circuitele secvențiale sincrone. 

<div align="center">

![ Schema bloc a unui circuit secvențial sincron](../media/circuit-secv.png)

_Figure: Schema bloc a unui circuit secvențial sincron_

</div>