# Fetch
Aveti de implementat etapele de **Fetch** ale calculatorului didactic.

Apoi va trebui sa plasati in etapa de **Decode** la semnalele d, mod, reg, rm, opc.

Veti primi o ordine aleatoare in care vor fi pusi bitii din instructiune. Vi se va zice la inceputul enuntului fiecare bit ce pozitie avea in instructiunea originala

***Daca aveti |IR4| inseamna ca pozitia 15 din ir va fi asociata pozitiei 4 din instructiunea originala!***

Urmatoarele semnale fac legatura intre modulul control_unit si modulele instantiate pentru program_counter(pc), memory_address(ma), ram, instruction_register(ir).

intarile in modul sunt:

   clk - semnalul de ceas

   rst - semnalul de reset

Iesirile modulului sunt:
regs_oe - seteaza semnalul de iesire din blocul de registri generali 

regs_we - seteaza semnalul de scriere in blocul de registri generali

regs_addr - selecteaza registrul general din blocul de registri generali,

ram_we - seteaza semnalul de scriere in memoria ram 

ram_oe - seteaza semnalul de iesire din memoria ram

ma_oe - seteaza semnalul de iesire din registrul memory_address

ma_we - seteaza semnalul de scriere in registrul memory_address

pc_oe - seteaza semnalul de iesire din registrul program_counter

pc_we -  seteaza semnalul de scriere in registrul program_counter

ir_oe -  seteaza semnalul de iesire din registrul instruction_register. PENTRU A PUTEA EVALUA ETAPA DE FETCH VA TREBUI SA AVETI O STARE DUPA IN CARE SETATI ACEST SEMNAL PE 1

ir_we - seteaza semnalul de scriere in registrul instruction_register



