#!/bin/bash
#
# vpl_evaluate.sh script 

source common_script.sh

#./vpl_run.sh
TOP_MODULE=fsm
TOP_SIM_MODULE=
TOP_EVALUATE_MODULE=evaluate_${TOP_MODULE}
SOLUTION_MODULE=
OTHER_SOURCES=
maxGrade=100

variation=$(date +"%d%H")
if [ $((variation % 2)) == 0 ]; then
    variation=$variation
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

python3 generate_inputs.py sequence

sequence=$(cat sequence.txt)

seperator="------------------------------"
printf "%s\n" "Se dorește proiectarea unui automat finit capabil să recunoască secvența de"
printf "%s\n" "caractere SECVENTA. Automatul va primi la intrare caractere codificate printr-un semnal de 2 biti, unde:
0 reprezintă caracterul „a”
1 reprezintă caracterul „b”
2 reprezinta caracterul „c” "
printf "%s\n"
printf "%s\n" "Ieșirea automatului va consta dintr-un semnal care va fi activat (valoarea 1)"
printf "%s\n" "atunci când la intrare ultimele X input-uri se potrivesc cu secventa mai sus"
printf "%s\n" "mentionata. X - oricate astfel incat secventa sa poata fi indeplinita.

Mentiuni: 
În cazul în care secvența curentă nu mai poate duce la identificarea secvenței"
printf "%s\n" "țintă (deadlock), automatul va reveni la starea inițială."

printf "%s\n" "\$seperator"
echo "SECVENTA - \$sequence"

# BUILD the code
iverilog ${TOP_MODULE}.v ${TOP_EVALUATE_MODULE}.v ${OTHER_SOURCES} -DVARIATION=$input_value -o ${TOP_MODULE}.vvp
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