import re

student_hex_text = """{{ STUDENT_ANSWER }}"""
question_answer = """{{ instruction_hex }}"""
precheck = {{ IS_PRECHECK }}

SEPARATOR = "#<ab@17943918#@>#"

# Regex for hexadecimal string starting with '0x'
regex = r"^0x[0-9A-Fa-f]+$"

{% for TEST in TESTCASES %}
if re.match(regex, student_hex_text):
    if len(student_hex_text) != 6:
        print('You need to have exact 4 hexadecimal characters after 0x')
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