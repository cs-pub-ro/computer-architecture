# Blocul always@ edge-triggered

În afară de circuitele care depind doar schimbarea nivelului semnalului, există și circuite al căror comportament depinde de tranzițiile semnalului (activ pe _front crescător_ sau _front descrescător_). Starea bistabililor, de exemplu, se modifică pe frontul crescător sau descrescător al unui semnal de ceas. În cazul acesta, blocul ''always@'' trebuie să se execute la detecția unui astfel de front (eng. _edge-triggered_). Pentru a modela un astfel de comportament Verilog oferă cuvântul cheie **posedge** ce poate fi alăturat numelui semnalului unui semnal din lista de senzitivități pentru a indica activarea blocului ''always'' la un front al semnalului. De exemplu blocul "always @(posedge clk)" se activează pe frontul crescător al semnalului _clk_.


## Sensitivity list

Cuvintele cheie **posedge** (pentru front crescător) și **negedge** (pentru front descrescător) indică activarea blocului _always@ edge-triggered_ la schimbarea frontului semnalului.

### Exemplu sensitivity list

```verilog
always @(posedge sig)   // frontul crescător al semnalului 'sig'
always @(negedge sig)   // frontul descrescător al semnalului 'sig'
always @(posedge sig1, posedge sig2)    // frontul crescator al 
// semnalului 'sig1' sau frontul crescător al semnalului 'sig2'
always @(posedge sig1, negedge sig2)    // frontul crescător al
// semnalului 'sig1' sau frontul descrescător al semnalului 'sig2'
```


## Atribuiri non-blocante


În blocurile ''always@'' din laboratoarele precedente au fost folosite atribuirile ce utilizează operatorul "=", numite _atribuiri blocante_, deoarece se execută secvențial, ca în limbajele de programare procedurale (C, Java etc). Verilog oferă și un alt tip de atribuiri, care sunt executate toate în același timp, în paralel, indiferent de ordinea lor în bloc. Pentru a descrie un astfel de comportament se folosește operatorul "<=", iar atribuirile se numesc _atribuiri non-blocante_. Acest nou tip de atribuire **modelează concurența care poate fi întâlnită în hardware la transferarea datelor între registre**. 

Variabilele cărora li se atribuie o valoare trebuie să fie de tip registru (_reg, integer_) atât în cazul blocant cât și în cel non-blocant. Simulatorul evaluează întâi partea dreaptă a atribuirilor și apoi atribuie valorile către partea stângă. Acest lucru face ca ordinea atribuirilor non-blocante să nu conteze, deoarece rezultatul lor va depinde de ce valori aveau variabilele din partea dreaptă înainte de execuție.

### Exemplu atribuiri non-blocante ==

```verilog
always @(posedge sig) // executat pe frontul crescător al semnalului sig
begin  
    a <= b;
    b <= a;     // se interschimba valoarea lui a cu cea a lui b
    c <= d;     // toate trei atribuirile au loc în același timp
end
```

În cadrul blocurilor always care modelează logică **combinațională** se folosesc **atribuiri blocante** ("="), iar în blocurile care modelează logică **secvențială** se folosesc **atribuiri non-blocante** ("<=")

## Bistabilul D


Exemplele următoare reprezintă implementarea unui bistabil D, prezentat în laboratorul 0, care menține valoarea de intrare ("D") între două fronturi crescătoare ale semnalului de ceas ("clk"). Circuitului prezentat în laboratorul 0 i s-a adăugat și un semnal de reset ("rst_n"). Numele semnalului de reset se termină cu "_n", în mod convențional, pentru a sugera că acesta este activ pe negedge.

În exemplul de mai jos, semnalul de reset este verificat **sincron**, atribuirile făcute ieșirii Q fiind **non-blocante**. Observați că operația de reset este condiționată de valoarea "0" a semnalului "rst_n".

### Bistabilul D - reset verificat sincron

```verilog
module D_flip_flop(output reg Q, input D, clk, rst_n);
 
always @(posedge clk) begin
    if(!rst_n)
      Q <= 0;
    else
      Q <= D;
end
 
endmodule
```

Verificarea resetului se poate realiza și în mod asincron.

### Informații adiționale despre always asincron

În cel de-al doilea exemplu, semnalul este verificat **asincron**. Modulul este sintetizabil și are un comportament asemănător cu modulul asincron din al treilea exemplu. Pentru a fi sintetizabil este necesar ca toate atribuirile asupra registrului Q să fie realizate în același bloc _always_, iar blocul _always_ să fie activat pe _frontul crescător_ al semnalului _clk_ sau pe _frontul crescător_ al semnalului _!rst_n_.

### Bistabilul D - reset verificat asincron

```verilog
module D_flip_flop(output reg Q, input D, clk, rst_n);
 
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      Q <= 0;
    else
      Q <= D;
end
 
endmodule
```

Un **modul** este **nesintetizabil** dacă acesta conține atribuiri asupra aceluiași registru în mai mult de un bloc **always**.

În cel de-al treilea exemplu, este prezentat cazul în care semnalul de reset este verificat **asincron**, iar atribuirile făcute ieșirii Q sunt **blocante** în cazul în care semnalul "!rst_n" devine 1 logic sau **non-blocante** pe frontul crescător al semnalului "clk". În acest caz, se obține un modul nesintetizabil.

### Bistabilul D - reset verificat sincron (modul nesintetizabil)

```verilog
always @(posedge clk) begin
    if(rst_n)
       Q <= D;
end

always @(*) begin
    if(!rst_n)
       Q <= 0;
end
 
endmodule
```