import sys, json, random, datetime
import numpy as np
quiz_order = 2
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
random.seed(secret + quiz_order + week + int(student_id))

# Define the micro-instructions and micro-operations
micro_instructions = ["μI" + str(i) for i in range(random.randint(6, 9))]
micro_operations = ["μO" + str(i) for i in range(random.randint(8, 10))]

micro_instruction_table = {}
for micro_instruction in micro_instructions:
    micro_instruction_table[micro_instruction] = [1 if random.randint(0, 3) == 0 else 0 for _ in range(len(micro_operations))]
    # Ensure at least one micro-operation is executed
    micro_instruction_table[micro_instruction][random.randint(0, len(micro_operations) - 1)] = 1

# Print the micro-instruction table
# print(json.dumps(micro_instruction_table))

# make the html table for the micro-instruction table
micro_instruction_table_html = """
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
<table>"""
micro_instruction_table_html += "<tr><th>Micro-Instruction</th>"
for micro_operation in micro_operations:
    micro_instruction_table_html += f"<th>{micro_operation}</th>"
micro_instruction_table_html += "</tr>"

for micro_instruction in micro_instructions:
    micro_instruction_table_html += f"<tr><td>{micro_instruction}</td>"
    for micro_operation in micro_operations:
        micro_instruction_table_html += f"<td>{micro_instruction_table[micro_instruction][micro_operations.index(micro_operation)]}</td>"
    micro_instruction_table_html += "</tr>"
micro_instruction_table_html += "</table>"
# print(micro_instruction_table_html)

# two micro operations are incompatible if they are part of the same micro instruction
incompatible_micro_operations_table = np.zeros((len(micro_operations), len(micro_operations)), dtype=int)
for i in range(len(micro_operations)):
    incompatible_micro_operations_table[i][i] = 1
    for j in range(i + 1, len(micro_operations)):
        for micro_instruction in micro_instruction_table:
            if micro_instruction_table[micro_instruction][i] == 1 and micro_instruction_table[micro_instruction][j] == 1:
                incompatible_micro_operations_table[i][j] = 1
                incompatible_micro_operations_table[j][i] = 1

# Print the incompatible micro-operations table
# print(incompatible_micro_operations_table)


incompatability_classes = []
for i in range(len(micro_operations)):
    incompatability_classes.append({
        "micro_operations": [i],
        "to_add": incompatible_micro_operations_table[i].copy()
    })

compose_incompatability_classes = []

while len(incompatability_classes) > 0:
    incompatibility_class = incompatability_classes.pop(0)
    evolving = False
    for i in range(len(micro_operations)):
        # need to check if the micro operation is higher than any of the micro operations in the class
        if np.all(np.array(incompatibility_class["micro_operations"]) < i):
            if i not in incompatibility_class["micro_operations"] and incompatibility_class["to_add"][i] == 1:
                incompatability_classes.append({
                    "micro_operations": incompatibility_class["micro_operations"] + [i],
                    "to_add": np.logical_and(incompatibility_class["to_add"], incompatible_micro_operations_table[i])
                })
                evolving = True
    if evolving is False:
        compose_incompatability_classes.append(incompatibility_class["micro_operations"])
            
# print(compose_incompatability_classes)

# we need to filter out the classes that are subsets of other classes
maximum_incompatability_classes = []
for i in range(len(compose_incompatability_classes)):
    is_subset = False
    for j in range(len(compose_incompatability_classes)):
        if i != j and set(compose_incompatability_classes[i]).issubset(compose_incompatability_classes[j]):
            is_subset = True
            break
    if is_subset is False:
        maximum_incompatability_classes.append(compose_incompatability_classes[i])

# print(maximum_incompatability_classes)

# get the highest number of micro operations in a class
max_micro_operations = max([len(incompatability_class) for incompatability_class in maximum_incompatability_classes])

# Print the maximum incompatibility classes
# print(max_micro_operations)

