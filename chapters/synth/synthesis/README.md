# Sinteza circuitelor digitale

## Ce este un FPGA?

FPGA (Field Programmable Gate Array) reprezintă un tip de circuit integrat care poate fi ``reprogramat de către utilizator după etapa de fabricație`` pentru a îndeplini funcții specifice. Spre deosebire de circuitele logice tradiționale, precum ASIC-urile (Application-Specific Integrated Circuits), unde odată imprimat circuitul pe pastila de siliciu, nu se mai pot realiza modificări, FPGA-urile sunt proiectate ca toate componentele și rutele de care dispun sa poata fi reconfigurate prin HDL-uri precum Verilog.

:::info
Desi noi facem ``RHDL``, e necesar sa cunoastem si faptul ca acesta va fi compilat intr-un fisier Verilog care o sa fie sintetizat mai departe de toolchainuri standard
:::

Procesul de configurare exploatează conceptul de ``programare spațială``, tipic de limbajelor de descriere hardware.

:::info
**Programarea spațială** reprezintă paradigma de proiectare în care comportamentul unui sistem este definit prin dispunerea și interconectarea componentelor logice în spațiul hardware-ului, nu prin succesiunea temporală a instrucțiunilor, precum în programarea software obișnuită. <br /> Aceasta presupune alocarea explicită a resurselor fizice și execuția paralelă a operațiilor.
:::

