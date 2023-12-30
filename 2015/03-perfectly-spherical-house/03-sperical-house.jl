filename = "input.txt"

# Read in the input file
directions = strip(read(filename, String))
# directions = ">"
# directions = "^>v<"
# directions = "^v^v^v^v^v"

dir_map = Dict(
    'v' => (-1, 0),
    '^' => ( 1, 0),
    '>' => ( 0, 1),
    '<' => ( 0,-1)
)

function run_santa(input)
    visited_houses = Set{Tuple{Int64,Int64}}()

    current_position_x = 0
    current_position_y = 0
    push!(visited_houses, (current_position_x, current_position_y))

    for c in input
        dir = dir_map[c]
        current_position_x += dir[1]
        current_position_y += dir[2]
        push!(visited_houses, (current_position_x, current_position_y))
    end

    return length(visited_houses)
end

function run_santa_robot(input)
    visited_houses = Set{Tuple{Int64,Int64}}()

    santa_position_x = 0
    santa_position_y = 0
    push!(visited_houses, (santa_position_x, santa_position_y))

    robot_position_x = 0
    robot_position_y = 0
    push!(visited_houses, (robot_position_x, robot_position_y))

    for (i, c) in enumerate(input)
        dir = dir_map[c]
        if iseven(i)
            santa_position_x += dir[1]
            santa_position_y += dir[2]
            push!(visited_houses, (santa_position_x, santa_position_y))
        else
            robot_position_x += dir[1]
            robot_position_y += dir[2]
            push!(visited_houses, (robot_position_x, robot_position_y))
        end
    end

    return length(visited_houses)
end

println("1: ", run_santa(directions))
println("2: ", run_santa_robot(directions))
