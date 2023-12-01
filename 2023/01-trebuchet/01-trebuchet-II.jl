# input_filename = "small_inputII.txt"
input_filename = "input.txt"


function isdigit_expanded(c)
    # print("!! ", c, ": ")
    if isdigit(c[begin])
        return Int(c[begin]) - Int('0')
    end
    if c[1:3] == "one" || c[1:3] == "eno"
        return 1
    elseif c[1:3] == "two" || c[1:3] == "owt"
        return 2
    elseif c[1:5] == "three" || c[1:5] == "eerht"
        return 3
    elseif c[1:4] == "four" || c[1:4] == "ruof"
        return 4
    elseif c[1:4] == "five" || c[1:4] == "evif"
        return 5
    elseif c[1:3] == "six" || c[1:3] == "xis"
        return 6
    elseif c[1:5] == "seven" || c[1:5] == "neves"
        return 7
    elseif c[1:5] == "eight" || c[1:5] == "thgie"
        return 8
    elseif c[1:4] == "nine" || c[1:4] == "enin"
        return 9
    elseif c[1:4] == "zero" || c[1:4] == "orez"
        return 0
    end

    return -1
end


open(input_filename, "r") do file
    sum = 0
    for line in eachline(file)
        print(line, "\n")
        number = 0
        line_expanded = line * "*****"
        for i in 1:length(line_expanded) - 4
            res = isdigit_expanded(line_expanded[i:i+4])
            if res >= 0
                print("    1. ", res, "\n")
                number += 10 * res
                break
            end
        end

        reverse_line_expended = reverse(line) * "*****"
        for i in 1:length(reverse_line_expended) - 4
            res = isdigit_expanded(reverse_line_expended[i:i+4])
            if res >= 0
                print("    2. ", res, "\n")
                number += res
                break
            end
        end

        print("N ", number, "\n")

        sum += number
    end
    print("\n", sum, "\n")
end
