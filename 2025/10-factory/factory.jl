using Combinatorics
using JuMP, HiGHS
using ProgressBars

function parse_machine(content::String)
    regex_goal = r"\[.*\]"
    regex_switches = r"\(.*\)"
    regex_joltage = r"\{.*\}"

    goal_str = match(regex_goal, content).match[2:end-1]
    goal = [c == '#' ? 1 : 0 for c ∈ goal_str]

    switches_str = match(regex_switches, content).match
    switches_I = Vector{Vector{Int}}()
    switches_II = Vector{Set{Int}}()
    for sub_switch ∈ split(switches_str, " ")
        s_I = zeros(Int, length(goal))
        for i ∈ parse.(Int, split(sub_switch[2:end-1], ","))
            s_I[i+1] = 1
        end
        s_II = Set{Int}([i+1 for i ∈ parse.(Int, split(sub_switch[2:end-1], ","))])

        push!(switches_I, s_I)
        push!(switches_II, s_II)
    end

    joltage_str = match(regex_joltage, content).match[2:end-1]
    joltage = parse.(Int, split(joltage_str, ","))

    return goal, switches_I, joltage, switches_II
end

function parse_input(filename::String)
    f = open(filename, "r")
    # println(readlines(f))
    return parse_machine.(readlines(f))
end


function start_machine(target::Vector{Int}, buttons::Vector{Vector{Int}})

    nb_light = length(target)
    nb_buttons = length(buttons)

    for r in 1:nb_buttons
        for combi in combinations(1:length(buttons), r)
            current_state = zeros(Int, nb_light)
            for i ∈ combi
                current_state = xor.(current_state, buttons[i])
            end
            if current_state == target
                return r
            end
        end
    end
end

function Part_I(inputs::Vector)
    r = 0
    for entry in inputs
        r += start_machine(entry[1], entry[2])
    end
    println("I ", r)
end


# Thanks internet for the tip for part II ;)
function convert_switches_to_matrix(buttons::Vector{Set{Int}}, n::Int)
    m = length(buttons)
    S = zeros(Int, n, m)
    for i ∈ 1:m
        for j ∈ buttons[i]
            S[j, i] = 1
        end
    end
    return S
end

function optimize_switches(joltage::Vector{Int}, buttons::Vector{Set{Int}})
    model = Model(HiGHS.Optimizer)
    n = length(joltage)
    m = length(buttons)
    S = convert_switches_to_matrix(buttons, n)  # n lines, columns
    @variable(model, x[1:m] >= 0, Int)
    @constraint(model, S * x == joltage)
    @objective(model, Min, sum(x))
    set_silent(model)
    optimize!(model)
    if termination_status(model) == MOI.OPTIMAL
        return sum(round.(Int, value.(x)))
    end
    error("No optimal button configuration found: $(termination_status(model))")
end


function Part_II(inputs::Vector)
    r = 0
    for entry in inputs
        r = optimize_switches(entry[3], entry[4])
        println(r)
    end
end

function run(inputs::Vector)
    res1 = 0
    res2 = 0
    for entry in ProgressBar(inputs)
        res1 += start_machine(entry[1], entry[2])
        res2 += optimize_switches(entry[3], entry[4])
    end
    println(" I ", res1)
    println("II ", res2)
end

# input_filename = "example.txt"
input_filename = "input.txt"
inputs = parse_input(input_filename)

# for i in inputs
    # println(i, " ", typeof(i))
# end

run(inputs)