input_filename = "example.txt"
# input_filename = "input.txt"

dir_map = Dict(
    "R" => (0, 1),
    "L" => (0, -1),
    "U" => (-1, 0),
    "D" => (1, 0)
)

dir_of_code = Dict(
    '0' => "R",
    '1' => "D",
    '2' => "L",
    '3' => "U"
)

function parse_input(filename)
    f = open(filename)
    input = readlines(f)
    close(f)
    lines = split.(input, " ")
    s = (x) -> [x[1], parse(Int, x[2]), x[3][2:end-1]]
    return s.(lines)
end

function convert_plan(plan)
    s = (x) -> [dir_of_code[x[3][end]], parse(Int, replace(x[3][begin:end-1], '#' => "0x")), "#"]
    return s.(plan)
end

function dig(plan, i0=0, j0=0)
    # In field, 0 means not digged, 1 means digged
    field = Dict((i0, j0) => 1)
    current_i = i0
    current_j = j0

    for (dir, len, _) in plan
        dir_vct = dir_map[dir]
        for _ in 1:len
            current_i += dir_vct[1]
            current_j += dir_vct[2]
            field[(current_i, current_j)] = 1
        end
    end
    return field
end


function fill(field, i1, j1)
    field[(i1, j1)] = 2
    for (i_, j_) in [(i1-1, j1), (i1+1, j1), (i1, j1-1), (i1, j1+1)]
        if get(field, (i_, j_), 0) == 0
            fill(field, i_, j_)
        end
    end
end

plan = parse_input(input_filename)
# for line in plan
#     println(line)
# end
field = dig(plan)
println(length(field))
# println(minimum(keys(field)))
# println(maximum(keys(field)))

# We consider that there is only 1 connex component, and that (1, 1) is inside it.
# and it works !
fill(field, 1, 1)
I = length(field)
println("1: ", I)

plan_2 = convert_plan(plan)
# for line in plan_2
#     println(line)
# end

field_2 = dig(plan_2)
println(minimum(keys(field_2)))
println(maximum(keys(field_2)))
fill(field_2, 1, 1)

II = length(field_2)
println("2: ", II)