# input_filename = "example.txt"
input_filename = "input.txt"

map = (x) -> x == '.' ? 0 : 1
dig = (x) -> x == 1 ? 0 : 1

function parse_input(filename::String)
    return split(strip(read(filename, String)), "\n\n")
end

function matrix_of_str(input)
    lines = split(input, "\n")
    mat = zeros(Int, length(lines), length(lines[begin]))
    for (i, s) in enumerate(lines)
        mat[i, :] = map.(collect(s))
    end
    return mat
end


function find_symetry(mat)
    m, n = size(mat)
    # print("m, n = ", m, ", ", n, "\n")
    for i in 1:div(n,2)
        l = mat[:, 1:i]
        r = mat[:, 2*i:-1:i+1]
        # println("i = ", i, "   ", "1:",i, " - ", i+1, ":", 2*i)
        # println(i, "\n", l, "\n", r, "\n")
        if l == r
            # println("found")
            return i
        end
    end
    # print("mid\n")
    for i in div(n,2)+1:n-1
        l = mat[:, 2*i-n+1:i]
        r = mat[:, end:-1:i+1]
        # println("i = ", i, "    ", 2*i-n+1, ":", i, " - ", i+1, ":", n)
        # println(i, '\n', l, "\n", r, "\n")
        if l == r
            return i
            # println("found")
        end
    end
    return 0
end

function part_1(mat_list)
    sum = 0
    for mat in matrix_of_str.(mat_list)
        sum += find_symetry(mat)
        sum += 100 * find_symetry(mat')
    end
    return sum
end

function part_2_aux(mat)
    (m, n) = size(mat)

    symH = find_symetry(mat')
    symV = find_symetry(mat)
    # print("symH = ", symH, "   symV = ", symV, "\n")
    for i in 1:m
        for j in 1:n
            mat[i,j] = dig(mat[i,j])
            sym = find_symetry(mat)
            if sym > 0 && sym != symV
                # println("Found V : ", i, " ", j, " ", sym)
                mat[i,j] = dig(mat[i,j])
                return sym
            end
            sym = find_symetry(mat')
            if sym > 0 && sym != symH
                mat[i,j] = dig(mat[i,j])
                # println("Found H : ", i, " ", j, " ", sym)
                return 100 * sym
            end
            mat[i,j] = dig(mat[i,j])
        end
    end
    # println(mat)
    println("Not found")
    return symV + 100 * symH
end

function part_2(mat_list)
    sum = 0
    for mat in matrix_of_str.(mat_list)
        aux = part_2_aux(mat)
        # println(aux)
        sum += aux
    end
    return sum
end

mat = parse_input(input_filename)


# for m in mat
#     println(m, "\n")
# end

# M = matrix_of_str(mat[begin])
# find_symettry(M)

I = part_1(mat)
println("Part 1: ", I)

II = part_2(mat)
println("Part 2: ", II)
