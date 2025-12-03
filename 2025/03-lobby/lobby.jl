file = open("input.txt", "r")

function partI(l)
    i = argmax(l)
    if i == length(l) # Case 1 : the biggest digit is at the top right
        j = argmax(l[begin:end-1])
        return parse(Int, l[j]*l[i])
    else
        j = argmax(l[i+1:end]) + i
        return parse(Int, l[i]*l[j])
    end
end

function partII(l, n=12)
    s = ""
    idx = 0
    for i in (n-1):-1:0
        idx += argmax(l[idx+1:end-i])
        s *= l[idx]
    end
    return parse(Int, s)
end

I = sum(partI.(split.(eachline(file),"")))
println(I)

II = sum(partII.(split.(eachline(file),"")))
println(II)