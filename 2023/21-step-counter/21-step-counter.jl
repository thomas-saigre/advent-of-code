# input_filename = "example.txt"
input_filename = "input.txt"

using SparseArrays

function parse_input(filename)
    f = open(filename)
    lines = readlines(f)
    close(f)
    nb_lines = length(lines)
    nb_cols = length(lines[1])

    idx_from_ij = (i, j) -> i + (j-1)*nb_lines
    rows = []
    cols = []

    start = (-1, -1)

    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            if c ∈ ['.', 'S']
                if i > 1 && lines[i-1][j] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(i-1, j))
                end
                if i < nb_lines && lines[i+1][j] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(i+1, j))
                end
                if j > 1 && lines[i][j-1] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(i, j-1))
                end
                if j < nb_cols && lines[i][j+1] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(i, j+1))
                end
                if c == 'S'
                    start = (i, j)
                end
            end
        end
    end
    return sparse(rows, cols, ones(length(rows)), nb_lines*nb_cols, nb_lines*nb_cols), start, idx_from_ij(start...)
end

function parse_input_2(filename)
    f = open(filename)
    lines = readlines(f)
    close(f)
    nb_lines = length(lines)
    nb_cols = length(lines[1])

    idx_from_ij = (i, j) -> i + (j-1)*nb_lines
    rows = []
    cols = []

    start = (-1, -1)

    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            if c ∈ ['.', 'S']
                if i == 1 && lines[nb_lines][j] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(nb_lines, j))
                end
                if i > 1 && lines[i-1][j] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(i-1, j))
                end
                if i < nb_lines && lines[i+1][j] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(i+1, j))
                end
                if i == nb_lines && lines[1][j] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(1, j))
                end

                if j == 1 && lines[i][nb_cols] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(i, nb_cols))
                end
                if j > 1 && lines[i][j-1] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(i, j-1))
                end
                if j < nb_cols && lines[i][j+1] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(i, j+1))
                end
                if j == nb_cols && lines[i][1] ∈ ['.', 'S']
                    push!(rows, idx_from_ij(i, j))
                    push!(cols, idx_from_ij(i, 1))
                end

                if c == 'S'
                    start = (i, j)
                end
            end
        end
    end
    return sparse(rows, cols, ones(length(rows)), nb_lines*nb_cols, nb_lines*nb_cols), start, idx_from_ij(start...)
end

function count_accessibles(map, start_idx, n_step)
    # display(map)
    map_after = map^n_step
    # display(map_after)
    return length(findall( !=(0), map_after[:, start_idx]))
end

function count_accessibles_inf(map, start_idx, n_step)
    # display(map)
    map_after = map^n_step
    # display(map_after)
    return sum(map_after[:, start_idx])
end


mapI, startI, start_idxI = parse_input(input_filename)

display(mapI)
# for i in 1:6
#     println(i, ": ", count_accessibles(mapI, start_idxI, i))
# end

I = count_accessibles(mapI, start_idxI, 64)
println("I: ", I)

mapII, startII, start_idxII = parse_input_2(input_filename)

display(mapII)
# for i in [6, 10, 50, 100, 500, 1000, 5000]
#     println(i, ": ", count_accessibles_inf(mapII, start_idxII, i))
# end