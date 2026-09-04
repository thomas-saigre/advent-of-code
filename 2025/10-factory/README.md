# Deal with joltage

Let's get the example

```
(3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
```

We set $n=4$ the number of counters and $m=6$ the number of switches.
Let $j = \begin{bmatrix}3 & 5 & 4 & 7\end{bmatrix}^T \in\mathbb{R}^n$ the objective joltage.

Let's convert the switches to a matrix :

$$
S :=
\begin{bmatrix}
0 & 0 & 0 & 0 & 1 & 1\\
0 & 1 & 0 & 0 & 0 & 1\\
0 & 0 & 1 & 1 & 1 & 0\\
1 & 1 & 0 & 1 & 0 & 0\\
\end{bmatrix}
\in\mathbb{R}^{n\times m}
$$

We want to get the number of time we need to press the buttons to have a total of joltage corresponding to $J$, so we need to find $x\in\mathbb{R}^m$ such that

$$
Sx = j
$$

From the problem description, one solution is $x = \begin{bmatrix}1 & 3 & 0 & 3 & 1 & 2\end{bmatrix}^T$, whose sum is 10.
This is actually not the only solution, my code returns $x = \begin{bmatrix}1 & 2 & 0 & 4 & 0 & 3\end{bmatrix}^T$.
