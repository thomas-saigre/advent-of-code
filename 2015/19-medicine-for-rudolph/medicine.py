

input_mollecule = "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF"

subs = []

f = open("input.txt")
lines = f.readlines()
f.close()

for line in lines:
    src, res = line.rstrip().split(" => ")
    subs.append((src, res))

def make_substitution(str, idx, l, res):
    return str[:idx] + res + str[idx+l:]


def nexts(mollecule, subs):
    news = set()
    mol = mollecule + '.'
    for i in range(len(mol)-1):
        for (src, res) in subs:
            if mol[i] == src:
                news.add(make_substitution(mollecule, i, 1, res))
            if mol[i:i+2] == src:
                news.add(make_substitution(mollecule, i, 2, res))
    return news


first_step = nexts(input_mollecule, subs)
print("I", len(first_step))


from treelib.tree import Tree


def build_molleclule(target_mol, subs):
    tree = Tree()
    tree.create_node("e", identifier="e")
    count = 0

    crt = True
    while crt:
        count += 1
        leaves = tree.leaves()
        for l in leaves:
            print(f"{len(leaves)} leaves",end="\r")
            mollecules = nexts(l.tag, subs)
            for m in mollecules:
                if not tree.contains(m):
                    tree.create_node(m, parent=l, identifier=m)
                if m == target_mol:
                    crt = False
        # tree.show()
    return count

def magic_from_the_internet(target_mol):
    # Magic formula : #NumSymbols - #Rn - #Ar - 2 * #Y - 1
    # https://www.reddit.com/r/adventofcode/comments/3xflz8/comment/cy4h7ji/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    NumSymbols = sum(1 for c in target_mol if c.isupper())
    Rn = target_mol.count('Rn')
    Ar = target_mol.count('Ar')
    Y = target_mol.count('Y')
    return NumSymbols - Rn - Ar - 2 * Y -1


# II = build_molleclule("HOH", [("e", "H"), ("e", "O"), ("H", "HO"), ("H", "OH"), ("O", "HH")])
# II = build_molleclule("HOHOHO", [("e", "H"), ("e", "O"), ("H", "HO"), ("H", "OH"), ("O", "HH")])
# II = build_molleclule(input_mollecule, subs)
II = magic_from_the_internet(input_mollecule)
print("II", II)