Spațiul în care se poate mapa circuitul este specific fiecărui model de FPGA, motiv pentru care alegerea unei arhitecturi adecvate sistemului vizat este esențială. Arhitectura FPGA-ului **Artix-7** (xc7a100t-1csg324), pe care vom încărca circuitele în cadrul acestui laborator, poate fi consultată în cadrul acestui [datasheet](https://www.xilinxsemi.com/datasheet/xilinxsemi/XC7A100T-1CSG324C.pdf). Cipul este integrat pe placa **Nexys A7**, a cărei structură este prezentată mai jos.

<div  align="center">

![Placa Nexys A7](../media/Nexys_A7.png)
_Figure: Placa Nexys A7_

</div>

### Pinii I/O
Modalitatea de packaging a chipului FPGA folosit este de tipul [BGA (Ball grid array)](https://en.wikipedia.org/wiki/Ball_grid_array). Acesta este indexat pe linii (cu litere) si coloane (cu cifre) 

## Arhitectura FPGA-ului
Arhitectura generică a unui FPGA este alcătuită din celule de intrare/ieșire (I/O), conectate printr-o rețea de comutație la elemente de tipul blocuri logice configurabile, blocuri de memorie și procesoare digitale de semnal.

<div  align="center">

![Arhitectura unui FPGA](../media/FPGA_Architecture.png)
_Figure: Arhitectura unui FPGA_

</div>

### Blocuri logice configurabile
Recunoscute și sub denumirea de **Configurable Logic Blocks** (CLB), reprezintă elementele fundamentale ale unui FPGA, fiind responsabile de implementarea logicii combinaționale și secvențiale. 

CLB-urile mai sunt numite și ``clustere`` și sunt compuse dintr-o serie de **Basic Logic Elements** (BLE-uri) și multiplexoare pentru rutarea semnalelor. 

BLE-urile sunt cele mai mici  elemente de pe FPGA și sunt formate din:
- **tabele de adevăr**, utilizate pentru implementarea logicii combinaționale;
- **multiplexoare**, utilizate pentru rutarea flexibilă a semnalelor;
- **bistabili**, utilizați pentru memorarea elementelor de stare și implementarea logicii secvențiale;



<div  align="center">

![Structura unui BLE](../media/BLE.png)
_Figure: Structura unui BLE_

</div>

În figura de mai sus se poate observa un Basic Logic Element a carui logică combinațională este modelată prin intermediul tabelului de adevar cu 4 intrări. Căsuțele colorate reprezintă blocuri de memorie SRAM 16x1 pe care le putem configura, astfel, fiecare intrare posibilă are o ieșire predefinită.

Spre exemplu, pentru o memorie configurată cu valoarea 0000000000000001, circuitul va fi echivalent cu out = i3 & i2 & i1 & i0.

[Ghid CLB A7](https://docs.amd.com/r/en-US/ug474_7Series_CLB/CLB-Overview)

### Blocuri de memorie
FPGA-urile conțin zone de memorie ce pot fi configurate ca memorie distribuită sau memorie block-RAM (BRAM).

[Ghid resurse memorie](https://docs.amd.com/v/u/en-US/ug473_7Series_Memory_Resources)

### Procesoare digitale de semnal
Operațiile de înmulțire pot deveni costisitoare atunci când sunt implementate exclusiv prin tabele de adevăr. Din acest motiv, arhitectura FPGA-urilor include blocuri dedicate capabile să efectueze operații aritmetice și logice complexe într-un mod mult mai rapid și eficient. 

Deși tehnologia de fabricație nu permite modificarea arhitecturii acestor blocuri, reducând astfel spațiul reconfigurabil, aceastea contribuie semnificativ la scăderea latenței circuitului. Acest ``trade-off`` trebuie evaluat atent atunci când se alege baza hardware pentru sistemul proiectat.

[DSP A7](https://docs.amd.com/v/u/en-US/ug479_7Series_DSP48E1)

### Celule de intrare/ieșire
Acestea sunt elemente responsabile de interfațarea circuitului intern cu mediul extern; 

### Fire de interconectare și matrici de comutație
Reprezintă o rețea care asigură legăturile atât între blocurile logice, cât și între acestea și cele de intrare/ieșire.


## Cum se configurează FPGA-ul?
Toate elementele hardware descrise anterior, pot fi configurate să execute logica dorită de noi prin intermediul unui fișier de tipul ``.bit``, cunoscut sub denumirea de ``bitstream``. 

:::info
**Bitstream**-ul conține configurația internă completă a unui FPGA, incluzând conexiunile, resursele logice și setările de intrare/ieșire. 
:::

Majoritatea FPGA-urilor moderne, precum seriile Xilinx Artix, Spartan și Virtex, sunt bazate pe memorie SRAM. La pornire sau în timpul unei reconfigurări ulterioare, bitstream-ul este citit dintr-un mediu de stocare nevolatil, precum memoria flash, și este încărcat în memoria internă SRAM de configurare prin intermediul controlerului de configurare al FPGA-ului.

:::note
Întrucât memoria SRAM este volatilă, conținutul bitsream-ului va rămâne valid până la întreruperea sursei de alimentare a circuitului, apăsarea butonului de reset sau suprascrierea configurației prin port-ul USB.
:::


În contiuare, vom urmări pașii necesari generării bitstream-ului și modul în care design-ul nostru va fi prelucrat în acest proces.

### Sinteză logică
Primul pas constă în transformarea descrierii HDL într-un set de porți logice si bistabili.

Astfel, această etapă va rezulta într-un graf dirijat fără cicluri, cunoscut și sub denumirea de ``Directed Acyclic Graph`` (DAG), practic, o rețea booleană formată din porți logice, bistabili și intrări/ieșiri, așezate pe baza precedenței acestora. Fișierul asociat se numește ``unrouted netlist`` și conține o descriere clară a primitivelor și modul în care acestea sunt conectate, însă fără informații despre plasarea efectivă pe hardware.


<div  align="center">

![Rețea booleană](../media/Boolean_Network.png)
_Figure: Rețea booleană_

</div>

### Mapare tehnologică

În continuare, se vor identifica subgrafurile pe care celulele de bază ale FPGA-ului le pot implementa, urmând să se selecteze un set specific de astfel de subgrafuri care acopera întregul circuit și minimizează o anumită metrică de interes, cum ar fi numărul de celule logice utilizate.

<div  align="center">

![Mapare tehnologică](../media/Technology_Mapping.png)
_Figure: Mapare tehnologică_

</div>

### Clustering
În urma etapei de mapare, va rezulta o serie de Basic Logic Elements, pe care dorim ca, prin faza de încapsulare, să le grupăm în clustere pentru a minimiza conexiunile externe și spori performanța internă.
Gruparea în clustere reprezintă a doua iterație de optimizare.

### Plasare fizică
Aceasta decide unde vor fi plasate efectiv blocurile logice. În funcție de obiectivul de optimizare, plasarea poate fi:
- wire length-driven;
- routability-driven;
- timing-driven;

### Rutare
După ce componentele au fost mapate, se începe procesul de trasare a rutelor dintre acestea. Scopul este de a minimiza aria totala ocupata de resursele de rutare și de a minimiza întârzierea pe calea critică.

În final, după ce toate etapele au fost realizate cu succes, ``bitstream loader``-ul va putea programa biții SRAM ai tabelelor de adevăr și ai conexiunilor dintre acestea, FPGA-ul adoptând noul comportament.