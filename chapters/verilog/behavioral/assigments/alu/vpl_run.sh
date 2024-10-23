#!/bin/bash
#
# vpl_run.sh script 

cat > vpl_execution <<EEOOFF
#!/bin/bash

# Variables
TOP_MODULE=alu
TOP_SIM_MODULE=test_\$TOP_MODULE
OTHER_SOURCES=

variation=\$(date +"%d%H")
if [ \$((variation % 2)) == 0 ]; then
    variation=variation
else
    variation=\$(expr \$variation - 1)
fi


op_vector=('ADDITION' 'SUBTRACTION' 'AND' 'OR' 'XOR' 'LEFT_SHIFT' 'RIGHT_SHIFT' 'ARITHMETIC_RIGHT_SHIFT' 'MULTIPLY' 'DIVIDE' 'MODULUS' 'COMPARE_EQUAL' 'COMPARE_LESS_THAN' 'COMPARE_GREATER_THAN' 'NAND' 'NOR')
op_sel=()
op_value=\$variation
i=0
while [ \$i -lt 4 ];
do
    start_value=0
    end_value=15
    op_value=\$(awk -v seed="\$op_value" -v start_number="\$start_value" -v end_number="\$end_value" 'BEGIN {
        # seed
        srand(seed)
        print start_number + int((end_number - start_number) * rand())
    }')
    sem=0
    for j in "\${op_sel[@]}"
    do
        if [ \$op_value -eq \$j ]; then
            sem=1
            break;
        fi
    done
    if [ \$sem -eq 1 ]; then
        continue;
    fi
    op_sel+=(\$op_value)
    i=\$((i + 1))
done

printf "Pentru i_w_in = 0, aveti de implementat operatia de %s\n" \${op_vector[\${op_sel[0]}]}
printf "Pentru i_w_in = 1, aveti de implementat operatia de %s\n" \${op_vector[\${op_sel[1]}]}
printf "Pentru i_w_in = 2, aveti de implementat operatia de %s\n" \${op_vector[\${op_sel[2]}]}
printf "Pentru i_w_in = 3, aveti de implementat operatia de %s\n" \${op_vector[\${op_sel[3]}]}

# Generate the testbench
iverilog -o \${TOP_MODULE}.vvp \${TOP_MODULE}.v \${TOP_SIM_MODULE}.v \${OTHER_SOURCES}
# Run the testbench
vvp \${TOP_MODULE}.vvp &> user.out
# SHOW the output
cat user.out

EEOOFF

chmod +x vpl_execution