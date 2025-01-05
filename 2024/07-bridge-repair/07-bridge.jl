using FStrings
using IterTools
using Dates
using BenchmarkTools

function parse_input(filename::String)
    file = open(input_filename, "r")
    lines = collect(eachline(file))

    results = []
    values = []

    for line in lines
        res, vals = split(line, ": ")
        push!(results, parse(Int, res))
        vals_ = parse.(Int, split(vals, " "))
        push!(values, vals_)
    end

    return results, values
end


function test_line(result, values, part)
    print(f"Dealing with {result} and {values}")
    if part == 1
        op = [+, *]
    else
        op = [*, +, 🗄️]
    end

    n = length(values) - 1

    for o in IterTools.product(repeat([op], n)...)
        tmp = values[begin]
        for i in eachindex(o)
            tmp = o[i](tmp, values[i+1])
        end

        if tmp == result
            println(f" possible with {o}")
            return result
        end
    end
    println(f" not possible")
    return 0
end


function 🗄️(a::Int, b::Int)
    # Convert both integers to strings, concatenate them, and then convert back to an integer
    return parse(Int, string(a) * string(b))
end


input_filename = "example.txt"
# input_filename = "input.txt"

results, values = parse_input(input_filename)
# println(results)

@time I = test_line.(results, values, 1)
# Surely not optimized : it took 314.604221 s to run !

@time II = test_line.(results, values, 2)
# Surely not optimized at all : it took ... to run !

println(f"I : {sum(I)}")
println(f"II: {sum(II)}")