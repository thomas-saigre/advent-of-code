# input_filename = "example.txt"
input_filename = "input.txt"

LEFT = 1
RIGHT = 2
UP = 4
DOWN = 8




function parse_input(filename::String)
    f = open(filename)
    lines = readlines(f)
    close(f)
    return lines
end


"""
    light_path_aux(i, j, lines, light, dir)

Recursively calculates the path of light in a grid of cells.

# Arguments
- `i`: The row index of the current cell.
- `j`: The column index of the current cell.
- `lines`: An array of strings representing the grid.
- `light`: A 2D array representing the visited cells. Each cell is a bitfield
  where each bit represents a direction. For example, if the cell has been
  visited from the left, the bit `LEFT` will be set to 1.
- `dir`: The direction of the light ray **entering** the current cell.

# Returns
- Nothing

# Example

"""
function light_path_aux(i, j, lines, light, dir)

    # println("** i=$i, j=$j, dir=$dir")
    # display(light)

    # First of all, we check if we already enter the cell with this direction
    if light[i, j] & dir == dir
        # println("===   Already visited")
        return
    end

    # Then, we mark the cell as visited
    light[i, j] |= dir

    # And make the ray goes on
    # Some cells are symmetrical, so we can consider that the ray is also entered by the way it goes out
    if lines[i][j] == '\\'
        if dir == LEFT
            # println("\\ from LEFT, going DOWN")
            light[i, j] |= DOWN
            if i+1 <= length(lines)
                light_path_aux(i+1, j, lines, light, UP)#
            end
        elseif dir == RIGHT
            # println("\\ from RIGHT, going UP")
            light[i, j] |= UP
            if i-1 >= 1
                light_path_aux(i-1, j, lines, light, DOWN)#
            end
        elseif dir == UP
            # println("\\ from UP, going RIGHT")
            light[i, j] |= RIGHT
            if j+1 <= length(lines[begin])
                light_path_aux(i, j+1, lines, light, LEFT)#
            end
        elseif dir == DOWN
            # println("\\ from DOWN, going LEFT")
            light[i, j] |= LEFT
            if j-1 >= 1
                light_path_aux(i, j-1, lines, light, RIGHT)#
            end
        else
            println("Error: invalid direction")
        end

    elseif lines[i][j] == '/'
        if dir == LEFT
            # println("/ from LEFT, going UP")
            light[i, j] |= UP
            if i-1 >= 1
                light_path_aux(i-1, j, lines, light, DOWN)#
            end
        elseif dir == RIGHT
            # println("/ from RIGHT, going DOWN")
            light[i, j] |= DOWN
            if i+1 <= length(lines)
                light_path_aux(i+1, j, lines, light, UP)#
            end
        elseif dir == UP
            # println("/ from UP, going LEFT")
            light[i, j] |= LEFT
            if j-1 >= 1
                light_path_aux(i, j-1, lines, light, RIGHT)#
            end
        elseif dir == DOWN
            # println("/ from DOWN, going RIGHT")
            light[i, j] |= RIGHT
            if j+1 <= length(lines[begin])
                light_path_aux(i, j+1, lines, light, LEFT)#
            end
        else
            println("Error: invalid direction")
        end

    # The bahavior of '|' and '-' is not symmetrical
    elseif lines[i][j] == '|'
        if dir == LEFT || dir == RIGHT
            # println("| Split: going UP and DOWN")
            if i-1 >= 1
                light_path_aux(i-1, j, lines, light, DOWN)#
            end
            if i+1 <= length(lines)
                light_path_aux(i+1, j, lines, light, UP)#
            end
        elseif dir == UP
            # println("| No split: continue to cell below")
            light[i, j] |= DOWN
            if i+1 <= length(lines[begin])
                light_path_aux(i+1, j, lines, light, UP)#
            end
        elseif dir == DOWN
            # println("| No split: continue to cell above")
            light[i, j] |= UP
            if i-1 >= 1
                light_path_aux(i-1, j, lines, light, DOWN)#
            end
        else
            println("Error: invalid direction")
        end

    elseif lines[i][j] == '-'
        if dir == UP || dir == DOWN
            # println("- Split: going LEFT and RIGHT")
            if j-1 >= 1
                light_path_aux(i, j-1, lines, light, RIGHT)#
            end
            if j+1 <= length(lines[begin])
                light_path_aux(i, j+1, lines, light, LEFT)#
            end
        elseif dir == LEFT
            # println("- No split: continue LEFT")
            light[i, j] |= RIGHT
            if j+1 <= length(lines[begin])
                light_path_aux(i, j+1, lines, light, LEFT)#
            end
        elseif dir == RIGHT
            # println("- No split: continue RIGHT")
            if j-1 >= 1
                light_path_aux(i, j-1, lines, light, RIGHT)#
            end
        else
            println("Error: invalid direction")
        end

    # If the cell is empty, we continue in the same direction (always symmetrical)
    elseif lines[i][j] == '.'
        if dir == LEFT
            light[i, j] |= RIGHT
            # println(". from LEFT, going right cell")
            if j+1 <= length(lines[begin])
                light_path_aux(i, j+1, lines, light, LEFT)#
            end
        elseif dir == RIGHT
            light[i, j] |= LEFT
            # println(". from RIGHT, going left cell")
            if j-1 >= 1
                light_path_aux(i, j-1, lines, light, RIGHT)#
            end
        elseif dir == UP
            light[i, j] |= DOWN
            # println(". from UP, going down cell")
            if i+1 <= length(lines)
                light_path_aux(i+1, j, lines, light, UP)
            end
        elseif dir == DOWN
            light[i, j] |= UP
            # println(". from DOWN, going up cell")
            if i-1 >= 1
                light_path_aux(i-1, j, lines, light, DOWN)
            end
        else
            println("Error: invalid direction")
        end

    end
end


"""
    light_path(lines, i0=1, j0=1, dir=LEFT)

Compute the light path on a grid based on the given lines.

# Arguments
- `lines`: A 2D array representing the grid.
- `i0`: The starting row index (default: 1).
- `j0`: The starting column index (default: 1).
- `dir`: The initial direction of the light path (default: LEFT).

# Returns
- `light`: A 2D array representing the light path on the grid.

"""
function light_path(lines, i0=1, j0=1, dir=LEFT)
    light = zeros(Int, length(lines), length(lines[begin]))
    light_path_aux(i0, j0, lines, light, dir)

    return light
end


function count_energizes(light)
    idx = findall( !=(0), light)
    return length(idx)
end


function look_for_max(lines)
    max = -1
    for i in 1:length(lines)
        light = light_path(lines, i, 1, LEFT)
        en = count_energizes(light)
        if en > max
            max = en
        end
        light = light_path(lines, i, length(lines[begin]), RIGHT)
        en = count_energizes(light)
        if en > max
            max = en
        end
    end
    for j in 1:length(lines[begin])
        light = light_path(lines, 1, j, UP)
        en = count_energizes(light)
        if en > max
            max = en
        end
        light = light_path(lines, length(lines), j, DOWN)
        en = count_energizes(light)
        if en > max
            max = en
        end
    end
    return max
end


lines = parse_input(input_filename)

light = light_path(lines)
I = count_energizes(light)
# display(light)
println("I = ", I)

II = look_for_max(lines)
println("II = ", II)