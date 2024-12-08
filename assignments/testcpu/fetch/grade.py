def process_file(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
    ok_count = 0
    silent = False
    # Count lines containing "OK"
    for line in lines:
        if "OK-FETCH" in line:
            ok_count += 10
        elif "OK" in line:
            ok_count += 2
        else:
            if silent == False:
                print(f"{line.strip()}")
                silent = True

    return ok_count

# Use the function with your file
ok = process_file("evaluate.out")

f = open("vpl_execution", "w")
print("#!/bin/bash", file=f)

print(f"echo 'Grade :=>> {ok}'", file=f)
f.close()