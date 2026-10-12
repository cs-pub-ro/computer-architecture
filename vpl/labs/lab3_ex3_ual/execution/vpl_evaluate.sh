#!/bin/sh
# vpl_evaluate.sh - executed by VPL when the student presses "Evaluate".
# Exercițiu personalizat: checker-ul și soluția de referință se generează pentru fiecare student (generate.py).
# The student's design and the reference solution are simulated with the same hidden checker (top.v);
# the grade is the share of checker lines that match.
# Do not run this script outside VPL: it overwrites/removes execution files.
. ./vpl_environment.sh || exit 1
. ./variation.sh
variation=$(generate_variation)

# Enunțul personalizat (textul se află într-un singur loc: task.py)
python3 task.py $variation 2>/dev/null || echo "(Enunțul nu a putut fi generat.)"
echo "----------------------------------------"

STUDENT_SOURCES="ual.v"
SOLUTION_SOURCES="ual_sol.v"

checker=$(generate_checker_unique_out)
python3 generate.py $variation eval || { echo "Error: generation failed" >&2; exit 1; }
# SECRET and the generators must not be reachable by student code
rm -rf task.py generate.py variation.sh __pycache__

# Prevent students from interfering with the $display calls from the checker
sed -i -e "s/\[CHECKER\]/[CHECKER: $checker]/g" top.v

# Reference compile output is NOT shown to the student (warnings would leak solution details)
iverilog -s top -o top_sol.vvp top.v $SOLUTION_SOURCES > sol_compile.log 2>&1 || { echo "Error: reference solution failed to compile" >&2; exit 1; }
iverilog -s top -o top.vvp top.v $STUDENT_SOURCES > compile.log 2>&1
student_ok=$?
# Porturile trebuie să aibă exact dimensiunile din enunț (altfel un modul mai larg ar trece pentru orice student)
if [ $student_ok -eq 0 ] && grep -q "expects [0-9]* bits, got" compile.log; then
    echo "Dimensiunile porturilor nu corespund enunțului:"
    grep "expects [0-9]* bits, got" compile.log | sed -e 's/^[^ ]* warning: Port [0-9]* (\([^)]*\)) of \([^ ]*\) expects \([0-9]*\) bits, got \([0-9]*\)\./- portul \1 al modulului \2 are \3 biți, dar ar trebui să aibă \4 biți./'
    student_ok=2
fi

# Do not let students find out [CHECKER: <hash>] prefix from just a simple grep on top.v, let them work harder for it
rm top.v

vvp top_sol.vvp | grep "^\[CHECKER: $checker\]" | sed -e "s/^\[CHECKER: $checker\]//g" > sol.out
: > evaluate.out
if [ $student_ok -eq 0 ]; then
    timeout 10 vvp top.vvp | grep "^\[CHECKER: $checker\]" | sed -e "s/^\[CHECKER: $checker\]//g" > evaluate.out
elif [ $student_ok -ne 2 ]; then
    cat compile.log
fi

grade=$(python3 grade.py $student_ok)
printf '#!/bin/sh\ncat feedback.txt\necho "Grade :=>> %s"\n' "$grade" > vpl_execution
chmod +x ./vpl_execution
