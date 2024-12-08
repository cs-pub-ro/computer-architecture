#!/bin/bash
#
# vpl_evaluate.sh script 

# github repository
# vpl
# HELPER_SCRIPTS_DIR=.
# source common_script.sh


# --- Set the variables for the assignment ---
TOP_MODULE=Exec_Checker
maxGrade=100
EVALUATE_FILE=evaluate.out

# -- Print the operations to be implemented --
iverilog -Wall -Winfloop *.v -o ${TOP_MODULE}.vvp
if [ $? -ne 0 ]; then
    echo "Error: iverilog failed" >&2
    exit 1
fi
vvp ${TOP_MODULE}.vvp > ${EVALUATE_FILE}
python3 grade.py
# # -- Generate the solution flags --
# solution_flags=$(generate_solution_flags ${op_sel[@]})

# #--- compile and run the code ---
# MAKE_CMD="make -f ${MAKEFILE} run_evaluate TOP_MODULE=${TOP_MODULE} OTHER_SOURCES=${OTHER_SOURCES} EVALUATION_FILE=${EVALUATION_FILE} SOLUTION_FLAGS=${solution_flags}"
# eval $MAKE_CMD &> error.log
# # make -f Makefile run_evaluate TOP_MODULE=${TOP_MODULE} OTHER_SOURCES=${OTHER_SOURCES} SOLUTION_FLAGS=${solution_flags}

# #--- generate the vpl_execution file to set the grade ---
# text=$(generate_evaluate_vpl_execution $EVALUATE_FILE $maxGrade)
# if [ $? -ne 0 ]; then
#     echo "Error: generate_evaluate_vpl_execution failed" >&2
#     exit 1
# fi
# echo $text