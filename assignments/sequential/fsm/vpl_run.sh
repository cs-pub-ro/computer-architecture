#!/bin/bash
#
# vpl_run.sh script 

cat > vpl_execution <<EEOOFF
#!/bin/bash

# Variables
TOP_MODULE=fsm
TOP_SIM_MODULE=test_\$TOP_MODULE
OTHER_SOURCES=

variation=\$(date +"%d%H")
variation=\$(expr \$variation + 0)
if [ \$((variation % 2)) == 0 ]; then
    variation=\$variation
else
    variation=\$(expr \$variation - 1)
fi

# Sequence Generator for a, b, c, groups, and special characters
generate_sequences() {
    # Define the inputs, special characters, and groupings
    inputs=("a" "b" "c")
    special_chars=("+" "*")
    groupings=("ab" "bc" "ca" "ac" "cb")

    # Loop over combinations to generate valid sequences
    for i in "\${inputs[@]}"; do
        for j in "\${inputs[@]}"; do
            for k in "\${inputs[@]}"; do
                for group in "\${groupings[@]}"; do
                    for char in "\${special_chars[@]}"; do
                        # Ensure sequence doesn't start with special character
                        echo "\$i(\$group)\$char"
                        echo "\$i\$char(\$group)"
                        echo "(\$group)\$char\$i"
                        echo "\$i\$char\$group"
                        echo "(\$group)\$i\$char"
                        echo "\$char\$i(\$group)"
                    done
                done
            done
        done
    done
}

# Generate the sequence
sequences=\$(generate_sequences)
sequences=(\$sequences)
echo \${sequences[0]}

start_value=0
end_value=\$(expr \${#sequences[@]} - 1)
echo \$end_value
input_value=\$(awk -v seed="\$variation" -v start_number="\$start_value" -v end_number="\$end_value" 'BEGIN {
   # seed
   srand(seed)
   print start_number + int((end_number - start_number) * rand())
}')
echo \$input_value

# Select 4 random sequences from the generated list
# selected_sequences=\$(echo "\$sequences" | shuf -n 1)
selected_sequences=\${sequences[\${input_value}]}


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
echo "SECVENTA - \$selected_sequences"
echo "\$selected_sequences" > sequence.txt
cat sequence.txt

# Generate the testbench
iverilog -o \${TOP_MODULE}.vvp \${TOP_MODULE}.v \${TOP_SIM_MODULE}.v \${OTHER_SOURCES}

# Run the testbench
vvp \${TOP_MODULE}.vvp &> user.out

# SHOW the output
cat user.out

EEOOFF

chmod +x vpl_execution
