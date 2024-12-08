import random
import sys
# Set the seed for reproducibility
random.seed(sys.argv[1])

# Array from which to extract random elements
array = [
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
    "MOV": [0b0000000,2],
    "PUSH": [0b0000010,1],
    "CALL": [0b0000100,1],
    "JMP": [0b0000101,1],
    "INC": [0b0001000,1],
    "DEC": [0b0001001,1],
    "NEG": [0b0001010,1],
    "NOT": [0b0001011,1],
    "SHL": [0b0001100,1],
    "SHR": [0b0001101,1],
    "SAR": [0b0001110,1],
    "CMP": [0b0100010,2],
    "TEST": [0b0100100,2],
    "ADD": [0b0101000,2],
    "ADC": [0b0101001,2],
    "SUB": [0b0101010,2],
    "SBB": [0b0101011,2],
    "AND": [0b0101100,2],
    "OR": [0b0101101,2],
    "XOR": [0b0101110,2]
}


regs = {
    "RA": 0b000,
    "RB": 0b001,
    "RC": 0b010,
    "SP": 0b011,
    "XA": 0b100,
    "XB": 0b101,
    "BA": 0b110,
    "BB": 0b111,
}

dep = random.randint(0, 0x10000)

instr = random.sample(array, 1)[0]

sums = ["BA+XA","BA+XB","BB+XA", "BB+XB"]
x = random.sample(sums,1)[0]
rm_bits = sums.index(x)
mem = f"[{x}+depls]"
reg = random.sample(list(regs.keys()), 1)[0]
if lut[instr][1] == 1:
    print(f"{instr} {mem}")
    ins = int(f"{lut[instr][0]:07b}010000{rm_bits:03b}"[::-1],2)
else:
    rg_bits = list(regs.keys()).index(reg)
    if random.randint(0,1):
        op1 = mem
        op2 = reg
        d = 0
    else:
        op1 = reg
        op2 = mem
        d = 1
    print(f"{instr} {op1}, {op2}")
    ins = int(f"{lut[instr][0]:07b}{d}10{rg_bits:03b}{rm_bits:03b}"[::-1],2)
f = open("cram.mem", "w")
print(f"{ins:04x} {dep:04x}", file=f)
for i in range(2**10-2):
    print(f"{random.randint(0, 0xffff):04x}", file=f)

f.close()

f = open("regfile.mem", "w")
for i in range(2**3):
    print(f"{random.randint(0, 0xffff):04x}", file=f)
f.close()