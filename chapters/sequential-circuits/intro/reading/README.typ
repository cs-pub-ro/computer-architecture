= Circuite secvențiale

Spre deosebire de circuitele logice combinaționale, cele secvențiale (eng: #emph[sequential logic]) nu mai depind exclusiv de valoarea curentă a intrărilor, ci și de stările anterioare ale circuitului. 

Logica secvențială poate fi de două tipuri: #strong[sincronă] și asincronă. În primul caz, cel cu care vom lucra și la laborator, este folosit un semnal de ceas care comandă elementul/elementele de memorare, acestea schimbându-și starea doar la impulsurile de ceas. În al doilea caz, ieșirile se modifică atunci când se modifică și intrările, neexistând un semnal de ceas pentru elementele de memorare. Circuitele secvențiale asincrone sunt mai greu de proiectat deoarece pot apărea probleme de sincronizare. Din această cauză ele sunt folosite mai rar. 

În continuare ne vom referi doar la circuitele secvențiale sincrone. 


#figure(image("../media/circuit-secv.png", width: 80%, fit: "contain", alt: " Schema bloc a unui circuit secvențial sincron"), caption: [Schema bloc a unui circuit secvențial sincron])

