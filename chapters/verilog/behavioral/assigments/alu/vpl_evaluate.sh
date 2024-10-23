#!/bin/bash
#
# vpl_evaluate.sh script 

source common_script.sh

#./vpl_run.sh
TOP_MODULE=alu
TOP_SIM_MODULE=test_${TOP_MODULE}
TOP_EVALUATE_MODULE=evaluate_${TOP_MODULE}
SOLUTION_MODULE=sol
OTHER_SOURCES=bigalu.v
maxGrade=100

variation=$(date +"%d%H")
if [ $((variation % 2)) == 0 ]; then
    variation=variation
else
    variation=$(expr $variation - 1)
fi

op_vector=('ADDITION' 'SUBTRACTION' 'AND' 'OR' 'XOR' 'LEFT_SHIFT' 'RIGHT_SHIFT' 'ARITHMETIC_RIGHT_SHIFT' 'MULTIPLY' 'DIVIDE' 'MODULUS' 'COMPARE_EQUAL' 'COMPARE_LESS_THAN' 'COMPARE_GREATER_THAN' 'NAND' 'NOR')
op_sel=()
op_value=$variation
i=0
while [ $i -lt 4 ];
do
    start_value=0
    end_value=15
    op_value=$(awk -v seed="$op_value" -v start_number="$start_value" -v end_number="$end_value" 'BEGIN {
        # seed
        srand(seed)
        print start_number + int((end_number - start_number) * rand())
    }')
    sem=0
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

printf "Pentru i_w_in = 0, aveti de implementat operatia de %s\n" ${op_vector[${op_sel[0]}]}
printf "Pentru i_w_in = 1, aveti de implementat operatia de %s\n" ${op_vector[${op_sel[1]}]}
printf "Pentru i_w_in = 2, aveti de implementat operatia de %s\n" ${op_vector[${op_sel[2]}]}
printf "Pentru i_w_in = 3, aveti de implementat operatia de %s\n" ${op_vector[${op_sel[3]}]}


# BUILD the code
iverilog ${TOP_MODULE}.v ${SOLUTION_MODULE}.v ${TOP_EVALUATE_MODULE}.v ${OTHER_SOURCES} -DOP0=${op_sel[0]} -DOP1=${op_sel[1]} -DOP2=${op_sel[2]} -DOP3=${op_sel[3]}  -o ${TOP_MODULE}.vvp
# RUN the code
vvp ${TOP_MODULE}.vvp  &> user.out


#--- remove multiple spaces --- 
cat user.out | sed 's/  */ /g' > dummy.out
mv dummy.out user.out

#--- remove blank lines ---
cat user.out | sed '/^\s*$/d' > dummy.out
mv dummy.out user.out

# Calculate number of correct test versus wrong test
correct_test_no=$(awk '$1=="OK" { print $0 }' user.out | wc -l | awk '{ print $1 }')
test_no=$(wc -l user.out | awk '{ print $1 }')
grade=$( expr $correct_test_no \* 100 / $test_no)

echo "#!/bin/bash" > vpl_execution

# if not max grade print the first error line
if (( $grade < $maxGrade )) ; then
text=$(awk '$1!="OK" { print $0 }' user.out | awk 'NR==1 { print $0 }')
echo "echo '$text' " >> vpl_execution
echo $text
fi

echo "echo 'Grade :=>> $grade' " >> vpl_execution
 
chmod +x vpl_execution