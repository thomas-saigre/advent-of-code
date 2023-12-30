input_filename = "input.txt"

function is_nice(string::String)
    has_enough_vowels = count(r"[aeiou]", string) >= 3
    has_double = occursin(r"([a-z])\1", string)
    has_forbidden = occursin(r"(ab|cd|pq|xy)", string)

    return has_enough_vowels && has_double && !has_forbidden
end

function is_nice_bis(string::String)
    has_pair = occursin(r"([a-z]{2}).*\1", string)
    has_repeat = occursin(r"([a-z])[a-z]\1", string)

    return has_pair && has_repeat
end

for s in ["ugknbfddgicrmopn", "aaa", "jchzalrnumimnmhp", "haegwjzuvuyypxyu", "dvszwmarrgswjxmb"]
    println(s, " : ", is_nice(s))
end
println()
for s in ["qjhvhtzxzqqjkmpb", "xxyxx", "uurcxstgmygtbstg", "ieodomkazucvgmuy"]
    println(s, " : ", is_nice_bis(s))
end

for (i, f) in enumerate([is_nice, is_nice_bis])
    println("Part ", i, ": ", count(f, readlines(input_filename)))
end