#!/bin/bash
#
# vpl_run.sh script 

cat > vpl_execution <<EEOOFF
#!/bin/bash

# Variables
TOP_MODULE=led7
TOP_SIM_MODULE=test_\$TOP_MODULE
OTHER_SOURCES=

variation=\$(date +"%d%H")
if [ \$((variation % 2)) == 0 ]; then
    variation=variation
else
    variation=\$(expr \$variation - 1)
fi

start_value=1000
end_value=9999
input_value=\$(awk -v seed="\$variation" -v start_number="\$start_value" -v end_number="\$end_value" 'BEGIN {
   # seed
   srand(seed)
   print start_number + int((end_number - start_number) * rand())
}')


printf "%s\n" "XYZT este: \$input_value"

# Generate the testbench
iverilog -o \${TOP_MODULE}.vvp \${TOP_MODULE}.v \${TOP_SIM_MODULE}.v \${OTHER_SOURCES}
# Run the testbench
vvp \${TOP_MODULE}.vvp &> user.out
# SHOW the output
cat user.out

EEOOFF

chmod +x vpl_execution