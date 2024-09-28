# Practică: Implementare modul UAL

Conținutul laboratorului este present la următorul [link](https://github.com/cs-pub-ro/computer-architecture/tree/main/chapters/microprogramable_cpu/arithmetic-logic-unit/drills/alu/support).

Vom completa conținutul **modulului alu**, folosind intrările și ieșirile prezentate mai jos.

```verilog
module alu #(
    parameter p_data_width = 6, // 6 for FPGA testing, 16 for Simulation and inside the CPU
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

Codurile de identificare ale operațiilor (cei 4 biți S) sunt definite în modulul ```alu.v``` din scheletul de laborator și in codul de mai jos.

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

TODO: exaplain the remaining code

## Extra operations

### XNOR

### MUL

### DIV

### MOD