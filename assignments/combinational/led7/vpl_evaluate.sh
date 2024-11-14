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
TOP_MODULE=led7
OTHER_SOURCES=('led7conv.v')
# transform array into space separated string
OTHER_SOURCES=$(generate_other_sources ${OTHER_SOURCES[@]})
maxGrade=100
EVALUATE_FILE=evaluate.out

variation=$(generate_variation)

# generate 4 unique random numbers between 0 and 9
digit_vector=(
    '0' '1' '2' '3'
    '4' '5' '6' '7'
    '8' '9'
)
no_digits=$(expr ${#digit_vector[@]} - 1)
# -- Set the number of unique digits--
unique_digits=4
digit_sel=($(generate_unique_random_numbers $unique_digits $no_digits $variation))

# -- Print the digits to be implemented --
printf "Pentru i_w_digit = 0, aveti de implementat cifra %s\n" ${digit_vector[${digit_sel[0]}]}
printf "Pentru i_w_digit = 1, aveti de implementat cifra %s\n" ${digit_vector[${digit_sel[1]}]}
printf "Pentru i_w_digit = 2, aveti de implementat cifra %s\n" ${digit_vector[${digit_sel[2]}]}
printf "Pentru i_w_digit = 3, aveti de implementat cifra %s\n" ${digit_vector[${digit_sel[3]}]}
# -- Generate the solution flags --
solution_flags=$(generate_solution_flags ${digit_sel[@]})

#--- compile and run the code ---
MAKE_CMD="make -f ${MAKEFILE} run_evaluate TOP_MODULE=${TOP_MODULE} OTHER_SOURCES=${OTHER_SOURCES} EVALUATION_FILE=${EVALUATION_FILE} SOLUTION_FLAGS=${solution_flags}"
# eval $MAKE_CMD &> error.log
eval $MAKE_CMD


#--- generate the vpl_execution file to set the grade ---
text=$(generate_evaluate_vpl_execution $EVALUATE_FILE $maxGrade)
if [ $? -ne 0 ]; then
    echo "Error: generate_evaluate_vpl_execution failed" >&2
    exit 1
fi
echo $text