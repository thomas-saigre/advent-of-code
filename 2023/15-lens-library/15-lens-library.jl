# input_filename = "example.txt"
input_filename = "input.txt"

function parse_input(filename::String)
    f = open(filename)
    lines = readlines(f)
    close(f)
    return split(lines[1], ",")
end

function hash(word)
    hash = 0
    for c in word
        hash += Int(c)
        hash = (17 * hash) % 256
    end
    return hash
end

function hasmap(input)
    if '=' in input
        s = split(input, '=')
        key = s[begin]
        value = parse(Int, s[end])
        return key, value
    elseif '-' in input
        s = split(input, '-')
        key = s[begin]
        value = -1
        return key, value
    else
        println("Error: invalid input")
    end
end

function run_2(inputs)
    boxes = [ [] for _ in 1:256 ]

    for input in inputs
        key, value = hasmap(input)
        box_nb = hash(key) + 1      # in julia, index starts at 1
        idx = findfirst(x -> x[1] == key, boxes[box_nb])
        if value == -1
            if !isnothing(idx)
                splice!(boxes[box_nb], idx)
            end
        else
            if isnothing(idx)
                push!(boxes[box_nb], (key, value))
            else
                boxes[box_nb][idx] = (key, value)
            end
        end
    end

    sum = 0
    for (i, box) in enumerate(boxes)
        for (j, (key, length)) in enumerate(box)
            # println("boxes[$i][$j] = ($key, $length)")
            sum += i * j * length
        end
    end
    return sum

end

input = parse_input(input_filename)

I = sum(hash.(input))
println("I = ", I)

II = run_2(input)
println("II = ", II)