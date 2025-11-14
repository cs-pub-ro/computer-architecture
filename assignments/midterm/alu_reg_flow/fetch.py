#!/usr/bin/env python3
"""
Exercise: ALU Operations with Register File
Given initial register values and a sequence of 5 ALU operations,
trace through the operations and determine the final value of a specific register.

Registers: RA, RB, RC, IS, XA, XB, BA, BB (all 4-bit)
Operations: ADC, SBB1, SBB2, NOT, AND, OR, XOR, SHL/SAL, SHR, SAR

Compatible with Moodle CodeRunner plugin.
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

# ============================================================================
# Register File Definition
# ============================================================================

register_names = ['RA', 'RB', 'RC', 'IS', 'XA', 'XB', 'BA', 'BB']

# Initialize registers with random 4-bit values
registers = {reg: random.randint(0, 15) for reg in register_names}


# Initial register values table
initial_table_html = """
<table border="1" style="border-collapse: collapse; margin: 10px 0;">
  <tr style="background-color: #f0f0f0;">
    <th style="padding: 8px;">Register</th>
    <th style="padding: 8px;">Value (Dec)</th>
    <th style="padding: 8px;">Value (Bin)</th>
  </tr>
"""

for reg in register_names:
    val = registers[reg]
    val_bin = f'{val:04b}'
    initial_table_html += f"""  <tr>
    <td style="padding: 8px; font-weight: bold;">{reg}</td>
    <td style="padding: 8px; text-align: center;">{val}</td>
    <td style="padding: 8px; text-align: center; font-family: monospace;">{val_bin}</td>
  </tr>
"""

# ============================================================================
# ALU Operations Definition
# ============================================================================

operations_def = [
    {
        'name': 'ADC',
        'func': lambda a, b, c: (a + b + c) & 0xF,
        'needs_carry': True,
        'creates_carry': True,
        'operands': 2
    },
    {
        'name': 'SBB1',
        'func': lambda a, b, c: (a - b - c) & 0xF,
        'needs_carry': True,
        'creates_carry': True,
        'operands': 2
    },
    {
        'name': 'SBB2',
        'func': lambda a, b, c: (b - a - c) & 0xF,
        'needs_carry': True,
        'creates_carry': True,
        'operands': 2
    },
    {
        'name': 'NOT',
        'func': lambda a, b, c: (~a) & 0xF,
        'needs_carry': False,
        'creates_carry': False,
        'operands': 1
    },
    {
        'name': 'AND',
        'func': lambda a, b, c: a & b,
        'needs_carry': False,
        'creates_carry': False,
        'operands': 2
    },
    {
        'name': 'OR',
        'func': lambda a, b, c: a | b,
        'needs_carry': False,
        'creates_carry': False,
        'operands': 2
    },
    {
        'name': 'XOR',
        'func': lambda a, b, c: a ^ b,
        'needs_carry': False,
        'creates_carry': False,
        'operands': 2
    },
    {
        'name': 'SHL',
        'func': lambda a, b, c: (a << 1) & 0xF,
        'needs_carry': False,
        'creates_carry': True,
        'operands': 1
    },
    {
        'name': 'SHR',
        'func': lambda a, b, c: (a >> 1) & 0xF,
        'needs_carry': False,
        'creates_carry': True,
        'operands': 1
    },
    {
        'name': 'SAR',
        'func': lambda a, b, c: ((a & 0x8) | (a >> 1)) & 0xF,
        'needs_carry': False,
        'creates_carry': True,
        'operands': 1
    }
]

# ============================================================================
# Operation Sequence Generation
# ============================================================================

operations_sequence = []
carry_in = 0  # Initial carry bit
destination_registers = []

for step in range(5):
    # Random operation
    op_def = random.choice(operations_def)
    
    # Source registers
    if op_def['operands'] == 2:
        # Binary operation: need two source registers
        src_reg1 = random.choice(register_names)
        src_reg2 = random.choice(register_names)
    else:
        # Unary operation: need one source register
        src_reg1 = random.choice(register_names)
        src_reg2 = None
    
    # Destination register (first source register)
    dest_reg = src_reg1
    if op_def['name'] == 'SBB2':
        dest_reg = src_reg2  # For SBB2, destination is second source register
    destination_registers.append(dest_reg)
    
    # Execute operation
    val1 = registers[src_reg1]
    val2 = registers[src_reg2] if src_reg2 else 0
    result = op_def['func'](val1, val2, carry_in)
    # Default carry out
    carry_out = 0
    if op_def['creates_carry']:
        if op_def['name'] == 'ADC':
            carry_out = 1 if (val1 + val2 + carry_in) > 15 else 0
        elif op_def['name'] == 'SBB1':
            carry_out = 1 if (val1 < (val2 + carry_in)) else 0
        elif op_def['name'] == 'SBB2':
            carry_out = 1 if (val2 < (val1 + carry_in)) else 0
        elif op_def['name'] == 'SHL':
            carry_out = 1 if (val1 & 0x8) != 0 else 0
        elif op_def['name'] in ['SHR', 'SAR']:
            carry_out = 1 if (val1 & 0x1) != 0 else 0

    # Store operation record
    op_record = {
        'step': step + 1,
        'operation': op_def['name'],
        'dest': dest_reg,
        'src1': src_reg1,
        'src2': src_reg2,
        'carry_in': carry_in if op_def['needs_carry'] else None,
        'carry_out': carry_out,
        'val1': val1,
        'val2': val2,
        'result': result
    }
    operations_sequence.append(op_record)

    # Update register
    registers[dest_reg] = result

    # Update carry for next operation
    carry_in = carry_out

# ============================================================================
# Select query register
# ============================================================================

# query_register = random.choice(register_names)
query_register = random.choice(destination_registers)
final_value = registers[query_register]
final_value_bin = f'{final_value:04b}'


# ============================================================================
# Build HTML Question
# ============================================================================


initial_table_html += "</table>"

# Operations sequence table
operations_table_html = """
<table border="1" style="border-collapse: collapse; margin: 10px 0;">
  <tr style="background-color: #f0f0f0;">
    <th style="padding: 8px;">Step</th>
    <th style="padding: 8px;">Operation</th>
  </tr>