if quiz_order == 0:
    question = """
    <div>
        <p>Given the following micro-instruction table, determine the highest cardinality of any of the maximum incompatible classes of micro-operations.</p>
        <h3>Micro-instruction table:</h3>
        <div>
        {}
        </div>
    </div>
    """.format(micro_instruction_table_html)
    print(
        json.dumps(
            {
                "question": question,
                "result": max_micro_operations
            }
        )
    )


compatability_classes = []
for i in range(len(micro_operations)):
    compatability_classes.append({
        "micro_operations": [i],
        "to_add": incompatible_micro_operations_table[i].copy()
    })

compose_compatability_classes = []

while len(compatability_classes) > 0:
    compatability_class = compatability_classes.pop(0)
    evolving = False
    for i in range(len(micro_operations)):
        # need to check if the micro operation is higher than any of the micro operations in the class
        if np.all(np.array(compatability_class["micro_operations"]) < i):
            if i not in compatability_class["micro_operations"] and compatability_class["to_add"][i] == 0:
                compatability_classes.append({
                    "micro_operations": compatability_class["micro_operations"] + [i],
                    "to_add": np.logical_or(compatability_class["to_add"], incompatible_micro_operations_table[i])
                })
                evolving = True
    if evolving is False:
        compose_compatability_classes.append(compatability_class["micro_operations"])

# print(compose_compatability_classes)

# we need to filter out the classes that are subsets of other classes
maximum_compatability_classes = []
for i in range(len(compose_compatability_classes)):
    is_subset = False
    for j in range(len(compose_compatability_classes)):
        if i != j and set(compose_compatability_classes[i]).issubset(compose_compatability_classes[j]):
            is_subset = True
            break
    if is_subset is False:
        maximum_compatability_classes.append(compose_compatability_classes[i])

# print(maximum_compatability_classes)

# get the number of maximum compatability classes
number_of_maximum_compatability_classes = len(maximum_compatability_classes)

# Print the number of maximum compatability classes
# print(number_of_maximum_compatability_classes)


if quiz_order == 1:
    question = """
    <div>
        <p>Given the following micro-instruction table, determine the number of maximum compatibility classes of micro-operations.</p>
        <h3>Micro-instruction table:</h3>
        <div>
        {}
        </div>
    </div>
    """.format(micro_instruction_table_html)
    print(
        json.dumps(
            {
                "question": question,
                "result": number_of_maximum_compatability_classes
            }
        )
    )

# make the html table for the maximum incompatible classes
maximum_incompatability_classes_html = """
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
<table>"""
maximum_incompatability_classes_html += "<tr><th>MIC</th>"
for micro_operation in micro_operations:
    maximum_incompatability_classes_html += f"<th>{micro_operation}</th>"
maximum_incompatability_classes_html += "</tr>"
for i, maximum_incompatability_class in enumerate(maximum_incompatability_classes):
    maximum_incompatability_classes_html += f"<tr><td>MIC_{i}</td>"
    for j in range(len(micro_operations)):
        maximum_incompatability_classes_html += f"<td>{1 if j in maximum_incompatability_class else 0}</td>"
    maximum_incompatability_classes_html += "</tr>"
maximum_incompatability_classes_html += "</table>"
# print(maximum_incompatability_classes_html)

# make the html table for the maximum compatible classes
maximum_compatability_classes_html = """
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
<table>"""
maximum_compatability_classes_html += "<tr><th>MCC</th>"
for micro_operation in micro_operations:
    maximum_compatability_classes_html += f"<th>{micro_operation}</th>"
maximum_compatability_classes_html += "</tr>"
for i, maximum_compatability_class in enumerate(maximum_compatability_classes):
    maximum_compatability_classes_html += f"<tr><td>MCC_{i}</td>"
    for j in range(len(micro_operations)):
        maximum_compatability_classes_html += f"<td>{1 if j in maximum_compatability_class else 0}</td>"
    maximum_compatability_classes_html += "</tr>"
