# Infinite elfs and infinite houses

Let $p$ be the puzzle input (29000000 in ma case), then for part I we look at the smallest $n$ such that
$$
    10\times \sum_{d|n}d \geqslant p,
$$
or equivalently, $\sigma_1(n) \geqslant \frac{p}{10}$, where $\sigma_1(n)$ is the sum of all divisors of $n$.

The sequence $(\sigma_1(n))_n$ is registered as the sequence [A00203](https://oeis.org/A000203) in the OEIS.

So to solve part I, we can use the python library [python-oeis](https://pypi.org/project/python-oeis/). This is surely not optimal at all, but it does the work !

Unfortunatrly, for part II, we cannot use this sequence anymore, as the elfs stop their distribution before infinity (who can blame them !).

Note for part II, in the same spirit as in the first one, as the elf give 11 presents at each time, we can just divide the input by 11 to reduce the computational time.
