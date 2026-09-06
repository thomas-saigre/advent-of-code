

def get_containers(path: str):
    containers = []
    with open(path, 'r') as f:
        for l in f.readlines():
            containers.append(int(l))
    return sorted(containers)[::-1]


def count(liter: int, containers: list, current: list):
    res = []
    s = sum(current)

    if s == liter:
        res.append(current)

    if s >= liter:      # We have already filled too much (or exactly)
        return res

    for i, c in enumerate(containers):
        # We fill container c, and recursively look if in the remaining containers it's ok or not
        tmp_rs = count(liter, containers[i+1:], current + [c])
        res += tmp_rs

    return res


c = get_containers('input.txt')
obj = 150
res = count(obj, c, [])
I = len(res)
print(" I", I)
ord = sorted(res, key=lambda x: len(x))
good = len(ord[0])
II = 0
for i in ord:
    if len(i) == good:
        II += 1
    if len(i) > good:
        break
print("II", II)