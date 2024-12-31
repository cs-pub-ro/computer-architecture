import sys, json, random, datetime
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
random.seed(secret + week + int(student_id))
# Define the problem
interrupts_table = [
    {"address": "0x0", "name": "Reserved", "type": "Internal Interrupt"},
    {"address": "0x1", "name": "Software Interrupt (INT)", "type": "Internal Interrupt"},
    {"address": "0x2", "name": "ALU Overflow", "type": "Internal Interrupt"},
    {"address": "0x3", "name": "Lack of Voltage (Power Off)", "type": "External Non-Maskable Interrupt"},
    {"address": "0x4", "name": "Level 0", "type": "External Maskable Interrupt"},
    {"address": "0x5", "name": "Level 1", "type": "External Maskable Interrupt"},
    {"address": "0x6", "name": "Level 2", "type": "External Maskable Interrupt"},
    {"address": "0x7", "name": "Level 3", "type": "External Maskable Interrupt"},
    {"address": "0x8", "name": "Level 4", "type": "External Maskable Interrupt"},
    {"address": "0x9", "name": "Level 5", "type": "External Maskable Interrupt"},
    {"address": "0xA", "name": "Level 6", "type": "External Maskable Interrupt"},
    {"address": "0xB", "name": "Level 7", "type": "External Maskable Interrupt"}
]

# make the table into a html table
interrupts_table_html = """
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
    <tr><th>Address</th><th>Name</th><th>Type</th></tr>
"""
for interrupt in interrupts_table:
    interrupts_table_html += f"<tr><td>{interrupt['address']}</td><td>{interrupt['name']}</td><td>{interrupt['type']}</td></tr>"
interrupts_table_html += "</table>"
# print(interrupts_table_html)

external_maskable_interrupts_times = [10, 20, 30, 40, 50, 60, 70, 80]

time_to_handle = {
    "External Maskable Interrupt Level 0": random.choice(external_maskable_interrupts_times),
    "External Maskable Interrupt Level 1": random.choice(external_maskable_interrupts_times),
    "External Maskable Interrupt Level 2": random.choice(external_maskable_interrupts_times),
    "External Maskable Interrupt Level 3": random.choice(external_maskable_interrupts_times),
    "External Maskable Interrupt Level 4": random.choice(external_maskable_interrupts_times),
    "External Maskable Interrupt Level 5": random.choice(external_maskable_interrupts_times),
    "External Maskable Interrupt Level 6": random.choice(external_maskable_interrupts_times),
    "External Maskable Interrupt Level 7": random.choice(external_maskable_interrupts_times),
    "External Non-Maskable Interrupt": random.choice([5, 10, 15, 20]),
    "ALU Overflow": random.choice([10, 15, 20]),
    "Software Interrupt": random.choice([15, 20, 25, 30])
}

#  make the time to handle into a html table
time_to_handle_html = """
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
    <tr><th>Type</th><th>Time to Handle</th></tr>
"""
for interrupt_type in time_to_handle:
    time_to_handle_html += f"<tr><td>{interrupt_type}</td><td>{time_to_handle[interrupt_type]}</td></tr>"
time_to_handle_html += "</table>"
# print(time_to_handle_html)

times_beetwen_interrupts = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]

index = 0
interrupt_requests = []
interrupt_requests.append({"cycle": 10, "type": random.choice(list(time_to_handle.keys())), "name": "INT" + str(index)})
for index in range(1, 7):
    cycle = interrupt_requests[index-1]["cycle"] + random.choice(times_beetwen_interrupts)
    interrupt_type = random.choice(list(time_to_handle.keys()))
    interrupt_name = "INT" + str(index)
    interrupt_requests.append({"cycle": cycle, "type": interrupt_type, "name": interrupt_name})

# make the interrupt requests into a html table
interrupt_requests_html = """
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
    <tr><th>Start Cycle</th><th>Type</th><th>Name</th></tr>
"""
for request in interrupt_requests:
    interrupt_requests_html += f"<tr><td>{request['cycle']}</td><td>{request['type']}</td><td>{request['name']}</td></tr>"
interrupt_requests_html += "</table>"
# print(interrupt_requests_html)



priority_of_intq = {
    "External Maskable Interrupt Level 0": 4,
    "External Maskable Interrupt Level 1": 5,
    "External Maskable Interrupt Level 2": 6,
    "External Maskable Interrupt Level 3": 7,
    "External Maskable Interrupt Level 4": 8,
    "External Maskable Interrupt Level 5": 9,
    "External Maskable Interrupt Level 6": 10,
    "External Maskable Interrupt Level 7": 11,
    "External Non-Maskable Interrupt": 3,
    "ALU Overflow": 2,
    "Software Interrupt": 1
}

def solve_interrupts(interrupt_requests):
    handled_interrupts = []
    current_cycle = 0
    active_interrupts = []
    remaining_interrupts = []

    for request in interrupt_requests:
        remaining_interrupts.append(request)
    
    while len(remaining_interrupts) > 0 or len(active_interrupts) > 0:
        if len(active_interrupts) > 0:
            active_interrupt = active_interrupts.pop(0)
            active_interrupt["remaining_cycles"] -= 1
            if active_interrupt["remaining_cycles"] == 0:
                handled_interrupts.append(active_interrupt["name"])
            else:
                active_interrupts.insert(0, active_interrupt)
        current_cycle += 1
        for request in remaining_interrupts:
            if request["cycle"] == current_cycle:
                active_interrupts.append({
                    "name": request["name"],
                    "type": request["type"],
                    "remaining_cycles": time_to_handle[request["type"]]
                })
                remaining_interrupts.remove(request)
        active_interrupts.sort(key=lambda x: priority_of_intq[x["type"]])
    
    return handled_interrupts

# Get the order of handled interrupts
handled_interrupts = solve_interrupts(interrupt_requests)

# chose a random order of the handled interupts larger than 3
index_of_interrupts = random.randint(4, len(handled_interrupts))

# generate the question in html format
question = """
<div>
    <p>
        Having the table of interrupt requests, interrupt types, and the time of the request,
        what is {}th interupt that will be handled completly by the CPU?
    </p>
</div>
<div>
<h3>Interrupts Table:</h3>
    {}
</div>
<div>
<h3>Time to handle Interrupts Table:</h3>
    {}
</div>
<div>
<h3>Interrupts to handle Table:</h3>
    {}
</div>
""".format(
    index_of_interrupts,
    interrupts_table_html,
    time_to_handle_html,
    interrupt_requests_html
)

print(
    json.dumps(
        {
            "question": question,
            "result": handled_interrupts[index_of_interrupts - 1]
        }
    )
)
