using FStrings
using DataStructures

input_filename = "example.txt"
# input_filename = "input.txt"

file = open(input_filename)
line = parse.(Int, collect(readline(file)))
nb_entry = length(line)



function fill_memory(line)

    memory_size = 9 * nb_entry

    memory = fill(-1, memory_size)
    # println(memory)

    spaces_dict = Dict{Int, Queue{Int}}()
    for i in 1:9
        spaces_dict[i] = Queue{Int}()
    end

    idx = 1
    file_id = -1
    is_file = true
    for i in eachindex(line)
        val = line[i]
        if is_file
            file_id += 1
            memory[idx:idx+val-1] .= file_id
        else
            if val != 0
                enqueue!(spaces_dict[val], idx)
            end
        end
        idx += val
        is_file = !is_file
    end
    return memory, idx-1, spaces_dict
end




function fragment_memory(memory, pointer, spaces_dict)


    while pointer > 0
        while memory[pointer] == -1
            pointer -= 1
        end

        current_file_id = memory[pointer]

        end_file_pointer = pointer
        while memory[pointer] == current_file_id && pointer > 0
            pointer -= 1
        end
        file_length = end_file_pointer - pointer

        if !isempty(spaces_dict[file_length])
            free_position = dequeue!(spaces_dict[file_length])
            memory[free_position:free_position+file_length] .= current_file_id
            memory[pointer+1:end_file_pointer] .= -1
            println(f"Moving file {current_file_id} to position {free_position}")
        end
    end

end


memory, pointer, spaces_dict = fill_memory(line)


# println(memory)
# println(spaces_dict)

fragment_memory(memory, pointer, spaces_dict)
println(memory)