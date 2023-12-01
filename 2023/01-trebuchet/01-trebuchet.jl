input_filename = "input.txt"


open(input_filename, "r") do file
    sum = 0
    for line in eachline(file)
        number = 0
        # print(line, " - ", reverse(line), "\n")

        for c in line
            if isdigit(c)
                # print(c, "\n")
                number += 10 * (Int(c) - Int('0'))
                break
            end
        end


        for c in reverse(line)
            if isdigit(c)
                # print(c, "\n")
                number += Int(c) - Int('0')
                break
            end
        end

        print(number, "\n")

        sum += number
    end
    print("\n", sum, "\n")
end
