# This module is common and should export all random variables for task/flags/grade in a reproducible manner and in the same way to avoid inconsistencies

import random
import sys
if len(sys.argv) < 2:
    print("Error: variation hash required", file=sys.stderr)
    sys.exit(1)

random.seed(sys.argv[1])

o1 = [random.randint(0,1) for i in range(4)]
o2 = [random.randint(0,1) for i in range(4)] 

