using FStrings

# input = [1, 2, 3, 4, 5, 7, 8, 9, 10, 11]
input = [1, 3, 5, 11, 13, 17, 19, 23, 29, 31, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113]
# S = sum(input)
# each_pack = div(S, 3)
# println(f"S = {S}, split in 3 packs of {each_pack}")

function split(arr::Vector{Int}, n_group::Int)
    S = sum(arr)
    target = div(S, n_group)

    # Sort descending so the recursive search prunes earlier.
    sorted_arr = sort(arr, rev=true)

    function can_split_groups(remaining::Vector{Int}, groups_left::Int)
        if groups_left == 1
            return sum(remaining) == target
        end

        n = length(remaining)

        function subset_sum(start::Int, s::Int, picked::Vector{Int})
            if s == target
                counts = Dict{Int, Int}()
                for x in picked
                    counts[x] = get(counts, x, 0) + 1
                end
                rest = Int[]
                for x in remaining
                    c = get(counts, x, 0)
                    if c > 0
                        counts[x] = c - 1
                    else
                        push!(rest, x)
                    end
                end
                return can_split_groups(rest, groups_left - 1)
            end
            if s > target || start > n
                return false
            end
            for i in start:n
                x = remaining[i]
                push!(picked, x)
                if subset_sum(i + 1, s + x, picked)
                    return true
                end
                pop!(picked)
            end
            return false
        end

        return subset_sum(1, 0, Int[])
    end

    for k in 1:length(sorted_arr)
        results = NTuple{3, Vector{Int}}[]

        function choose_first(start::Int, picked::Vector{Int}, picked_sum::Int)
            # Build the first group recursively.
            if picked_sum == target
                counts = Dict{Int, Int}()
                for x in picked
                    counts[x] = get(counts, x, 0) + 1
                end
                remaining = Int[]
                for x in sorted_arr
                    c = get(counts, x, 0)
                    if c > 0
                        counts[x] = c - 1
                    else
                        push!(remaining, x)
                    end
                end
                if can_split_groups(remaining, n_group - 1)
                    push!(results, (copy(picked), remaining, Int[]))
                end
                return
            end

            if length(picked) == k || picked_sum > target
                return
            end

            for i in start:length(sorted_arr)
                x = sorted_arr[i]
                push!(picked, x)
                choose_first(i + 1, picked, picked_sum + x)
                pop!(picked)
            end
        end

        choose_first(1, Int[], 0)
        if !isempty(results)
            return results
        end
    end

    return NTuple{3, Vector{Int}}[]
end

function run(input, n_group)

    splits = split(input, n_group)
    println("found $(length(splits)) splits")

    sorted = sort(splits, by=x->length(x[1]))
    mi = length(sorted[1][1])

    QE_min = typemax(Int64)

    for vvv in sorted
        if length(vvv[1]) == mi
            QE = prod(vvv[1])
            QE_min = min(QE, QE_min)
        else
            break
        end
    end
    return QE_min
end

I = run(input, 3)
println(f"I : {I}")

II = run(input, 4)
println(f"II : {II}")
