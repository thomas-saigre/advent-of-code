import pandas as pd
import functools
import numpy as np

operators = {"+": lambda x,y: x+y, "*": lambda x,y: x*y}
neutral = {"+": 0, "*": 1}

# filename = "example.txt"
filename = "input.txt"

df = pd.read_csv(filename, sep=r'\s+', header=None)
op = df.tail(1)
df.drop(df.tail(1).index, inplace=True)
df = df.astype(int)


def math_earth(df):
    I = 0
    for i in range(len(df.columns)):
        I += functools.reduce(operators[op[i].iloc[-1]], df[i])
    return I

I = math_earth(df)
print(I)

def math_cephalopods(filename, df_partI, op):
    n_cols = len(df_partI.columns)
    f = open(filename, 'r')
    lines = f.readlines()[:-1]

    n_lines = len(lines)
    len_line = len(lines[0])

    big_array = np.empty((n_lines, len_line-1), dtype=str)
    for i, line in enumerate(lines):
        big_array[i,:] = list(line[:-1])

    II = 0

    idx_str = big_array.shape[1] - 1
    idx_op = n_cols - 1

    while idx_op >= 0 and idx_str >= 0:
        col_res = neutral[op[idx_op].iloc[-1]]
        cur_col = ''.join(big_array[:, idx_str])
        while cur_col.strip() != "":
            other = int(cur_col)
            col_res = operators[op[idx_op].iloc[-1]](col_res, other)
            idx_str -= 1
            cur_col = ''.join(big_array[:, idx_str])

            if idx_str < 0:
                break

        idx_op -= 1
        idx_str -= 1
        II += col_res

    return II

II = math_cephalopods(filename, df, op)
print(II)