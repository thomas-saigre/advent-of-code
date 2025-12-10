
function parse_machine(content::String)
    regex_goal = r"\[.*\]"
    regex_switches = r"\(.*\)"
    regex_joltage = r"\{.*\}"

    goal_str = match(regex_goal, content).match[2:end-1]
    goal = [c == '#' ? 1 : 0 for c ∈ goal_str]

    switches_str = match(regex_switches, content).match
    switches = Set{Set{Int}}()
    for sub_switch ∈ split(switches_str, " ")
        s = Set{Int}([i+1 for i ∈ parse.(Int, split(sub_switch[2:end-1], ","))])
        push!(switches, s)
    end

    joltage_str = match(regex_joltage, content).match[2:end-1]
    joltage = parse.(Int, split(joltage_str, ","))

    return goal, switches, joltage
end

function parse_input(filename::String)
    f = open(filename, "r")
    # println(readlines(f))
    return parse_machine.(readlines(f))
end

input_filename = "example.txt"
# input_filename = "input.txt"
inputs = parse_input(input_filename)

for i in inputs
    println(i, "\n")
end