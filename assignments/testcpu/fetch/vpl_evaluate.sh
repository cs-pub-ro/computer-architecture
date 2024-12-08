#!/bin/bash
#
# vpl_evaluate.sh script 

# github repository
# vpl
# HELPER_SCRIPTS_DIR=.
# source common_script.sh

# source helper functions
generate_variation() {
    # get the day and hour
    variation=$(date +"%d%H")
    # make sure variation is a number
    variation=$(expr $variation + 0)
    # variation will be the same for 2 consecutive hours
    if [ $((variation % 2)) == 0 ]; then
        variation=$variation
    else
        variation=$(expr $variation - 1)
    fi
    echo $variation
    return 0
}

# --- Set the variables for the assignment ---
TOP_MODULE=checker
maxGrade=100
EVALUATE_FILE=evaluate.out

variation=$(generate_variation)
task="$(python3 genr.py $variation)"
flags=$(python3 gen_flags.py $variation)
# -- Print the operations to be implemented --
echo "$task"
iverilog -Wall -Winfloop ${TOP_MODULE}.v block_ram.v bus_interface_unit.v control_unit_sol.v control_unit.v cram.v register.v ${flags} -o ${TOP_MODULE}.vvp
if [ $? -ne 0 ]; then
    echo "Error: iverilog failed" >&2
    exit 1
fi
vvp ${TOP_MODULE}.vvp > ${EVALUATE_FILE}
python3 grade.py
chmod +x vpl_execution

