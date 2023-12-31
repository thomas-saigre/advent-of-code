# input_filename = "example.txt"
input_filename = "input.txt"

allequal(x) = all(y->y==x[1],x)

function parse_input(input_filename)
    input = readlines(input_filename)
    p = []
    v = []
    s = split.(input, " @ ")
    for l in s
        p_ = split(l[1], ", ")
        v_ = split(l[2], ", ")
        push!(p, parse.(Int, p_))
        push!(v, parse.(Int, v_))
    end
    return zip(p, v)
end

function compute_interection_XY(hail1, hail2)
    p1_, v1_ = hail1
    p2_, v2_ = hail2

    p1 = p1_[1:2]; v1 = v1_[1:2]
    p2 = p2_[1:2]; v2 = v2_[1:2]

    # vectors are colinear, so trajectories will never intersect
    if allequal(v1 ./ v2)
        return Inf, Inf
    end
    x_inter = (p2[2] - p1[2] + v1[2]/v1[1] * p1[1] - v2[2]/v2[1] * p2[1])  /  (v1[2]/v1[1] - v2[2]/v2[1])
    y_inter = p1[2] + v1[2]/v1[1] * (x_inter - p1[1])
    return x_inter, y_inter
end

function is_future(hail, x_inter, y_inter)
    p, v = hail
    x, y = p[1:2]
    vx, vy = v[1:2]

    if (vx > 0 && x_inter < x) || (vx < 0 && x_inter > x)
        return false
    end

    if (vy > 0 && y_inter < y) || (vy < 0 && y_inter > y)
        return false
    end

    return true
end

function intersect_test_area(hails, area_min, area_max)
    count = 0
    for (i, h1) in enumerate(hails)
        for (j, h2) in enumerate(hails)
            if i < j
                x_inter, y_inter = compute_interection_XY(h1, h2)
                if x_inter >= area_min && x_inter <= area_max && y_inter >= area_min && y_inter <= area_max
                    if is_future(h1, x_inter, y_inter) && is_future(h2, x_inter, y_inter)
                    count += 1
                    # println("hail $i vs hail $j ", x_inter, ", ", y_inter)
                    end
                end
            end
        end
    end
    return count
end


hails = parse_input(input_filename)

function perfect_throw(hails)

    p1, v1 = hails[1]
    p2, v2 = hails[2]
    p3, v3 = hails[3]

    c_z_12 = [v2[2] - v1[2], v1[1] - v2[1], 0            , p1[2] - p2[2], p2[1] - p1[1], 0            ]
    c_z_13 = [v3[2] - v1[2], v1[1] - v3[1], 0            , p1[2] - p3[2], p3[1] - p1[1], 0            ]
    c_y_12 = [v2[3] - v1[3], 0            , v1[1] - v2[1], p1[3] - p2[3], 0            , p2[1] - p1[1]]
    c_y_13 = [v3[3] - v1[3], 0            , v1[1] - v3[1], p1[3] - p3[3], 0            , p3[1] - p1[1]]
    c_x_12 = [0            , v2[3] - v1[3], v1[2] - v2[2], 0            , p1[3] - p2[3], p2[2] - p1[2]]
    c_x_13 = [0            , v3[3] - v1[3], v1[2] - v3[2], 0            , p1[3] - p3[3], p3[2] - p1[2]]

    vecs = (c_z_12, c_z_13, c_y_12, c_y_13, c_x_12, c_x_13)
    A = vcat(transpose.(vecs)...)

    rhs_z_12 = p1[2] * v1[1] - p2[2] * v2[1] - p1[1] * v1[2] + p2[1] * v2[2]
    rhs_z_13 = p1[2] * v1[1] - p3[2] * v3[1] - p1[1] * v1[2] + p3[1] * v3[2]
    rhs_y_12 = p1[3] * v1[1] - p2[3] * v2[1] - p1[1] * v1[3] + p2[1] * v2[3]
    rhs_y_13 = p1[3] * v1[1] - p3[3] * v3[1] - p1[1] * v1[3] + p3[1] * v3[3]
    rhs_x_12 = p1[3] * v1[2] - p2[3] * v2[2] - p1[2] * v1[3] + p2[2] * v2[3]
    rhs_x_13 = p1[3] * v1[2] - p3[3] * v3[2] - p1[2] * v1[3] + p3[2] * v3[3]

    rhs = [rhs_z_12, rhs_z_13, rhs_y_12, rhs_y_13, rhs_x_12, rhs_x_13]

    s = float.(A) \ float.(rhs)

    # bon bah ça marche pas... oopsi
    return sum(floor.(Int, s[1:3]))
end

# for (i, h1) in enumerate(hails)
#     for (j, h2) in enumerate(hails)
#         if i >= j
#             continue
#         end
#         println("hail $i vs hail $j ", compute_interection_XY(h1, h2))
#     end
# end
I = intersect_test_area(hails, 200000000000000, 400000000000000)
println("Intersections: ", I)

II = perfect_throw(collect(hails))
println("Part 2 : ", II)