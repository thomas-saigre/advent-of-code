# input_filename = "example.txt"
input_filename = "input.txt"

using Combinatorics
import Base.Iterators: product

function parse_input(input_filename)
    input_file = open(input_filename)
    lines = readlines(input_file)
    close(input_file)

    map = []
    ranges = []

    for (m, r) in split.(lines, " ")
        push!(map, m)
        push!(ranges, parse.(Int, split(r, ",")))
    end

    return map, ranges
end

function check_map(map, ranges)
    s = filter( !=(""), split(map, ".") )
    return (length(s) == length(ranges)) && (all(length.(s) .== ranges))
end


function replace_unknown(map, idx, p)
    vct = collect(map)
    vct[idx] .= p
    return join(vct)
end

function count_valid(map, ranges)
    count = 0
    # println("Map : ", map)
    unknown = findall( ==('?'), map)
    for p in product(fill("#.", length(unknown))...)
        new_map = replace_unknown(map, unknown, p)
        # println(new_map, ", ", ranges)
        if check_map(new_map, ranges)
            count += 1
        end
    end
    # print("    count = ", count, "\n")
    return count
end

function part_1(map, ranges)
    sum = 0
    for (m, r) in zip(map, ranges)
        sum += count_valid(m, r)
    end
    return sum
end

map, ranges = parse_input(input_filename)
# println("Map : ", map)
# println("Ranges : ", ranges)

# println("Check map : ", check_map(".##..#....###.", [1,1,3]))

# count_valid("???.###.", [1,1,3])
# count_valid(".??..??...?##.", [1,1,3])


I = part_1(map, ranges)
println("I = ", I)