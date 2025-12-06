import pandas as pd
import functools

# filename = "example.txt"
filename = "input.txt"

operators = {"+": lambda x,y: x+y,
             "*": lambda x,y: x*y
            }

df = pd.read_csv(filename, sep=r'\s+', header=None)
op = df.tail(1)
df.drop(df.tail(1).index, inplace=True)
df = df.astype(int)


I = 0
for i in range(len(df.columns)):
    I += functools.reduce(operators[op[i].iloc[-1]], df[i])
print(I)
