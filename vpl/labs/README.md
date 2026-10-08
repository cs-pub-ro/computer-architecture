# VPL setups for the Verilog labs (lab1 - lab5)

One folder per exercise, same scheme as `verilog_vpl_moodle_setup`: `execution/`, `requested/`, `ASSIGNMENT.md`, `README.md`.
Each folder's `README.md` has the Moodle steps (what to upload where, the maximum number of files, which files to keep at Run, ...).
`ASSIGNMENT.md` (paste it as the activity description) and all messages shown to students are in Romanian, adapted from the lab PDFs
(requirements and hints; everything about running/viewing simulations in ISE was left out).

## How every exercise works
- **The assignment text lives in one place: `execution/task.py`.** Both `vpl_run.sh` and `vpl_evaluate.sh` call it, so it is printed in the console at the top of **Run** and **Evaluate**.
- **Run** compiles the student's files with a testbench and prints the simulation. Stops after 10 s of real time.
- **Evaluate** simulates the student's design **and the reference solution** with the same hidden checker (`top.v`, with the `[CHECKER: hash]` trick) and grades the share of matching checks. The student sees the first failing check and "Verificări trecute: X din Y".
- **Files to keep when running** (Moodle setting, per activity): see the last column of the table. Without them Run only shows a short note instead of the text.
- Change `SECRET` in each `execution/variation.sh` right before publishing.

## Exercises
| Folder | Requested files | Max files | Checks | Checker | Files to keep when running |
|---|---|---|---|---|---|
| `lab1_ex1_full_adder` | `full_adder.v`, `full_adder_test.v` | 2 | 12 | combinational | task.py |
| `lab1_ex2_adder4` | `adder4.v`, `adder4_test.v` | 2 | 256 | combinational | task.py |
| `lab1_ex3_adder_n` | `adder.v` | 1 | per student | combinational (personalized) | task.py, generate.py, variation.sh |
| `lab1_ex4_comp1` | `comp1.v` | 1 | per student | combinational (personalized) | task.py, generate.py, variation.sh |
| `lab2_ex1_adder4` | `adder4.v`, `adder4_test.v` | 2 | 256 | combinational | task.py |
| `lab2_ex2_generic_adder` | `generic_adder.v`, `generic_adder_test.v` | 2 | 692 | combinational | task.py |
| `lab2_ex3_comp4` | `comp4.v` | 1 | per student | combinational (personalized) | task.py, generate.py, variation.sh |
| `lab2_ex4_mux4_1` | `mux4_1.v` | 1 | per student | combinational (personalized) | task.py, generate.py, variation.sh |
| `lab3_ex1_multiplier` | `multiplier.v`, `multiplier_test.v` | 2 | 256 | combinational | task.py |
| `lab3_ex2_seven_seg` | `seven_seg.v`, `seven_seg_test.v` | 2 | 10 | combinational | task.py |
| `lab3_ex3_ual` | `ual.v` | 1 | per student | combinational (personalized) | task.py, generate.py, variation.sh |
| `lab3_ex4_ual_generic` | `ual.v` | 1 | per student | combinational (personalized) | task.py, generate.py, variation.sh |
| `lab4_ex1_ba` | `ba.v`, `ba_test.v` | 2 | 400 | FSM, cycle-exact | task.py |
| `lab4_ex2_trecere` | `counter.v`, `fsm_trecere.v`, `trecere.v`, `trecere_test.v` | 4 | per student | FSM, cycle-exact (personalized) | task.py, generate.py, variation.sh |
| `lab5_ex1a_mealy_fsm` | `mealy_fsm.v`, `mealy_fsm_test.v` | 2 | 477 | FSM, cycle-exact | task.py |
| `lab5_ex1b_moore_fsm` | `moore_fsm.v`, `moore_fsm_test.v` | 2 | 477 | FSM, cycle-exact | task.py |
| `lab5_ex2_sequential_multiplier` | `register.v`, `sequential_multiplier.v`, `sequential_multiplier_test.v` | 3 | 120 | lab protocol | task.py |
| `lab5_ex3_ram_reader` | `ram.v`, `ram_reader.v`, `ram_reader_test.v` | 3 | 64 | lab protocol | task.py |

## Personalized exercises (last two exercises of lab1-lab4, except lab4 ex1; lab5 is standard)
Each student gets his own values, derived from `MOODLE_USER_ID` and `SECRET` (`generate_variation` in `variation.sh`; no date involved, so the statement never changes for a student).
`generate.py` turns the hash into the values, `task.py` prints the statement, and at **Evaluate** `generate.py` also writes the hidden checker (`top.v`) and the reference solution for that student.

