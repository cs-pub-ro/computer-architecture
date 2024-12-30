import re

student_decimal_text = """{{ STUDENT_ANSWER }}"""
question_speedup = """{{ speedup }}"""
question_speedup = float(question_speedup)
precheck = {{ IS_PRECHECK }}

# __student_answer__ = """{{ STUDENT_ANSWER | e('py') }}"""

SEPARATOR = "#<ab@17943918#@>#"

regex = r"^[+-]?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?$"

{% for TEST in TESTCASES %}
if re.match(regex, student_decimal_text):
    if precheck != 1:
        if abs(float(student_decimal_text) - question_speedup) < 0.01:
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