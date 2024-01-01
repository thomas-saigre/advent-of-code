using Plots
using ProgressBars

input_filename = "input.txt"

struct Instruction
    type::Char
    start::Vector{Int}
    end_::Vector{Int}
end

function parse_instruction(file::String)
    f = open(file)
    lines = readlines(file)
    close(f)
    instruction = []
    for line in lines
        m = match(r"t(.+) (\d+),(\d+) through (\d+),(\d+)", line)
        start = [parse(Int, m[2]), parse(Int, m[3])] .+ [1, 1]
        end_ = [parse(Int, m[4]), parse(Int, m[5])] .+ [1, 1]
        push!(instruction, Instruction(m[1][end], start, end_))
    end
    return instruction
end

function apply_instructions(instructions, part=1)
    grid = zeros(Int, 1000, 1000)

    # heatmap_plot = heatmap(grid, c=:blues)
    # anim = @animate for instruction in ProgressBar(instructions)
    for instruction in instructions

        s = instruction.start
        e = instruction.end_
        if part == 1
        if instruction.type == 'n'
            grid[s[1]:e[1], s[2]:e[2]] .= 1
        elseif instruction.type == 'f'
            grid[s[1]:e[1], s[2]:e[2]] .= 0
        elseif instruction.type == 'e'
            grid[s[1]:e[1], s[2]:e[2]] .= 1 .- grid[s[1]:e[1], s[2]:e[2]]
        end
        else
        if instruction.type == 'n'
            grid[s[1]:e[1], s[2]:e[2]] .+= 1
        elseif instruction.type == 'f'
            grid[s[1]:e[1], s[2]:e[2]] .= max.(grid[s[1]:e[1], s[2]:e[2]] .- 1, 0)
        elseif instruction.type == 'e'
            grid[s[1]:e[1], s[2]:e[2]] .+= 2
        end
        end
        # heatmap!(heatmap_plot, grid, c=:blues)
    end
    # gif(anim, "animated_plot.gif", fps = 8)
    heatmap_plot = heatmap(grid, c=:blues)
    savefig(heatmap_plot, "heatmap"*string(part)*".png")

    if part == 1
        return length(filter( !=(0), grid))
    else
        return sum(grid)
    end
end

instructions = parse_instruction(input_filename)
for part in [1, 2]
    println("Part ", part, " : ", apply_instructions(instructions, part))
end
