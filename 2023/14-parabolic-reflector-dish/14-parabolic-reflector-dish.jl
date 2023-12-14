input_filename = "example.txt"
# input_filename = "input.txt"

using ProgressBars

map = (x) -> x == '.' ? 0 : x == 'O' ? 1 : 2
pam = (x) -> x == 0 ? '.' : x == 1 ? 'O' : '#'
dir = Dict(
    'N' => (-1, 0),
    'S' => (1, 0),
    'W' => (0, -1),
    'E' => (0, 1)
)

function back_to_string(plat)
    (m, n) = size(plat)
    s = ""
    for i in 1:m
        for j in 1:n
            s *= pam(plat[i, j])
        end
        s *= "\n"
    end
    return s
end

function parse_input(filename::String)
    f = open(filename)
    lines = readlines(f)
    close(f)
    mat = zeros(Int, length(lines), length(lines[begin]))
    for (i, s) in enumerate(lines)
        mat[i, :] = map.(collect(s))
    end
    return mat
end



function tilt_platform_aux(plat, dir, rocks)
    if length(rocks) == 0
        return
    else
        (m, n) = size(plat)
        updated_rocks = []
        for rock in rocks
            i_ = rock[1] + dir[1]
            j_ = rock[2] + dir[2]
            idx_ = CartesianIndex(i_, j_)
            # println(rock, " -> ", idx_)
            if (i_ > 0) && (i_ <= m) && (j_ > 0) && (j_ <= n)
                if plat[idx_] == 0
                    plat[idx_] = 1
                    plat[rock] = 0
                    push!(updated_rocks, idx_)
                end
                # if  plat[idx_] == 1 && idx_ in rocks
                #     push!(updated_rocks, rock)
                # end
            end
        end
        tilt_platform_aux(plat, dir, updated_rocks)
    end
end


function tilt_platform(plat, cp)
    rocks  = findall( ==(1), plat)
    if cp in ['S', 'E']
        rocks = reverse(rocks)
    end

    tilt_platform_aux(plat, dir[cp], rocks)
end

function count_weight(plat)
    sum = 0
    N = size(plat, 1)
    for i in 1:N
        nb_rocks = count( ==(1), plat[i, :])
        sum += nb_rocks * (N - i + 1)
    end
    return sum
end


function part_II(plat, n_cyle=1000000000)
    for _ in ProgressBar(1:n_cyle)
        tilt_platform(plat, 'N')
        tilt_platform(plat, 'W')
        tilt_platform(plat, 'S')
        tilt_platform(plat, 'E')
    end
end

plat = parse_input(input_filename)
# str = back_to_string(plat)
# println(str)

plat_I = copy(plat)
tilt_platform(plat_I, 'N')
# str = back_to_string(plat_I)
# println('\n', str)

I = count_weight(plat_I)
println("I = ", I)


plat_II = copy(plat)
part_II(plat_II, 1000000000)
str = back_to_string(plat_II)
println('\n', str)

II = count_weight(plat_II)
println("II = ", II)
