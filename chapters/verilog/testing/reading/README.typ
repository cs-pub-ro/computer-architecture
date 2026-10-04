= Testare

Pentru testarea unui modul folosind simulatorul se creează module speciale de test, în care, printre altele, se vor atribui valori intrărilor. Simularea permite detecția rapidă a erorilor de implementare și corectarea acestora. 

Pentru a crea un modul de test și a-l simula puteți urma tutorialul de simulare #link("https://cs-pub-ro.github.io/computer-architecture/Tutoriale/Simulare%20Vivado/")[aici], iar această secțiune va prezenta câteva din construcțiile de limbaj pe care le puteți folosi într-un astfel de modul. 



#figure(image("../media/circuit_tb.png", width: 80%, fit: "contain", alt: "Diagrama testare circuit"), caption: [Diagrama testare circuit])


== Blocul initial


Blocurile #emph[initial] descriu un comportament executat o singură dată la începerea/activarea simulării și sunt folosite pentru inițializări și în module de test. Instrucțiunile sale trebuie încadrate între cuvintele cheie #emph[begin] și #emph[end] și sunt executate secvențial.

```verilog
initial begin 
    a = 0; 
    b = 1; 
    #10; _ delay 10 unități de timp de simulare 
    a = 1; 
    b = 0; 
end 
```

Blocurile #emph[initial] nu sunt sintetizabile, fiind folosite doar în simulări.


== Sincronizarea prin întârziere


Folosind operatorul #emph[\#] se poate specifica o durată de timp între apariția instrucțiunii și momentul executării acesteia. Aceasta este utilă pentru a separa temporal diversele atribuiri ale intrărilor. Durata de timp este reprezentată prin unități de timp de simulare. De exemplu, dacă simularea folosește un #emph[timescale] în nanosecunde, #emph[\#n] va reprezenta n nanosecunde.


== Afișare


Atât în modulele de test cât și în modulele testate se pot folosi construcții pentru afișare în interiorul blocurilor #emph[initial] și #emph[always]. Una dintre aceste instrucțiuni este #emph[display]:

```verilog
$display(arguments);
```

Argumentele acestei comenzi sunt similare cu cele ale funcției #emph[printf] din C, ca în exemplul de mai jos, iar specificația completă o puteți găsi #link("https://www.chipverify.com/verilog/verilog-display-tasks")[aici]. #emph[\$display] adaugă o linie nouă, iar dacă nu se dorește acest lucru se poate folosi comanda #emph[\$write]. 

```verilog
a = 1; b = 4;

$display("suma=%d", a+b);
```
