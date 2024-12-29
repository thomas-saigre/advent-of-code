# input_filename = "example.txt"
# input_filename = "example2.txt"
input_filename = "input.txt"


function make_mul(instruction)
    nb = parse.(Int, split(instruction[5:end-1], ",")) # 🪄
    return prod(nb)
end



input = open(input_filename) do file
    read(file, String)
end

regexI = r"mul\(\d+,\d+\)"
println("I ", sum(m -> make_mul(m.match), eachmatch(regexI, input)))


regexII = r"(mul\(\d+,\d+\)|do\(\)|don't\(\))"

function II(input)
    do_mul = true
    res = 0
    for m in eachmatch(regexII, input)
        if m.match == "do()"
            do_mul = true
        elseif m.match == "don't()"
            do_mul = false
        else
            if do_mul
                res += make_mul(m.match)
            end
        end
    end
    return res
end

println("II ", II(input))