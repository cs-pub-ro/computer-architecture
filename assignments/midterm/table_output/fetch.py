"""
Exercise: Truth Table output given input value
Given a truth table (2, 3, or 4 inputs), identify the output for a specific input combination.
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

no_in = [2, 3, 4]

selected_no_in = random.choice(no_in)
selected_input = [random.randint(0, 1) for _ in range(selected_no_in)]


# generate truth table
def generate_truth_table(num_inputs, selected_input):
    num_rows = 2 ** num_inputs
    table = []
    selected_output = 0
    for i in range(num_rows):
        inputs = [(i >> bit) & 1 for bit in reversed(range(num_inputs))]
        output = random.randint(0, 1)  # Random output for demonstration
        # verify if the two lists are equal
        if inputs == selected_input:
            selected_output = output
        table.append(inputs + [output])
    return (table, selected_output)


select_table, result = generate_truth_table(selected_no_in, selected_input)

# Get input variable names
input_vars = ['A', 'B', 'C', 'D'][:selected_no_in]


# Shuffle truth table rows for display
display_indices = list(range(len(select_table)))
random.shuffle(display_indices)
shuffled_table = [select_table[i] for i in display_indices]

# Generate HTML for the question
html_question = """
<div class="truth-table-question">
    <p><strong>Given the following truth table, identify the output for the input combination"""
for var in selected_input:
    html_question += f' {var}'
html_question += """:</strong></p>
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
    <p><strong>Answer:</strong> Enter the output value (0 or 1)</p>
"""
html_question += """
</div>
"""

# Output in JSON format for Moodle CodeRunner
output = {
    'question': html_question,
    'result': result,
}

print(json.dumps(output))

# write to a file the html_question for testing
with open('html_question.html', 'w') as f:
    f.write(html_question)
