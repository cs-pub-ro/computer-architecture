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

io_registers = {
    "SCDMA" : "0x0192",
    "MADMA" : random.randint(1000, 3000),
    "CNTDMA" : random.randint(2, 8),
    "INITDMA" : "0x0001",
    "SCIO0" : "0x0000",
    "SCIO1" : "0x0000",
    "SCIO2" : "0x0000",
    "SCIO3" : "0x0000"
}
MADMA = io_registers["MADMA"]
CNTDMA = io_registers["CNTDMA"]
io_registers["MADMA"] = f"0x{MADMA:04X}"
io_registers["CNTDMA"] = f"0x{CNTDMA:04X}"

# transform the io registers in a html table
io_registers_table = """
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
    <tr><th>Register</th><th>Value</th></tr>
"""
for register in io_registers:
    io_registers_table += f"<tr><td>{register}</td><td>{io_registers[register]}</td></tr>"
io_registers_table += "</table>"
# print(io_registers_table)

main_memory = {}
for i in range(10):
    main_memory[f"0x{(MADMA+i):04X}"] = random.randint(0, 255)

# transform the main memory in a html table
main_memory_table = """
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
    <tr><th>Address</th><th>Value</th></tr>
"""
for address in main_memory:
    main_memory_table += "<tr><td>0x{}</td><td>0x{}</td></tr>".format(address, '{:04x}'.format(main_memory[address]))
main_memory_table += "</table>"
# print(main_memory_table)

result = main_memory[f"0x{MADMA+CNTDMA:04X}"]


print(
    json.dumps({
        "io_registers_table": io_registers_table,
        "main_memory_table": main_memory_table,
        "result": result,
        "result_hex": f"0x{result:04X}"
    })
)