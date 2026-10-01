#!/bin/sh
# vpl_run.sh - executed by VPL when the student presses "Run".
# Shows the student's personalized LUT and simulates their lut.v with the
# student-visible testbench test_lut.v. Does NOT grade anything.
. ./vpl_environment.sh || exit 1
. ./variation.sh

variation=$(generate_variation)

# Same task text as in "Evaluate"
python3 task.py $variation > task.txt || exit 1

# Evaluation-only files are not needed here
rm -rf top.v lut_sol.v gen_flags.py grade.py generate.py __pycache__

iverilog -Wall -Winfloop test_lut.v lut.v -o test_lut.vvp
if [ $? -ne 0 ]; then
    echo "Error: iverilog failed" >&2
    exit 1
fi

cat > vpl_execution <<'EEOOFF'
#!/bin/sh
cat task.txt
echo
echo "Simulation (test_lut.v):"
vvp test_lut.vvp
EEOOFF
chmod +x vpl_execution