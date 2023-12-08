# input_filename = "ex1.txt"
# input_filename = "ex2.txt"
# input_filename = "ex3.txt"
input_filename = "input.txt"


function parse_map(input_filename)
    f = open(input_filename, "r")
    lines = readlines(f)
    close(f)
    idx = 1
    instructions = lines[idx]
    idx += 2
    map = Dict()
    while idx <= length(lines)
        line = lines[idx]
        line = split(line, " = ")
        location = line[1]
        tmp = replace(line[2], '(' => "")
        tmp = replace(tmp, ')' => "")
        left_rigth = split(tmp, ", ")
        map[location] = left_rigth
        idx += 1
    end

    return instructions, map
end



function part_1(instructions, map)
    n_step = 0
    idx = 1
    location = "AAA"

    while location != "ZZZ"
        n_step += 1
        ins = instructions[idx]
        location = (ins == 'L') ? map[location][1] : map[location][2]
        if idx + 1 > length(instructions)
            idx = 1
        else
            idx += 1
        end
        # println("Now in ", location)
    end

    return n_step
end


function part_2_aux(instructions::String, map::Dict, dep)
    n_step = 0
    idx = 1
    location = dep
    while !endswith(location, "Z")
        n_step += 1
        ins = instructions[idx]
        location = (ins == 'L') ? map[location][1] : map[location][2]
        if idx + 1 > length(instructions)
            idx = 1
        else
            idx += 1
        end
    end
    return n_step
end


function part_2(instructions, map)
    locations = [e for e in filter(x->endswith(x, "A"), keys(map))]
    lam = (x->part_2_aux(instructions, map, x))
    steps = lam.(locations)

    return lcm(steps...)

end


instructions, map = parse_map(input_filename)

n_step_1 = part_1(instructions, map)
println("Part 1: ", n_step_1)

n_step_2 = part_2(instructions, map)
println("Part 2: ", n_step_2)