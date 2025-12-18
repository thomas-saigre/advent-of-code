using JSON

function count(filename::String)
    # input has only 1 line
    file = readlines(filename)[begin]
    number_pattern = r"(-|)\d+"
    numbers = parse.(Int, [ match.match for match in eachmatch(number_pattern, file)])
    return sum(numbers)
end

# unfirtunately, I did not found a working way to do part II with regexp only :/
# red_pattern = r"(\{[^}]*\"[a-z]+\":\"red\"[^}]*\})"
# a = [ match.match for match in eachmatch(red_pattern, file)]
# for v in a
#     println(v)
# end
# println(length(a))

function clean_json(j)
    if typeof(j) == Vector{Any}
        res = []
        for e ∈ j
            c_e = clean_json(e)
            if c_e !== nothing
                push!(res, c_e)
            end
        end
        return res
        # return [ e for e ∈ j if (e = clean_json(e); e !== nothing) ]
    end
    if typeof(j) == JSON.Object{String, Any}
        if "red" ∉ values(j)
            res = Dict()
            for k in keys(j)
                c_e = clean_json(j[k])
                if c_e !== nothing
                    res[k] = c_e
                end
            end
            return res
        else
            return nothing
        end
    end
    # println(j, " of type ", typeof(j))
    return j
end

I = count("input.txt")
println("I : ", I)

j = JSON.parsefile("input.txt")
cleaned = clean_json(j)
open("output.json", "w") do f
    write(f, JSON.json(cleaned))
end
II = count("output.json")
println("II: ", II)
