# input_filename = "ex.txt"
input_filename = "input.txt"

function parse_input(filename)
    f = open(filename, "r")
    lines = readlines(f)
    close(f)
    s = split.(lines, " ")
    return map(m -> parse.(Int, m), s)
end

function predict(data, element, f=1)
    if all(x -> x == 0, data)
        return 0
    else
        new_line = data[begin+1:end] .- data[begin:end-1]
        # println("New line: ", new_line)
        return element(data) + f * predict(new_line, element, f)
    end
end

function run(data_list, element, f=1)
    sum = 0
    for data in data_list
        sum += predict(data, element, f)
    end
    return sum
end


data = parse_input(input_filename)

I = run(data, last)
println("Part I: ", I)
II = run(data, first, -1)
println("Part II: ", II)