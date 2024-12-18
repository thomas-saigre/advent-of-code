import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image

MEM_VAL = 1
PATH_VAL = 2

input = np.loadtxt("input.txt", delimiter=",", dtype=int)



def get_neighbors(x, y, memory):
    neighbors = []
    for dx, dy in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
        if 0 <= x + dx < 71 and 0 <= y + dy < 71:
            if memory[x + dx, y + dy] == 0:
                neighbors.append((x + dx, y + dy))
    return neighbors


def shortest_path(memory, start=(0,0), end=(70,70)):
    P = set()
    dist = np.ones((71,71)) * np.inf
    dist[start] = 0
    pred = {}

    while True: # Tant qu'il existe un sommet hors de P
        a = None
        min_dist = np.inf
        for i in range(71):
            for j in range(71):
                if (i, j) not in P and dist[i, j] < min_dist:
                    min_dist = dist[i, j]
                    a = (i, j)
        if a is None:
            break
        # print("Sommet ", a)
        P.add(a)

        if a == end:
            break

        neighbors = get_neighbors(*a, memory)
        # print("Voisins ", neighbors)

        for b in neighbors:
            if b not in P:
                if dist[b] > dist[a] + 1:
                    dist[b] = dist[a] + 1
                    pred[b] = a

    return dist[end], pred


def partI():
    memory = np.zeros((71,71))

    for i in range(1024):
        x, y = input[i]
        memory[x, y] = MEM_VAL

    dist, pred = shortest_path(memory)
    print("I:", int(dist))

    path = (70,70)
    while path != (0,0):
        memory[path] = PATH_VAL
        path = pred[path]
    memory[0,0] = PATH_VAL
    matplotlib.image.imsave('pathI.png', memory, cmap="viridis")
    # plt.imshow(memory, cmap="viridis")
    # plt.savefig("pathI.png")


def partII(init=2938):      # magic !
    memory = np.zeros((71,71))
    i = 0

    for _ in range(init):
        x, y = input[i]
        memory[x, y] = MEM_VAL
        i += 1

    crt = True
    while crt:
        x, y = input[i]
        memory[x, y] = MEM_VAL
        print(i, input[i], end=" ")

        dist, pred = shortest_path(memory)
        print(dist)
        if dist == np.inf:
            crt = False
            print("II:", f"{input[i][0]},{input[i][1]}")
            memory[0,0] = PATH_VAL
            matplotlib.image.imsave('pathII.png', memory, cmap="viridis")
        i += 1


partI()
partII()