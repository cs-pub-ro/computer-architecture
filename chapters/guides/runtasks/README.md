# Rulare exemple practice Verilog

Exemple practice necesită aplicația Vivado 2022.1 (urmărește tutorialul de instalare sau cel pentru docker) și utlitarul make. Directoarele au o structură asemănătoare (eq. [alu](https://github.com/cs-pub-ro/computer-architecture/tree/main/chapters/microprogramable_cpu/arithmetic-logic-unit/drills/alu/support)):
 - director ```tcl_files``` unde sunt prezente scripturi ajutătoare
   - ```build.tcl``` pentru crearea proiectului ```.xpr```
   - ```run.tcl``` pentru rularea simulării și crearea fișierului de unde ```test.vcd```
   - ```simulation.tcl``` pentru vizionarea rezultatului simulării în interfață grafică.
 - ```test_*.v``` fișierul ce conține detaliile pentru simulare
 - ```*.v``` fișiere verilog necesare implementării
 - ```*.xdc``` fișierul ce conține constrângerile de pini pentru FPGA folosit în cadrul laboratorului (Nexys 4 Arty-A7-100T)
 - ```Makefile``` fișierul Makefile ce conține rețetele pentru principale comenzi

Comenzile prezente în ```Makefile``` sunt:
 - ```make build``` crează proiectul Vivado necesar.
 - ```make run``` după crearea proiectului putem rula simularea
 - ```make simulation``` după rularea simulării putem încărca grafic simularea.
 - ```make vivado``` deschiderea proeictului Vivado 2022.1 pentru modificări sau încărcarea pe FPGA conform ghidului Programare Vivado FPGA.
 - ```make clean``` ștergerea fișierelor generate de comenzile anterioare

Dacă lucrăm în Visual Studio Code sau alt editor text decât Vivado după fiecare modificare pentru a vedea rezultate noi va trebuie să rulăm ```make clean && make build```.