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

I = sum(partI.(split.(eachline(file),"")))
println(I)