import sys, json, random, datetime
#args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
#x=10
#random.seed(x + args['id'])
x=10
week=datetime.datetime.now().isocalendar()[0]
random.seed(x + week)


def format_string_fixed_length(input_string, length):
    # Ensure the string is of the specified length, padding with spaces if necessary
    return f"{input_string:<{length}}"

# Define the 2D array based on the LaTeX table
instruction_table = [
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
instruction_table_string = ""
instruction_table_string += format_string_fixed_length("MOD \\ RM", 16)
for mod in mod_labels:
    instruction_table_string += format_string_fixed_length(mod, 16)
instruction_table_string += "\n"
for i, rm in enumerate(rm_labels):
    instruction_table_string += format_string_fixed_length(rm, 16)
    for j in range(len(mod_labels)):
        instruction_table_string += format_string_fixed_length(instruction_table[i][j], 16)
    instruction_table_string += "\n"

# Print the 2D array as a string
# print(instruction_table_string)

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

opcode_table_string = ""
opcode_table_string += format_string_fixed_length("OPCODE", 16)
opcode_table_string += format_string_fixed_length("INSTRUCTION", 16)
opcode_table_string += "\n"
for opcode in opcode_table:
    opcode_table_string += format_string_fixed_length(opcode, 16)
    opcode_table_string += format_string_fixed_length(opcode_table[opcode], 16)
    opcode_table_string += "\n"

# Print the opcode table as a string
# print(opcode_table_string)

instruction_register_table = [
    ["Instruction Register (IR)"],
    ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"],
    ["OPC", "d", "MOD", "REG", "RM"]
]

instruction_register_table_string = ""
instruction_register_table_string += format_string_fixed_length("Instruction Register (IR)", 60)
instruction_register_table_string += "\n"
for i in instruction_register_table[1]:
    instruction_register_table_string += format_string_fixed_length(i, 4)
instruction_register_table_string += "\n"
instruction_register_table_string += format_string_fixed_length("OPC", 28)
instruction_register_table_string += format_string_fixed_length("d", 4)
instruction_register_table_string += format_string_fixed_length("MOD", 8)
instruction_register_table_string += format_string_fixed_length("REG", 12)
instruction_register_table_string += format_string_fixed_length("RM", 12)
instruction_register_table_string += "\n"

# Print the instruction register table as a string
# print(instruction_register_table_string)

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

register_table_string = ""
register_table_string += format_string_fixed_length("REG", 16)
register_table_string += format_string_fixed_length("REGISTER", 16)
register_table_string += "\n"
for register in register_table:
    register_table_string += format_string_fixed_length(register, 16)
    register_table_string += format_string_fixed_length(register_table[register], 16)
    register_table_string += "\n"

# Print the register table as a string
# print(register_table_string)

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
    instruction_text += instruction_table[int(rm, 2)][int(mod, 2)]
else:
    d = random.choice(["0", "1"])
    reg = random.choice(list(register_table.keys()))
    if d == "1":
        instruction_text += register_table[reg] + ", " + instruction_table[int(rm, 2)][int(mod, 2)]
    else:
        instruction_text += instruction_table[int(rm, 2)][int(mod, 2)] + ", " + register_table[reg]

# generate the instruction
instruction_binary = opcode + d + mod + reg + rm
instruction_hex = hex(int(instruction_binary, 2))

print(
    json.dumps({
        "opcode": opcode,
        "mod": mod,
        "rm": rm,
        "d": d,
        "reg": reg,
        "instruction_text": instruction_text,
        "instruction_binary": instruction_binary,
        "instruction_hex": instruction_hex,
        "instruction_table": instruction_table_string,
        "opcode_table": opcode_table_string,
        "instruction_register_table": instruction_register_table_string,
        "register_table": register_table_string
    })
)