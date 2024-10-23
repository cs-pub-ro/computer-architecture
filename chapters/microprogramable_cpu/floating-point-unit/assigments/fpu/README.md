Implmentați modulul verilog pentru un FPU (floating point unit) cu 2 operanzi IEEE754 i_w_op1 și i_w_op2 pe 32 biți fiecare, cu rezultatul pe 32 biți o_w_out și o linie de selecție pe 3 biți a operație i_w_sel.
Operațiile sunt:

| Operation Code (i_w_sel) | Operation       |
|--------------------------|-----------------|
| 000                      | Addition        |
| 001                      | Subtraction     |
| 010                      | Multiplication  |
| 011                      | Division        |
| 100                      | Square Root     |
| 101                      | Absolute Value  |
| 110                      | Negation        |
| 111                      | Comparison      |