maximum_compatability_classes_html += "</table>"
# print(maximum_compatability_classes_html)

# select the maximum incompatible class with the highest number of micro operations
selected_maximum_incompatability_class = max(maximum_incompatability_classes, key=len)

# Print the selected maximum incompatibility class
# print(selected_maximum_incompatability_class)

# select all the maximum compaticipiity classes that have at least one micro operation in the selected maximum incompatibility class
selected_maximum_compatability_classes = []
for maximum_compatability_class in maximum_compatability_classes:
    if len(set(maximum_compatability_class).intersection(set(selected_maximum_incompatability_class))) > 0:
        selected_maximum_compatability_classes.append(maximum_compatability_class)

# Print the selected maximum compatability classes
# print(selected_maximum_compatability_classes)

current_solutions = []
current_solutions.append({
    "indexes": [],
    "remaining_classes": [{ "index": i, "microop": maximum_compatability_class } for i, maximum_compatability_class in enumerate(selected_maximum_compatability_classes)]
})
def get_essential_classes(remaining_classes):
    essential_classes = []
    for maximum_compatability_class in remaining_classes:
        for micro_operation in maximum_compatability_class["microop"]:
            is_unique = True
            for other_maximum_compatability_class in remaining_classes:
                if maximum_compatability_class != other_maximum_compatability_class and micro_operation in other_maximum_compatability_class["microop"]:
                    is_unique = False
                    break
            if is_unique:
                essential_classes.append(maximum_compatability_class)
                break
    return essential_classes

def remove_micro_operations(remaining_classes, essential_classes):
    for essential_class in essential_classes:
        for micro_operation in essential_class["microop"]:
            for other_maximum_compatability_class in remaining_classes:
                if micro_operation in other_maximum_compatability_class["microop"]:
                    other_maximum_compatability_class["microop"].remove(micro_operation)
searchable = True
while searchable:
    searchable = False
    new_current_solutions = []
    for current_solution in current_solutions:
        remaining_classes = current_solution["remaining_classes"]
        current_indexes = current_solution["indexes"]
        # if they are remaining classes
        if len(remaining_classes) > 0:
            # if any of the selected maximum compatability classes is the only class that has a micro operation that is not in the other classes
            # then we can add that class to the current solution
            essential_classes = get_essential_classes(remaining_classes)
            if len(essential_classes) > 0:
                current_indexes += [essential_class["index"] for essential_class in essential_classes]
                for essential_class in essential_classes:
                    remaining_classes.remove(essential_class)
                remove_micro_operations(remaining_classes, essential_classes)
                new_current_solutions.append({
                    "indexes": current_indexes,
                    "remaining_classes": remaining_classes
                })
                searchable = True
            else:
                # find the class with the highest number of micro operations
                maximum_micro_operations = max([len(maximum_compatability_class["microop"]) for maximum_compatability_class in remaining_classes])
                if maximum_micro_operations > 0:
                    # maximum_micro_operations_classes = [maximum_compatability_class for maximum_compatability_class in remaining_classes if len(maximum_compatability_class["microop"]) == maximum_micro_operations]
                    # for each class we create a new solution
                    # for remaining_class in maximum_micro_operations_classes:
                    for remaining_class in remaining_classes:
                        new_remaining_classes = remaining_classes.copy()
                        new_remaining_classes.remove(remaining_class)
                        new_current_indexes = current_indexes.copy()
                        new_current_indexes.append(remaining_class["index"])
                        remove_micro_operations(new_remaining_classes, [remaining_class])
                        new_current_solutions.append({
                            "indexes": new_current_indexes,
                            "remaining_classes": new_remaining_classes
                        })
                    searchable = True
    if searchable:
        current_solutions = new_current_solutions.copy()


# Print the current solution
# print("current_solutions")
# print(current_solutions)

