# Parametrizarea modulelor

## Parameter

Cuvântul rezervat ''parameter'' este o construcție de limbaj în Verilog care permite unui modul să fie reutilizat cu specificații diferite. Spre exemplu, un sumator poate fi parametrizat să accepte o valoare pentru numărul de biți care poate să fie configurată diferit de la o simulare la alta. Comportamentul lor este similar cu cel al argumentelor unor funcții în alte limbaje de programare cunoscute. Folosind  ''parameter'', este declarată o valoare constantă, prin urmare, este ilegală modificarea valorii acesteia în timpul simulării. De asemenea, este ilegal ca un alt tip de dată să aibă același nume ca unul dintre parametri.

```verilog
parameter MSB = 7;       // MSB este un parametru cu valoarea constantă 7
parameter [7:0] number = 2’b11;    // o valoare de 2 biți este convertită
                                   // într-o valoare de 8 biți 
```

O variabilă de tip parametru este vizibilă local, în modulul ce a fost declarată.


## Construirea și instanțierea modulelor parametrizabile


Instanțierea modulelor a fost folosită și în laboratorul anterior pentru a invoca logica implementată într-un alt modul. În acel context, era necesar să cunoaștem dimensiunea semnalelor din interfață pentru a le potrivi cu variabilele conectate la instanță. În cazul în care un modul are dimensiunile porturilor parametrizate, acesta poate fi instanțiat  cu valori particulare ale parametrilor (diferite de cele predefinite). Să considerăm drept exemplu modulul de mai jos:

```verilog
module my_beautiful_module (out, a, b);
    output [7:0] out;
    input [3:0] a;
    input [4:0] b;

    …// some logic
endmodule
```

Pentru a instanția acest modul, vom avea nevoie de 3 variabile de 8, 4, respectiv 5 fire pe care le vom conecta astfel:

```verilog
My_beautiful_module inst1(out, a, b);
```

Pe de altă parte, având modulul:

```verilog
module my_beautiful_parameterized_module(out, a, b);
    parameter a_width = 4;
    parameter b_width = 5;
    parameter out_width = 8;

    output [out_width-1:0] out;
    input [a_width-1:0] a;
    input [b_width-1:0] b;

    …// some logic
endmodule
```

Îi putem utiliza logica fără a depinde de o dimensiune predefinită a semnalelor din interfață

```verilog
wire [4:0] out1;
wire [4:0] out2;
wire [2:0] a;
wire [1:0] b;

my_beautiful_parameterized_module #(.a_width(3),
                                    .b_width(2),
                                    .out_width(5)) inst2(out, a, b);

// Sau, menținându-se ordinea parametrilor, doar prin specificarea noilor dimensiuni:

my_beautiful_parameterized_module #(3, 2, 5) inst3(out, a, b);
```

## Macro: `define

Un macro este un nume căruia i se poate asocia o valoare înainte de compilarea codului. Macro-urile sunt utile pe post de aliasuri, fără a utiliza resursele compilatorului. Acestea nu sunt variabile, prin urmare nu pot fi atribuite valori unui macro în timpul simulării. Majoritatea limbajelor de programare, inclusiv Verilog suportă definirea de macrouri.

În Verilog, un macro este specificat cu ajutorul directivei de compilator **`define**. Aceasta înlocuiește textul definit cu o valoare specifică. Un nume de tip `define este un macro global, însemnând că dacă este declarat într-un modul, va rămâne declarat și la ieșirea din modul. După ce macroul este declarat, poate fi apelat în cod cu ajutorul caracterului ` (back-tic). Indiferent dacă sunt declarate în interiorul sau în afara unui modul, compilatorul le tratează la fel.

```verilog
`define MY_NUMBER 5
`define MY_STRING “Hello world!”
`define ADD2PLUS2 2 + 2  
```
