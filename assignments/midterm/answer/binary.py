import re

student_binary_text = """{{ STUDENT_ANSWER }}"""
question_number = """{{ result }}"""
# Convert the expected result to an integer from binary
question_number = int(question_number, 2)
precheck = {{ IS_PRECHECK }}

SEPARATOR = "#<ab@17943918#@>#"

# Regex to match any binary integer text (0 or 1)
regex = r"^[01]+$"

fixed_length = 8

{% for TEST in TESTCASES %}
if re.match(regex, student_binary_text):
    if len(student_binary_text) != fixed_length:
        print('You need to have exactly 8 binary characters')
    else:
        if precheck != 1:
            if int(student_binary_text, 2) == question_number:
                print('correct')
            else:
                print('incorrect')
else:
    print("The value must be a binary text")
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}