import re

student_text = """{{ STUDENT_ANSWER }}"""
question_answer = """{{ result }}"""
question_answer = question_answer.strip().upper()
student_text = student_text.strip().upper()
precheck = {{ IS_PRECHECK }}

SEPARATOR = "#<ab@17943918#@>#"

addressing_table = [
    ["[BA+XA]", "[BA+XA+]", "[BA+XA+Imm]", "RA"],
    ["[BA+XB]", "[BA+XB+]", "[BA+XB+Imm]", "RB"],
    ["[BB+XA]", "[BB+XA+]", "[BB+XA+Imm]", "RC"],
    ["[BB+XB]", "[BB+XB+]", "[BB+XB+Imm]", "SP"],
    ["[XA]", "[BA+(-XA)]", "[XA+Imm]", "XA"],
    ["[XB]", "[BB+(-XA)]", "[XB+Imm]", "XB"],
    ["[BA]", "[Imm]", "[BA+Imm]", "BA"],
    ["[BB]", "[[Imm]]", "[BB+Imm]", "BB"]
]
opcode_table = {
    "0000000" : "MOV",
    "0001000" : "INC",
    "0001001" : "DEC",
    "0001010" : "NEG",
    "0001011" : "NOT",
    "0001100" : "SHL",
    "0001101" : "SHR",
    "0001110" : "SAR",
    "0101000" : "ADD",
    "0101001" : "ADC",
    "0101010" : "SUB",
    "0101011" : "SBB",
    "0101100" : "AND",
    "0101101" : "OR",
    "0101110" : "XOR"
}

def string_to_regex(string):
    return string.replace("[", r"\[").replace("]", r"\]").replace("+", r"\+").replace("-", r"\-").replace("(", r"\(").replace(")", r"\)")

# generate a regex pattern for the addressing table
addressing_table_pattern = ""
for row in addressing_table:
    for element in row:
        addressing_table_pattern += string_to_regex(element) + "|"
addressing_table_pattern = addressing_table_pattern[:-1]

opcode_table_pattern = ""
for key in opcode_table:
    opcode_table_pattern += opcode_table[key] + "|"
opcode_table_pattern = opcode_table_pattern[:-1]

instruction_pattern = r"^({opcode_table_pattern})\ ({addressing_table_pattern})(\,\ ({addressing_table_pattern}))?$".format(
    opcode_table_pattern=opcode_table_pattern,
    addressing_table_pattern=addressing_table_pattern
)
operation_pattern = r"({opcode_table_pattern})\ .*".format(
    opcode_table_pattern=opcode_table_pattern
)

possible_addressing = []
for row in addressing_table:
    for element in row:
        possible_addressing.append(element)

{% for TEST in TESTCASES %}
if re.match(instruction_pattern, student_text):
    if precheck != 1:
        if student_text == question_answer:
            print('correct')
        else:
            print('incorrect')
else:
    if re.match(operation_pattern, student_text):
        print("The ADDRESSING is incorrect it can be one of {} and if it has SOURCE use ', ' between DESTINATION and SOOURCE".format(possible_addressing))
    else:
        print("The OPERATION is incorrect it can be one of {}".format(opcode_table.values()))
{{ TEST.testcode }}
{% if not loop.last %}
print(SEPARATOR)
{% endif %}
{% endfor %}