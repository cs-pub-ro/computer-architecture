def process_file(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
    ok_count = 0
    # Count lines containing "OK"
    for line in lines:
        if "OK" in line:
            ok_count += 1
        else:
            print(f"{line.strip()}")
            return ok_count

    return ok_count

# Use the function with your file
ok = process_file("evaluate.out")

def compare_files(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        # Read files line by line
        for line_number, (line1, line2) in enumerate(zip(f1, f2), start=1):
            # Check if lines differ
            if line1 != line2:
                print(f"(STORE) expected: {line1.strip()}, got: {line2.strip()}")
                return False
        
        # Check if one file has extra lines
        extra_f1 = f1.readline()
        extra_f2 = f2.readline()
        if extra_f1 or extra_f2:
            if extra_f1:
                print(f"Expected extra: {extra_f1.strip()}")
            else:
                print(f"Got extra: {extra_f2.strip()}")
            return False

    # If no differences found
    return True
f = open("vpl_execution", "w")
print("#!/bin/bash", file=f)
if ok == 9:
    result = compare_files("sol_regs.hex", "uut_regs.hex")
    result2 = compare_files("sol.hex", "uut.hex")
    if result and result2:
        print(f"echo 'Grade :=>> 100'", file=f)
    else:
        print(f"echo 'Grade :=>> 90'", file=f)
else:
    print(f"echo 'Grade :=>> {ok*10}'", file=f)
f.close()