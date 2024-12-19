import sys
def process_file(filename):
    ok_string = sys.argv[1]

    with open(filename, 'r') as file:
        lines = file.readlines()
    ok_count = 0
    silent = False
    # Count lines containing "OK"
    for line in lines:
        if f"{ok_string}-FETCH" in line:
            ok_count += 10
        elif ok_string in line:
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