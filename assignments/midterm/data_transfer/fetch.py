#!/usr/bin/env python3
"""
Exercise 1: Truth Table to Gate Name (Enhanced)
Given a truth table (2, 3, or 4 inputs), identify the Boolean gate name in capital letters.
Compatible with Moodle CodeRunner plugin.
"""

import sys
import json
import random

# Parse arguments from Moodle CodeRunner
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args.get('id', '0')

exam_secret = 12345  # Change this for each exam period
random.seed(exam_secret + int(student_id))

reg_file_values = [f"{random.randint(0, 255):02X}" for _ in range(8)]

regs = [x for x in reg_file_values]
t1 = t1_i = f"{random.randint(0, 255):02X}"
t2 = t2_i = f"{random.randint(0, 255):02X}"
operations = ""

aluops = ["ADC", "SBB1", "SBB2", "SHR", "SAR", "SHL", "XOR", "NOT", "AND", "OR"]

def no_change():
    return (not any(x != y for x, y in zip(reg_file_values, regs))) and t1 == t1_i and t2 == t2_i

def source_alu(t1_oe, t2_oe, op, c):
    op1 = t1 if t1_oe else "00"
    op2 = t2 if t2_oe else "00"
    sopi = random.randint(0, 1)
    if t1_oe == t2_oe == 1:
        sop = t1 if sopi == 0 else t2
        sop_oe = "t1_oe=1;" if sopi == 0 else "t2_oe=1;"
    elif t1_oe == 1:
        sop = t1
        sop_oe = "t1_oe=1;"
    elif t2_oe == 1:
        sop = t2
        sop_oe = "t2_oe=1;"
    else:
        sop = "00"
        sop_oe = ""

    twop = ""
    if t1_oe:
        twop += "t1_oe=1;"
    if t2_oe:
        twop += "t2_oe=1;"
    if c:
        twop += "alu_carry=1;"

    op1_val = int(op1, 16)
    op2_val = int(op2, 16)
    carry = c

    aluop = aluops[op]
    if aluop in ["SHR","SAR","SHL","NOT"]:
        oe_text = f"{sop_oe}alu_op={aluop};alu_oe=1;"
    else:
        oe_text = f"{twop}alu_op={aluop};alu_oe=1;"
    if aluop == "ADC":
        result = (op1_val + op2_val + carry) & 0xFF
    elif aluop == "SBB1":
        result = (op1_val - op2_val - carry) & 0xFF
    elif aluop == "SBB2":
        result = (op2_val - op1_val - carry) & 0xFF
    elif aluop == "AND":
        result = op1_val & op2_val
    elif aluop == "OR":
        result = op1_val | op2_val
    elif aluop == "NOT":
        # Only one operand is relevant, pick sop
        result = (~int(sop, 16)) & 0xFF
    elif aluop == "XOR":
        result = op1_val ^ op2_val
    elif aluop == "SHL":
        result = (int(sop, 16) << 1) & 0xFF
    elif aluop == "SAR":
        # signed arithmetic right shift
        val = int(sop, 16)
        result = ((val >> 1) | (0x80 if val & 0x80 else 0)) & 0xFF
    elif aluop == "SHR":
        result = (int(sop, 16) >> 1) & 0xFF
    else:
        result = 0

    source = f"{result:02X}"
    return source, oe_text

def source_regs(index):
    return regs[index], f"regs_addr={index};regs_oe=1;"

def dst_regs(source,index):
    global regs
    regs[index] = source
    return f"regs_addr={index};regs_we=1;"

def dst_t(source,t):
    global t1
    global t2
    if t == 1:
        t2 = source
        return f"t2_we=1;"
    else:
        t1 = source
        return "t1_we=1;"

def state(i):
    global operations
    if random.random() < 0.4:
        (source, oe_text) = source_regs(random.randint(0,7))
        source_is_regs = True
    else:
        (source, oe_text) = source_alu(
            1 if random.random() < 0.8 else 0,
            1 if random.random() < 0.8 else 0,
            random.randint(0, len(aluops)-1),
            random.randint(0,1)
        )
        source_is_regs = False
    
    if random.random() < 50 and not source_is_regs:
        we_text = dst_regs(source, random.randint(0,7))
    else:
        we_text = dst_t(source, random.randint(0,1))
    operations += f"State {i}: {oe_text}{we_text}\n"

while no_change():
    operations = ""
    for i in range(5):
        state(i)

changed_indices = [i for i, (a, b) in enumerate(zip(reg_file_values+[t1_i,t2_i], regs+[t1,t2])) if a != b]
idx = random.choice(changed_indices)
if idx < 8:
    ask_for = f"regs[{idx}]"
elif idx == 8:
    ask_for = f"T1"
else:
    ask_for = f"T2"
changed_value = (regs+[t1,t2])[idx]
print(f"Having regs = {reg_file_values}, t1 = {t1_i}, t2 = {t2_i}")
print(f"and these states:")
print(operations)
print(F"find {ask_for} (hexa)")
print(f"hint: its {changed_value}")
# TODO html question

