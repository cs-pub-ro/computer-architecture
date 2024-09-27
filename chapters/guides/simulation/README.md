# Simulare modul în Vivado

Pentru acest tutorial vom presupune că ați creat un modul cu numele "task01" într-un fișier cu numele "task01.v". Pentru a simula acest modul urmăriți următorii pași:

1. Din fereastra **Flow Navigator** apăsați pe Add Sources 
![Add Sources](../media/simulate_module1.png)
sau apăsați click dreapta oriunde în fereastra **Sources** și apoi Add Sources 
![exemplu1](../media/simulate_module1.1.png).
Același rezultat poate fi obținut și prin apăsarea combinației de taste **Alt+A**.
2. După ce fereastra de Add Sources s-a deschis, selectați "Add or create simulation sources" și apăsați Next.
![exemplu2](../media/simulate_module2.png)
3. Apăsați apoi Create File și alegeți un nume pentru fișierul vostru de test, de exemplu: task01_tb.v (**tb** de la **testbench**), apăsați "Ok" și apoi Finish
![exemplu3](../media/simulate_module4.png).
4. Dacă se va deschide o nouă fereastră "Define Module" apăsați "Ok" 
![exemplu4](../media/simulate_module5.png)
5. Apoi "Yes" - pentru că e vorba de un fișier de simulare nu avem nevoie de porturi de intrare/ieșire.
![exemplu5](../media/simulate_module6.png)
6. Ar trebui să observați în fereastra **Sources** un nou fișier: task01_tb.v
![aici1](../media/simulate_module7.png).
7. Ștergeți conținutul predefinit al fișierului task01_tb.v și înlocuiți-l cu cel din această imagine:
![imagine](../media/simulate_module8.png).
8. Prima linie **`timescale 1ns/1ps** specifică unitatea de măsură și precizia simulării. În interiorul modulului de test regăsim variabilele (**in**) de tip **reg** ce se vor lega la porturile de intrare pentru modulul pe care îl testăm. Mai jos regăsim instanțierea modului. Numai după ce adăugăm această instanțiere, structura ierarhică din fereastra Sources se schimbă ca:
![aici2](../media/simulate_module8.png).
9. În continuare vom adăuga diverse valori de test pentru variabilele legate la porturile de intrare ale modulului pe care îl vom testa. De exemplu: pornim cu **in** setat la **1**, așteptăm 200 de unități de timp (200ns în cazul nostru) și apoi setăm **in** la **0** ș.a.m.d.
![exemplu6](../media/simulate_module8.1.png).
10. Salvăm fișierul task01_tb.v (**Ctrl+S**).
11. Pentru a rula simularea: click pe "Run Simulation" și apoi pe "Run Behavioral Simulation"
(![exemplu7](../media/simulate_module9.png)).
12. Se va deschide o nouă fereastră de simulare împărțită în 3: **Scope & Sources**, **Objects & Protocol Instances** și fișier "Untitled 1" de tip Waveform configuration file (.wcfg) unde vom vedea valorile porturilor. Pentru a adăuga și portul "out" în fișierul .wcfg vom da click la "Scope" pe "task01_instance" (1), apoi vom apăsa și menține pe obiectul "out" mutându-l în dreapta (2), iar în final vom relansa simularea cu cele două semnale de interes. Vedeți pașii descriși.
![aici3](../media/simulate_module10.png)
13. Simularea se va reîncărca.
![reîncărca](../media/simulate_module11.png)
14. Rezultatul final se poate vedea dacă apăsăm pe Zoom Fit.
![Zoom Fit](../media/simulate_module12.png).
15. În final putem verifica vizual dacă semnalele au valorile pe care le așteptăm:
![exemplu corect](../media/simulate_module13.png).


Dacă aveți sugestii de îmbunătățire a acestei pagini vă rog să trimiteți sugestiile pe mail la [dosarudaniel@gmail.com](mailto:dosarudaniel@gmail.com). Studenții implicați vor fi recomensați cu puncte bonus.