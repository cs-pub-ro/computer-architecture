import random
import sys
# Set the seed for reproducibility
random.seed(sys.argv[1])

numbers = list(range(16))
random.shuffle(numbers)
for i in range(16):
    print(f"-DIR{i}={numbers[i]}", end=" ")
print()