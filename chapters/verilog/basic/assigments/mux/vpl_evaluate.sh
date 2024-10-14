#!/bin/bash
#
# vpl_evaluate.sh script 

source common_script.sh

#./vpl_run.sh
TOP_MODULE=mux
TOP_SIM_MODULE=test_${TOP_MODULE}
TOP_EVALUATE_MODULE=evaluate_${TOP_MODULE}
SOLUTION_MODULE=solution_${TOP_MODULE}
OTHER_SOURCES=
maxGrade=100

# get the variation
variation=\$(date +"%d%H")
if [ \$((variation % 2)) == 0 ]; then
    variation=variation
else
    variation=\$(expr \$variation - 1)
fi

start_sel_no_bits=2
end_sel_no_bits=4
sel_no_bits=\$(awk -v seed="\$variation" -v start_number="\$start_sel_no_bits" -v end_number="\$end_sel_no_bits" 'BEGIN {
   # seed
   srand(seed)
   print start_number + int((end_number - start_number) * rand())
}')


# BUILD the code
iverilog ${TOP_MODULE}.v ${SOLUTION_MODULE}.v ${TOP_EVALUATE_MODULE}.v ${OTHER_SOURCES} -P p_sel_width=${sel_no_bits} -o ${TOP_MODULE}.vvp
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