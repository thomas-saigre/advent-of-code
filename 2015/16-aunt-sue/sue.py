
class Sue():

    def __init__(self, n, children=None, cats=None, samoyeds=None, pomeranians=None, akitas=None, vizslas=None, goldfish=None, trees=None, cars=None, perfumes=None):
        self.n = n
        self.children = children
        self.cats = cats
        self.samoyeds = samoyeds
        self.pomeranians = pomeranians
        self.akitas = akitas
        self.vizslas = vizslas
        self.goldfish = goldfish
        self.trees = trees
        self.cars = cars
        self.perfumes = perfumes

    def check_I(self, **kwargs):
        for k, val in kwargs.items():
            if getattr(self, k) is not None and getattr(self, k) != val:
                # print(f"Sue {self.n} has {getattr(self, k)} {k}, and not {val}")
                return False
        return True

    def check_II(self, **kwargs):
        for k, val in kwargs.items():
            if (sue_value := getattr(self, k)) is not None:
                if k in ["cats", "trees"]:
                    if not sue_value > val:
                        return False
                elif k in ["pomeranians", "goldfish"]:
                    if not sue_value < val:
                        return False
                else:
                    if sue_value != val:
                        return False
        return True

MFCSAM_RESULT = {
    "children":     3,
    "cats":         7,
    "samoyeds":     2,
    "pomeranians":  3,
    "akitas":       0,
    "vizslas":      0,
    "goldfish":     5,
    "trees":        3,
    "cars":         2,
    "perfumes":     1
}

def parse_attributes(string):
    attributes = {}
    pairs = string.split(", ")
    for pair in pairs:
        key, value = pair.split(": ")
        attributes[key] = int(value)
    return attributes

def parse_input(filename):
    sues = []
    with open(filename, 'r') as file:
        lines = file.readlines()
        for l in lines:
            number, attributes_str = l.split(":", 1)
            number = int(number.split()[-1])
            attributes = parse_attributes(attributes_str.strip())
            # print(f"{number}: {attributes}")
            s = Sue(number, **attributes)
            sues.append(s)
            # number, attributes = l.split(":")
            # sues.append(Sue(number, **attributes))
    return sues

sues = parse_input("input.txt")

for sue in sues:
    if sue.check_I(**MFCSAM_RESULT):
        print("I :", sue.n)
    if sue.check_II(**MFCSAM_RESULT):
        print("II:", sue.n)
