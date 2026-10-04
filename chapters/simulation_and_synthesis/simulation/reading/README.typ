
= Simularea circuitelor digitale

În urma #raw("compilării") unui fișier Verilog, se poate confirma doar #strong[corectitudinea sintactică] a codului, fără a se putea garanta și conformitatea funcțională a design-ului.
Prin urmare, #raw("simularea") are ca obiectiv #strong[validarea comportamentului] implementării, verificând dacă pentru un set de stimuli bine definiți se obțin rezultatele așteptate.

#figure(
  table(columns: 3, align: left,
    table.header([#strong[Etapă]], [#strong[Flux]], [#strong[Importanță]]),
    [Compilare], [Codul este analizat, erorile sunt raportate și \  sunt create fișierele intermediare.], [#strong[Depistarea timpurie a erorilor:] \  Identifică erorile de sintaxă înainte de a rula simularea.],
    [Elaborare], [Modulele sunt instanțiate, se realizează conexiunile \  și se generează structura design-ului.], [#strong[Asigurarea unui model corect:] \  Garantează ca ierarhia design-ului este corectă.],
    [Simulare], [Se aplică semnale de intrare, se obțin semnale de \  ieșire, iar comportamentul este verificat.], [#strong[Depistarea timpurie a erorilor:] \  Confirmă sau infirmă un comportament conform cu specificațiile.],
  ),
)
Pentru a realiza simularea, este necesară crearea unei platforme de test, denumita #emph[testbench]. Aceasta presupune un modul Verilog compus din trei părți:

- #strong[Generatorul de semnale], cu ajutorul căruia vom aplica stimuli design-ului;
- #strong[O instanță a design-ului], care poate fi privită ca un #raw("blackbox") prin care vor trece semnalele de intrare;
- #strong[Conexiunea la monitor], unde se va verifica corectitudinea valorilor de ieșire prin compararea acestora cu valorile așteptate;


#figure(image("../media/testbench_diagram.png", width: 80%, fit: "contain", alt: "Structura testbench-ului"), caption: [Structura testbench-ului])


Exemplul următor are rolul de a ne oferi o înțelegere mai clară asupra modului în care putem implementa un astfel de #emph[testbench] utilizând limbajul de descriere hardware #strong[Verilog].

Pentru început, trebuie să înțelegem care este #strong[scopul design-ului] pe care dorim să îl testăm, astfel reușind să ne conturăm #strong[așteptări] referitoare la ieșirile acestuia.

```verilog
 `timescale 1ns/1ps

 module incrementer ( 
            output	[4:0] out,
            input 	[3:0] in  );
      assign out = in + 1;
 endmodule
```



#figure(image("../media/incrementer_diagram.png", width: 80%, fit: "contain", alt: "Diagrama incrementer-ului"), caption: [Structura modulului incrementer])


Modulul #emph[incrementer] este un circut combinațional care primește la intrare o valoare reprezentată pe 4 biți și furnizează la ieșire aceeași valoare incrementată cu o unitate.

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
      // (denumit în industrie și "Device Under Test" sau "DUT")
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

== Construcții de limbaj esențiale în procesul de simulare

În mod conceptual, circuitele descrise de noi în Verilog au un caracter "infinit", reacționând permanent la intrări. Testbench-ul introduce o #strong[limitare temporală], definind o perioadă finită de simulare și un set clar de stimuli. Astfel, pentru a realiza simularea în mod corect, este esențială înțelegerea mecanismelor de modelare temporală.

=== Mecanisme de modelare temporală

#enum(start: 1)[#strong[Delay] \ ]
Descris de notația #raw("#n"), acesta blochează execuția simulării pentru n unități de timp înainte să execute următoarea linie de cod.

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

În acest sens devine foarte utilă directiva #raw("`timescale"). Reprezentată prin notația #raw("`timescale <time_unit>/<time_precision>"), aceasta setează doua proprietăți temporale pentru toate modulele din scope-ul curent.
- #strong[time\_unit]: Definește unitatea de măsură pentru delay-uri. 
#quote(block: true)[De exemplu, dacă #emph[time]unit\_ este setat la 1ns, atunci \#5 vor însemna 5 nanosecunde.]
- #strong[time\_precision]: Determină cel mai mic interval de timp care poate fi simulat și modul în care vor fi rotunjite delay-urile.
#quote(block: true)[De exemplu, dacă #emph[time]precision\_ este setat la 1ps, atunci simulatorul va lucra cu pași de 1 picosecundă, iar orice delay va fi rotunjit la cea mai apropiata picosecundă.]

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
#enum(start: 2)[#strong[Wait] \ ]
Descris de notația #raw("wait(condition);"), acesta blochează execuția simulării, până când condiția este îndeplinită, înainte să execute următoarea linie de cod.

```verilog
 `timescale 1ns/1ps

 module wait_example();
      reg a, b;

      initial begin 
            a = 0;
            b = 0;      
            
            wait (a == 1);    // se așteaptă până când a devine 1

            b = 1;
      end
 endmodule
```
#enum(start: 3)[#strong[Event] \ ]
Un eveniment este un obiect static folosit pentru #strong[sincronizarea între două sau mai multe procese concurente]. Un proces va declanșa evenimentul, iar un alt proces va aștepta acel eveniment.

Evenimentele sunt declanșate prin intermediul operatorului #raw("->") sau #raw("->>"), iar procesele pot aștepta apariția acestora utilizând #raw("@") sau #raw(".triggered").


```verilog
 `timescale 1ns/1ps

 module event_example();
      event a;

      initial begin 
            #20 ->a;
      end

      initial begin
            @(a);
            $display("The event has been triggered!");
      end
 endmodule
```

=== Blocul initial

Acum ca am înțeles și implementat mecanismul de modelare a timpului, următorul pas constă în #strong[încapsularea codului] într-o structură care ne oferă control complet asupra momentului în care acesta incepe și se termină.

Cea mai potrivită construcție în acest sens este blocul #raw("initial"). Acesta:
- își începe execuția la #strong[momentul de timp 0];
- rulează #strong[o singură dată], finalizându-se automat atunci când toate instrucțiunile din interior s-au finalizat sau simularea a fost încheiată dintr-un alt bloc #emph[initial].

#quote(block: true)[💡 Rețineți că blocurile #emph[initial] nu sunt sintetizabile, fiind destinate exclusiv simulării.]

În cadrul unui modul pot exista mai multe astfel de construcții, acestea executându-se în paralel. Astfel putem executa concomitent #strong[secvențe de stimuli], #strong[dinamica semnalului de ceas] și/sau #strong[monitorizarea semnalelor].


```verilog
 `timescale 1ns/1ps

 module initial_example();
      wire  [3:0] count;
      reg         clk, reset;

      counter dut (
            .count(count),
            .clk(clk),
            .reset(reset)
      );

      initial begin
            clk = 0;    // ceasul este inițializat
      end

      initial begin
            forever begin
                  #10 clk = ~clk;   // ceasul este activat periodic
            end
      end

      initial begin 
            reset <= 1'b1;    
            #200 reset <= 1'b0;     // este introdus un semnal de reset
            #200 $finish;           // se încheie simularea și implicit toate blocurile initial
      end

      initial begin
            $monitor("Time = %0t | reset = %b | clk = %b | count = %b (%0d)",
                              $time, reset, clk, count, count);   // se afișeaza valorile semnalelor
      end
 endmodule
```

=== Funcții de sistem

Funcțiile de sistem reprezintă un #strong[set de instrumente] menite să faciliteze procesul de simulare. Acestea se identifică prin prefixul #raw("$") și sunt interpretate direct de simulator, oferindu-ne o modalitate simplă de a:
- afișa mesaje și semnale;
- opri sau termina simularea;
- genera valori pseudo-aleatoare;
- obține timpul curent al simulării;
- genera fișiere VCD (Value Change Dump);

#figure(
  table(columns: 3, align: left,
    table.header([#strong[Funcție]], [#strong[Descriere]], [#strong[Exemplu]]),
    [#raw("$time")], [Returnează timpul curent al simulării ca număr întreg pe 64 de biți], [#raw("current_time = $time;")],
    [#raw("$realtime")], [Returnează timpul curent al simulării ca număr real (floating-point)], [#raw("rt = $realtime;")],
    [#raw("$random")], [Generează un număr întreg aleator cu semn pe 32 de biți], [#raw("rand_val = $random % 100;")],
    [#raw("$urandom")], [Generează un număr întreg aleator fără semn pe 32 de biți], [#raw("rand_val = $urandom % 256;")],
    [#raw("$display()")], [Afișare formatată cu linie nouă la final], [#raw("$display(\"Value: %h\", data);")],
    [#raw("$write()")], [Afișare formatată fără linie nouă], [#raw("$write(\"Loading...\");")],
    [#raw("$monitor()")], [Afișare automată când se schimbă valorile monitorizate], [#raw("$monitor(\"Time=%t, Data=%h\", $time, data);")],
    [#raw("$strobe()")], [Afișare la sfârșitul pasului de timp], [#raw("$strobe(\"Final value: %h\", data);")],
    [#raw("$finish")], [Încheie definitiv simularea], [#raw("$finish;")],
    [#raw("$stop")], [Oprește temporar simularea (poate fi reluată)], [#raw("$stop;")],
    [#raw("$dumpfile")], [Specifică fișierul în care se salvează undele (de obicei #raw(".vcd"))], [#raw("$dumpfile(\"waves.vcd\");")],
    [#raw("$dumpvars")], [Specifică ce semnale și module să fie salvate în fișierul de undă], [#raw("$dumpvars(0, top_module);")],
  ),
)
== Vizualizarea grafică a semnalelor

Până în acest moment, rezultatele simulării au fost interpretate exclusiv în format text, prin afișări în consolă. Totuși, pe măsură ce design-ul devine mai complex, iar numărul semnalelor crește, această abordare poate fi completată de o vizualizare grafică.

#raw("Formele de undă") (#emph[waveforms]) reprezintă o #strong[ilustrare grfică a variației semnalelor digitale în timp], permițând o analiză mai detaliată a evoluției acestora. 

Prin această metodă putem:
- urmări simultan mai multe semnale, observând relațiile dintre ele;
- identifica rapid anomalii sau comportamente neașteptate;
- valida sincronizarea între diverse componente ale design-ului;

Există mai multe simulatoare care facilitează generarea formelor de undă. Un ghid util care prezintă câteva dintre cele mai populare simulatoare poate fi găsit #link("https://www.rickyspears.com/technology/mastering-hdl-simulation-a-comprehensive-guide-to-the-top-4-verilog-simulators-for-beginners/")[aici].

=== Fișiere VCD

Formele de undă sunt create pe baza unor fișiere #raw("VCD") (Value Change Dump), fie generate #strong[manual] prin comenzi precum #raw("$dumpfile") și #raw("$dumpvars"), fie generate și interpretate #strong[automat] de simulatorul utilizat.

Aceste fișiere VCD nu sunt altceva decât fișiere text în format ASCII ce conțin:
- informații de antet;
- variabile predefinite;
- modificări ale valorilor variabilelor;

fiind echivalente cu înregistrarea întregii informații de simulare.

```text
$date
	Sun Sep 28 16:30:19 2025
$end
$version
	Icarus Verilog
$end
$timescale
	1ps
$end
$scope module vcd_example $end
$var wire 1 ! b $end
$var reg 1 " a $end
$scope module dut $end
$var wire 1 " a $end
$var wire 1 ! b $end
$upscope $end
$upscope $end
$enddefinitions $end
$comment Show the parameter values. $end
$dumpall
$end
#0
$dumpvars
0"
0!
$end
#1000
1!
1"
#2000
```

=== Forme de undă

Urmărind pașii descrisi în cadrul acestui #link("https://cs-pub-ro.github.io/computer-architecture/Tutoriale/Simulare%20Vivado/")[tutorial], putem vizualiza formele de undă asociate modulului #emph[incrementer], al carui testbench l-am implementat la începtul acestui laborator.


#figure(image("../media/incrementer_waveform.png", width: 80%, fit: "contain", alt: "Formele de undă ale modulului incrementer"), caption: [Waveform-ul modulului incrementer])


Analizând waveform-ul, putem observa: #strong[lista de variabile], #strong[axa timpului de simulare], #strong[valorile variabilelor la momentul de timp asociat] și #strong[marker-ul de timp].

#quote(block: true)[💡 Ordinea undelor depinde de #raw("ordinea declarării") variabilelor in modulul de test.]

#quote(block: true)[💡 Axa timpului este ilustrată pe baza unității de măsură precizată de noi prin #raw("`timescale").]

#quote(block: true)[💡 Putem vizualiza valorile în ce bază de numerație dorim prin modificarea setării #raw("radix") din cadrul simulatorului.]

#quote(block: true)[💡 Marker-ii de timp permit măsurarea intervalului dintre două evenimente din simulare. Se selectează punctul de început și, ținând apăsată tasta #raw("Shift") urmată de #raw("click"), punctul final. Simulatorul va calcula automat durata dintre acestea.]

În timpul simulării, pentru a reproduce cât mai fidel comportamentul real al hardware-ului, pe lângă valorile logice standard (0 și 1), semnalele pot adopta și valori speciale:
- #strong[#raw("X")] (Unknown), stare necunoscută, folosită atunci când simulatorul nu poate determina dacă semnalul este 0 sau 1;
- #strong[#raw("Z")] (High Impedance), indică faptul că semnalul este deconectat, fără un driver activ;

În simulare, acestea se vor regăsi în următoarea formă:


#figure(image("../media/z_x_waveform.png", width: 80%, fit: "contain", alt: "Ilustrarea valorilor X si Z"), caption: [Ilustrarea valorilor X si Z])


== Tipuri de simulare

Până în acest punct, simularea efectuată a fost de tip #strong[comportamental], reprezentând etapa inițială a procesului de validare. Scopul acesteia este de a verifica #raw("corectitudinea algoritmică a implementării") la nivel de descriere hardware (HDL).


#figure(image("../media/simulation_diagram.png", width: 80%, fit: "contain", alt: "Simularea comportamentală"), caption: [Simularea comportamentală])


În etapele ulterioare, procesul de simulare se apropie progresiv de comportamentul hardware-ului real, fiind clasificat în două categorii, în funcție de stadiul fluxului de proiectare în care se află design-ul.

#enum(start: 1)[Simularea #strong[post-sinteză] \ ]
Se realizează după etapa de sinteză, pe baza #raw("netlist")-ului rezultat. \ 
Aceasta se împarte in două categorii: 
- simulare #strong[funcțională], confirmă că procesul de sinteză nu a introdus erori logice;
- simulare #strong[temporală], adaugă un nivel suplimentar de precizie prin includerea unor timpi de întârziere estimați pentru operațiile logice;
   
#quote(block: true)[💡 Netlist-ul este o descriere structurală a design-ului, în care logica a fost deja mapată pe resursele hardware disponibile, dar #strong[fără a include încă informații precise despre plasare și rutare].]

#enum(start: 2)[Simularea #strong[post-implementare] \ ]
Se efectuează după etapa de plasare și rutare, moment în care design-ul este asociat direct cu structura fizică a dispozitivului. În acest caz, simularea se bazează pe un #raw("netlist") îmbogățit cu informații detaliate despre întârzierile reale introduse de elementele logice, conexiunile interne și traseele de rutare. 
Și aici există doua subtipuri:
- simulare #strong[funcțională], verifică păstrarea funcționalității de bază și după procesul de implementare;
- simulare #strong[temporală], oferă o imagine fidelă asupra comportamentului final al circuitului, fiind esențială pentru validarea constrângerilor de timing;

Detalii suplimentare privind etapele de sinteză și implementare vor fi prezentate în capitolul următor.
