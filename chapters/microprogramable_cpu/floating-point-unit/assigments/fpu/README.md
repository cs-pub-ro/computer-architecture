# Assigment - FPU

Implmentați modulul verilog pentru un FPU (floating point unit) cu 2 operanzi IEEE754 i_w_op1 și i_w_op2 pe 32 biți fiecare, cu rezultatul pe 32 biți o_w_out și o linie de selecție pe 3 biți a operație i_w_opsel. 
Operațiile sunt:

| Operation Code (i_w_opsel) | Operation       | Result  |
|--------------------------|-----------------|-------|
| 000                      | Addition        | op1 + op2    |
| 001                      | Subtraction     | op1 - op2    |
| 010                      | Multiplication  | op1 * op2     |
| 011                      | Division        | op1 / op2     |
| 100                      | Negation        | -op1     |
| 101                      | Absolute Value  | \|op1\|   |
| 110                      | Less than       | op1 < op2    |
| 111                      | Equal           | op1 == op2   |