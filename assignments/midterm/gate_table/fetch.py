#!/usr/bin/env python3
"""
Exercise: Truth Table to Gate Name (Enhanced)
Given a truth table (2, 3, or 4 inputs), identify the Boolean gate name in capital letters.
Compatible with Moodle CodeRunner plugin.
"""

import sys
import json
import random
# import datetime

# Parse arguments from Moodle CodeRunner
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args.get('id', '0')

# Change this for each exam period
exam_secret = 12345
# Seed with current hour to vary questions throughout the day
# just for simulation purposes
# hour=datetime.datetime.now().hour
# random.seed(exam_secret + int(student_id) + hour)
random.seed(exam_secret + int(student_id))

gates = ["AND", "OR", "XOR", "NAND", "NOR", "XNOR"]
no_in = [2, 3, 4]

selected_gate = random.choice(gates)
selected_no_in = random.choice(no_in)


# generate truth table
def generate_truth_table(gate, num_inputs):
    num_rows = 2 ** num_inputs
    table = []
    for i in range(num_rows):
        inputs = [(i >> bit) & 1 for bit in reversed(range(num_inputs))]
        if gate == "AND":
            output = int(all(inputs))
        elif gate == "OR":
            output = int(any(inputs))
        elif gate == "XOR":
            output = int(sum(inputs) % 2)
        elif gate == "NAND":
            output = int(not all(inputs))
        elif gate == "NOR":
            output = int(not any(inputs))
        elif gate == "XNOR":
            output = int((sum(inputs) % 2) == 0)
        table.append(inputs + [output])
    return table


select_table = generate_truth_table(selected_gate, selected_no_in)

# Get input variable names
input_vars = ['A', 'B', 'C', 'D'][:selected_no_in]


# Shuffle truth table rows for display
display_indices = list(range(len(select_table)))
random.shuffle(display_indices)
shuffled_table = [select_table[i] for i in display_indices]

# Generate HTML for the question
html_question = """
<div class="truth-table-question">
    <p><strong>Given the following truth table, identify the Boolean gate name:</strong></p>
    <table border="1" style="border-collapse: collapse; margin: 10px 0;">
        <tr style="background-color: #f0f0f0;">
"""

# Add header cells for each input
for var in input_vars:
    html_question += f'            <th style="padding: 8px; text-align: center;">{var}</th>\n'

html_question += '            <th style="padding: 8px; text-align: center;">Output</th>\n        </tr>\n'

# Add truth table rows
for row in shuffled_table:
    html_question += '        <tr>\n'
    for val in row:
        html_question += f'            <td style="padding: 8px; text-align: center;">{val}</td>\n'
    html_question += '        </tr>\n'

html_question += """    </table>
    <p><strong>Answer:</strong> Enter the gate name in <strong>CAPITAL LETTERS</strong>.</p>
    <p>Possible gates: </p>
"""
for gate in gates:
    html_question += f'{gate} &nbsp; '

html_question += """
</div>
"""

# Correct answer
result = selected_gate

# Output in JSON format for Moodle CodeRunner
output = {
    'question': html_question,
    'result': result,
}

print(json.dumps(output))

# write to a file the html_question for testing
with open('html_question.html', 'w') as f:
    f.write(html_question)
