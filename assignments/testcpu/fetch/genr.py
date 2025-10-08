import random
import sys
# Set the seed for reproducibility
random.seed(sys.argv[1])

numbers = list(range(16))
random.shuffle(numbers)

f = open("lut.mem","r")
lines = f.readlines()
f.close()
x = [(lines[i], lines[i + 1]) for i in range(0, len(lines), 2)]
instrs = random.sample(x, 5)
f = open("instructions.mem", "w")

for i,instr in enumerate(instrs):
    print(instr[1].strip(), file=f)
for i in range(3):
    print(f"{random.randint(0, 0xffff):04x}", file=f)
f.close()

print(f"Aveti de implementat etapa de fetch si decode pentru urmatoarele pozitii de biti: |{'|'.join([f'IR{i}' for i in numbers])}|")

