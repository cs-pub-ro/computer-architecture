#!/bin/bash
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

# generate_integer_value start_value=0 end_value=1000 seed=variation
generate_integer_value() {
    local start_value=0
    local end_value=1000
    local seed=0
    # act on the number of arguments
    if [ $# -gt 0 ]; then
        start_value=$1
        if [ $start_value -lt 0 ]; then
            echo "Error: start_value is negative" >&2
            return 1
        fi
        if [ $# -gt 1 ]; then
            end_value=$2
            if [ $start_value -gt $end_value ]; then
                echo "Error: start_value is greater than end_value" >&2
                return 1
            fi
            if [ $# -gt 2 ]; then
                seed=$3
            else
                seed=$(generate_variation)
            fi
        fi
    fi
    local value=$(awk -v seed="$seed" -v start_number="$start_value" -v end_number="$end_value" 'BEGIN {
        # seed
        srand(seed)
        print start_number + int((end_number - start_number) * rand())
    }')
    echo $value
    return 0
}

# generate k unique random numbers lower than the given number for the seed
# generate_unique_random_numbers k=1 number=10 seed=variation
generate_unique_random_numbers() {
    local k=1
    local number=10
    local seed=0
    if [ $# -gt 0 ]; then
        k=$1
        if [ $k -lt 1 ]; then
            echo "Error: k is lower than 1" >&2
            return 1
        fi
        if [ $# -gt 1 ]; then
            number=$2
        fi
        if [ $# -gt 2 ]; then
            seed=$3
        else
            seed=$(generate_variation)
        fi
    fi
    if [ $number -lt $k ]; then
        echo "Error: number is lower than k" >&2
        return 1
    fi
    local start_value=0
    local end_value=$(expr $number - 1)
    local op_sel=()
    local op_value=0
    local i=0
    local first_seed=$seed
    while [ $i -lt $k ];
    do
        op_value=$(generate_integer_value $start_value $end_value $seed)
        seed=$(expr $seed + 10000)
        local sem=0
        for j in "${op_sel[@]}"
        do
            if [ $op_value -eq $j ]; then
                sem=1
                break;
            fi
        done
        if [ $sem -eq 1 ]; then
            continue;
        fi
        op_sel+=($op_value)
        i=$((i + 1))
    done
    echo ${op_sel[@]}
    return 0
}

# generate solution flags from the op_sel array
# generate_solution_flags op_sel
generate_solution_flags() {
    local op_sel=("$@")
    local solution_flags=""
    for i in "${!op_sel[@]}"
    do
        solution_flags+="\ -DOP$i=${op_sel[$i]}"
    done
    echo $solution_flags
    return 0
}

# generate other sources from the array
# generate_other_sources other_sources
generate_other_sources() {
    local other_sources=("$@")
    local other_sources_str=""
    for i in "${other_sources[@]}"
    do
        other_sources_str+="\ $i"
    done
    echo $other_sources_str
    return 0
}
