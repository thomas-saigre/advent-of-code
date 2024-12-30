using FStrings

function load_grid(filename::String)

    input = open(filename) do file
        read(file, String)
    end

    lines = split(input, '\n')
    nb_lines = length(lines)
    nb_col = length(lines[begin])

    data = []
    for _ in 1:3
        push!(data, repeat(".", nb_col+6))
    end
    for line in lines
        push!(data, "..." * line * "...")
    end
    for _ in 1:3
        push!(data, repeat(".", nb_col+6))
    end

    grid = permutedims(hcat([collect(row) for row in data]...))
    return grid
end


function print_grid(grid::Array{Char,2})
    n, m = size(grid)
    for i in 4:n-3
        for j in 4:m-3
            print(grid[i,j])
        end
        print('\n')
    end
end

function is_xmas(grid::Array{Char,2}, i::Int, j::Int)
    dirs = [
        [ 1, 0], # →
        [ 1, 1], # ↘
        [ 0, 1], # ↓
        [-1, 1], # ↙
        [-1, 0], # ←
        [-1,-1], # ↖
        [ 0,-1], # ↑
        [ 1,-1], # ↗
    ]

    nb_valid = 0

    for dir in dirs
        dx = dir[1]
        dy = dir[2]
        if grid[i,j] * grid[i+dx,j+dy] * grid[i+2*dx,j+2*dy] * grid[i+3*dx,j+3*dy] == "XMAS"
            # println(f"XMAS found from pos ({i},{j}) in direction [{dx},{dy}] : {grid[i,j] * grid[i+dx,j+dy] * grid[i+2*dx,j+2*dy] * grid[i+3*dx,j+3*dy]}")
            nb_valid += 1
        end
    end
    return nb_valid
end

function is_x_mas(grid::Array{Char,2}, i::Int, j::Int)
    dirs = [
        [ 1, 1], # ↘
        [-1,-1], # ↖
    ]
    dirs_dual = [
        [-1, 1], # ↙
        [ 1,-1], # ↗
    ]

    test_one = grid[i-1, j-1] * grid[i, j] * grid[i+1, j+1] ∈ ["MAS", "SAM"]
    test_two = grid[i-1,j+1] * grid[i, j] * grid[i+1, j-1] ∈ ["MAS", "SAM"]
    if test_one && test_two
        # println("    OUI !")
        return 1
    else
        return 0
    end
end


function search_xmas(grid::Array{Char,2})
    count = 0
    for i in 1:size(grid, 1)
        for j in 1:size(grid, 2)
            if grid[i,j] == 'X'
                # println(f"X found in ({i},{j})")
                count += is_xmas(grid, i, j)
            end
        end
    end
    return count
end

function search_x_mas(grid::Array{Char,2})
    count = 0
    for i in 1:size(grid, 1)
        for j in 1:size(grid, 2)
            if grid[i,j] == 'A'
                # println(f"A found in ({i},{j})")
                count += is_x_mas(grid, i, j)
            end
        end
    end
    return count
end

# filename = "example.txt"
filename = "input.txt"


grid = load_grid(filename)
# print_grid(grid)
I = search_xmas(grid)
println(f"I : {I}")
II = search_x_mas(grid)
println(f"II: {II}")