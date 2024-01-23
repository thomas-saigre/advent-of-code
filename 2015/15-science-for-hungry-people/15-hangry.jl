############# SCIENCE FOR HUNGRY PEOPLE #############
#= hand written form =#  tab  =  #= the input file =#
[[2,0,-2,0,3] [0,5,-3,0,3] [0,0,5,-1,8] [0,-1,0,5,8]]
#= Get cost from spoons =# function cost(n, tab_inpu)
igr = [n .* r for r in eachrow(tab_inpu[1:end-1, :])]
vals #=_not_manuel_=# = sum.(igr);if all(>=(0), vals)
return     prod(vals); else          return 0 end end
function   calories(n, tab)   calories =n.*tab[end,:]
;;return   sum(calories)end   ;function f(target_sum)
resul  =   []; for first_vl   in 0:#= ∴ =# target_sum
for b in   0: (target_sum -   first_vl) a = first_vl;
for c in   0:(target_sum +0          - first_vl - b);
d_valu =   target_sum - a - b - c;   d = d_valu;if a+
b+c+d ==   target_sum;push!(resul,   [first_vl, b, c,
d] ) end   end end #=_AoC_ =# end;   return resul end
target_s   = 100; LL = f(target_s)   ;function d(vct)
m=-1;for   v in vct c=cost(          v, tab); if c> m
m = c;end;end; return m end;function g(vct); m = -1.;
for v in vct; c = cost(v, tab);if c >m&& (calories(v,
tab) == 500) m = c end end; return trunc(Int, m) end;
#=EAT=# println(d(LL));println(g(LL)) #=COOKIES 🍪 =#