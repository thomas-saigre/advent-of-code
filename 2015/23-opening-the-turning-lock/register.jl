

struct Instruction
    type::String
    reg::Int        # 1 for a, 2 for b, 0 if not concerned
    offset::Int
end

name_to_reg = Dict([
    ('a', 1),
    ('b', 2),
])

function parse_input(filename)

    r::Vector{Instruction} = []

    open(filename, "r") do file
        for line in eachline(file)
            name = line[1:3]

            reg = 0
            if name != "jmp"
                reg = name_to_reg[line[5]]
            end

            offset = 1
            if name in ["jmp", "jie", "jio"]
                offset = parse(Int, line[end-2:end])    # This should work for my input as the number of offset has at most two digits
            end

           push!(r, Instruction(name, reg, offset))
        end
    end

    return r
end

function run(instruction_list::Vector{Instruction}, a_init::Int = 0)
    reg::Vector{Int} = [a_init, 0]    # initially both registers at 0
    size = length(instruction_list)
    idx = 1

    while(1 ≤ idx ≤ size)
        curr = instruction_list[idx]
        # println(idx, ": ", reg, "  ", curr)
        if curr.type == "hlf"
            reg[curr.reg] /= 2
            idx += 1
        elseif curr.type == "tpl"
            reg[curr.reg] *= 3
            idx += 1
        elseif curr.type == "inc"
            reg[curr.reg] += 1
            idx += 1
        elseif curr.type == "jmp"
            idx += curr.offset
        elseif curr.type == "jie"   # jump if even
            if reg[curr.reg] % 2 == 0
                idx += curr.offset
            else
                idx += 1            # to avoid infinite loop, but actually the description does not tell about it ¯\_(ツ)_/¯
            end
        elseif curr.type == "jio"   # jump if one
            if reg[curr.reg] == 1
                idx += curr.offset
            else
                idx += 1
            end
        end
    end
    # println("End ", reg)
    return reg
end

ins = parse_input("input.txt")

res_1 = run(ins)
println("Part I  : ", res_1[2])

res_2 = run(ins, 1)
println("Part II : ", res_2[2])
