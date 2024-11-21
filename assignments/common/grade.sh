#!/bin/bash

# compute grade based on the evaluate file and max grade
compute_grade() {
    if [ $# -lt 1 ]; then
        echo "Error: compute_grade needs evaluation file" >&2
        return 1
    fi
    local EVALUATE_FILE=$1
    if [ ! -f $EVALUATE_FILE ]; then
        echo "Error: $EVALUATE_FILE does not exist" >&2
        return 1
    fi
    local max_grade=100
    if [ $# -gt 1 ]; then
        max_grade=$2
    fi
    #--- remove multiple spaces ---
    cat $EVALUATE_FILE | sed 's/  */ /g' > tmp.out
    mv tmp.out $EVALUATE_FILE

    #--- remove blank lines ---
    cat $EVALUATE_FILE | sed '/^\s*$/d' > tmp.out
    mv tmp.out $EVALUATE_FILE
    rm -f tmp.out

    # Calculate number of correct test versus wrong test
    local correct_test_no=$(awk '$1=="OK" { print $0 }' $EVALUATE_FILE | wc -l | awk '{ print $1 }')
    local test_no=$(wc -l $EVALUATE_FILE | awk '{ print $1 }')
    local grade=$(expr $correct_test_no \* $max_grade / $test_no)

    echo $grade
    return 0
}

# generate evaluate vpl_execution file
generate_evaluate_vpl_execution() {
    if [ $# -lt 2 ]; then
        echo "Error: generate_evaluate_vpl_execution needs evaluation file and max grade" >&2
        return 1
    fi
    local EVALUATE_FILE=$1
    local max_grade=$2
    local grade=$(compute_grade $EVALUATE_FILE $max_grade)
    if [ $? -ne 0 ]; then
        return 1
    fi
    echo "#!/bin/bash" > vpl_execution
    # if not max grade print the first error line
    if [ $grade -lt $max_grade ] ; then
        local text=$(awk '$1!="OK" { print $0 }' $EVALUATE_FILE | awk 'NR==1 { print $0 }')
        echo "echo '$text' " >> vpl_execution
        echo $text
    else
        echo "OK"
    fi
    echo "echo 'Grade :=>> $grade' " >> vpl_execution
    chmod +x vpl_execution
    return 0
}
