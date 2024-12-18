def process_file(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
    ok_count = 0
    nok_count = 0
    first = True
    # Count lines containing "Match"
    for line in lines:
        if "Match" in line:
            ok_count += 1
        else:
            if first:
                print(f"{line.strip()}")
                first = False
            nok_count += 1

    return nok_count

# Use the function with your file
nok = process_file("evaluate.out")


no_tests = 6
f = open("vpl_execution", "w")
print("#!/bin/bash", file=f)

print(f"echo 'Grade :=>> {(no_tests-nok)*100//6}'", file=f)
f.close()