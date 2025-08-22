import sys, json, random, datetime
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
random.seed(secret + week + int(student_id))


def calculate_max_data_rate(baud_rate, data_bits, stop_bits, parity_bits):
    # Calculate the total bits per frame
    total_bits_per_frame = 1 + data_bits + parity_bits + stop_bits

    # Calculate the maximum data rate
    max_data_rate = (baud_rate * data_bits) / total_bits_per_frame

    return max_data_rate

# Given UART configuration

baud_rates = [4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600]
data_bits_set = [5, 6, 7, 8]
stop_bits_set = [1, 2]
parity_bits_set = [0, 1]  # None,  or [Odd, Even]

baud_rate = random.choice(baud_rates)
data_bits = random.choice(data_bits_set)
stop_bits = random.choice(stop_bits_set)
parity_bits = random.choice(parity_bits_set)

# Calculate the maximum data rate
max_data_rate = calculate_max_data_rate(baud_rate, data_bits, stop_bits, parity_bits)

# Make a html table from the UART configuration
uart_configuration_table = """
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
"""
uart_configuration_table += "<tr><th>Parameter</th><th>Value</th></tr>\n"
uart_configuration_table += "<tr><td>Baud Rate</td><td>{}</td></tr>".format(baud_rate)
uart_configuration_table += "<tr><td>Data Bits</td><td>{}</td></tr>".format(data_bits)
uart_configuration_table += "<tr><td>Stop Bits</td><td>{}</td></tr>".format(stop_bits)
if parity_bits == 0:
    uart_configuration_table += "<tr><td>Parity Bits</td><td>None</td></tr>"
else:
    uart_configuration_table += "<tr><td>Parity Bits</td><td>1</td></tr>"
uart_configuration_table += "</table>"

# generate question in html format
question = """
<div>
    <p>Having the following UART configuration, what is the maximum data rate that can be achieved?</p>
</div>
<div>
<h3>UART configurations:</h3>
    {}
</div>
""".format(uart_configuration_table)

print(
    json.dumps(
        {
            "question": question,
            "result": max_data_rate
        }
    )
)