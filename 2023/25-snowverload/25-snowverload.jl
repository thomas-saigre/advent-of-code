using Graphs
using Karnak, Luxor, Colors
using ProgressBars

# input_filename = "example.txt"
input_filename = "input.txt"

function parse_input(input_filename::String)
    f = open(input_filename)
    lines = readlines(f)
    close(f)

    split_lines = split.(lines, ": ")
    d = Dict()
    for i in eachindex(split_lines)
        tmp = split(split_lines[i][2], " ")
        d[split_lines[i][1]] = tmp
    end

    vertices = Dict()
    vals = []
    v_idx = 1
    for k in keys(d)
        if !(k in keys(vertices))
            vertices[k] = v_idx
            v_idx += 1
            push!(vals, k)
        end
        for v in d[k]
            if !(v in keys(vertices))
                vertices[v] = v_idx
                v_idx += 1
                push!(vals, v)
            end
        end
    end

    g = SimpleGraph(length(vertices))
    for k in keys(d)
        for v in d[k]
            add_edge!(g, vertices[k], vertices[v])
        end
    end

    return g, vertices, vals

end

function remove_edge(g, vertices, v1, v2)
    v1_idx = vertices[v1]
    v2_idx = vertices[v2]
    rem_edge!(g, v1_idx, v2_idx)
end

#=
function look_for_split_in_2(g, vertices)
    for v1 in keys(vertices)
        v1_idx = vertices[v1]
        neighbors_1 = neighbors(g, v1_idx)
        for v1_n in neighbors_1
            for v2 in ProgressBar(keys(vertices))
                v2_idx = vertices[v2]
                neighbors_2 = neighbors(g, v2_idx)
                for v2_n in neighbors_2
                    for v3 in keys(vertices)
                        v3_idx = vertices[v3]
                        neighbors_3 = neighbors(g, v3_idx)
                        for v3_n in neighbors_3
                            g_tmp = deepcopy(g)
                            rem_edge!(g_tmp, v1_idx, v1_n)
                            rem_edge!(g_tmp, v2_idx, v2_n)
                            rem_edge!(g_tmp, v3_idx, v3_n)
                            cc = connected_components(g_tmp)
                            if length(cc) == 2
                                println("split in 2: ", v1, " ", v1_n, " ", v2, " ", v2_n, " ", v3, " ", v3_n)
                                return cc
                            end
                        end
                    end
                end
            end
        end
    end
end
=#
g, v, vals = parse_input(input_filename)


@svg begin
    background("gray30")
    sethue("orange")
    setline(0.2)
    drawgraph(g, vertexlabels = vals, layout = spring,
        vertexshapesizes = 5, vertexlabelfontsizes=2,
        edgestrokecolors = colorant"red")
end 600 300


# For example
# remove_edge(g, v, "hfx", "pzl")
# remove_edge(g, v, "bvb", "cmg")
# remove_edge(g, v, "nvd", "jqt")

# For input
# we see when plotting the graph that the three edges to cut are
remove_edge(g, v, "tmt", "pnz")
remove_edge(g, v, "mvv", "xkz")
remove_edge(g, v, "gbc", "hxr")


cc = connected_components(g)

# cc = look_for_split_in_2(g, v)
I = length(cc[1]) * length(cc[2])
println("Part 1 : ", I)





