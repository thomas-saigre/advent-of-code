import numpy as np
from operator import and_, or_, lshift, rshift
import random

operations = {'AND': and_, 'OR': or_, 'LSHIFT': lshift, 'RSHIFT': rshift}
tikz_gate = {'AND': "and port", 'OR': "or port"}

class Wire:
    def __init__(self, lhs, rhs):
        self.lhs = lhs
        self.rhs = rhs

    def __str__(self):
        return f"{self.lhs} -> {self.rhs}"

def parse_input(filename):
    with open(filename, "r") as f:
        lines = f.read().splitlines()
        r = []
        for line in lines:
            s = line.split(' -> ')
            r.append(Wire(s[0], s[1]))
        return r


random.seed("07122015")

def get_random_position(max_val=100):
    return random.randint(0, max_val), random.randint(0, max_val)

def get_random_name():
    chars = "abcdefghijklmnopqrstuvwxyz"
    return ''.join(random.choice(chars) for _ in range(4))



def begin_file(f):
    f.write(r"""\documentclass{standalone}
\usepackage{circuitikz}
\usepackage{amsmath, amssymb}
\begin{document}

\begin{circuitikz}
""")

def add_wire(f, name, value, pos=None):
    if pos is None:
        posX, posY = get_random_position()
        pos = f"{posX},{posY}"
    if name == "a":
        f.write(f"    \\draw({pos}) node[draw, anchor=west, fill=red, xshift=20] ({name}) {{{name}}};\n")
    else:
        f.write(f"    \\draw({pos}) node[draw, anchor=west] ({name}) {{{name}}};\n")
    if value is not None:
        f.write(f"    \\draw[green!50!black] ({name}.west) node[anchor=east] {{{value}}};\n")

def add_not_gate(f, pos=None):
    pos = None
    if pos is None:
        posX, posY = get_random_position()
        pos = f"{posX},{posY}"
    name = get_random_name()
    f.write(f"    \\draw({pos}) node[not port, anchor=west] ({name}) {{}};\n")
    return name

def add_2_gate(f, op, pos=None):
    pos = None
    if pos is None:
        posX, posY = get_random_position()
        pos = f"{posX},{posY}"
    name = get_random_name()
    f.write(f"    \\draw({pos}) node[{tikz_gate[op]}, anchor=west] ({name}) {{}};\n")
    return name

def add_shift_gate(f, op, val, pos=None):
    pos = None
    if pos is None:
        posX, posY = get_random_position()
        pos = f"{posX},{posY}"
    name = get_random_name()
    if op[0] == "L": op_ = r"$\ll$"
    elif op[0] == "R": op_ = r"$\gg$"
    f.write(f"    \\draw({pos}) node[draw, anchor=west] ({name}) {{{op_}{val}}};\n")
    return name

def link(f, in_, out):
    f.write(f"    \\draw ({in_}) |- ({out});\n")

def end_file(f):
    f.write(r"""\end{circuitikz}
\end{document}""")



def generate_tex_file(filename, entries, wires_values):

    with open(filename, 'w') as f:
        begin_file(f)
        wires = []
        for e in entries:
            if e.lhs.isdigit():
                add_wire(f, e.rhs, int(e.lhs))
                wires.append(e.rhs)

            elif "NOT" in e.lhs:
                in1 = e.lhs.replace("NOT ", "")
                out = e.rhs
                if in1 not in wires:
                    add_wire(f, in1, None)
                    wires.append(in1)
                name = add_not_gate(f, pos=f"{in1}.east")
                if out not in wires:
                    add_wire(f, out, None, pos=f"{name}.east")
                    wires.append(out)
                link(f, f"{in1}.east", f"{name}.in 1")
                link(f, f"{name}.out", f"{out}.west")

            elif "AND" in e.lhs or "OR" in e.lhs:
                lhs = e.lhs.split(" ")
                in1 = lhs[0]
                op = lhs[1]
                in2 = lhs[2]
                out = e.rhs
                if in1 not in wires:
                    add_wire(f, in1, None)
                    wires.append(in1)
                if in2 not in wires:
                    add_wire(f, in2, None)
                    wires.append(in2)
                name = add_2_gate(f, op)
                if out not in wires:
                    add_wire(f, out, None, pos=f"{name}.east")
                    wires.append(out)
                link(f, f"{in1}.east", f"{name}.in 1")
                link(f, f"{in2}.east", f"{name}.in 2")
                link(f, f"{name}.out", f"{out}.west")

            elif "SHIFT" in e.lhs:
                lhs = e.lhs.split(" ")
                in1 = lhs[0]
                op = lhs[1]
                shift_val = int(lhs[2])
                out = e.rhs
                if in1 not in wires:
                    add_wire(f, in1, wires_values[in1])
                    wires.append(in1)
                name = add_shift_gate(f, op, shift_val, pos=f"{in1}.east")
                if out not in wires:
                    add_wire(f, out, wires_values[in1], pos=f"{name}.east")
                link(f, f"{in1}.east", f"{name}.west")
                link(f, f"{name}.east", f"{out}.west")

            else:
                in1 = e.lhs
                out = e.rhs
                if in1 not in wires:
                    add_wire(f, in1, wires_values[in1])
                if out not in wires:
                    add_wire(f, out, wires_values[in1], pos=f"{in1}.east")

        print(f"Generated {filename}.")
        end_file(f)



def compute_wires_aux(end, entries, wires):
    if end in wires.keys():
        return wires[end]
    else:
        for e in entries:
            if e.rhs == end:
                if "NOT" in e.lhs:
                    in1 = e.lhs.replace("NOT ", "")
                    val_in = compute_wires_aux(in1, entries, wires)
                    res = ~val_in
                    wires[end] = ~res
                    return res

                elif "AND" in e.lhs or "OR" in e.lhs or "SHIFT" in e.lhs:
                    lhs = e.lhs.split(" ")
                    in1 = lhs[0]
                    op = lhs[1]
                    in2 = lhs[2]
                    if in1.isdigit():
                        val_in1 = np.uint16(in1)
                    else:
                        val_in1 = compute_wires_aux(in1, entries, wires)
                    if in2.isdigit():
                        val_in2 = np.uint16(in2)
                    else:
                        val_in2 = compute_wires_aux(in2, entries, wires)
                    res = operations[op](val_in1, val_in2)
                    wires[end] = res
                    return res

                else:
                    in1 = e.lhs
                    if in1.isdigit():
                        res = np.uint16(in1)
                        wires[end] = res
                        return res
                    else:
                        res = compute_wires_aux(in1, entries, wires)
                        wires[end] = res
                        return res
        print(f"Did not found {end} :/")




def compute_wires(entries, end="a"):
    wires = {}
    value = compute_wires_aux(end, entries, wires)
    return value, wires


def update_entries(entries, resI):
    for e in entries:
        if e.rhs == "b":
            e.lhs = str(resI)


if __name__ == "__main__":
    # input_filename = "example.txt"
    input_filename = "input.txt"
    entries = parse_input(input_filename)
    I, wires = compute_wires(entries)
    print("I", I)
    generate_tex_file("circuitI.tex", entries, wires)

    update_entries(entries, I)
    II, wires = compute_wires(entries)
    print("II", II)
    generate_tex_file("circuitII.tex", entries, wires)
