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
TOP_MODULE=comb
OTHER_SOURCES=('mux.v')
# transform array into space separated string
OTHER_SOURCES=$(generate_other_sources ${OTHER_SOURCES[@]})
maxGrade=100
EVALUATE_FILE=evaluate.out


variation=$(generate_variation)

# generate a random number between 0 and 255
input_value=$(generate_integer_value 0 255 $variation)

# --- Print the true table ---
seperator="------------------------------"
rows="|%5s| %5s| %5s| %7s|\n"
printf "%s\n" "$seperator"
printf "$rows" "i_w_a" "i_w_b" "i_w_c" "o_w_out"
printf "%s\n" "$seperator"
tmp_value=$input_value
for a in $(seq 0 1);
do
    for b in $(seq 0 1);
    do
        for c in $(seq 0 1);
        do
            fresult=$((tmp_value % 2))
            tmp_value=$((tmp_value / 2))
            printf "$rows" $a $b $c $fresult
        done
    done
done
printf "%s\n" "$seperator"


# -- Generate the solution flags --
solution_flags=$(generate_solution_flags $input_value)

#--- compile and run the code ---
MAKE_CMD="make -f ${MAKEFILE} run_evaluate TOP_MODULE=${TOP_MODULE} OTHER_SOURCES=${OTHER_SOURCES} EVALUATION_FILE=${EVALUATION_FILE} SOLUTION_FLAGS=${solution_flags}"
eval $MAKE_CMD &> error.log
# eval $MAKE_CMD

#--- generate the vpl_execution file to set the grade ---
text=$(generate_evaluate_vpl_execution $EVALUATE_FILE $maxGrade)
if [ $? -ne 0 ]; then
    echo "Error: generate_evaluate_vpl_execution failed" >&2
    exit 1
fi
echo $text