# input_filename = "example.txt"
input_filename = "input.txt"

function nb_of_int(x, y)
    if floor(y) - floor(x) == 0
        return 0
    elseif floor(y) == y
        return floor(Int, y) - floor(Int, x) - 1
    else
        return floor(Int, y) - floor(Int, x)
    end
end

function compute_score(course_time, record)
    delta = course_time^2 - 4 * record
    x1 = (-course_time + sqrt(delta)) / (-2)
    x2 = (-course_time - sqrt(delta)) / (-2)
    return nb_of_int(x1, x2)
end

function part_I(lines)
    times = parse.(Int, split(lines[1], r"\s+")[begin+1:end])
    dist = parse.(Int, split(lines[2], r"\s+")[begin+1:end])

    print(times, "\n")
    print(dist, "\n")

    score = 1

    for i in eachindex(times)

        local_score = compute_score(times[i], dist[i])
        score *= local_score
    end
    return score
end

function part_II(lines)

    time = parse(Int, replace(split(lines[1], ":")[end], " " => ""))
    dist = parse(Int, replace(split(lines[2], ":")[end], " " => ""))

    print(time, "\n")
    print(dist, "\n")

    return compute_score(time, dist)
end

f = open(input_filename, "r")
lines = readlines(f)
close(f)

score_I = part_I(lines)
print("Part I: ", score_I, "\n\n")

score_II = part_II(lines)
print("Part II: ", score_II, "\n")