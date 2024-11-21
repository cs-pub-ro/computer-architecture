#!/bin/bash
#
# vpl_evaluate.sh script 

source common_script.sh

TOP_MODULE=fpu
TOP_EVALUATE_MODULE=evaluate_${TOP_MODULE}
OTHER_SOURCES=
maxGrade=100
RESULT_FILE=result.out
EVALUATE_FILE=evaluate.out
GRADE_SCRIPT=grade.sh
EVALUATE_FLAGS="+INPUT_FILE=${RESULT_FILE}"
GENERATOR_COMPILER="g++ -std=c++20"
GENERATOR_SOURCE=fpu.cpp
GENERATOR_BINARY=fpu


# Build the generator code
$GENERATOR_COMPILER $GENERATOR_SOURCE -o $GENERATOR_BINARY
chmod +x $GENERATOR_BINARY

# Generate the testbench
./$GENERATOR_BINARY ${RESULT_FILE}

# BUILD the code
iverilog ${TOP_MODULE}.v ${TOP_EVALUATE_MODULE}.v ${OTHER_SOURCES} -o ${TOP_EVALUATE_MODULE}.vvp
# RUN the code
vvp ${TOP_EVALUATE_MODULE}.vvp  ${EVALUATE_FLAGS} > ${EVALUATE_FILE} 2>&1


#--- remove multiple spaces --- 
cat ${EVALUATE_FILE} | sed 's/  */ /g' > dummy.out
mv dummy.out ${EVALUATE_FILE}

#--- remove blank lines ---
cat ${EVALUATE_FILE} | sed '/^\s*$/d' > dummy.out
mv dummy.out ${EVALUATE_FILE}

# Calculate number of correct test versus wrong test
correct_test_no=$(awk '$1=="OK" { print $0 }' ${EVALUATE_FILE} | wc -l | awk '{ print $1 }')
test_no=$(wc -l ${EVALUATE_FILE} | awk '{ print $1 }')
grade=$( expr $correct_test_no \* 100 / $test_no)

echo "#!/bin/bash" > vpl_execution

# if not max grade print the first error line
if (( $grade < $maxGrade )) ; then
text=$(awk '$1!="OK" { print $0 }' ${EVALUATE_FILE} | awk 'NR==1 { print $0 }')
echo "echo '$text' " >> vpl_execution
echo $text
fi

echo "echo 'Grade :=>> $grade' " >> vpl_execution
 
chmod +x vpl_execution