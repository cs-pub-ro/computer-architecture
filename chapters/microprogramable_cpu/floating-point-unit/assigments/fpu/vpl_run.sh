#!/bin/bash
#
# vpl_run.sh script 

cat > vpl_execution <<EEOOFF
#!/bin/bash

# Variables
TOP_MODULE=fpu
TOP_SIM_MODULE=test_\$TOP_MODULE
OTHER_SOURCES=


# Generate the testbench
iverilog -o \${TOP_MODULE}.vvp \${TOP_MODULE}.v \${TOP_SIM_MODULE}.v \${OTHER_SOURCES}
# Run the testbench
vvp \${TOP_MODULE}.vvp &> user.out
# SHOW the output
cat user.out

EEOOFF

chmod +x vpl_execution