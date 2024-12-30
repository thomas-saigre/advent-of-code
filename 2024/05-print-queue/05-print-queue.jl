using FStrings
using DataStructures: DefaultDict

function parse_input(filename::String)
    input = open(filename) do file
        read(file, String)
    end

    split_input = split(input, "\n\n")

    # Get rules
    rules = DefaultDict{Int,Set{Int}}(Set())
    for rule in split(split_input[1], '\n')
        vals = parse.(Int, split(rule, '|'))
        # println(f"{vals[1]} before {vals[2]}")
        push!(rules[vals[1]], vals[2])
    end

    # Get inputs
    lines = split(split_input[2], '\n')
    inputs = split.(lines, ',')
    inputs = [parse.(Int, input) for input in inputs]

    # println(rules)
    # println(inputs)
    return rules, inputs
end


function is_valid(input, rules)
    for i in eachindex(input)
        for r in rules[input[i]]
            if r ∈ input[begin:i-1]
                return 0
            end
        end
    end
    return input[div(end, 2) + 1]
end

function validate(input, rules)
    while true
        println(input)
        is_sorted = true

        for i in eachindex(input)
            for j in 1:i-1
                if input[j] ∈ input[begin:i-1]
                    tmp = input[j]
                    input[j] = input[i]
                    input[i] = tmp
                    is_sorted = false
                end
            end
        end

        if is_sorted
            break
        end
    end

end

function run()

    input_filename = "example.txt"
    # input_filename = "input.txt"

    rules, inputs = parse_input(input_filename)

    I  = 0
    II = 0

    for input in inputs
        r_tmp = is_valid(input, rules)
        if r_tmp ≠ 0
            I += r_tmp
        else
            II += 0
            # II += validate(input, rules)
        end
    end

    println(f"I : {I}")
    println(f"II: {II}")

end

run()