= Bistabilul D

Elementele de memorare din circuitele secvențiale pot fi implementate prin bistabile (eng. #emph[flip-flops]). Acestea stochează valori în funcție de valoarea de la intrare și de semnalul de ceas. Valoarea stocată poate fi schimbată doar atunci când ceasul realizează o tranziție activă (un semnal de ceas poate fi "activ" pe front crescător (eng. #emph[rising edge]) sau pe front descrescător (eng. #emph[falling edge])).

Există 4 tipuri principale de bistabile: D, T, SR și JK, iar în acest laborator ne vom axa pe bistabilul D. Acesta are un design simplu și este folosit în general pentru implementarea registrelor din procesoare (cea mai mică și mai rapidă unitate de stocare din ierarhia de memorie).


#figure(image("../media/d-flip-flop.png", width: 80%, fit: "contain", alt: " Diagrama bloc pentru bistabilul D"), caption: [Diagrama bloc pentru bistabilul D])


Intrările și ieșirile circuitului sunt:
- ''D'' - valoarea (#emph[data]) de stocat
- ''clk'' - semnalul de ceas, considerat activ pe front crescător în descrierile următoare
- ''Q'' - starea curentă
- ''!Q'' - starea curentă negată

Ca mod de funcționare, ecuația caracteristică a sa este ''Qnext = D'', adică starea următoare (''Qnext'') a bistabilului depinde doar de intrarea ''D'', fiind independentă de starea curentă (''Q''), după cum se observă și din tabelul de mai jos. 

#figure(
  table(columns: 3, align: left,
    table.header([D], [Q], [Qnext]),
    [0], [0], [0],
    [0], [1], [0],
    [1], [0], [1],
    [1], [1], [1],
  ),
  caption: [Tabelul de tranziții pentru bistabilul D],
)

Pentru a înțelege mai ușor comportamentul bistabilelor, pe lângă tabelele de tranziții mai sunt utile și diagramele de semnale (eng. #emph[timing diagrams]), cum este cea din figura de mai jos, unde se poate observa cum ieșirea ''Q'' se schimbă doar pe frontul crescător de ceas și devine egală cu intrarea ''D'' în momentul tranziției ceasului.


#figure(image("../media/d-flip-flop-timing.png", width: 80%, fit: "contain", alt: " Diagrama de semnale pentru bistabilul D"), caption: [Diagrama de semnale pentru bistabilul D])

