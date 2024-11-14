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
TOP_MODULE=alu
OTHER_SOURCES=('full_alu.v')
# transform array into space separated string
OTHER_SOURCES=$(generate_other_sources ${OTHER_SOURCES[@]})
maxGrade=100
EVALUATE_FILE=evaluate.out

variation=$(generate_variation)

op_vector=(
    'ADDITION' 'SUBTRACTION' 'BITWISE_AND'
    'BITWISE_OR' 'BITWISE_XOR' 'LEFT_SHIFT'
    'RIGHT_SHIFT' 'ARITHMETIC_RIGHT_SHIFT'
    'MULTIPLY' 'DIVIDE' 'MODULUS' 'COMPARE_EQUAL'
    'COMPARE_LESS_THAN' 'COMPARE_GREATER_THAN'
    'BITWISE_NAND' 'BITWISE_NOR'
)

no_ops=$(expr ${#op_vector[@]} - 1)
# -- Set the number of operations to be implemented --
sel_ops=4
op_sel=($(generate_unique_random_numbers $sel_ops $no_ops $variation))

printf "Pentru i_w_opsel = 0, aveti de implementat operatia de %s\n" ${op_vector[${op_sel[0]}]}
printf "Pentru i_w_opsel = 1, aveti de implementat operatia de %s\n" ${op_vector[${op_sel[1]}]}
printf "Pentru i_w_opsel = 2, aveti de implementat operatia de %s\n" ${op_vector[${op_sel[2]}]}
printf "Pentru i_w_opsel = 3, aveti de implementat operatia de %s\n" ${op_vector[${op_sel[3]}]}

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
