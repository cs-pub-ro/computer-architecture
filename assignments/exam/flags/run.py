import re

student_binary_text = """{{ STUDENT_ANSWER }}"""
question_flag_register_bs = """{{ flag_register_bs }}"""
precheck = {{ IS_PRECHECK }}

# __student_answer__ = """{{ STUDENT_ANSWER | e('py') }}"""

SEPARATOR = "#<ab@17943918#@>#"

regex = r"[^01]"

{% for TEST in TESTCASES %}
if re.search(regex, student_binary_text):
    print("You have non-binary text")
else:
    if len(student_binary_text) != 5:
        print('You need to have exact 5 binary characters')
    else:
        if precheck != 1:
            if student_binary_text === question_flag_register_bs:
                print('corect')
            else:
                print('incorect')
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}