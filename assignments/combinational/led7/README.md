# 7-LED Segment DIGIT
Implementați un modul verilog care să afișeze in funcție de o intrare de selecție una din cele 4 cifre date (XYZT).

Intrările modulului sunt:
 - i_w_sel - ce cifră se va afișa (2 biți)

Ieșirele modulului sunt:
 - o_w_ca - linia ca din 7-led segment
 - o_w_cb - linia cb din 7-led segment
 - o_w_cc - linia cc din 7-led segment
 - o_w_cd - linia cd din 7-led segment
 - o_w_ce - linia ce din 7-led segment
 - o_w_cf - linia cf din 7-led segment
 - o_w_cg - linia cg din 7-led segment

Ca sa aflați cele 4 cifre XYZT apăsați butonul "evaluate" din VPL.

Pentru valorile i_w_sel:
 - i_w_sel = 2'd0, se va afișa cifra T
 - i_w_sel = 2'd1, se va afișa cifra Z
 - i_w_sel = 2'd2, se va afișa cifra Y
 - i_w_sel = 2'd3, se va afișa cifra X

Avem un 7-led segment cu anod comun și ieșirele vor fi active când vor avea valoarea 1'b0.

Mai jos puteți vedea cum sunt poziționate linile cx ale 7-led segment.

![7-LED-SEGMENT](media/led7.jpg)

Mai jos puteți vedea cum sunt afișate cifrele zecimale pe un 7-led segment.

![7-LED-DIGITS](media/7leddigits.png)