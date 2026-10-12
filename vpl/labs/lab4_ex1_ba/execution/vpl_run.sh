#!/bin/bash
#
# vpl_run.sh script - executed by VPL when the student presses "Run".
# This script only generates ./vpl_execution, which compiles the student's
# files together with the student-visible testbench and shows the simulation.
# It does NOT grade anything.

# Enunțul exercițiului: se afișează în consolă, ca să nu fie nevoie să reveniți la pagina activității.
# Textul se află într-un singur loc: task.py. La Run, VPL păstrează doar fișierele bifate în
# "Files to keep when running" (aici: task.py).
python3 task.py > task.txt 2>/dev/null || echo "(Enunțul nu este disponibil în consolă; vezi pagina activității.)" > task.txt

cat > vpl_execution <<'EEOOFF'
#!/bin/bash

cat task.txt
echo
echo "----------------------------------------"

# Variables
SOURCES="ba.v"
TESTBENCH=ba_test.v
TOP_SIM_MODULE=ba_test

# Generate the testbench
# Some lab testbenches never call $finish (free-running clock): stop the simulation ourselves
echo 'module vpl_stop; initial #1000 $finish; endmodule' > vpl_stop.v
iverilog -s ${TOP_SIM_MODULE} -s vpl_stop -o sim.vvp ${TESTBENCH} ${SOURCES} vpl_stop.v
if [ $? -ne 0 ]; then
    echo "Eroare: iverilog a eșuat"
    exit 1
fi
# Run the testbench (10s limit in case of an infinite loop)
echo "Simulare (${TESTBENCH}):"
timeout 10 vvp sim.vvp | grep -v '^vpl_stop.v:'
if [ ${PIPESTATUS[0]} -eq 124 ]; then
    echo "Eroare: simularea a depășit limita de timp (buclă infinită?)"
fi

EEOOFF

chmod +x vpl_execution
