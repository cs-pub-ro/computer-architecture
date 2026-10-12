#!/bin/bash
#
# vpl_run.sh script - executed by VPL when the student presses "Run".
# Exercițiu personalizat: valorile se derivă din MOODLE_USER_ID și SECRET.
# La Run, VPL păstrează doar fișierele bifate în "Files to keep when running": task.py, generate.py, variation.sh.
# It does NOT grade anything.

. ./vpl_environment.sh || exit 1
if [ ! -f variation.sh ] || [ ! -f generate.py ] || [ ! -f task.py ]; then
    cat > vpl_execution <<'EEOOFF'
#!/bin/bash
echo "Configurare incompletă: la „Files to keep when running” trebuie bifate task.py, generate.py și variation.sh."
EEOOFF
    chmod +x vpl_execution
    exit 0
fi
. ./variation.sh
variation=$(generate_variation)

# Enunțul personalizat (textul se află într-un singur loc: task.py)
python3 task.py $variation > task.txt 2>/dev/null || echo "(Enunțul nu a putut fi generat.)" > task.txt

# Secretul și generatorul nu trebuie să fie accesibile codului studentului
rm -rf task.py generate.py variation.sh __pycache__

cat > vpl_execution <<'EEOOFF'
#!/bin/bash

cat task.txt
echo
echo "----------------------------------------"

# Variables
SOURCES="trecere.v fsm_trecere.v counter.v"
TESTBENCH=trecere_test.v
TOP_SIM_MODULE=trecere_test

# Generate the testbench
# Some testbenches never call $finish (free-running clock): stop the simulation ourselves
echo 'module vpl_stop; initial #10000 $finish; endmodule' > vpl_stop.v
iverilog -s ${TOP_SIM_MODULE} -s vpl_stop -o sim.vvp ${TESTBENCH} ${SOURCES} vpl_stop.v
if [ $? -ne 0 ]; then
    echo "Eroare: iverilog a eșuat"
    exit 1
fi
# Run the testbench (10s limit in case of an infinite loop)
echo "Simulare (${TESTBENCH}):"
timeout 10 vvp sim.vvp | grep -v -e '^vpl_stop.v:' -e '^vpl_tb.v:'
if [ ${PIPESTATUS[0]} -eq 124 ]; then
    echo "Eroare: simularea a depășit limita de timp (buclă infinită?)"
fi

EEOOFF

chmod +x vpl_execution
