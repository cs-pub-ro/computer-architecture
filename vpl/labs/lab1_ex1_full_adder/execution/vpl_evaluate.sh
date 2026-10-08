#!/bin/sh
# vpl_evaluate.sh - executed by VPL when the student presses "Evaluate".
# The student's design and the reference solution are simulated with the same
# hidden checker (top.v); the grade is the share of checker lines that match.
# Do not run this script outside VPL: it overwrites/removes execution files.
. ./vpl_environment.sh || exit 1
. ./variation.sh

# Enunțul exercițiului (textul se află într-un singur loc: task.py)
python3 task.py 2>/dev/null || echo "(Enunțul nu este disponibil în consolă; vezi pagina activității.)"
echo "----------------------------------------"

STUDENT_SOURCES="full_adder.v"
SOLUTION_SOURCES="full_adder_sol.v"

checker=$(generate_checker_unique_out)
# Prevent students from interfering with the $display calls from the checker
sed -i -e "s/\[CHECKER\]/[CHECKER: $checker]/g" top.v

# Reference compile output is NOT shown to the student (warnings would leak solution details)
iverilog -s top -o top_sol.vvp top.v $SOLUTION_SOURCES > sol_compile.log 2>&1 || { echo "Error: reference solution failed to compile" >&2; exit 1; }
iverilog -s top -o top.vvp top.v $STUDENT_SOURCES > compile.log 2>&1
student_ok=$?

# Do not let students find out [CHECKER: <hash>] prefix from just a simple grep on top.v, let them work harder for it
rm top.v

vvp top_sol.vvp | grep "^\[CHECKER: $checker\]" | sed -e "s/^\[CHECKER: $checker\]//g" > sol.out
: > evaluate.out
if [ $student_ok -eq 0 ]; then
    timeout 10 vvp top.vvp | grep "^\[CHECKER: $checker\]" | sed -e "s/^\[CHECKER: $checker\]//g" > evaluate.out
else
    cat compile.log
fi

grade=$(python3 grade.py $student_ok)
printf '#!/bin/sh\ncat feedback.txt\necho "Grade :=>> %s"\n' "$grade" > vpl_execution
chmod +x ./vpl_execution
