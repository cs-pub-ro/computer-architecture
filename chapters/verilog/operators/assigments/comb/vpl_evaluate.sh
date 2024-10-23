#!/bin/bash
#
# vpl_evaluate.sh script 

source common_script.sh

#./vpl_run.sh
TOP_MODULE=comb
TOP_SIM_MODULE=test_${TOP_MODULE}
TOP_EVALUATE_MODULE=evaluate_${TOP_MODULE}
SOLUTION_MODULE=sol
OTHER_SOURCES=mux.v
maxGrade=100

variation=$(date +"%d%H")
if [ $((variation % 2)) == 0 ]; then
    variation=variation
else
    variation=$(expr $variation - 1)
fi

start_value=0
end_value=255
input_value=$(awk -v seed="$variation" -v start_number="$start_value" -v end_number="$end_value" 'BEGIN {
   # seed
   srand(seed)
   print start_number + int((end_number - start_number) * rand())
}')

seperator="------------------------------"
rows="|%5s| %5s| %5s| %7s|\n"
printf "%s\n" "Implmentați modulul verilog pentru tabelul de adevăr (i_w_a, i_w_b, i_w_c - intrări, i_w_out - ieșire):"
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

# BUILD the code
iverilog ${TOP_MODULE}.v ${SOLUTION_MODULE}.v ${TOP_EVALUATE_MODULE}.v ${OTHER_SOURCES} -DVARIATION=$input_value -o ${TOP_MODULE}.vvp
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