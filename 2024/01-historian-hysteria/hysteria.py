import numpy as n
o=lambda v:print(sum(n.abs(v[:,1]-v[:,0])))
l=lambda v:print(sum([dict(zip(*n.unique(v[:,1],return_counts=True))).get(e,0)*e for e in v[:,0]]))
d=n.loadtxt("t");d.sort(0);o(d);l(d)