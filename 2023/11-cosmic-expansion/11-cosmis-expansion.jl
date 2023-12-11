# input_filename = "example.txt"
input_filename = "input.txt"

map = Dict('.' => 0, '#' => 1)

function mat_of_input(input_filename)
    input_file = open(input_filename)
    lines = readlines(input_file)
    close(input_file)
    mat = zeros(Int, length(lines), length(lines[begin]))
    for (i, line) in enumerate(lines)
        for (j, char) in enumerate(line)
            mat[i, j] = map[char]
        end
    end
    return mat
end

function get_coords(mat, dist=1)
    x = collect(1:size(mat, 1))
    y = collect(1:size(mat, 2))

    for (i, col) in enumerate(eachcol(mat))
        if sum(col) == 0
            x[i:end] .+= dist
        end
    end
    for (j, row) in enumerate(eachrow(mat))
        if sum(row) == 0
            y[j:end] .+= dist
        end
    end
    return x, y
end


function compute_sum_dist(mat, dist=1)
    coord_x, coord_y = get_coords(mat, dist)
    galaxies = Tuple.(findall(!=(0), mat))

    sum = 0
    for k in eachindex(galaxies)
        for l in eachindex(galaxies)
            if k < l
                i1, j1 = galaxies[k]
                i2, j2 = galaxies[l]
                dist = abs(coord_y[i1] - coord_y[i2]) + abs(coord_x[j1] - coord_x[j2])
                # println((i1, j1), "->", (i2, j2), ", dist = ", dist)
                sum += dist
            end
        end
    end
    return sum
end


mat = mat_of_input(input_filename)
I = compute_sum_dist(mat)
println("I = ", I)
II = compute_sum_dist(mat, 1000000-1)
println("II = ", II)