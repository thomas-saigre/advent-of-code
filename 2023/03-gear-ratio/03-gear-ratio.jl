# input_file = "example.txt"
input_file = "input.txt"

function parse_file(filename)

    lines = []
    open(filename, "r") do file
        for line in eachline(file)
            push!(lines, line)
        end
    end

    return lines
end

function read_number(line::String, index::Int)
    number = ""
    size = 0
    for i in index:length(line)
        c = line[i]
        if isdigit(c)
            number = number * c
            size += 1
        else
            break
        end
    end
    return parse(Int, number), size
end


function is_special_char(c::Char)
    return !isdigit(c) && c != '.'
end

function look_around(lines, i::Int, j::Int, size::Int)
    number_of_lines = length(lines)
    size_of_line = length(lines[begin])

    # look around the number
    # First the line above (if it exists)
    if i > 1
        if j > 1
            if is_special_char(lines[i-1][j-1])
                print("above")
                return true
            end
        end
        for idx in j:j+size
            if idx <= size_of_line && is_special_char(lines[i-1][idx])
                print("above")
                return true
            end
        end
    end

    # Then the line below (if it exists)
    if i < number_of_lines
        if j > 1
            if is_special_char(lines[i+1][j-1])
                print("below")
                return true
            end
        end
        for idx in j:j+size
            if idx <= size_of_line && is_special_char(lines[i+1][idx])
                print("below")
                return true
            end
        end
    end

    # On the left
    if j > 1
        if is_special_char(lines[i][j-1])
            print("left")
            return true
        end
    end

    # On the right
    if j+size <= size_of_line
        if is_special_char(lines[i][j+size])
            print("right")
            return true
        end
    end

    return false

end


function look_around_for_star(lines, i::Int, j::Int, size::Int)
    number_of_lines = length(lines)
    size_of_line = length(lines[begin])

    # look around the number
    # First the line above (if it exists)
    if i > 1
        if j > 1
            if lines[i-1][j-1] == '*'
                print("above")
                return i-1, j-1
            end
        end
        for idx in j:j+size
            if idx <= size_of_line && lines[i-1][idx] == '*'
                print("above")
                return i-1, idx
            end
        end
    end

    # Then the line below (if it exists)
    if i < number_of_lines
        if j > 1
            if lines[i+1][j-1] == '*'
                print("below")
                return i+1, j-1
            end
        end
        for idx in j:j+size
            if idx <= size_of_line && lines[i+1][idx] == '*'
                print("below")
                return i+1, idx
            end
        end
    end

    # On the left
    if j > 1
        if lines[i][j-1] == '*'
            print("left")
            return i, j-1
        end
    end

    # On the right
    if j+size <= size_of_line
        if lines[i][j+size]  == '*'
            print("right")
            return i, j+size
        end
    end

    return -1, -1

end




function engine_number(lines)
    engine_number = 0

    for i in eachindex(lines)               # index of the line
        current_line = lines[i]
        j = 1
        while j <= length(current_line)
            c = current_line[j]

            if isdigit(c)
                num, size = read_number(current_line, j)
                if look_around(lines, i, j, size)
                    print(" ", num, "\n")
                    engine_number += num
                end
                # print(num, " ")
                j += size
            else
                j += 1
            end
        end
    end

    return engine_number
end


function gear_ration(lines)
    gear_ratio = 0

    dict_numbers = Dict()

    for i in eachindex(lines)               # index of the line
        current_line = lines[i]
        j = 1
        while j <= length(current_line)
            c = current_line[j]

            if isdigit(c)
                num, size = read_number(current_line, j)
                coords = look_around_for_star(lines, i, j, size)
                if coords[1] != -1
                    print(" ", num, " ", coords, "\n")
                end
                if get(dict_numbers, coords, 0) == 0
                    dict_numbers[coords] = [num]
                else
                    push!(dict_numbers[coords], num)
                end
                # print(num, " ")
                j += size
            else
                j += 1
            end
        end
    end

    print("\ncheck\n")
    for (key, value) in dict_numbers
        if length(value) == 2
            # print(key, " ", value, "\n")
            ratio = value[1] * value[2]
            gear_ratio += ratio
        end
    end

    return gear_ratio
end

lines = parse_file(input_file)

number = engine_number(lines)
print("\nEngine number: ", number, "\n")

gear_ratio = gear_ration(lines)
print("\nGear ratio: ", gear_ratio, "\n")
