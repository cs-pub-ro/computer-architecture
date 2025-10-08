import sys, json, random, datetime
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
# to be different from the encode one
random.seed(secret + 1 + week + int(student_id))

# Define the 2D array based on the LaTeX table
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

# Define the row and column labels
rm_labels = ["000", "001", "010", "011", "100", "101", "110", "111"]
mod_labels = ["00", "01", "10", "11"]

# Generate the addressing table in html format
addressing_table_html = """
<style>
    table, th, td {
        border: 1px solid black;
        border-collapse: collapse;
    }
    th, td {
        padding: 5px;
        text-align: left;
    }
</style>
<table>
    <tr><th>MOD \ RM</th>
"""
for mod in mod_labels:
    addressing_table_html += f"<th>{mod}</th>"
addressing_table_html += "</tr>\n"
for i, rm in enumerate(rm_labels):
    addressing_table_html += f"<tr><td>{rm}</td>"
    for j in range(len(mod_labels)):
        addressing_table_html += f"<td>{addressing_table[i][j]}</td>"
    addressing_table_html += "</tr>\n"
addressing_table_html += "</table>"
# print(addressing_table_html)

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

# Generate the opcode table in html format
opcode_table_html = """
<style>
    table, th, td {
        border: 1px solid black;
        border-collapse: collapse;
    }
    th, td {
        padding: 5px;
        text-align: left;
    }
</style>
<table>
    <tr><th>OPCODE</th><th>INSTRUCTION</th></tr>
"""
for opcode in opcode_table:
    opcode_table_html += f"<tr><td>{opcode}</td><td>{opcode_table[opcode]}</td></tr>\n"
opcode_table_html += "</table>"
# print(opcode_table_html)

instruction_register_table = [
    ["Instruction Register (IR)"],
    ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"],
    ["OPC", "OPC", "OPC", "OPC", "OPC", "OPC", "OPC", "d", "MOD", "MOD", "REG", "REG", "REG", "RM", "RM", "RM"]
]
# Generate the instruction register table in html format
instruction_register_table_html = """
<style>
    table, th, td {
        border: 1px solid black;
        border-collapse: collapse;
    }
    th, td {
        padding: 5px;
        text-align: left;
    }
</style>
<table>
    <tr><th colspan="16">Instruction Register (IR)</th></tr>
    <tr>
"""
for i in instruction_register_table[1]:
    instruction_register_table_html += f"<td>{i}</td>"
instruction_register_table_html += "</tr>\n"
instruction_register_table_html += "<tr>"
instruction_register_table_html += "<td colspan='7'>OPC</td>"
instruction_register_table_html += "<td>d</td>"
instruction_register_table_html += "<td colspan='2'>MOD</td>"
instruction_register_table_html += "<td colspan='3'>REG</td>"
instruction_register_table_html += "<td colspan='3'>RM</td>"
instruction_register_table_html += "</tr>\n"
instruction_register_table_html += "</table>"
# print(instruction_register_table_html)

register_table = {
    "000" : "RA",
    "001" : "RB",
    "010" : "RC",
    "011" : "SP",
    "100" : "XA",
    "101" : "XB",
    "110" : "BA",
    "111" : "BB"
}
# Generate the registers table in html format
registers_table_html = """
<style>
    table, th, td {
        border: 1px solid black;
        border-collapse: collapse;
    }
    th, td {
        padding: 5px;
        text-align: left;
    }
</style>
<table>
    <tr><th>REG</th><th>Name</th></tr>
"""
for register in register_table:
    registers_table_html += f"<tr><td>{register}</td><td>{register_table[register]}</td></tr>"
registers_table_html += "</table>"
# print(registers_table_html)

# Generate the random test case

# first opcode
opcode = random.choice(list(opcode_table.keys()))

# get the mod and rm values
# mod can not be 10 
mod = random.choice(mod_labels)
while mod == "10":
    mod = random.choice(mod_labels)
# if mod is 01 rm can not be 110 or 111
rm = random.choice(rm_labels)
while mod == "01" and rm in ["110", "111"]:
    rm = random.choice(rm_labels)
# test if it has one or two operands
d = '0'
reg = "000"
instruction_text = opcode_table[opcode] + " "
if opcode[1] == '0' and opcode[3] == '1':
    instruction_text += addressing_table[int(rm, 2)][int(mod, 2)]
else:
    d = random.choice(["0", "1"])
    reg = random.choice(list(register_table.keys()))
    if d == "1":
        instruction_text += register_table[reg] + ", " + addressing_table[int(rm, 2)][int(mod, 2)]
    else:
        instruction_text += addressing_table[int(rm, 2)][int(mod, 2)] + ", " + register_table[reg]

# generate the instruction
instruction_binary = opcode + d + mod + reg + rm
instruction_hex = hex(int(instruction_binary, 2))

# generate the question in html format
question = """
<div>
    <p> Having the following memory addressing table, instruction format table, registers address table, and opcode table.  What is the following instuction encoded in hexadecimal IR={} ? </p>
    <p> Write the answer ah "OPERATION DESTINATION, SOURCE" (space between OPERATION and DESTINATION, ", " between DESTINATION and SOURCE) </p>
    <div>
        <h3>Memory Addressing Table:</h3>
        {}
    </div>
    <div>
        <h3>Instruction Format Table:</h3>
        {}
    </div>
    <div>
        <h3>Registers Address Table:</h3>
        {}
    </div>
    <div>
        <h3>Opcode Table:</h3>
        {}
    </div>
</div>
""".format(
    instruction_hex,
    addressing_table_html,
    instruction_register_table_html,
    registers_table_html,
    opcode_table_html
)


print(
    json.dumps({
        "question": question,
        "result": instruction_text
    })
)
