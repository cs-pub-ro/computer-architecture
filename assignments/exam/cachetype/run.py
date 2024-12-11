import re

student_decimal_text = """{{ STUDENT_ANSWER }}"""
question_cacheparameter = """{{ cacheparameter }}"""
question_cacheparameter = int(question_cacheparameter)
precheck = {{ IS_PRECHECK }}

# __student_answer__ = """{{ STUDENT_ANSWER | e('py') }}"""

SEPARATOR = "#<ab@17943918#@>#"

regex = r"^[+-]?\d+$"

{% for TEST in TESTCASES %}
if re.match(regex, student_decimal_text):
    if precheck != 1:
        if int(student_decimal_text) == question_cacheparameter:
            print('corect')
        else:
            print('incorect')
else:
    print("The value must be an integer")
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}