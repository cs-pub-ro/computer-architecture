#import "/labs/common/template.typ": callout

= Sinteza circuitelor digitale

== De ce Verilog?
Motivația studierii limbajului #raw("Verilog") în cadrul acestui laborator a fost fundamentată de capacitatea sa de a descrie comportamentul și structura circuitelor digitale. Prin nivelul său optim de #raw("abstractizare"), Verilog ne permite să ne concentrăm asupra funcționalității design-ului mai mult dectât pe detaliile de implementare, facilitând înțelegerea organizării si comunicării componentelor unui calculator, concept central al acestui curs.

Comportamentul ciclic descris printr-o abordare relativ abstractă poate fi transformat, printr-o succesiune de pași, într-o #raw("configurație logică") ce poate fi mapată direct pe hardware. Astfel, prin intermediul componentelor interactive (led-uri, switchuri, butoane etc.) conectate la la pinii acestuia, circuitul poate fi testat în condiții reale de timp, oferind o perspectivă mai realistă asupra funcționalității sale.

În cadrul acestui laborator, vom învăța cum să mapăm codul Verilog pe FPGA-ul Artix-7, obținând, prin urmare, o #raw("implementare fizică a designului proiectat").

== Ce este un FPGA?

FPGA (Field Programmable Gate Array) reprezintă un tip de circuit integrat care poate fi #raw("reprogramat de către utilizator după etapa de fabricație") pentru a îndeplini funcții specifice. Spre deosebire de circuitele logice tradiționale, precum ASIC-urile (Application-Specific Integrated Circuits), unde odată imprimat circuitul pe pastila de siliciu, nu se mai pot realiza modificări, FPGA-urile sunt proiectate ca toate componentele și rutele de care dispun sa poata fi reconfigurate prin HDL-uri precum Verilog.

Procesul de configurare exploatează conceptul de #raw("programare spațială"), tipic de limbajelor de descriere hardware.

#callout(kind: "info")[
#strong[Programarea spațială] reprezintă paradigma de proiectare în care comportamentul unui sistem este definit prin dispunerea și interconectarea componentelor logice în spațiul hardware-ului, nu prin succesiunea temporală a instrucțiunilor, precum în programarea software obișnuită. \  Aceasta presupune alocarea explicită a resurselor fizice și execuția paralelă a operațiilor.
]

Spațiul în care se poate mapa circuitul este specific fiecărui model de FPGA, motiv pentru care alegerea unei arhitecturi adecvate sistemului vizat este esențială. Arhitectura FPGA-ului #strong[Artix-7] (xc7a100t-1csg324), pe care vom încărca circuitele în cadrul acestui laborator, poate fi consultată în cadrul acestui #link("https://www.xilinxsemi.com/datasheet/xilinxsemi/XC7A100T-1CSG324C.pdf")[datasheet]. Cipul este integrat pe placa #strong[Nexys A7], a cărei structură este prezentată mai jos.


#figure(image("../media/Nexys_A7.png", width: 80%, fit: "contain", alt: "Placa Nexys A7"), caption: [Placa Nexys A7])


== Arhitectura FPGA-ului
Arhitectura generică a unui FPGA este alcătuită din celule de intrare/ieșire (I/O), conectate printr-o rețea de comutație la elemente de tipul blocuri logice configurabile, blocuri de memorie și procesoare digitale de semnal.


#figure(image("../media/FPGA_Architecture.png", width: 80%, fit: "contain", alt: "Arhitectura unui FPGA"), caption: [Arhitectura unui FPGA])


=== Blocuri logice configurabile
Recunoscute și sub denumirea de #strong[Configurable Logic Blocks] (CLB), reprezintă elementele fundamentale ale unui FPGA, fiind responsabile de implementarea logicii combinaționale și secvențiale. 

CLB-urile mai sunt numite și #raw("clustere") și sunt compuse dintr-o serie de #strong[Basic Logic Elements] (BLE-uri) și multiplexoare pentru rutarea semnalelor. 

BLE-urile sunt cele mai mici  elemente de pe FPGA și sunt formate din:
- #strong[tabele de adevăr], utilizate pentru implementarea logicii combinaționale;
- #strong[multiplexoare], utilizate pentru rutarea flexibilă a semnalelor;
- #strong[bistabili], utilizați pentru memorarea elementelor de stare și implementarea logicii secvențiale;




#figure(image("../media/BLE.png", width: 80%, fit: "contain", alt: "Structura unui BLE"), caption: [Structura unui BLE])


În figura de mai sus se poate observa un Basic Logic Element a carui logică combinațională este modelată prin intermediul tabelului de adevar cu 4 intrări. Căsuțele colorate reprezintă blocuri de memorie SRAM 16x1 pe care le putem configura, astfel, fiecare intrare posibilă are o ieșire predefinită.

Spre exemplu, pentru o memorie configurată cu valoarea 0000000000000001, circuitul va fi echivalent cu out = i3 & i2 & i1 & i0.


=== Blocuri de memorie
FPGA-urile conțin zone de memorie ce pot fi configurate ca memorie distribuită sau memorie block-RAM (BRAM).


=== Procesoare digitale de semnal
Operațiile de înmulțire pot deveni costisitoare atunci când sunt implementate exclusiv prin tabele de adevăr. Din acest motiv, arhitectura FPGA-urilor include blocuri dedicate capabile să efectueze operații aritmetice și logice complexe într-un mod mult mai rapid și eficient. 

