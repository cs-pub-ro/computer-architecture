student_gate = """{{ STUDENT_ANSWER }}"""
question_answer = """{{ result }}"""
precheck = {{ IS_PRECHECK }}

SEPARATOR = "#<ab@17943918#@>#"


fixed_length = 4
gates = ["AND", "OR", "XOR", "NAND", "NOR", "XNOR"]


{% for TEST in TESTCASES %}
if student_gate in gates:
    if precheck != 1:
        if student_gate == question_answer:
            print('correct')
        else:
            print('incorrect')
else:
    print("This is not a valid gate name. Valid names are: AND, OR, XOR, NAND, NOR, XNOR. (case-sensitive)")
# {{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}