def process_file(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
    ok_count = 0
    # Count lines containing "Match"
    for line in lines:
        if "Match" in line:
            ok_count += 1
        else:
            print(f"{line.strip()}")
            return ok_count

    return ok_count

# Use the function with your file
ok = process_file("evaluate.out")


f = open("vpl_execution", "w")
print("#!/bin/bash", file=f)

print(f"echo 'Grade :=>> {ok*100//6}'", file=f)
f.close()