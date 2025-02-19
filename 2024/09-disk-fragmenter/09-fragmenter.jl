using FStrings

# input_filename = "example.txt"
input_filename = "input.txt"

file = open(input_filename)
line = parse.(Int, collect(readline(file)))
nb_entry = length(line)


function fill_memory(line)

    memory_size = 9 * nb_entry

    memory = fill(-1, memory_size)
    # println(memory)

    idx = 1
    file_id = -1
    is_file = true
    for i in eachindex(line)
        val = line[i]
        if is_file
            file_id += 1
            memory[idx:idx+val-1] .= file_id
        end
        idx += val
        is_file = !is_file
    end
    return memory, idx-1
end


function fragment_memory(memory, file_pointer)
    memory_pointer = 1

    while memory_pointer < file_pointer
        if memory[memory_pointer] == -1
            # println(f"Putting {memory[file_pointer]} in position {memory_pointer}")
            # println(f" {memory}")
            memory[memory_pointer] = memory[file_pointer]
            memory[file_pointer] = -1
            while memory[file_pointer] == -1
                file_pointer -= 1
            end
        end
        memory_pointer += 1
    end
end


function check_sum(memory)
    truncated_memory = memory[memory .!= -1]
    # println(truncated_memory)
    return sum(truncated_memory .* collect(eachindex(truncated_memory) .- 1))

end

memory, pointer = fill_memory(line)
# println(memory)

fragment_memory(memory, pointer)

println("I : ", check_sum(memory))