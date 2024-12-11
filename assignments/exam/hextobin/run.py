import re

student_binary_text = """{{ STUDENT_ANSWER }}"""
question_number = """{{ number }}"""
question_number = int(question_number)
precheck = {{ IS_PRECHECK }}

# __student_answer__ = """{{ STUDENT_ANSWER | e('py') }}"""

SEPARATOR = "#<ab@17943918#@>#"

regex = r"[^01]"

{% for TEST in TESTCASES %}
if re.search(regex, student_binary_text):
    print("You have non-binary text")
else:
    if len(student_binary_text) != 8:
        print('You need to have exact 8 binary characters')
    else:
        if precheck != 1:
            if int(student_binary_text, 2) == question_number:
                print('corect')
            else:
                print('incorect')
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}