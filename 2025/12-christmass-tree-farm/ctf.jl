function parse_input(filename)
    open(filename, "r") do f
        lines = readlines(f)

        present_areas = []
        regions = []
        regions_dim = []

        for i ∈ 0:5
            p = lines[5*i+2] * lines[5*i+3] * lines[5*i+4]
            push!(present_areas, count(c -> c == '#', p))
        end

        for j ∈ 31:length(lines)
            s = split(lines[j], ": ")
            push!(regions_dim, parse.(Int, split(s[1], "x")))
            push!(regions, parse.(Int, split(s[2])))
        end

        return present_areas, regions_dim, regions
    end
end

function check_region(dim, region, present_areas)
    total_area = dim[1] * dim[2]
    required_area = 0
    for (i, n) ∈ enumerate(region)
        required_area += n * present_areas[i]
        if required_area > total_area
            return 0
        end
    end
    return 1
end

present_areas, regions_dim, regions = parse_input("input.txt")

I = sum(check_region.(regions_dim, regions, (present_areas,)))
println(I)
