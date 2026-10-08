#!/usr/bin/env python3
# Grading script: compares evaluate.out (student) with sol.out (reference).
# Line format: module|a=1 b=0|sum=1 c_out=0     (key = module|inputs)
import sys

def read_lines(path):
    try:
        with open(path, "r", encoding="utf-8", errors="replace") as stream:
            return [line.strip() for line in stream if line.strip()]
    except OSError:
        return []

def parse(lines):
    table = {}
    for line in lines:
        parts = line.split("|")
        if len(parts) == 3:
            table[(parts[0], parts[1])] = parts[2]
    return table

compiled = len(sys.argv) > 1 and sys.argv[1] == "0"
expected = [l.split("|") for l in read_lines("sol.out") if l.count("|") == 2]
actual = parse(read_lines("evaluate.out"))

feedback, passed, first_fail = [], 0, None
for module, inputs, outs in expected:
    got = actual.get((module, inputs))
    if got == outs:
        passed += 1
    elif first_fail is None:
        first_fail = (module, inputs, outs, got)

total = len(expected)
if total == 0:
    feedback.append("Eroare internă: lipsește ieșirea de referință.")
    grade = 0
else:
    grade = passed * 100 // total
    if len(sys.argv) > 1 and sys.argv[1] == "2":
        feedback.append("Dimensiunile porturilor nu corespund enunțului (vezi mesajele de mai sus).")
    elif not compiled:
        feedback.append("Codul nu compilează (vezi erorile de mai sus).")
    elif first_fail:
        module, inputs, outs, got = first_fail
        feedback.append(f"Test eșuat pentru {module} ({inputs}): așteptat {outs}, obținut {got if got is not None else 'nicio ieșire'}")
    feedback.append(f"Verificări trecute: {passed} din {total}.")

with open("feedback.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(feedback) + "\n")
print(grade)
