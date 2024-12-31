import re

student_text = """{{ STUDENT_ANSWER }}"""
question_answer = """{{ handled_interrupt }}"""
precheck = {{ IS_PRECHECK }}

SEPARATOR = "#<ab@17943918#@>#"

regex = r"^INT[0-7]$"

{% for TEST in TESTCASES %}
if not re.match(regex, student_text):
    print("A valid input is INT0, INT1, INT2, INT3, INT4, INT5, INT6, or INT7")
else:
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