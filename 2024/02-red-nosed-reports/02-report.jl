# input_filename = "example.txt"
input_filename = "input.txt"


function is_valid_array(values)
    diffs = values[2:end] .- values[1:end-1]

    if all(>(0), diffs) || all(<(0), diffs)
        vabs = abs.(diffs)
        if all(>=(1), vabs) && all(<=(3), vabs)
            # println("  safe")
            return 1
        end
    end
    # println("  unsafe")
    return 0
end


function is_valid(input::String)
    values = parse.(Int, split(input, " "))
    # print(values)
    return is_valid_array(values)
end


function is_valid_dampener(input::String)
    values = parse.(Int, split(input, " "))
    if is_valid_array(values) == 1
        return 1
    end
    for i in eachindex(values)
        is_safe = is_valid_array(vcat(values[1:i-1], values[i+1:end]))
        if is_safe == 1
            return 1
        end
    end
    return 0
end

open(input_filename, "r") do file
    lines = collect(eachline(file))
    println("I  ", sum(is_valid.(lines)))
    println("II ", sum(is_valid_dampener.(lines)))
end