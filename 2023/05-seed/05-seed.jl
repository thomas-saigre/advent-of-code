# input_filename = "example.txt"
input_filename = "input.txt"


function get_seeds(input)
    number_list = parse.(Int, split(input, " ")[2:end])
    return number_list
end


function parse_permutations(filename::String)
    permutations = []
    split_file = split(strip(read(filename, String)), "\n\n")

    line_by_line = split.(split_file, "\n")

    # get the seeds
    seeds = get_seeds(line_by_line[begin][begin])
    #get the permutations
    for p in line_by_line[begin+1:end]
        res = split.(p[begin+1:end], " ")
        sigma = map(m -> parse.(Int, m), res)
        push!(permutations, sigma)
    end

    return seeds, permutations
end

function apply_permutation(input::Int, permutation)
    for sigma in permutation
        map = sigma[1]      # begining of the outpu interval
        beg = sigma[2]      # begining of the input interval
        len = sigma[3]      # length of the intervals
        offset = map - beg
        if input in beg:beg+len-1
            return  input + offset
        end
    end
    return input
end


function run_pipeline_I(seeds, permutations)
    locations = zeros(Int, length(seeds))
    for i in eachindex(seeds)
        out = seeds[i]
        # print(i, ": ", out, " ")
        for sigma in permutations
            out = apply_permutation(out, sigma)
            # print(out, " ")
        end
        locations[i] = out
        # print("\n")
    end
    m = min(locations...)
    return m
end

function run_pipeline_II(seeds, permutations)
    m = typemax(Int)
    ln = length(seeds)
    idx = 1
    while idx <= ln
        bg = seeds[idx]
        en = bg + seeds[idx+1]
        print("performing ", bg, ":", en, "\n")
        for seed in bg:en-1
            out = seed
            for sigma in permutations
                out = apply_permutation(out, sigma)
            end
            if out < m
                m = out
            end
        end
        idx += 2
    end

    return m
end


seeds, permutations = parse_permutations(input_filename)
print("seedsI = ", seeds, "\n")


result_I = run_pipeline_I(seeds, permutations)
print("Part I: ", result_I, "\n")
result_II = run_pipeline_II(seeds, permutations)
print("Part II: ", result_II, "\n")


