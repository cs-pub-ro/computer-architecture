import re

student_decimal_text = """{{ STUDENT_ANSWER }}"""
question_answer = """{{ answer }}"""
question_answer = int(question_answer)
precheck = {{ IS_PRECHECK }}

# __student_answer__ = """{{ STUDENT_ANSWER | e('py') }}"""

SEPARATOR = "#<ab@17943918#@>#"

regex = r"^[+-]?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?$"

{% for TEST in TESTCASES %}
if re.match(regex, student_decimal_text):
    if precheck != 1:
        if int(student_decimal_text) == question_answer:
            print('corect')
        else:
            print('incorect')
else:
    print("This is not a floating point number")
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}