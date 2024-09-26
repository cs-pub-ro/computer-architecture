# Debouncer

Elementele de memorare (stare) ale circuitului se modelează printr-un bloc activ pe frontului semnalului de ceas. În blocul combinațional trebuie tratate toate stările posibile ale automatului, semnalele de ieșire și tranzițiile din aceste stări.

```verilog
module fsm(output reg out, input in, clk, reset_n);
reg [2:0] state, next_state;

// partea secvențială
always @(posedge clk) begin
    if (reset_n == 0) state <= 0;
    else state <= next_state;
end

// partea combinationala
always @(*) begin
    out = 0;
    case (state)
        0:   if (in == 0) begin 
                 next_state = 1;
                 out = 1;
             end
             else next_state = 2;
        1:   if (in == 0) begin
                 next_state = 3;
                 out = 1;
             end
             else next_state = 4;         
    ...
    endcase
end
endmodule
```

<note important>Nu combinați blocurile secvențiale cu cele combinaționale (e.g. "always @(posedge clk, state, in)") deoarece majoritatea utilitarelor nu vor sintetiza corect un astfel de circuit.
</note>


## Expresii regulate


Expresiile Regulate sunt secvențe de caractere ce definesc un tipar de căutare, folosite în multe cazuri pentru identificarea șirurilor sau sub-șirurilor de caractere ce se potrivesc cu expresia.
Cea mai simplă metodă de vizualizare a unei expresii regulate este prin intermediul Automatelor Finite de stări.

Pentru a descrie un tipar care conține un sub-șir între zero și nelimitate ori, este utilizat cuantificatorul "*", iar pentru a descrie un tipar care conține un sub-șir între una și nelimitate ori, este utilizat cuantificatorul "+".

Parantezele "(" ")" sunt folosite pentru a delimita grupuri de caractere. Dacă acestea nu sunt specificate, cuantificatorul va avea efect asupra caracterului anterior.

### Exemple:

```
a(bc)*  -  se va potrivi cu șirurile de caractere 'a', 'abc', 'abcbc', 'abcbcbc' etc.
(ab)+c  -  se va potrivi cu șirurile de caractere 'abc', 'ababc', 'abababc' etc.
ab+a    -  se va potrivi cu șirurile de caractere 'aba', 'abba', 'abbba' etc.
```

<note important>Nu confundați operatorii "*" și "+" cu înmulțire și adunare. În contextul expresiilor regulate, aceștia sunt folosiți pentru a descrie tipare de căutare și **NU** sunt folosiți pentru a scrie cod Verilog.
</note>


## Debouncing


Atunci când un buton este apăsat sau un switch este comutat, două părți metalice intră în contact pentru a permite curentului să treacă. Cu toate acestea, ele nu se conectează instantaneu, ci se conectează și deconectează de câteva ori înainte de realizarea conexiunii propriu-zise. Același lucru se întâmplă și în momentul eliberării unui buton (când acesta nu mai este apăsat). Acest fenomen poate conduce la comutări false sau modificări multiple nedorite asupra semnalului și este denumit **bouncing**.

Prin urmare, se poate spune că fenomenul de "bouncing" nu este un comportament ideal pentru niciun switch care execută mai multe tranziții ale unei singure intrări. Aceasta nu este o problemă majoră când avem de-a face cu circuite de putere, dar poate cauza probleme atunci când avem de-a face cu circuitele logice sau digitale. Așadar, pentru a elimina oscilațiile din semnal cauzate de acest fenomen se folosește principiul de **Switch Debouncing**.
