
# Simularea circuitelor digitale

În urma ``compilării`` unui fișier Verilog, se poate confirma doar **corectitudinea sintactică** a codului, fără a se putea garanta și conformitatea funcțională a design-ului.
Prin urmare, ``simularea`` are ca obiectiv **validarea comportamentului** implementării, verificând dacă pentru un set de stimuli bine definiți se obțin rezultatele așteptate.

| **Etapă** 			| **Flux** 		 | **Importanță**                                                                                                              |
|-----------------|--------------|---------------|
| Compilare       | Codul este analizat, erorile sunt raportate și <br /> sunt create fișierele intermediare.   | **Depistarea timpurie a erorilor:** <br /> Identifică erorile de sintaxă înainte de a rula simularea.             | 
| Elaborare       | Modulele sunt instanțiate, se realizează conexiunile <br /> și se generează structura design-ului.    | **Asigurarea unui model corect:** <br /> Garantează ca ierarhia design-ului este corectă.   |
| Simulare        | Se aplică semnale de intrare, se obțin semnale de <br /> ieșire, iar comportamentul este verificat.      | **Depistarea timpurie a erorilor:** <br /> Confirmă sau infirmă un comportament conform cu specificațiile.            | 

Pentru a realiza simularea, este necesară crearea unei platforme de test, denumita _testbench_. Aceasta presupune un modul Verilog compus din trei părți:

- **Generatorul de semnale**, cu ajutorul căruia vom aplica stimuli design-ului;
- **O instanță a design-ului**, care poate fi privită ca un ``blackbox`` prin care vor trece semnalele de intrare;
- **Conexiunea la monitor**, unde se va verifica corectitudinea valorilor de ieșire prin compararea acestora cu valorile așteptate;

<div  align="center">

![Structura testbench-ului](../media/testbench_diagram.png)

_Figure: Structura testbench-ului_

</div>

Exemplul următor are rolul de a ne oferi o înțelegere mai clară asupra modului în care putem implementa un astfel de _testbench_ utilizând limbajul de descriere hardware **Verilog**.

Pentru început, trebuie să înțelegem care este **scopul design-ului** pe care dorim să îl testăm, astfel reușind să ne conturăm **așteptări** referitoare la ieșirile acestuia.

```verilog
 `timescale 1ns/1ps

 module incrementer ( 
            output	[4:0] out,
            input 	[3:0] in  );
      assign out = in + 1;
 endmodule
```


<div  align="center">

![Diagrama incrementer-ului](../media/incrementer_diagram.png)

_Figure: Structura modulului incrementer_

</div>

Modulul _incrementer_ este un circut combinațional care primește la intrare o valoare reprezentată pe 4 biți și furnizează la ieșire aceeași valoare incrementată cu o unitate.

Pentru a testa daca modulul realizează într-adevar această operație, îi vom furniza 8 stimuli cărora le vom analiza ulterior rezultatul. Astfel, integrând cele trei componente menționate anterior, rezultă următorul testbench:

```verilog
 `timescale 1ns/1ps

 module testbench ();
      wire  [4:0] get_output;
      reg   [3:0] send_input;
      
      // Generatorul de semnale 
      initial begin
            send_input = 0;
            repeat (7) begin
                  #10 send_input = send_input + 1;
            end
            #10 $finish;
      end

      // Instanța modulului de testat
      // (denumit în industrie și "Device Under Test", DUT)
      incrementer dut (
            .out(get_output),
            .in(send_input)
      );

      // Conexiunea la monitor
      initial begin
            $monitor("Time = %0t | input = %b (%0d) | output = %b (%0d)",
                        $time, send_input, send_input, get_output, get_output);
      end

      initial begin
            $dumpfile("waves.vcd");  
            $dumpvars(0, testbench);
      end
 endmodule
```
Astfel, în urma simulării, putem observa următorul rezultat:

```bash
 Time = 0     | input = 0000 (0) | output = 00001 (1)
 Time = 10000 | input = 0001 (1) | output = 00010 (2)
 Time = 20000 | input = 0010 (2) | output = 00011 (3)
 Time = 30000 | input = 0011 (3) | output = 00100 (4)
 Time = 40000 | input = 0100 (4) | output = 00101 (5)
 Time = 50000 | input = 0101 (5) | output = 00110 (6)
 Time = 60000 | input = 0110 (6) | output = 00111 (7)
 Time = 70000 | input = 0111 (7) | output = 01000 (8)
 ./example/testbench.v:13: $finish called at 80000 (1ps)
```

## Construcții de limbaj esențiale în procesul de simulare

În mod conceptual, circuitele descrise de noi în Verilog au un caracter "infinit", reacționând permanent la intrări. Testbench-ul introduce o **limitare temporală**, definind o perioadă finită de simulare și un set clar de stimuli. Astfel, pentru a realiza simularea în mod corect, este esențială înțelegerea mecanismelor de modelare temporală.

1. **Delay** <br />
Descris de notația `` #n ``, acesta blochează execuția simulării pentru n unități de timp înainte să execute următoarea linie de cod.

```verilog
 `timescale 1ns/1ps

 module delay_example();
      reg a;

      initial begin 
            a = 0;      // la momentul de timp t = 0 ns a are valoarea 0
            #10 a = 1;  // la momentul de timp t = 10 ns a va avea valoarea 1
      end

 endmodule
```

Este necesar totuși să îi menționăm simulatorului și la ce ne unitate de măsură ne referim prin n:
- s (secunde)
- ms (milisecunde)
- us (microsecunde)
- ns (nanosecunde)
- ps (picosecunde)
altfel, acesta va utiliza unitatea sa implicită de măsură.

În acest sens devine foarte utilă directiva `` `timescale ``. Reprezentată prin notația `` `timescale <time_unit>/<time_precision> ``, aceasta setează doua proprietăți temporale pentru toate modulele din scope-ul curent.
- **time_unit**: Definește unitatea de măsură pentru delay-uri. 
> De exemplu, dacă _time_unit_ este setat la 1ns, atunci #5 vor însemna 5 nanosecunde.
- **time_precision**: Determină cel mai mic interval de timp care poate fi simulat și modul în care vor fi rotunjite delay-urile.
> De exemplu, dacă _time_precision_ este setat la 1ps, atunci simulatorul va lucra cu pași de 1 picosecundă, iar orice delay va fi rotunjit la cea mai apropiata picosecundă.

```verilog
 `timescale 10ns/1ns

 module timescale_example();
      reg val;

      initial begin
            val <= 0;
            #1 $display("Time = %0t at delay #1", $realtime);
            val <= 1;
            #0.49 $display("Time = %0t at delay #0.49", $realtime);
            val <= 0;
            #0.50 $display("Time = %0t at delay #0.50", $realtime);
            val <= 1;
            #0.51 $display("Time = %0t at delay #0.51", $realtime);
            val <= 0;
            #5 $display("Time = %0t End of simulation.", $realtime);
      end
 endmodule
```

Astfel, în urma simulării, putem observa următorul rezultat:

```bash
 Time = 10000 at delay #1
 Time = 15000 at delay #0.49
 Time = 20000 at delay #0.50
 Time = 25000 at delay #0.51
 Time = 75000 End of simulation.
```
2. **Wait** <br />
