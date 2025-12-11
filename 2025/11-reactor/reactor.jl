using Graphs
using Karnak, Luxor, Colors
include("load_graph.jl")


# input_filename = "example.txt"
input_filename = "input.txt"

g, vs, vals = parse_input(input_filename)

# println(g)
# println(vs, vals)


@svg begin
    background("#0f0f23")
    sethue("#00cc00")
    setline(0.2)
    drawgraph(g, vertexlabels = vals, layout = stress,
        vertexshapesizes = 4, vertexlabelfontsizes=4,
        vertexfillcolors = (v) -> v ∈ (vs["svr"], vs["you"], vs["out"], vs["dac"], vs["fft"]) ? colorant"#d50620" : colorant"#00cc00",
        edgearrows = true, edgestrokeweights=0.5,
        edgestrokecolors = colorant"#cccccc",
        )
end

"""
    nb_path(key, vs[, memo])

Counts the nupmber of path in the graph represented by `g` and `vals` begining at `key`.
  - `v_id::Int` is the index of the vertex in the graph
  - `g::SimpleDiGraph{Int}` is the graph object
  - `vals::Vector{String}` is the vector making the inverse correspondance : vals[index] = key
  - `memo=Dict()` is a Dict used for memoization. At beginning, empty

Path to amelioration : create a graph with String keys insted of Int
"""
function nb_path(v_id::Int, g::SimpleDiGraph{Int}, vals, memo=Dict())
    if haskey(memo, v_id)
        return memo[v_id]
    end

    if vals[v_id] == "out"
        return 1
    end

    neighbors_vertices = neighbors(g, v_id)
    # println(neighbors_vertices)
    result = 0
    for v in neighbors_vertices
        result += nb_path(v, g, vals, memo)
    end

    memo[v_id] = result
    return result
end


idx_dep = vs["you"]
I = nb_path(idx_dep, g, vals)
println(I)