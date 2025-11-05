# Control unit intro exercise

Se da urmatoarea structura in schelet:

<div align="center">

![Mini calculator didactic](minicd.png)

_Figure: Mini calculator didactic_
</div>

Sa se implementeze:
1. Registrul cu interfata oe,we, gasit in register.rs
2. Register File-ul, care fata de registrul normal are si o linie de selectie
3. Ram-ul, va veti folosi de SyncBRAM-ul declarat in schelet
4. Alu-ul care are doar flagul transport(carry) si zero pe langa rezultat, cu toate operatiile
5. (Exercitiu cu enuntul dat de asistent, aceste enunturi sunt exemple doar)
a. Sa se modifice unitatea de control in asa fel incat sa se adune RA cu RB
b. Sa se modifice unitatea de control in asa fel incat sa se itereze in ram de la adresa 0 pana la primul element nul, si sa se adune cu 1
