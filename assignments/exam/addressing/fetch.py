import sys, json, random, datetime
#args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
#x=10
#random.seed(x + args['id'])
x=10
week=datetime.datetime.now().isocalendar()[0]
random.seed(x + week)



# Define the register values
registers = {
    "RA": random.randint(0, 2000),
    "RB": random.randint(0, 2000),
    "RC": random.randint(0, 2000),
    "SP": random.randint(0, 2000),
    "XA": random.randint(2, 200),
    "XB": random.randint(2, 200),
    "BA": random.randint(0, 2000),
    "BB": random.randint(0, 2000),
    "PC": random.randint(0, 200)
}

# Define the immediate value
immediate_value = random.randint(0, 2000)

# Define the main memory
main_memory = {}

# go though each type of memory addressing
# 1. Direct Addressing
da_question = "What is the value of the memory address register (MA) if the instruction is using direct addressing?"
da_result = immediate_value
# 2. Indirect Addressing
ia_question = "What is the value of the memory address register (MA) if the instruction is using indirect addressing?"
if immediate_value not in main_memory:
    main_memory[immediate_value] = random.randint(0, 2000)
ia_result = main_memory[immediate_value]
# 3. Indirect Addressing from Register
iar_registers = ["RA", "RB", "RC", "SP", "XA", "XB", "BA", "BB", "PC"]
for register in iar_registers:
    if registers[register] not in main_memory:
        main_memory[registers[register]] = random.randint(0, 2000)
selected_register = random.choice(iar_registers)
iar_question = "What is the value of the memory address register (MA) if the instruction is using indirect addressing from register {}?".format(selected_register)
iar_result = registers[selected_register]
# 4. Indirect Addressing from Base and Index Registers with Increment After for Index
base_registers = ["BA", "BB"]
index_registers = ["XA", "XB"]
for base_register in base_registers:
    for index_register in index_registers:
        if registers[base_register] + registers[index_register] not in main_memory:
            main_memory[registers[base_register] + registers[index_register]] = random.randint(0, 2000)
selected_base_register = random.choice(base_registers)
selected_index_register = random.choice(index_registers)
iabii_question = "What is the value of the memory address register (MA) if the instruction is using indirect addressing from base register {} and index register {} with increment after for index?".format(selected_base_register, selected_index_register)
iabii_result = registers[selected_base_register] + registers[selected_index_register]
# 5. Indirect Addressing from Base and Index Registers with Decrement Before for Index
for base_register in base_registers:
    for index_register in index_registers:
        if registers[base_register] + registers[index_register] - 1 not in main_memory:
            main_memory[registers[base_register] + registers[index_register] - 1] = random.randint(0, 2000)
iabid_question = "What is the value of the memory address register (MA) if the instruction is using indirect addressing from base register {} and index register {} with decrement before for index?".format(selected_base_register, selected_index_register)
iabid_result = registers[selected_base_register] + registers[selected_index_register] - 1
# 6. Indirect Addressing from Base and Immediate
for base_register in base_registers:
    if registers[base_register] + immediate_value not in main_memory:
        main_memory[registers[base_register] + immediate_value] = random.randint(0, 2000)
iabimm_question = "What is the value of the memory address register (MA) if the instruction is using indirect addressing from base register {} and immediate value?".format(selected_base_register)
iabimm_result = registers[selected_base_register] + immediate_value
# 7. Indirect Addressing from Index and Immediate
for index_register in index_registers:
    if registers[index_register] + immediate_value not in main_memory:
        main_memory[registers[index_register] + immediate_value] = random.randint(0, 2000)
iaiimm_question = "What is the value of the memory address register (MA) if the instruction is using indirect addressing from index register {} and immediate value?".format(selected_index_register)
iaiimm_result = registers[selected_index_register] + immediate_value
# 8. Indirect Addressing from Base and Index with Immediate
for base_register in base_registers:
    for index_register in index_registers:
        if registers[base_register] + registers[index_register] + immediate_value not in main_memory:
            main_memory[registers[base_register] + registers[index_register] + immediate_value] = random.randint(0, 2000)
iabiimm_question = "What is the value of the memory address register (MA) if the instruction is using indirect addressing from base register {} and index register {} with immediate value?".format(selected_base_register, selected_index_register)
iabiimm_result = registers[selected_base_register] + registers[selected_index_register] + immediate_value
# 9. Immediate Addressing
if registers["PC"] + immediate_value not in main_memory:
    main_memory[registers["PC"] + immediate_value] = random.randint(0, 2000)
imma_question = "What is the value of the memory address register (MA) if the instruction is using immediate addressing?"
imma_result = registers["PC"] + immediate_value
# 10. Direct Register Addressing
dra_question = "What is the value of the memory address register (MA) if the instruction is using direct register addressing?"
dra_result = 0

# compute the question and result
addressing_modes = [
    {
        "question": da_question,
        "result": da_result
    },
    {
        "question": ia_question,
        "result": ia_result
    },
    {
        "question": iar_question,
        "result": iar_result
    },
    {
        "question": iabii_question,
        "result": iabii_result
    },
    {
        "question": iabid_question,
        "result": iabid_result
    },
    {
        "question": iabimm_question,
        "result": iabimm_result
    },
    {
        "question": iaiimm_question,
        "result": iaiimm_result
    },
    {
        "question": iabiimm_question,
        "result": iabiimm_result
    },
    {
        "question": imma_question,
        "result": imma_result
    },
    {
        "question": dra_question,
        "result": dra_result
    }
]
selected_addressing_mode = random.choice(addressing_modes)

question = "Having the following register values, the main memory values and the immediate value 0x{}, ".format('{:04x}'.format(immediate_value)) + selected_addressing_mode["question"]
question += " (Write the answer in hexadecimal format (4 hex characters - MSB first) starting with 0x\n\n"
# make a table with the register values as a string for the question
registers_table = "| Register | Value |\n| --- | --- |\n"
for register in registers:
    registers_table += "| {} | 0x{} |\n".format(register, '{:04x}'.format(registers[register]))
question += "\n\n" + registers_table + "\n"
# make a table with the main memory values as a string for the question
main_memory_table = "| Address | Value |\n| --- | --- |\n"
# sort the main memory addresses in ascending order
for address in sorted(main_memory):
    main_memory_table += "| 0x{} | 0x{} |\n".format('{:04x}'.format(address), '{:04x}'.format(main_memory[address]))
question += "\n" + main_memory_table + "\n"

print(question)

print(
    json.dumps(
        {
            'question': question,
            'result': '{:04x}'.format(selected_addressing_mode["result"])
        }
    )
)
# print(m)