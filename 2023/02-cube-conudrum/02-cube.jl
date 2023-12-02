input_filename = "input.txt"


function keep_only_digits(input)
    return replace(input, r"\D" => "")
end


function is_possible(input::String, r::Int, g::Int, b::Int)
    first_split = split(input, ": ")
    game_idx = parse(Int, keep_only_digits(first_split[1]))

    second_split = split(first_split[2], "; ")

    for i in eachindex(second_split)
        run = split(second_split[i], ",")

        for j in eachindex(run)
            balls = split(run[j])
            number_of_balls = parse(Int, balls[1])
            color = balls[2]
            if color == "red"
                if number_of_balls > r
                    print(game_idx, " Too much r\n")
                    return -1
                end
            elseif color == "green"
                if number_of_balls > g
                    print(game_idx, " too much g\n")
                    return -1
                end
            elseif color == "blue"
                if number_of_balls > b
                    print(game_idx, " Too much b\n")
                    return -1
                end
            else
                print("ERROR color: ", color, "\n")
            end
        end
    end

    return game_idx
end


function power(input::String)
    first_split = split(input, ": ")
    game_idx = parse(Int, keep_only_digits(first_split[1]))

    r_max = 0
    g_max = 0
    b_max = 0

    second_split = split(first_split[2], "; ")

    for i in eachindex(second_split)
        run = split(second_split[i], ",")

        for j in eachindex(run)
            balls = split(run[j])
            number_of_balls = parse(Int, balls[1])
            color = balls[2]
            if color == "red"
                if number_of_balls > r_max
                    r_max = number_of_balls
                end
            elseif color == "green"
                if number_of_balls > g_max
                    g_max = number_of_balls
                end
            elseif color == "blue"
                if number_of_balls > b_max
                    b_max = number_of_balls
                end
            else
                print("ERROR color: ", color, "\n")
            end
        end
    end

    return r_max * g_max * b_max
end




open(input_filename, "r") do file
    sum = 0
    power_sum = 0
    for line in eachline(file)
        game_idx = is_possible(line, 12, 13, 14)
        if game_idx > 0
            sum += game_idx
            print(game_idx, "\n")
        end

        power_ = power(line)
        power_sum += power_
    end

    print("Sum of indices: ", sum, "\n")

    print("Power sum: ", power_sum, "\n")
end