Deși tehnologia de fabricație nu permite modificarea arhitecturii acestor blocuri, reducând astfel spațiul reconfigurabil, aceastea contribuie semnificativ la scăderea latenței circuitului. Acest #raw("trade-off") trebuie evaluat atent atunci când se alege baza hardware pentru sistemul proiectat.


=== Celule de intrare/ieșire
Acestea sunt elemente responsabile de interfațarea circuitului intern cu mediul extern; 

=== Fire de interconectare și matrici de comutație
Reprezintă o rețea care asigură legăturile atât între blocurile logice, cât și între acestea și cele de intrare/ieșire.


== Cum se configurează FPGA-ul?
Toate elementele hardware descrise anterior, pot fi configurate să execute logica dorită de noi prin intermediul unui fișier de tipul #raw(".bit"), cunoscut sub denumirea de #raw("bitstream"). 

#callout(kind: "info")[
#strong[Bitstream]-ul conține configurația internă completă a unui FPGA, incluzând conexiunile, resursele logice și setările de intrare/ieșire. 
]

Majoritatea FPGA-urilor moderne, precum seriile Xilinx Spartan și Virtex, sunt bazate pe memorie SRAM. La pornire sau în timpul unei reconfigurări ulterioare, bitstream-ul este citit dintr-un mediu de stocare nevolatil, precum memoria flash, și este încărcat în memoria internă SRAM de configurare prin intermediul controlerului de configurare al FPGA-ului.

#callout(kind: "note")[
Întrucât memoria SRAM este volatilă, conținutul bitsream-ului va rămâne valid până la întreruperea sursei de alimentare a circuitului, apăsarea butonului de reset sau suprascrierea configurației prin port-ul USB.
]

Acest fișier este generat automat de catre utilitarul folosit, în cazul nostru Vivado, iar procesul de generare presupune o serie de prelucrări în lanț, ce vor fi explicate în cele ce urmează. Însă înainte de a porni acest proces, este nevoie sa furnizăm două fișiere esențiale:
#enum(start: 1)[fișierul #raw(".v") asociat circuitului pe care dorim să îl implementăm;]
#enum(start: 2)[fișierul #raw(".xdc"), cunoscut și sub denumirea de #raw("constraint file");  ]

Fișierul menționat anterior conține o serie de comenzi Tcl ce indică compilatorului mapările directe dintre semnalele design-ului furnizat și elementele hardware pe care dorim să le utilizăm pe post de intrări, respectiv ieșiri.

```tcl
#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { SW[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { LED[0] }]; #IO_L18P_T2_A24_15 Sch=led[0] 
```
Exemplul de mai sus ilustrează maparea semnalului #strong[SW\[0\]] al modulului #strong[constrainted\_module] la pinul #strong[J15] al plăcuței, respectiv semnalul #strong[LED\[0\]] la pinul #strong[H17] al plăcuței.

```verilog
module constrainted_module (
    output [1:0] LED,
    input  [1:0] SW
);

// Logica modulului

endmodule
```

În contiuare, vom urmări pașii necesari generării bitstream-ului și modul în care design-ul nostru va fi prelucrat în acest proces.

=== Sinteză logică
Primul pas constă în transformarea descrierii HDL într-un set de porți logice si bistabili.

Astfel, această etapă va rezulta într-un graf dirijat fără cicluri, cunoscut și sub denumirea de #raw("Directed Acyclic Graph") (DAG), practic, o rețea booleană formată din porți logice, bistabili și intrări/ieșiri, așezate pe baza precedenței acestora. Fișierul asociat se numește #raw("unrouted netlist") și conține o descriere clară a primitivelor și modul în care acestea sunt conectate, însă fără informații despre plasarea efectivă pe hardware.



#figure(image("../media/Boolean_Network.png", width: 80%, fit: "contain", alt: "Rețea booleană"), caption: [Rețea booleană])


=== Mapare tehnologică

În continuare, se vor identifica subgrafurile pe care celulele de bază ale FPGA-ului le pot implementa, urmând să se selecteze un set specific de astfel de subgrafuri care acopera întregul circuit și minimizează o anumită metrică de interes, cum ar fi numărul de celule logice utilizate.


#figure(image("../media/Technology_Mapping.png", width: 80%, fit: "contain", alt: "Mapare tehnologică"), caption: [Mapare tehnologică])


=== Clustering
În urma etapei de mapare, va rezulta o serie de Basic Logic Elements, pe care dorim ca, prin faza de încapsulare, să le grupăm în clustere pentru a minimiza conexiunile externe și spori performanța internă.
Gruparea în clustere reprezintă a doua iterație de optimizare.

=== Plasare fizică
Aceasta decide unde vor fi plasate efectiv blocurile logice. În funcție de obiectivul de optimizare, plasarea poate fi:
- wire length-driven;
- routability-driven;
- timing-driven;

=== Rutare
După ce componentele au fost mapate, se începe procesul de trasare a rutelor dintre acestea. Scopul este de a minimiza aria totala ocupata de resursele de rutare și de a minimiza întârzierea pe calea critică.

În final, după ce toate etapele au fost realizate cu succes, #raw("bitstream loader")-ul va putea programa biții SRAM ai tabelelor de adevăr și ai conexiunilor dintre acestea, FPGA-ul adoptând noul comportament.
