# Practică: Implementare modul UAL

Conținutul laboratorului este prezent la următorul [link](https://github.com/cs-pub-ro/computer-architecture/tree/main/chapters/microprogramable_cpu/arithmetic-logic-unit/drills/alu/support).

Vom completa conținutul **modulului alu**, folosind intrările și ieșirile prezentate mai jos.

```verilog
module alu #(
    parameter p_data_width = 5, // 5 for FPGA testing, 16 for Simulation and inside the CPU
    parameter p_flags_width = 5
)(
    output wire [(p_data_width-1):0] o_w_out,
    output wire [(p_flags_width-1):0] o_w_flags,
    input wire [(p_data_width-1):0] i_w_op1,
    input wire [(p_data_width-1):0] i_w_op2,
    input wire [3:0] i_w_opcode,
    input wire i_w_carry,
    input wire i_w_oe
);
```

Codurile de identificare ale operațiilor (cei 4 biți S) sunt definite în modulul ```alu.v``` din scheletul de laborator și în codul de mai jos.

```verilog
localparam ADC  = 4'd0;
localparam SBB1 = 4'd1;
localparam SBB2 = 4'd2;
localparam NOT  = 4'd3;
localparam AND  = 4'd4;
localparam OR   = 4'd5;
localparam XOR  = 4'd6;
localparam SHL  = 4'd7;
localparam SHR  = 4'd8;
localparam SAR  = 4'd9;
```

## Operațiile

Partea combinațională a modulului descrie comportamentul fiecărei operații în funcție de codul operațional ``` i_w_opcode ``` prin intermediul unei structuri `case`.

### Adunarea cu carry (ADC)

Se execută adunarea celor 2 operanzi și carry, iar în cazul în care rezultatul depășește ca mărime parametrul `p_data_width`, bitul în plus activează flag-ul _carry_.

Flag-ul de _overflow_ este activat cu 2 condiții:

1. **MSB**-ul operanzilor este egal. Acest bit indică dacă operandul este un număr pozitiv sau negativ, iar suma dintre două numere de semn opus nu poate depăși intervalul lor.
2. **MSB**-ul rezultatului diferă de cel al operanzilor, indicând că a avut loc overflow-ul

```verilog
ADC: begin
    {l_r_carry, l_r_result} = i_w_op1 + i_w_op2 + i_w_carry;
    l_r_overflow = (i_w_op1[p_data_width-1] == i_w_op2[p_data_width-1]) &&
                    (i_w_op1[p_data_width-1] != l_r_result[p_data_width-1]);
end
```

### Scăderile (SBB1/SBB2)

Condițiile pentru activarea semnalelor de _carry_ și _overflow_ sunt asemănătoare cu cele din cazul adunării, cu excepția primei condiții de _overflow_, care e inversată.

```verilog
i_w_op2[p_data_width-1] != i_w_op1[p_data_width-1]
```

### Operațiile logice (AND/OR/XOR/NOT) și de shift (SHL/SHR/SAR)

Se observă că operațiile logice nu activează semnalele _carry_ și _overflow_, iar în cazul operațiilor cu un singur operand (NOT/SHL/SHR/SAR), datorită operatorului `|`, acesta se poate afla pe oricare din intrări `i_w_op1` sau `i_w_op2` cu condiția ca cealaltă să aibă valoarea **0**.

De asemenea operația `SAL` lipsește întrucât e identică cu `SHL`.

### Zero (Z), Sign (S), Parity (P)

Aceste semnale au aceleași condiții de activare indiferent de operația efectuată. De asemenea paritatea este verificată prin operatorul de reducere _XNOR_.

```verilog
l_r_zero = l_r_result == 0;
l_r_sign = l_r_result[p_data_width-1];
l_r_parity = ~^l_r_result;
```

## Extra operations

### XNOR

### MUL

### DIV

### MOD
