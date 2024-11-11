#!/bin/bash
#
# vpl_run.sh script 

cat > vpl_execution <<EEOOFF
#!/bin/bash

# Variables
TOP_MODULE=mux
TOP_SIM_MODULE=test_\$TOP_MODULE
OTHER_SOURCES=

variation=\$(date +"%d%H")
if [ \$((variation % 2)) == 0 ]; then
    variation=variation
else
    variation=\$(expr \$variation - 1)
fi

echo \$variation

start_sel_no_bits=2
end_sel_no_bits=4
sel_no_bits=\$(awk -v seed="\$variation" -v start_number="\$start_sel_no_bits" -v end_number="\$end_sel_no_bits" 'BEGIN {
   # seed
   srand(seed)
   print start_number + int((end_number - start_number) * rand())
}')
input_no_entries=\$(( 2 ** \$sel_no_bits))

echo "Implementează un multiplexor \$input_no_entries:1. Ieșirea se va numi o_w_out, selectorul se va numi i_w_sel (MSB first), iar intrarea se va numi i_w_in și va avea \$input_no_entries biți (MSB first)."

EEOOFF

chmod +x vpl_execution