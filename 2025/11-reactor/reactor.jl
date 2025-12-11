using Graphs
using Karnak, Luxor, Colors
include("load_graph.jl")


# input_filename = "example.txt"
# input_filename = "example_2.txt"
input_filename = "input.txt"

g, vs, vals = parse_input(input_filename)

# println(g)
# println(vs, vals)

# using EzXML
# using GraphIO.GEXF
# can be read on https://lite.gephi.org/v1.0.2/ (but not usefull as the keys are not exported)
# savegraph("graph.gexf", g, GEXFFormat())

# @svg begin
#     background("#0f0f23")
#     sethue("#00cc00")
#     setline(0.2)
#     drawgraph(g, vertexlabels = vals, layout = stress,
#         vertexshapesizes = 4, vertexlabelfontsizes=4,
#         vertexfillcolors = (v) -> v ∈ (vs["svr"], vs["you"], vs["out"], vs["dac"], vs["fft"]) ? colorant"#d50620" : colorant"#00cc00",
#         edgearrows = true, edgestrokeweights=0.5,
#         edgestrokecolors = colorant"#cccccc",
#         )
# end

"""
    nb_path(key, vs[, memo])

Counts the number of path in the graph represented by `g` begining at `v_beg` and going to `v_end`.
  - `v_beg::Int` is the index of the vertex in the graph from where we start,
  - `v_end::Int` is the index of the vertex we aim to join,
  - `memo=Dict()` is a Dict used for memoization. At beginning, empty.

Path to amelioration : create a graph with String keys insted of Int
"""
function nb_path(v_beg::Int, v_end::Int, g::SimpleDiGraph{Int}, memo=Dict())
    if haskey(memo, v_beg)
        return memo[v_beg]
    end

    if v_beg == v_end
        return 1
    end

    neighbors_vertices = neighbors(g, v_beg)
    result = 0
    for v in neighbors_vertices
        result += nb_path(v, v_end, g, memo)
    end

    memo[v_beg] = result
    return result
end

function part_II(g::SimpleDiGraph{Int}, vs)
    idx_svr = vs["svr"]
    idx_fft = vs["fft"]
    idx_dac = vs["dac"]
    idx_out = vs["out"]

    svr_to_fft = nb_path(idx_svr, idx_fft, g)
    fft_to_dac = nb_path(idx_fft, idx_dac, g)
    dac_to_out = nb_path(idx_dac, idx_out, g)

    return svr_to_fft * fft_to_dac * dac_to_out
end


if "you" in vals
    idx_you = vs["you"]
    idx_out = vs["out"]
    I = nb_path(idx_you, idx_out, g)
    println("I : ", I)
end

if "svr" in vals
    II = part_II(g, vs)
    println("II: ", II)
end