import random
import sys
# Set the seed for reproducibility
random.seed(sys.argv[1])

possible = [
    "MOV",
    "PUSH",
    "CALL",
    "JMP",
    "ADD",
    "ADC",
    "SUB",
    "SBB",
    "AND",
    "OR",
    "XOR",
    "INC",
    "DEC",
    "NEG",
    "NOT",
    "SHL",
    "SHR",
    "SAR",
    "CMP",
    "TEST",
]

lut = {
    "MOV": 2,
    "PUSH": 1,
    "CALL": 1,
    "JMP": 1,
    "INC": 1,
    "DEC": 1,
    "NEG": 1,
    "NOT": 1,
    "SHL": 1,
    "SHR": 1,
    "SAR": 1,
    "CMP": 2,
    "TEST": 2,
    "ADD": 2,
    "ADC": 2,
    "SUB": 2,
    "SBB": 2,
    "AND": 2,
    "OR": 2,
    "XOR": 2
}
from itertools import product



# Example usage
array = ["RA", "RB", "RC", "SP", "XA", "XB", "BA", "BB"]
array2 = ["RA", "RB", "RC", "SP", "XA", "XB", "BA", "BB", "[BA]", "[BB]", "[XA]", "[XB]", "[BA+XA]", "[BA+XB]", "[BB+XA]", "[BB+XB]", "[BA+XA+]", "[BA+XB+]", "[BB+XA+]", "[BB+XB+]", "[BA+XA-]","[BB+XA-]"]
pairs = list(product(possible, array2, array))
instr = random.sample(pairs, 1024)
for pair in instr:
    if lut[pair[0]] == 1:
        print(f"{pair[0]} {pair[1]}")
    else:
        if random.randint(0,1):
            print(f"{pair[0]} {pair[1]}, {pair[2]}")
        else:
            print(f"{pair[0]} {pair[2]}, {pair[1]}")