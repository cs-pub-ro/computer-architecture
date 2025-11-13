import re
student_answer = """{{ STUDENT_ANSWER }}"""
question_answer = """{{ result }}"""
precheck = {{ IS_PRECHECK }}

SEPARATOR = "#<ab@17943918#@>#"

output_alphabet = ['A', 'B', 'C', 'D']
valid_answers_format = r"[" + "".join(output_alphabet) + r"]+"


fixed_length = len(question_answer)
regex = r"^" + valid_answers_format + r"$"

{% for TEST in TESTCASES %}
if re.match(regex, student_answer):
    if len(student_answer) != fixed_length:
        print('You need to have exact {} characters'.format(fixed_length))
    else:
        if precheck != 1:
            if student_answer == question_answer:
                print('correct')
            else:
                print('incorrect')
else:
    print("Your answer contains invalid characters. Valid characters are: " + ", ".join(output_alphabet))
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}