| Exercise | What varies | Variants |
|---|---|---|
| lab1 ex3 `adder` | width N of the adder: 5, 6, 7, 9, 10 or 11 (output has N+1 bits) | 6 |
| lab1 ex4 `comp1` | `o1`, `o2`, `o3` compute 3 different relations among <, <=, =, !=, >=, > | 120 |
| lab2 ex3 `comp4` | same 3-relation choice, plus unsigned or signed (two's complement) operands | 240 |
| lab2 ex4 `mux4_1` | which input is selected for each `s2 s1` (a permutation of i1..i4) and whether the output is inverted | 48 |
| lab3 ex3 `ual` | an ordered pair of operations (sel=0, sel=1) among add, multiply, subtract, AND, OR, XOR, max, min | 56 |
| lab3 ex4 `ual` | another pair (never the same as in ex3, if the same `SECRET` is used), and the default value of `width` (3, 4, 5, 6 or 8) | ~275 |
| lab4 ex2 `trecere` | durations: cars green 30-70 s, yellow 5-15 s, pedestrians green 20-45 s (pedestrians red = green + yellow) | 150 |

- **Use the same `SECRET` in all personalized activities and do not change it after students started** (their values depend on it; lab3 ex4 also relies on it to differ from lab3 ex3).
- **Collisions:** the hash does not guarantee distinct values. With 150 students, lab1 ex3 uses all 6 variants, lab2 ex4 about 46 of 48, lab3 ex3 about 52 of 56, and lab1 ex4 about 84 of 120.
- **Student-visible testbench:** for the six exercises whose interface changes, the testbench for Run is generated for the student (`vpl_tb.v`) and is not a requested file, so the students cannot edit it. `trecere` keeps the lab testbench.
- **Port widths are enforced:** the checker reports "portul X al modulului Y are N biți, dar ar trebui să aibă M biți" and the grade is 0 if a port width differs from the statement (otherwise a wider module, e.g. an 11-bit adder, would pass for every smaller N).
- **The secret is not reachable by student code:** `variation.sh`, `generate.py` and `task.py` are deleted before any student code is compiled or simulated, both at Run and at Evaluate (checked with `$fopen`).
- To see a student's values locally: `python3 execution/generate.py <hash> dump`.
- Verified on 40 distinct variants per exercise (all 6 for the adder): the reference gives 100 with no `x`/`z`, another student's reference gives less than 100, an empty skeleton gives 0; alternative correct styles (ripple adder with a loop, `case` based UAL and multiplexer) give 100.

## Things to know (all exercises)
- **Behaviour not in the lab text was taken from the reference solutions** and written into the assignment where grading depends on it: the `ba` timing (Moore: `o` = 1 right after the edge that reads the `a` of "ba"), the structure of the `trecere` phases (cars green / yellow / red, matching pedestrians red / green), the `ual` operations and `sel`, the parameter names `op_width` / `width`, and the Mealy/Moore tables (checked against the figures in the lab 5 PDF).
- **`seven_seg`** is checked only for digits 0-9, as the lab says; the student's `default` case is free.
- **`multiplier` (lab3 ex1)** must not use the `*` operator (as the lab says): Evaluate gives 0 if it appears in the code (`always @(*)` and comments are ignored).
- **Resets:** the lab's own FSM examples use asynchronous reset, so `mealy_fsm` / `moore_fsm` accept both synchronous and asynchronous reset.
- **FSM exercises `ba`, `trecere`, `mealy_fsm`, `moore_fsm` are graded cycle-exact against the reference**, sampling the outputs before and after every rising clock edge. `sequential_multiplier` and `ram_reader` reuse the lab testbench's own protocol and timing.
- **Files I had to create.** `ual.v` (lab3 ex3/ex4), `mealy_fsm.v` and `moore_fsm.v` have no skeleton in the zips, so their skeletons contain just the port list (for `ual.v` ex4 the default of `width` is left to the student). Lab2 ex1/ex2, lab3 ex2, lab5 ex1a/1b and lab5 ex2 have no testbench in the `*_skel` zips, so the one from the `*_sol` zip is given to students.
- **Self-contained files.** Exercises that reuse earlier modules (lab1 ex2/ex3, lab3 ex3/ex4) ask students to paste them into the single requested file.
- **Testbench fix.** In the self-checking lab testbenches (lab1 ex1, lab5 ex2, lab5 ex3) `!=` was changed to `!==`; otherwise an empty skeleton (outputs `x`/`z`) was reported as "Success" by Run.
- **RAM (lab5 ex3).** The Xilinx Block RAM IP cannot be simulated with iverilog, so `ram.v` is a behavioral stand-in (1024 x 16, one cycle read latency, contents of `ram.mif`). It is given as a requested file; Evaluate uses its own copy.
- **Not included:** FPGA-only files (`.ucf`, `*_top.v`, `debouncer.v`, `divider.v`, ISE project files, simulation outputs) and the explanation-only questions of the labs.
- **Simulator caveat.** iverilog does not evaluate an `always @(*)` block at time 0 when it only reads variables with declaration initializers. Designs written that way can show `x` in iverilog although they work in ISim. The lab solutions do not have this problem.
