using ProgressBars

# input_filename = "example.txt"
input_filename = "input.txt"

function parse_expr(expr)
    cond = match(r"([^\:]+)\:(\w+),(.+)", expr)
    # println(cond)
    if isnothing(cond)
        return "\"" * expr * "\""
    else
        return "(" * cond[1] * ") ? \"" * cond[2] * "\" : (" * parse_expr(cond[3]) * ")"
    end
end

function get_workflow(str)
    s = split(replace(str, '}' => ""), '{')
    name = s[1]
    expression = parse_expr(s[2])
    # println(expression)
    # map = Meta.parse(expression)
    map = (x,m,a,s) -> eval(Meta.parse(
            replace(expression, "x<" => string(x)*"<", "x>" => string(x)*">",
                                "m<" => string(m)*"<", "m>" => string(m)*">",
                                "a<" => string(a)*"<", "a>" => string(a)*">",
                                "s<" => string(s)*"<", "s>" => string(s)*">")
            # replace(expression, "x" => string(x), "m" => string(m), "a" => string(a), "s" => string(s))
    ))
    # println("Name : ", name)
    # println("Map : ", map)
    return name, map
end

function parse_input(filename::String)
    permutations = []
    split_file = split(strip(read(filename, String)), "\n\n")

    line_by_line = split.(split_file, "\n")

    workflows = Dict()
    for line in line_by_line[1]
        name, map = get_workflow(line)
        workflows[name] = map
    end

    parts = []
    for line in line_by_line[2]
        expr = split(line[2:end-1], ",")
        vals = []
        for e in expr
            _, val = match(r"(\w+)=(\d+)", e)
            val = parse(Int, val)
            push!(vals, val)
        end
        push!(parts, vals)
    end

    return workflows, parts
end


# name, map = get_workflow("px{a<2006:qkq,m>2090:A,rfg}")
# a = 15000
# m = 10
# println(eval(map))

function is_accepted(part, workflows)
    r = "in"
    while !(r in ["A", "R"])
        # println(r)
        r = workflows[r](part...)
    end
    return r == "A"
end

function part_I(workflows, parts)

    map = (x) -> is_accepted(x, workflows)
    s = sum.(parts)
    r = map.(parts)
    return sum(r .* s)
end

function part_II(workflows)
    nb = 0
    for x in 1:4000
        for m in 1:4000
            for a in ProgressBar(1:4000)
                for s in 1:4000
                    if is_accepted([x, m, a, s], workflows)
                        nb += 1
                    end
                end
            end
        end
    end
    return nb
end

workflows, parts = parse_input(input_filename)
# println(typeof(workflows["px"]))
# println(workflows["px"](15000, 10, 15000, 15000))
# for p in parts
#     println(p)
# end
# println(workflows["in"](787, 2655, 1222, 2876))




I = part_I(workflows, parts)
println("I: ", I)
II = part_II(workflows)
println("II: ", II)


# println(eval(workflows["px"], :(x = 15000), :(m = 10), :(a = 15000), :(s = 15000)))