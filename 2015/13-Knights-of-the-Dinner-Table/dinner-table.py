import numpy as np
import itertools
import sys

def parse_input(filename):
    f = open(filename, 'r')
    lines = f.readlines()
    l = len(lines)
    n = int((1 + (1 + 4*l)**0.5) / 2)

    hapinnes = np.zeros((n,n), dtype=int)

    corr = {}
    idx = 0

    for line in lines:
        words = line[:-2].split()
        subject = words[0]
        if subject not in corr:
            corr[subject] = idx
            idx += 1
        target = words[-1]
        eps = 1 if words[2] == 'gain' else -1
        if target not in corr:
            corr[target] = idx
            idx += 1

        hapinnes[corr[subject], corr[target]] = eps * int(words[3])

    return hapinnes, corr

def find_best(hapiness):
    m_h = -sys.maxsize - 1
    n = hapiness.shape[0]
    for p in itertools.permutations(range(n)):
        p = np.array(p)
        indices = np.arange(n)
        next_indices = (indices + 1) % n
        h = np.sum(hapiness[p[indices], p[next_indices]] + hapiness[p[next_indices], p[indices]])
        m_h = max(h, m_h)
    return m_h

# h, c = parse_input("example.txt")
h, c = parse_input("input.txt")

n = h.shape[0]
h_II = np.hstack((np.vstack((h, np.zeros(n, dtype=int))), np.zeros((n+1,1), dtype=int)))
# print(h_II)

I = find_best(h)
print(I)
II = find_best(h_II)
print(II)