#!/bin/bash
if [[ $# -ne 1 ]]; then
    echo 'Too many/few arguments, expecting one' >&2
    exit 1
fi

EVALUATE_FILE=$1
#--- remove multiple spaces --- 
cat $EVALUATE_FILE | sed 's/  */ /g' > dummy.out
mv dummy.out $EVALUATE_FILE

#--- remove blank lines ---
cat $EVALUATE_FILE | sed '/^\s*$/d' > dummy.out
mv dummy.out $EVALUATE_FILE

# Calculate number of correct test versus wrong test
correct_test_no=$(awk '$1=="OK" { print $0 }' $EVALUATE_FILE | wc -l | awk '{ print $1 }')
test_no=$(wc -l $EVALUATE_FILE| awk '{ print $1 }')
grade=$( expr $correct_test_no \* 100 / $test_no)

echo $grade