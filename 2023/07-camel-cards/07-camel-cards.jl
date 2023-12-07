# input_filename = "example.txt"
input_filename = "input.txt"

using StatsBase

function parse_cards(lines)
    decks = []
    bets = []

    for line in lines
        split_line = split(line, " ")
        push!(decks, split_line[1])
        push!(bets, parse(Int, split_line[2]))
    end
    return decks, Int.(bets)
end


function strength(deck, II=false)
    cm = countmap(deck)
    card_count = sort([ v for v in values(cm)], rev=true)

    if II
        n_joker = haskey(cm, 'J') ? cm['J'] : 0

        if n_joker >= 1
            if card_count == [4, 1] || card_count == [3, 2] || card_count == [5]
                # 4 of a kind and 1 joker => 5 of a kind
                # 3 of one kind an 2 joker => 5 of a kind
                # 5 jokers => 5 of a kind
                return 6

            elseif card_count == [3, 1, 1]
                # 3 of one kind and 1 joker and 1 other => 4 of a kind and 1 other
                if !(n_joker in [3, 1])
                    println("Error: 3 of one kind and 2 joker")
                end
                return 5

            elseif card_count == [2, 2, 1]
                if (n_joker == 1)
                    # 2 of one kind and 1 joker and 2 other => 3 of one kind and 2 of the other kind (full)
                    return 4
                elseif (n_joker == 2)
                    # 2 of one kind and 2 jokers and 1 other => 4 of a kind and 1 other
                    return 5
                else
                    println("Error: 2 of one kind and 2 joker and 1 other")
                    return -1
                end

            elseif card_count == [2, 1, 1, 1]
                # 2 of one kind and 1 joker and 2 others => 3 of one kind and 2 othe rkinds (3,1,1)
                # 2 jokers and 3 others kinds => 3 of one kind and 2 other kinds (3,3,1)
                if !(n_joker in [1, 2])
                    println("Error: 2 of one kind and 1 joker and 2 others")
                end
                return 3

            elseif card_count == [1, 1, 1, 1, 1]  # 5 different cards
                if n_joker != 1
                    println("Error: 5 different cards and not 1 joker")
                end
                return 1

            else
                println("Error: not yet implemented ", card_count)
            end

        end
    end

    if card_count == [5] return 6
    elseif card_count == [4, 1] return 5
    elseif card_count == [3, 2] return 4
    elseif card_count == [3, 1, 1] return 3
    elseif card_count == [2, 2, 1] return 2
    elseif card_count == [2, 1, 1, 1] return 1
    else return 0
    end
end

function char_map(c, II=false)
    if c == 'A' return 14
    elseif c == 'K' return 13
    elseif c == 'Q' return 12
    elseif c == 'J' return II ? 0 : 11
    elseif c == 'T' return 10
    else return parse(Int, c)
    end
end


function decks_order(deck1, deck2, II=false)

    strength_1 = strength(deck1, II)
    strength_2 = strength(deck2, II)

    if strength_1 != strength_2
        return strength_1 > strength_2
    else    # There is a tie
        for i in eachindex(deck1)
            if char_map(deck1[i], II) != char_map(deck2[i], II)
                return char_map(deck1[i], II) > char_map(deck2[i], II)
            end
        end
        print("Error: decks are identical\n")
        return false
    end
end


function part_I(decks, bets)
    sorted_decks_idx = sortperm(decks, lt=(x,y)->decks_order(x,y), rev=true)
    return sum(collect(1:length(bets)) .* bets[sorted_decks_idx])
end

function part_II(decks, bets)
    sorted_decks_idx = sortperm(decks, lt=(x,y)->decks_order(x,y,true), rev=true)
    return sum(collect(1:length(bets)) .* bets[sorted_decks_idx])
end

f = open(input_filename, "r")
lines = readlines(f)
close(f)

decks, bets = parse_cards(lines)

#=
print(decks, "\n"
    , bets, "\n")

for deck in decks
    strength(deck)
end

print(decks_order("KK677", "QQQJA"))
sorted = sort(decks, lt=decks_order, rev=true)
print(sorted, "\n")
=#

print("Part  I: ", part_I(decks, bets), "\n")
print("Part II: ", part_II(decks, bets), "\n")
