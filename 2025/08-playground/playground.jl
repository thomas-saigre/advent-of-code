
function load_jbox(filename::String)
    file = open(filename, "r")
    boxes = split.(eachline(file), ",")
    res = [parse.(Int, v) for v ∈ boxes]
    return res
end

function dist(boxA::Vector{Int}, boxB::Vector{Int})
    return sqrt(sum((boxA .- boxB) .^ 2))
end

function build_dist_matrix(boxes::Vector{Vector{Int}})
    n = length(boxes)
    mat = zeros(n, n)
    for i ∈ 1:n
        for j ∈ 1:n
            mat[i, j] = (i < j) ? dist(boxes[i], boxes[j]) : Inf
        end
    end
    return mat
end


function find_in_set(circuits::Vector{Set{Int}}, element::Int)
    for i ∈ 1:length(circuits)
        if element ∈ circuits[i]
            return i
        end
    end
    println("I did not find ", element, " while I should have :/")
    return -1
end

function print_circuits(circuits::Vector{Set{Int}})
    s = "["
    for set ∈ circuits
        s *= "{"
        for e ∈ set
            s *= string(e) * ","
        end
        s *= "}, "
    end
    s = s[begin:end-2]
    s *= "]"
    println(s)
end


function connect(dist_mat::Matrix{Float64}, nb::Int, positions::Vector{Vector{Int}})
    nb_circuit = 0
    nb_boxes = size(dist_mat, 1)
    circuits = [Set{Int}(i) for i ∈ 1:nb_boxes]
    # print_circuits(circuits)

    function make_connection()
        idx = argmin(dist_mat)
        # println("=== Connection ", idx)
        set_a = find_in_set(circuits, idx[1])
        set_b = find_in_set(circuits, idx[2])
        union!(circuits[set_a], circuits[set_b])
        if set_a != set_b
            deleteat!(circuits, set_b)
            # circuits[set_b] = Set{Int}()
        end
        # print_circuits(circuits)
        dist_mat[idx] = Inf

        return idx
    end

    for i ∈ 1:nb
        make_connection()
    end

    sort!(circuits, lt=(x,y)->length(x) > length(y))
    # print_circuits(circuits)

    I = prod(length.(circuits[1:3]))
    println(I)

    idx = CartesianIndex(-1, -1)
    while length(circuits) > 1
        idx = make_connection()
    end
    II = positions[idx[1]][1] * positions[idx[2]][1]
    println(II)

    return circuits
end


# filename = "example.txt"
# nb = 10
filename = "input.txt"
nb = 1000

jbox = load_jbox(filename)

mat = build_dist_matrix(jbox)

circuits = connect(mat, nb, jbox)
