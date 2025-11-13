#!/usr/bin/env python3
"""
Exercise: ALU Single Operation Result
Given two 4-bit register values and an ALU operation,
determine the result of the operation.
"""
import sys
import json
import random
# import datetime

# Parse arguments from Moodle CodeRunner
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args.get('id', '0')

# Change this for each exam period
exam_secret = 12345
# Seed with current hour to vary questions throughout the day
# just for simulation purposes
# hour=datetime.datetime.now().hour
# random.seed(exam_secret + int(student_id) + hour)
random.seed(exam_secret + int(student_id))

# Definim operațiile posibile în română cu detalii pentru implementare.
operations = [
    {
        "name": "ADC",
        "func": lambda a, b, c: (a + b + c) & 0xF,
        "needs_carry": True
    },
    {
        "name": "SBB1",
        "func": lambda a, b, c: (a - b - c) & 0xF,
        "needs_carry": True
    },
    {
        "name": "SBB2",
        "func": lambda a, b, c: (b - a - c) & 0xF,
        "needs_carry": True
    },
    {
        "name": "NOT",
        "func": lambda a, b, c: (~a) & 0xF,
        "needs_carry": False
    },
    {
        "name": "AND",
        "func": lambda a, b, c: a & b,
        "needs_carry": False
    },
    {
        "name": "OR",
        "func": lambda a, b, c: a | b,
        "needs_carry": False
    },
    {
        "name": "XOR",
        "func": lambda a, b, c: a ^ b,
        "needs_carry": False
    },
    {
        "name": "SHL/SAL",
        "func": lambda a, b, c: (a << 1) & 0xF,
        "needs_carry": False
    },
    {
        "name": "SHR",
        "func": lambda a, b, c: (a >> 1) & 0xF,
        "needs_carry": False
    },
    {
        "name": "SAR",
        "func": lambda a, b, c: ((a & 0x8) | (a >> 1)) & 0xF,
        "needs_carry": False
    }
]
op = random.choice(operations)
a = random.randint(0, 15)
b = random.randint(0, 15)
carry = random.randint(0, 1) if op["needs_carry"] else None

a_bin = f"{a:04b}"
b_bin = f"{b:04b}"

if op["needs_carry"]:
    result = op["func"](a, b, carry)
else:
    result = op["func"](a, b, 0)
result_bin = f"{result:04b}"

# Descriere întrebare
if op["needs_carry"]:
    html_question = f"""
    <div>
    <p><strong>ALU operation:</strong> {op['name']}</p>
    <ul>
      <li>A = {a} (<code>{a_bin}</code>)</li>
      <li>B = {b} (<code>{b_bin}</code>)</li>
      <li>Carry = {carry}</li>
    </ul>
    <p><strong>Write the result in 4-bit binary:</strong></p>
    </div>
    """
else:
    html_question = f"""
    <div>
    <p><strong>ALU operation:</strong> {op['name']}</p>
    <ul>
      <li>A = {a} (<code>{a_bin}</code>)</li>
      <li>B = {b} (<code>{b_bin}</code>)</li>
    </ul>
    <p><strong>Write the result in 4-bit binary:</strong></p>
    </div>
    """

output = {
    'question': html_question,
    'result': result_bin,
    # 'operation': op['name'],
    # 'desc': op['desc'],
    # 'operand_a': a,
    # 'operand_b': b,
    # 'carry': carry
}
print(json.dumps(output))

# write html_question to a file for debugging
with open(f"html_question_{student_id}.html", "w") as f:
    f.write(html_question)
