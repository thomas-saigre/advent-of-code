# input_filename = "ex1.txt"
# input_filename = "ex2.txt"
# input_filename = "ex3.txt"
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

char_convert = Dict(
    '|' => '┃',
    '-' => '━',
    'L' => '┗',
    'J' => '┛',
    '7' => '┓',
    'F' => '┏',
    'S' => 'S',
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


function size_loop_aux(lines, i, j, source, elts, D=0)
    # println("**** Call with ", i, ", ", j, " ( ", source, " ), D = ", D)
    if lines[i][j] == 'S'
        # println("---------------> Found S")
        return D+1, elts
    else
        for (di, dj, compat, dir) in get(maps, lines[i][j], [])
            i_ = i + di
            j_ = j + dj
            # println("        Look to ", i_, ", ", j_, " ( ", compat, " ) di=", di, " dj=", dj, " dir=", dir, " source=", source, "")
            if i_ >= 1 && i_ <= length(lines) && j_ >= 1 && j_ <= length(lines[begin])
                # println("        -> ", lines[i_][j_], " ( ", compat, " )" )
                if lines[i_][j_] in compat && from[dir] != source
                    # println("    Going to ", i_, ", ", j_, " ( ", lines[i_][j_], " )")
                    elts = vcat(elts, [(i, j, source)])
                    return size_loop_aux(lines, i_, j_, dir, elts, D+1)
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
        if i_ > 0 && i_ <= length(lines) && j_ > 0 && j_ <= length(lines[begin])
            if lines[i_][j_] in compat
                # println("    Going to ", i_, ", ", j_, " ( ", lines[i_][j_], " )")
                D, elts = size_loop_aux(lines, i_, j_, source, [(i0, j0, "X")], 0)
                return div(D, 2), elts
            end
        end
    end
end

function print_path(lines, elts)
    new_lines = []
    for line in lines
        push!(new_lines, collect(line))
    end
    for (i, j, dir) in elts
        new_lines[i][j] = char_convert[lines[i][j]]
    end
    return new_lines
end


function get_dir(i, j, elts)
    for dir in ['u', 'd', 'l', 'r']
        if (i, j, dir) in elts
            return dir
        end
    end
    return '.'
end

function count_inside(lines, elts)
    count = 0
    for (i, line) in enumerate(lines)
        print('\n')
        # in_path = ((i, 0) in elts) && (line[begin] in ['L', 'J', '7', 'F', '|', 'S'])
        in_path = false
        look_for = 'u'
        for (j, c) in enumerate(line)
            dir = get_dir(i, j, elts)
            if dir != '.'
                if c == 'J' && dir == 'l'
                    dir = 'd'
                end
                if dir in ['u', 'd'] && dir == look_for
                    in_path = !in_path
                    if in_path
                        println(i, ", ", j, ": Entering")
                    else
                        println(i, ", ", j, ": Exiting")
                    end
                    look_for = (look_for == 'u') ? 'd' : 'u'
                end
            else
                println(i, ", ", j, " : ", c, " (", in_path, ")" )
                if in_path
                    count += 1
                end
            end
        end
    end
    return count
end



f = open(input_filename, "r")
lines = readlines(f)
close(f)

S = look_for_S(lines)

D, elts = size_loop(lines, S...)
# println(elts)

println("I: ", D)

# II = count_inside(lines, elts)
# println("II: ", II)

new_lines = print_path(lines, elts)
f = open("output.txt", "w")
for line in new_lines
    println(f, join(line, ""))
end
close(f)