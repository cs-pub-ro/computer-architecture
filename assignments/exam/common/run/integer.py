import re

student_decimal_text = """{{ STUDENT_ANSWER }}"""
question_number = """{{ result }}"""
question_number = int(question_number)
precheck = {{ IS_PRECHECK }}

SEPARATOR = "#<ab@17943918#@>#"

# Regex to match any decimal integer text, including negative integers
regex = r"^-?\d+$"

{% for TEST in TESTCASES %}
if re.match(regex, student_decimal_text):
    if precheck != 1:
        if int(student_decimal_text, 10) == question_number:
            print('correct')
        else:
            print('incorrect')
else:
    print("The value must be an integer")
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}