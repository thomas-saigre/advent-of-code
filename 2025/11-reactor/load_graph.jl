using Graphs

function parse_input(filename::String)
    f = open(filename)
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

    g = SimpleDiGraph(length(vertices))
    for k in keys(d)
        for v in d[k]
            add_edge!(g, vertices[k], vertices[v])
        end
    end

    return g, vertices, vals

end