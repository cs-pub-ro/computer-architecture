import sys, json, random, datetime
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
random.seed(secret + week + int(student_id))

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

# generate the question in html format
question = """
<div>
    <p> Having the following I/O registers table and main memory table. What is the value on the data bus? </p>
    <p> Write the result in hexadecimal (starting with 0x) </p>
    <div>
        <h3>IO Registers</h3>
        {}
    </div>
    <div>
    <h3>Main Memory</h3>
        {}
    </div>
""".format(io_registers_table, main_memory_table)

question += """
<div>
<h3> SCDMA Register </h3>
<table>
    <tr>
        <th>0</th>
        <th>1</th>
        <th>2</th>
        <th>3</th>
        <th>4</th>
        <th>5</th>
        <th>6</th>
        <th>7</th>
        <th>8</th>
        <th>9</th>
        <th>10</th>
        <th>11</th>
        <th>12</th>
        <th>13</th>
        <th>14</th>
        <th>15</th>
    </tr>
    <tr>
        <td>SIO_0</td>
        <td>SIO_1</td>
        <td>SIO_2</td>
        <td>SIO_3</td>
        <td>X</td>
        <td>X</td>
        <td>SDMA</td>
        <td>EOBT</td>
        <td>EXTIRQ</td>
        <td>X</td>
        <td>PIRQ</td>
        <td>ENIRQ</td>
        <td>X</td>
        <td>MT</td>
        <td>DT</td>
        <td>ENT</td>
    </tr>
</table>

<ul>
    <li>SIO_0-3 - Status of the I/O devices 0 - functional 1 - not functional</li>
    <li>SDMA - DMA is active for 0 - inactive for 1</li>
    <li>EOBT - End of block transfer for 0 - not for 1</li>
    <li>EXTIRQ - There is an external interrupt from IO device for 0 - not for 1</li>
    <li>PIRQ - There is a programmable interrupt from CPU for 0 - not for 1 (testing)</li>
    <li>ENIRQ - Enable interrupt for 0 - disable for 1</li>
    <li>MT - Mode of transfer 0 - block for 1 - cycle stealing</li>
    <li>DT - Direction of transfer 0 - from IO to memory to IO for 1 - from memory to IO</li>
    <li>ENT - Enable transfer for 0 - disable for 1</li>
</ul>
</div>
<div><br><br></div>
<div>
<h3>SCIOX Register</h3>
<table>
    <tr>
        <th>0</th>
        <th>1</th>
        <th>2</th>
        <th>3</th>
        <th>4</th>
        <th>5</th>
        <th>6</th>
        <th>7</th>
        <th>8</th>
        <th>9</th>
        <th>10</th>
        <th>11</th>
        <th>12</th>
        <th>13</th>
        <th>14</th>
        <th>15</th>
    </tr>
    <tr>
        <td>S</td>
        <td>C</td>
        <td>X</td>
        <td>X</td>
        <td>X</td>
        <td>X</td>
        <td>X</td>
        <td>X</td>
        <td>X</td>
        <td>X</td>
        <td>X</td>
        <td>ENIRQ</td>
        <td>X</td>
        <td>X</td>
        <td>DT</td>
        <td>X</td>
    </tr>
</table>

<ul>
    <li>S - Status of the IO device 0 - functional 1 - not functional</li>
    <li>C - Start transfer for 1 - stop for 0</li>
    <li>ENIRQ - Enable interrupt for 0 - disable for 1</li>
    <li>DT - Direction of transfer 0 - from IO to memory to IO for 1 - from memory to IO</li>
</ul>
</div>
</div>
"""

print(
    json.dumps({
        "question": question,
        "result": f"0x{result:04X}"
    })
)