"""

for op in operations_sequence:
    if op['src2'] is not None:
        details = f"{op['operation']} {op['src1']}, {op['src2']}"
    else:
        # Unary operation
        details = f"{op['operation']} {op['src1']}"
    
    operations_table_html += f"""  <tr>
    <td style="padding: 8px; text-align: center;">{op['step']}</td>
    <td style="padding: 8px; font-family: monospace; font-size: 9pt;">{details}</td>
  </tr>
"""

operations_table_html += "</table>"

# Build complete question
html_question = f"""
<div class="register-alu-question">
    <h3>Register File ALU Operations</h3>
    
    <h4>Initial Register Values:</h4>
    {initial_table_html}
    
    <h4>Operation Sequence (5 operations):</h4>
    {operations_table_html}
    
    <h4>Question:</h4>
    <p>After executing all 5 operations above, what is the final value of register <strong>{query_register}</strong>?</p>
    
    <h4>Answer Format:</h4>
    <p>Enter the result as a <strong>4-bit binary number</strong> (e.g., <code>1010</code>)</p>

    <h4>Destination registers:</h4>
    <p> For all operations, the destination register is the first source register, except for SBB2 where it is the second source register.</p>
</div>
"""

# ============================================================================
# Generate JSON Output
# ============================================================================

output = {
    'question': html_question,
    'result': final_value_bin,
    # 'query_register': query_register,
    # 'final_value': final_value,
    # 'initial_registers': initial_registers,
    # 'final_registers': registers,
    # 'operations': [
    #     {
    #         'step': op['step'],
    #         'operation': op['operation'],
    #         'destination': op['dest'],
    #         'source1': op['src1'],
    #         'source2': op['src2'],
    #         'carry_in': op['carry_in'],
    #         'carry_out': op['carry_out'],
    #         'result': op['result']
    #     }
    #     for op in operations_sequence
    # ]
}

print(json.dumps(output))

# write html_question to a file for debugging
with open("html_question.html", "w") as f:
    f.write(html_question)
