import re

student_hex_text = """{{ STUDENT_ANSWER }}"""
question_answer = """{{ result }}"""
precheck = {{ IS_PRECHECK }}

SEPARATOR = "#<ab@17943918#@>#"

# Regex for hexadecimal string starting with '0x'
regex = r"^0x[0-9A-Fa-f]+$"

fixed_length = 4

{% for TEST in TESTCASES %}
if re.match(regex, student_hex_text):
    if len(student_hex_text) != (fixed_length + 2):
        print('You need to have exact {} hexadecimal characters after 0x'.format(fixed_length))
    else:
        if precheck != 1:
            if int(student_hex_text, 16) == int(question_answer, 16):
                print('correct')
            else:
                print('incorrect')
else:
    print("This is not a valid hexadecimal number")
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}