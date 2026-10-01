#!/usr/bin/env python3
# Used to generate the compilation flags for the solution or maybe for the checker
from generate import *

flags = []
for index, bit in enumerate(o1):
    flags.append(f"-DLUT_O1_{index}={bit}")
for index, bit in enumerate(o2):
    flags.append(f"-DLUT_O2_{index}={bit}")

print(" ".join(flags))
