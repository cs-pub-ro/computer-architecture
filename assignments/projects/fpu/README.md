# FPU

Implmentați modulul verilog pentru un FPU (floating point unit) cu 2 operanzi 32-bits IEEE754.

Intrările sunt:
 - i_w_op1 - primul operand (32 de biți)
 - i_w_op2 - al doilea operand (32 biți)
 - i_w_opsel - linie de selecție a operației (3 biți)

Ieșirea este:
 - o_w_out - rezultatul operației între cei doi operanzi (32 biți)

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

Standardul IEEE754 poate fi găsit la următorul [link](https://curs.upb.ro/2024/mod/resource/view.php?id=46321).

Pentru a vă ajuta în rezolvare avem următoarele materiale video:
 - [Reprezentare IEEE754](https://ctipub-my.sharepoint.com/:v:/g/personal/stefan_dan_ciocirlan_upb_ro/EdT8OQWyXc9MvafVmUvP1_wBW3bESoQJ7kAXzvPbNLJyYg?e=rXFLan&nav=eyJwbGF5YmFja09wdGlvbnMiOnt9LCJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJTdHJlYW1XZWJBcHAiLCJyZWZlcnJhbE1vZGUiOiJtaXMiLCJyZWZlcnJhbFZpZXciOiJwb3N0cm9sbC1jb3B5bGluayIsInJlZmVycmFsUGxheWJhY2tTZXNzaW9uSWQiOiJlN2FhMThmZi02ZDk0LTQ5YWMtYWM0NC0yMDRmNGMyNTA4MjEifX0%3D)
 - [Adunare IEEE754](https://ctipub-my.sharepoint.com/:v:/g/personal/stefan_dan_ciocirlan_upb_ro/EZ1mlBsUVxRApccFv7Rj4JQBrZwYJ1JCb80YVsfhyqgWkw?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=t23cOK)
 - [Scădere IEEE754](https://ctipub-my.sharepoint.com/:v:/g/personal/stefan_dan_ciocirlan_upb_ro/EYp6Tk2nUONPiySrwgjl83EBahG2wOaPyreZWE2EQ3mFDw?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=lVwmop)
 - [Înmulțire IEEE754](https://ctipub-my.sharepoint.com/:v:/g/personal/stefan_dan_ciocirlan_upb_ro/EcWX-oXDWU5KnyecEDasxjoBHSzzf-8NvoZyCfo8Ca_9fg?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=qbElkD)
 - [Împărțire 1 IEEE754](https://ctipub-my.sharepoint.com/:v:/g/personal/stefan_dan_ciocirlan_upb_ro/EVWvarvhvUZAlG80QO32SaQByTHOZLsjb5z6TDz1iio1gg?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=pm3lPI)
 - [Împărțire 2 IEEE754](https://ctipub-my.sharepoint.com/:v:/g/personal/stefan_dan_ciocirlan_upb_ro/EaU-1JasofxGpIesR43Od7wBQI93emIt51zO4YVaFstI4Q?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=HNlxCk)
 - [Operații Relaționale IEEE754](https://ctipub-my.sharepoint.com/:v:/g/personal/stefan_dan_ciocirlan_upb_ro/EeCqdJoCAaxBq0f0fjSPbTMBbRsiFfuubVkHrR7qb4Aa4A?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=eXKb4E)
 - [Rounding 1 IEEE754](https://youtu.be/wbxSTxhTmrs?t=529)
 - [Rounding 2 IEEE754](https://www.youtube.com/watch?v=8EYBJhQoDNc)

