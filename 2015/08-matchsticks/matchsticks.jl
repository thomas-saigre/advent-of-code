l=length
c=count
f(s)=replace(s,"\\\\"=>"B",r"\\x\w{2}"=>"T","\\\""=>"A","\""=>"")
y(s)=l(s)-l(f(s))
z(s)=c(==('\\'),s)+c(==('\"'),s)+2
l=readlines("i")
print(sum(y.(l))," ",sum(z.(l)))