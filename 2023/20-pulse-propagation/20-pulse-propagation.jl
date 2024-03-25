using DataStructures

# input_filename = "ex1.txt"
# input_filename = "ex2.txt"
input_filename = "input.txt"

mutable struct Module_
    type::Char
    destination::Vector{String}
    state::Int  # 0: off, 1: on
end


function parse_input(filename)
    f = open(filename)
    lines = readlines(f)
    close(f)
    d = Dict()

    for line in lines
        s = split(line, " -> ")
        name = s[1][2:end]
        type = s[1][1]
        dest = split(s[2], ", ")
        d[name] = Module_(type, dest, 0)
    end

    return d
end


function create_connected_conj(modules)
    connected_conj = Dict()
    for name in keys(modules)
        m = modules[name]
        if m.type == '&'
            connected_conj[name] = Dict()
            for name2 in keys(modules)
                m2 = modules[name2]
                if name in m2.destination
                    connected_conj[name][name2] = 0
                end
            end
            # println("      prev of ", name, ": ", connected_conj[name])
        end
    end
    return connected_conj
end


function press_button_1(modules, connected_conj)
    Q = Queue{Tuple{String, Int64, String}}()
    enqueue!(Q, ("roadcaster", 0, "button"))
    n_pulse = [0, 0]

    while !isempty(Q)
        name, pulse, source = dequeue!(Q)
        n_pulse[pulse+1] += 1
        # println(source, " -", (pulse==1) ? "high" : "low", "-> ", name)
        if name ∈ keys(modules)
        m = modules[name]
        if m.type == '%' # filp-flop
            if pulse == 0       # low-pulse
                m.state = m.state ⊻ 1
                for dest in m.destination
                    enqueue!(Q, (dest, m.state, name))
                end
            end
        elseif m.type == '&' # conjugaison
            prev = connected_conj[name]
            prev[source] = pulse
            connected_conj[name] = prev
            # println("      prev of ", name, ": ", prev)
            pulse = reduce(&, values(prev)) ⊻ 1
            for dest in m.destination
                enqueue!(Q, (dest, pulse, name))
            end
        elseif m.type == 'b' # broadcaster
            for dest in m.destination
                enqueue!(Q, (dest, pulse, name))
            end
        else
            println("Error: unknown type ", m.type)
        end
        end
    end
    return n_pulse
end

function press_button_2(modules, connected_conj, button="rx")
    Q = Queue{Tuple{String, Int64, String}}()
    enqueue!(Q, ("roadcaster", 0, "button"))


    while !isempty(Q)
        name, pulse, source = dequeue!(Q)

        if name == button && pulse == 0
            println(source, " -", (pulse==1) ? "high" : "low", "-> ", name)
            return true
        end

        if name ∈ keys(modules) # for part 1
        m = modules[name]
        if m.type == '%' # filp-flop
            if pulse == 0       # low-pulse
                m.state = m.state ⊻ 1
                for dest in m.destination
                    enqueue!(Q, (dest, m.state, name))
                end
            end
        elseif m.type == '&' # conjugaison
            prev = connected_conj[name]
            prev[source] = pulse
            connected_conj[name] = prev
            # println("      prev of ", name, ": ", prev)
            pulse = reduce(&, values(prev)) ⊻ 1
            for dest in m.destination
                enqueue!(Q, (dest, pulse, name))
            end
        elseif m.type == 'b' # broadcaster
            for dest in m.destination
                enqueue!(Q, (dest, pulse, name))
            end
        else
            println("Error: unknown type ", m.type)
        end
        end
    end
    return false
end

function press_n_button(modules, n)
    connected_conj = create_connected_conj(modules)
    n_total_pulse = [0, 0]
    for _ in 1:n
        n_total_pulse .+= press_button_1(modules, connected_conj)
        # println()
    end
    return reduce(*, n_total_pulse)
end

function activate_machine(modules)
    #=
    n_push_list = [0, 0, 0, 0]
    for (i, name) in enumerate(["lk", "zv", "xt", "sp"])
        n_push = 0
        connected_conj = create_connected_conj(modules)
        while !press_button_2(modules, connected_conj, name)
            n_push += 1
        end
        n_push_list[i] = n_push
    end
    println(n_push_list)
    return lcm(n_push_list...)
    =#
    return lcm(3823, 4051, 3767, 3929)
end



modules = parse_input(input_filename)
I = press_n_button(modules, 1000)
println("Part I: ", I)

II = activate_machine(modules)
println("Part II: ", II)
# >= 30464484388140
# >= 182786906328840