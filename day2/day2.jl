# https://adventofcode.com/2019/day/2
using DelimitedFiles

input_arr = readdlm("day2\\input.txt",',',Int)

# before running the program, replace position 1 with the value 12 and replace
# position 2 with the value 2.
setindex!(input_arr,[12,2],[1,2] .+ 1)

function intcode(code)
    op_index = 0
    op_value = getindex(code,op_index + 1) # julia is 1-indexed
    while op_value != 99
        first_index = getindex(code,op_index + 2) + 1
        first_val = getindex(code, first_index)
        second_index = getindex(code,op_index + 3) + 1
        second_val = getindex(code,second_index)
        output_index = getindex(code,op_index + 4) + 1
        if op_value == 1
            # addition code
            output_val = first_val + second_val
        elseif op_value == 2
            # multiplication code
            output_val = first_val * second_val
        else
            # error
            print("error")
        end
        setindex!(code,output_val,output_index)
        op_index += 4
        op_value = getindex(code,op_index + 1)
    end
    return code
end

# tests
intcode([1,0,0,0,99]) == [2,0,0,0,99]
intcode([2,3,0,3,99]) == [2,3,0,6,99]
intcode([2,4,4,5,99,0]) == [2,4,4,5,99,9801]
intcode([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]

processed_code = intcode(input_arr)

output = getindex(processed_code,1)
