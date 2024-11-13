#!/bin/bash
#
# vpl_evaluate.sh script 

# github repository
HELPER_SCRIPTS_DIR=../../common
# vpl
# HELPER_SCRIPTS_DIR=.
# source common_script.sh

# source helper functions
source ${HELPER_SCRIPTS_DIR}/variation.sh
source ${HELPER_SCRIPTS_DIR}/grade.sh
MAKEFILE=${HELPER_SCRIPTS_DIR}/Makefile

# --- Set the variables for the assignment ---
TOP_MODULE=X
OTHER_SOURCES=('a.v' 'b.v' 'c.v')
# transform array into space separated string
OTHER_SOURCES=$(generate_other_sources ${OTHER_SOURCES[@]})
maxGrade=100
EVALUATE_FILE=evaluate.out

variation=$(generate_variation)

# -- Define the operations --
op_vector=(
    'a' 'b' 'c' 'd'
)

no_ops=$(expr ${#op_vector[@]} - 1)
# -- Set the number of operations to be implemented --
sel_ops=2
op_sel=($(generate_unique_random_numbers $sel_ops $no_ops $variation))

# -- Print the operations to be implemented --
printf "Pentru 0, aveti de implementat %s\n" ${op_vector[${op_sel[0]}]}
printf "Pentru 1, aveti de implementat %s\n" ${op_vector[${op_sel[1]}]}

# -- Generate the solution flags --
solution_flags=$(generate_solution_flags ${op_sel[@]})

#--- compile and run the code ---
MAKE_CMD="make -f ${MAKEFILE} run_evaluate TOP_MODULE=${TOP_MODULE} OTHER_SOURCES=${OTHER_SOURCES} EVALUATION_FILE=${EVALUATION_FILE} SOLUTION_FLAGS=${solution_flags}"
# eval $MAKE_CMD &> error.log
eval $MAKE_CMD
# make -f Makefile run_evaluate TOP_MODULE=${TOP_MODULE} OTHER_SOURCES=${OTHER_SOURCES} SOLUTION_FLAGS=${solution_flags}

#--- generate the vpl_execution file to set the grade ---
text=$(generate_evaluate_vpl_execution $EVALUATE_FILE $maxGrade)
if [ $? -ne 0 ]; then
    echo "Error: generate_evaluate_vpl_execution failed" >&2
    exit 1
fi
echo $text
