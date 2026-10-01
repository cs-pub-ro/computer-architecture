from generate import *


print("Implement this lut:")
print("a|b|o1|o2")
print("---------")

for (a,b,o1,o2) in zip([0,0,1,1],[0,1,0,1],o1,o2):
    print(f"{a}|{b}| {o1}| {o2}")

