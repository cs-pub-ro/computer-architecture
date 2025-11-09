import re

student_decimal_text = """{{ STUDENT_ANSWER }}"""
question_number = """{{ result }}"""
question_number = float(question_number)
precheck = {{ IS_PRECHECK }}

# __student_answer__ = """{{ STUDENT_ANSWER | e('py') }}"""

SEPARATOR = "#<ab@17943918#@>#"

regex = r"^[+-]?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?$"

{% for TEST in TESTCASES %}
if re.match(regex, student_decimal_text):
    if precheck != 1:
        if abs(float(student_decimal_text) - question_number) < 0.1:
            print('correct')
        else:
            print('incorrect')
else:
    print("This is not a floating point number")
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}