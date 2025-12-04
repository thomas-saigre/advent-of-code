function parse_input(filepath::String)
    file = open(filepath, "r")

    data = split.(eachline(file), "")
    ncol = length(data[begin])
    nrow = length(data)


    room = zeros(Int, ncol+2, nrow+2)

    for i in 1:ncol
        for j in 1:nrow
            room[i+1,j+1] = (data[i][j] == "@") ? 1 : 0
        end
    end
    return room, ncol, nrow
end

function convolution(data, i, j, window)
    interest = data[i-1:i+1,j-1:j+1]
    return sum(interest .* window)
end

function partI(room, ncol, nrow)
    nb = 0
    window = [1 1 1 ; 1 0 1 ; 1 1 1]
    for i in 1:ncol
        for j in 1:nrow
            if room[i+1, j+1] == 1
                if convolution(room, i+1, j+1, window) < 4
                    nb += 1
                end
            end
        end
    end
    return nb
end

function partII(room, ncol, nrow)
    nb = 0
    window = [1 1 1 ; 1 0 1 ; 1 1 1]
    dont_stop_me_now = true
    while dont_stop_me_now
        dont_stop_me_now = false
        to_remove = Set()
        for i in 1:ncol
            for j in 1:nrow
                if room[i+1, j+1] == 1
                    if convolution(room, i+1, j+1, window) < 4
                        nb += 1
                        push!(to_remove, (i+1,j+1))
                        dont_stop_me_now = true
                    end
                end
            end
        end
        for (i, j) in to_remove
            room[i, j] = 0
        end
    end
    return nb
end

# filename = "example.txt"
filename = "input.txt"

data, ncol, nrow = parse_input(filename)

I = partI(data, ncol, nrow)
println(I)

II = partII(data, ncol, nrow)
println(II)
