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
MAKEFILE=Makefile

# --- Set the variables for the assignment ---
TOP_MODULE=fsm
OTHER_SOURCES=
maxGrade=100
EVALUATE_FILE=evaluate.out
SEQUENCE_FILE=sequence.txt

variation=$(generate_variation)


# Sequence Generator for a, b, c, groups, and special characters
generate_sequences() {
    # Define the inputs, special characters, and groupings
    inputs=("a" "b" "c")
    special_chars=("+" "*")
    groupings=("ab" "bc" "ca" "ac" "cb")

    # Loop over combinations to generate valid sequences
    for i in "${inputs[@]}"; do
        for j in "${inputs[@]}"; do
            for k in "${inputs[@]}"; do
                for group in "${groupings[@]}"; do
                    for char in "${special_chars[@]}"; do
                        # Ensure sequence doesn't start with special character
                        echo "$i($group)$char"
                        echo "$i$char($group)"
                        echo "($group)$char$i"
                        echo "$i$char$group"
                        echo "($group)$i$char"
                        echo "$char$i($group)"
                    done
                done
            done
        done
    done
}

# Generate the sequence
sequences=($(generate_sequences))

# Select a random sequence
sequence_index=$(generate_integer_value 0 $(expr ${#sequences[@]} - 1) $variation)
selected_sequences=${sequences[${sequence_index}]}

echo "SECVENTA=$selected_sequences"
echo $selected_sequences > $SEQUENCE_FILE

#--- compile and run the code ---
MAKE_CMD="make -f ${MAKEFILE} run_evaluate TOP_MODULE=${TOP_MODULE} EVALUATION_FILE=${EVALUATION_FILE} SEQUENCE_FILE=${SEQUENCE_FILE}"
eval $MAKE_CMD &> error.log
# eval $MAKE_CMD
#--- generate the vpl_execution file to set the grade ---
text=$(generate_evaluate_vpl_execution $EVALUATE_FILE $maxGrade)
if [ $? -ne 0 ]; then
    echo "Error: generate_evaluate_vpl_execution failed" >&2
    exit 1
fi
echo $text