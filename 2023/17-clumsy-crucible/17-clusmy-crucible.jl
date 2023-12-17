# input_filename = "example.txt"
input_filename = "input.txt"


function parse_input(filename)
    f = open(filename)
    input = readlines(f)
    close(f)
    mat = zeros(Int, length(input), length(input[begin]))
    for (i, line) in enumerate(input)
        mat[i, :] = parse.(Int, collect(line))
    end
    return mat
end


"""
accessibles(i, j, path, nb_lines, nb_cols)

Compute the accessible positions from a given position (i, j) on the grid.

# Arguments
- `i`: The row index of the current position.
- `j`: The column index of the current position.
- `path`: A list of previously visited positions.
- `nb_lines`: The total number of rows in the grid.
- `nb_cols`: The total number of columns in the grid.

# Returns
- `next_possibles`: A list of accessible positions from the current position.

"""
function accessibles(i, j, path, nb_lines, nb_cols)

    next_possibles = []
    if length(path) == 0
        if i-1 >= 1
            push!(next_possibles, (i-1, j)) # going up
        end
        if i+1 <= nb_lines
            push!(next_possibles, (i+1, j)) # doing down
        end
        if j+1 <= nb_cols
            push!(next_possibles, (i, j+1)) # going right
        end
        if j-1 >= 1
            push!(next_possibles, (i, j-1)) # going left
        end
        return next_possibles
    end

    (i_prev, j_prev) = path[end]

    if length(path) >= 2
        (i_prev_prev, j_prev_prev) = path[end-1]
        if i_prev == i_prev_prev && i_prev == i  # we canont go further in that direction
            if i-1 >= 1
                push!(next_possibles, (i-1, j)) # going up
            end
            if i+1 <= nb_lines
                push!(next_possibles, (i+1, j)) # going down
            end
            return next_possibles
        end
        if j_prev == j_prev_prev && j_prev == j  # we canont go further in that direction
            if j+1 <= nb_cols
                push!(next_possibles, (i, j+1)) # going right
            end
            if j-1 >= 1
                push!(next_possibles, (i, j-1)) # going left
            end
            return next_possibles
        end
    end

    if i_prev == i      # same line
        if i-1 >= 1
            push!(next_possibles, (i-1, j)) # going up
        end
        if i+1 <= nb_lines
            push!(next_possibles, (i+1, j)) # doing down
        end
        if j-1 == j_prev
            if j+1 <= nb_cols
                push!(next_possibles, (i, j+1)) # going right
            end
        elseif j+1 == j_prev
            if j-1 >= 1
                push!(next_possibles, (i, j-1)) # going left
            end
        end
    end

    if j_prev == j      # same column
        if j+1 <= nb_cols
            push!(next_possibles, (i, j+1)) # going right
        end
        if j-1 >= 1
            push!(next_possibles, (i, j-1)) # going left
        end
        if i-1 == i_prev
            if i+1 <= nb_lines
                push!(next_possibles, (i+1, j)) # doing down
            end
        elseif i+1 == i_prev
            if i-1 >= 1
                push!(next_possibles, (i-1, j)) # going up
            end
        end
    end
    return next_possibles
end


function look_for_min(w, P, nb_cols, nb_lines)
    min = Inf
    i_min = -1
    j_min = -1
    for i in 1:nb_lines
        for j in 1:nb_cols
            if (i, j) ∉ P && w[i, j] < min
                min = w[i, j]
                i_min = i
                j_min = j
            end
        end
    end
    return i_min, j_min
end

function find_shortest_path(heat_loss, i0=1, j0=1)
    P = Set()
    paths = Dict()
    w = Inf * ones(size(heat_loss))
    w[i0, j0] = 0
    nb_lines, nb_cols = size(heat_loss)

    while length(P) < length(heat_loss)
        i, j = look_for_min(w, P, nb_cols, nb_lines)
        if(i == -1 || j == -1)
            println("Error: no minimum found")
            return -1, []
        end
        push!(P, (i, j))

        vertices = accessibles(i, j, get(paths, (i, j), []), nb_lines, nb_cols)
        # println("Vertices: ", vertices, " from ", (i, j))
        for (i_, j_) in vertices
            if (i_, j_) ∉ P
                # print("  - ", (i_, j_), " with weight: ", w[i_, j_], " -> ")
                if w[i_, j_] > w[i, j] + heat_loss[i_, j_]
                    # println("update")
                    w[i_, j_] = w[i, j] + heat_loss[i_, j_]
                    paths[(i_, j_)] = [get(paths, (i, j), []) ; [(i, j)]]    # we arrive to (i_, j_) from (i, j)
                end
            end
        end
    end
    println("HERE")
    return w[end, end], paths[(nb_lines, nb_cols)]
end

function compute_heat_loss(heat_loss, path)
    s_ = 0
    for (i, j) in path
        s_ += heat_loss[i, j]
    end
    return s_
end


heat_loss = parse_input(input_filename)
# display(heat_loss)

#=
nb_lines, nb_cols = size(heat_loss)
println("Test 1: ", accessibles(1, 1, [], nb_lines, nb_cols))                           # Should be [(2, 1), (1, 2)]
println("Test 2: ", accessibles(1, 2, [(1, 1)], nb_lines, nb_cols))                     # Should be [(2, 2), (1, 3)]
println("Test 3: ", accessibles(2, 2, [(1, 1), (1, 2)], nb_lines, nb_cols))             # Should be [(2, 1), (3, 2), (2 ,3)]
println("Test 4: ", accessibles(3, 2, [(1, 1), (1, 2), (2, 2)], nb_lines, nb_cols))     # Should be [(3, 1), (3, 3)]
=#

w, path = find_shortest_path(heat_loss)
print("The shortest path is: ", path, " with a total heat loss of ", w, "\n")


print("The total heat loss is: ", compute_heat_loss(heat_loss, path[2:end]), "\n")