function parse_input(filename::String)
    f = open(filename, "r")
    lines = readlines(f)
    idx = findfirst(item -> item == "", lines)
    # println(idx)
    ranges = [parse.(Int, split(line, "-")) for line in lines[begin:idx-1]]
    # println(ls)
    ingredient = parse.(Int, lines[idx+1:end])
    # println(ingredient)
    return ranges, ingredient
end

function is_valid(ranges, ig)
    for (a,b) ∈ ranges
        if ig ∈ a:b
            return 1
        end
    end
    return 0
end

function partII(ranges)
    sort!(ranges, lt=(x,y)->x[1] < y[1])     # we sort the range so they are in increasing order
    nb_ranges = length(ranges)
    idx = 1
    n = 0
    while idx < nb_ranges
        entry = ranges[idx][1]
        exit = ranges[idx][2]
        idx += 1
        while idx <= nb_ranges &&  exit >= ranges[idx][1]    # we check if the next range overlap the current one (and that we are stil inbound)
            exit = max(exit, ranges[idx][2])
            idx += 1
        end
        # println(entry, " - ", exit, " (", idx, ")")
        n += exit - entry + 1 # Théorème de Mickey
    end
    return n
end

# ranges, ingredient = parse_input("example.txt")
ranges, ingredient = parse_input("input.txt")
I = sum(is_valid.((ranges,), ingredient))
println(I)

II = partII(ranges)
println(II)
