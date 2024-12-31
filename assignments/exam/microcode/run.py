import re

student_decimal_text = """{{ STUDENT_ANSWER }}"""
question_number = """{{ result }}"""
question_number = int(question_number)
precheck = {{ IS_PRECHECK }}

# __student_answer__ = """{{ STUDENT_ANSWER | e('py') }}"""

SEPARATOR = "#<ab@17943918#@>#"

regex = r"[^0123456789]"

{% for TEST in TESTCASES %}
if re.search(regex, student_decimal_text):
    print("You have non-decimal text")
else:
    if precheck != 1:
        if int(student_decimal_text, 10) == question_number:
            print('correct')
        else:
            print('incorect')
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}