using ProgressBars
function look_and_say(s::String)
    output = ""
    size = length(s)
    s *= "00"
    idx = 1
    while idx <= size
        count = 1
        if s[idx+1] == s[idx]
            count += 1
            if s[idx+2] == s[idx]
                count += 1
            end
        end
        output *= string(count) * s[idx]
        idx += count
    end
    return output
end

function run(s, nb=5)
    # println(s)
    for i in ProgressBar(1:nb)
        s = look_and_say(s)
        # println(s)
    end
    return s
end

sI = run("3113322113", 40)
println("Part I : ", length(sI))
sII = run(sI, 10)
println("Part II: ", length(sII))