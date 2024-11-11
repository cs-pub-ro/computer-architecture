#!/bin/bash
#
# vpl_run.sh script 

cat > vpl_execution <<EEOOFF
#!/bin/bash

# Variables
TOP_MODULE=comb
TOP_SIM_MODULE=test_\$TOP_MODULE
OTHER_SOURCES=

variation=\$(date +"%d%H")
if [ \$((variation % 2)) == 0 ]; then
    variation=variation
else
    variation=\$(expr \$variation - 1)
fi


start_value=0
end_value=255
input_value=\$(awk -v seed="\$variation" -v start_number="\$start_value" -v end_number="\$end_value" 'BEGIN {
   # seed
   srand(seed)
   print start_number + int((end_number - start_number) * rand())
}')

seperator="------------------------------"
rows="|%5s| %5s| %5s| %7s|\n"
printf "%s\n" "Implmentați modulul verilog pentru tabelul de adevăr (i_w_a, i_w_b, i_w_c - intrări, i_w_out - ieșire):"
printf "%s\n" "\$seperator"
printf "\$rows" "i_w_a" "i_w_b" "i_w_c" "o_w_out"
printf "%s\n" "\$seperator"
tmp_value=\$input_value
for a in \$(seq 0 1);
do
    for b in \$(seq 0 1);
    do
        for c in \$(seq 0 1);
        do
            fresult=\$((tmp_value % 2))
            tmp_value=\$((tmp_value / 2))
            printf "\$rows" \$a \$b \$c \$fresult
        done
    done
done
printf "%s\n" "\$seperator"

# Generate the testbench
iverilog -o \${TOP_MODULE}.vvp \${TOP_MODULE}.v \${TOP_SIM_MODULE}.v \${OTHER_SOURCES}
# Run the testbench
vvp \${TOP_MODULE}.vvp &> user.out
# SHOW the output
cat user.out

EEOOFF

chmod +x vpl_execution