# input_filename = "example.txt"
input_filename = "input.txt"


function make_numbers_from_list(list)
    numbers = []
    for item in list
        if item == ""
            continue
        end
        push!(numbers, parse(Int, item))
    end
    return numbers
end


function parse_file(filename)

    numbers = []
    winning_numbers = []
    open(filename, "r") do file
        for line in eachline(file)
            split_split = split(line, ":")
            splitnumbers = split(split_split[2], "|")

            numbers_of_card = make_numbers_from_list(split(splitnumbers[1], " "))
            winning_numbers_of_card = make_numbers_from_list(split(splitnumbers[2], " "))
            push!(numbers, numbers_of_card)
            push!(winning_numbers, winning_numbers_of_card)
        end
    end

    return numbers, winning_numbers
end


function score(numbers, winning_numbers)
    nb_win = nb_winining(numbers, winning_numbers)
    if nb_win == 0
        return 0
    else
        return 2^(nb_win-1)
    end
    return nb_win
end

function nb_winining(numbers, winning_numbers)
    nb_win = 0
    for i in eachindex(numbers)
        if numbers[i] in winning_numbers
            nb_win += 1
        end
    end
    return nb_win
end

function part_one(input_filename)
    numbers, winning_numbers = parse_file(input_filename)
    total_score = 0
    for i in eachindex(numbers)
        s = score(numbers[i], winning_numbers[i])
        # print(i, ": ", s, "\n")
        total_score += score(numbers[i], winning_numbers[i])
    end
    return total_score
end

function part_two(input_filename)
    numbers, winning_numbers = parse_file(input_filename)
    total_score = 0
    number_of_cards = ones(Int, length(numbers))
    for i in eachindex(numbers)
        nb_win = nb_winining(numbers[i], winning_numbers[i])
        for w in 1:nb_win
            if w > length(number_of_cards)
                break
            end
            number_of_cards[i+w] += number_of_cards[i]
        end
    end
    # print(number_of_cards, "\n")
    return sum(number_of_cards)
end


print("Part one: ", part_one(input_filename), "\n")
print("Part two: ", part_two(input_filename), "\n")