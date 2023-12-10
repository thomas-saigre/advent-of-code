# input_filename = "ex1.txt"
# input_filename = "ex2.txt"
input_filename = "input.txt"

up   = (-1, 0, ['7', 'F', '|', 'S'], 'd')
down = ( 1, 0, ['L', 'J', '|', 'S'], 'u')
left = ( 0,-1, ['L', 'F', '-', 'S'], 'r')
right= ( 0, 1, ['7', 'J', '-', 'S'], 'l')

maps = Dict(
    '|' => [up, down],
    '-' => [left, right],
    'L' => [up, right],
    'J' => [left, up],
    '7' => [left, down],
    'F' => [down, right],
)

from = Dict(
    'u' => 'd',
    'd' => 'u',
    'l' => 'r',
    'r' => 'l',
)


function look_for_S(lines)
    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            if c == 'S'
                return (i, j)
            end
        end
    end
end


function size_loop_aux(lines, i, j, source, D=0)
    # println("**** Call with ", i, ", ", j, " ( ", source, " ), D = ", D)
    if lines[i][j] == 'S'
        # println("---------------> Found S")
        return D+1
    else
        for (di, dj, compat, dir) in get(maps, lines[i][j], [])
            i_ = i + di
            j_ = j + dj
            # println("        Look to ", i_, ", ", j_, " ( ", compat, " ) di=", di, " dj=", dj, " dir=", dir, " source=", source, "")
            if i_ >= 1 && i_ <= length(lines) && j_ >= 1 && j_ <= length(lines[begin])
                # println("        -> ", lines[i_][j_], " ( ", compat, " )" )
                if lines[i_][j_] in compat && from[dir] != source
                    # println("    Going to ", i_, ", ", j_, " ( ", lines[i_][j_], " )")
                    return size_loop_aux(lines, i_, j_, dir, D+1)
                end
            end
        end
    end

end

function size_loop(lines, i0, j0)
    for (di, dj, compat, source) in [up, down, left, right]
        i_ = i0 + di
        j_ = j0 + dj
        # println("Look to ", i_, ", ", j_, " ( ", compat, " )")
        if i_ >= 0 && i_ <= length(lines) && j_ >= 0 && j_ <= length(lines[begin])
            if lines[i_][j_] in compat
                # println("    Going to ", i_, ", ", j_, " ( ", lines[i_][j_], " )")
                D = size_loop_aux(lines, i_, j_, source)
                return div(D, 2)
            end
        end
    end
end



f = open(input_filename, "r")
lines = readlines(f)
close(f)

S = look_for_S(lines)

D = size_loop(lines, S...)
println("I: ", D)