# filter the solutions that have a subset of the indexes in another solution
filtered_current_solutions = []
for current_solution in current_solutions:
    has_subset = False
    for other_current_solution in current_solutions:
        if current_solution != other_current_solution and set(other_current_solution["indexes"]).issubset(set(current_solution["indexes"])):
            if len(other_current_solution["indexes"]) < len(current_solution["indexes"]):
                has_subset = True
                break
    if has_subset is False:
        filtered_current_solutions.append(current_solution)

# Print the filtered current solutions
# print("filtered_current_solutions")
# print(filtered_current_solutions)

# store only the set of indexes
final_solutions = []
for filtered_current_solution in filtered_current_solutions:
    current_indexes = set(filtered_current_solution["indexes"])
    if current_indexes not in final_solutions:
        final_solutions.append(current_indexes)

# Print the final solutions
# print("final_solutions")
# print(final_solutions)

def clog2(x):
    """Ceiling of log2"""
    if x <= 0:
        raise ValueError("domain error")
    return (x-1).bit_length()

# for each solutions we take every time the class with the highest number of micro operations
def get_minimum_instruction_size(solution):
    minimum_instruction_size = 0
    instruction_size_solutions = []
    instruction_size_solutions.append({
        "indexes": list(solution),
        "remaining_classes": [{ "index": i, "microop": selected_maximum_compatability_classes[i] } for i in solution],
        "instruction_size": 0
    })
    
    searchable = True
    while searchable:
        searchable = False
        new_instruction_size_solutions = []
        for current_solution in instruction_size_solutions:
            remaining_classes = current_solution["remaining_classes"]
            current_indexes = current_solution["indexes"]
            current_instruction_size = current_solution["instruction_size"]
            # if they are remaining classes
            if len(remaining_classes) > 0:
                # find the class with the highest number of micro operations
                maximum_micro_operations = max([len(maximum_compatability_class["microop"]) for maximum_compatability_class in remaining_classes])
                if maximum_micro_operations > 0:
                    maximum_micro_operations_classes = [maximum_compatability_class for maximum_compatability_class in remaining_classes if len(maximum_compatability_class["microop"]) == maximum_micro_operations]
                    # for each class we create a new solution
                    for remaining_class in maximum_micro_operations_classes:
                        new_remaining_classes = remaining_classes.copy()
                        new_remaining_classes.remove(remaining_class)
                        new_current_indexes = current_indexes.copy()
                        new_current_indexes.append(remaining_class["index"])
                        new_current_instruction_size = current_instruction_size + clog2(len(remaining_class["microop"]) + 1)
                        new_instruction_size_solutions.append({
                            "indexes": new_current_indexes,
                            "remaining_classes": new_remaining_classes,
                            "instruction_size": new_current_instruction_size
                        })
                        searchable = True
        if searchable:
            instruction_size_solutions = new_instruction_size_solutions.copy()
    return min([current_solution["instruction_size"] for current_solution in instruction_size_solutions])

# get the minimum instruction size for each solution
minimum_instruction_sizes = [get_minimum_instruction_size(final_solution) for final_solution in final_solutions]

# Print the minimum instruction sizes
# print("minimum_instruction_sizes")
# print(minimum_instruction_sizes)

# get the minimum instruction size
minimum_instruction_size = min(minimum_instruction_sizes)

# Print the minimum instruction size
# print("minimum_instruction_size")
# print(minimum_instruction_size)

if quiz_order == 2:
    question = """
    <div>
        <p>Given the following micro-instruction table, maximum incompatible classes table, and maximum compatible classes table determine the minimum instruction size required to encode the micro-instructions.</p>
        <h3>Micro-instruction table:</h3>
        <div>
        {}
        </div>
        <h3>Maximum Incompatible Classes:</h3>
        <div>
        {}
        </div>
        <h3>Maximum Compatible Classes:</h3>
        <div>
        {}
        </div>
    </div>
    """.format(micro_instruction_table_html, maximum_incompatability_classes_html, maximum_compatability_classes_html)
    print(
        json.dumps(
            {
                "question": question,
                "result": minimum_instruction_size
            }
        )
    )