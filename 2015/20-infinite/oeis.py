from oeis_sequences.OEISsequences import A000203
from collections import defaultdict
puzzle_input = 29000000
target_i = puzzle_input // 10
def test(n): return A000203(n) >= target_i
I = 1
while not test(I):
    I += 1
print("I :", I)
houses = defaultdict(int)
target_ii = puzzle_input // 11
for elf in range(1, target_ii):
    for h in range(1,51):
        houses[elf*h] += elf
    if houses[elf] >= target_ii:
        print("II:", elf)
        break
