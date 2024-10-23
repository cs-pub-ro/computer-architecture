#!/bin/bash
#
# vpl_evaluate.sh script 

source common_script.sh

#./vpl_run.sh
TOP_MODULE=led7
TOP_SIM_MODULE=test_${TOP_MODULE}
TOP_EVALUATE_MODULE=evaluate_${TOP_MODULE}
SOLUTION_MODULE=sol
OTHER_SOURCES=led7conv.v
maxGrade=100

variation=$(date +"%d%H")
if [ $((variation % 2)) == 0 ]; then
    variation=variation
else
    variation=$(expr $variation - 1)
fi

start_value=1000
end_value=9999
input_value=$(awk -v seed="$variation" -v start_number="$start_value" -v end_number="$end_value" 'BEGIN {
   # seed
   srand(seed)
   print start_number + int((end_number - start_number) * rand())
}')

printf "%s\n" "XYZT este: $input_value"
tmp_value=$input_value
digit1=$((tmp_value % 10))
tmp_value=$((tmp_value / 10))
digit2=$((tmp_value % 10))
tmp_value=$((tmp_value / 10))
digit3=$((tmp_value % 10))
tmp_value=$((tmp_value / 10))
digit4=$((tmp_value % 10))

# BUILD the code
iverilog ${TOP_MODULE}.v ${SOLUTION_MODULE}.v ${TOP_EVALUATE_MODULE}.v ${OTHER_SOURCES} -DDIGIT1=$digit1 -DDIGIT2=$digit2 -DDIGIT3=$digit3 -DDIGIT4=$digit4  -o ${TOP_MODULE}.vvp
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
fi

echo "echo 'Grade :=>> $grade' " >> vpl_execution
 
chmod +x vpl_execution