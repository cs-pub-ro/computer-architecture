import re

student_text = """{{ STUDENT_ANSWER }}"""
question_answer = """{{ instruction_text }}"""
precheck = {{ IS_PRECHECK }}

SEPARATOR = "#<ab@17943918#@>#"


{% for TEST in TESTCASES %}
if precheck != 1:
    if student_text.upper() == question_answer.upper():
        print('correct')
    else:
        print('incorrect')
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}