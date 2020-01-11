# https://adventofcode.com/2019/day/2
using DelimitedFiles

input_arr = readdlm("day2\\input.txt",',',Int)

# before running the program, replace position 1 with the value 12 and replace
# position 2 with the value 2.

test_code = copy(input_arr)
setindex!(test_code,[12,2],[1,2] .+ 1)

function intcode(code)
    test_code = copy(code)
    op_index = 0
    op_value = test_code[op_index + 1] # julia is 1-indexed
    while op_value != 99
        first_index = test_code[op_index + 2] + 1
        first_val = test_code[first_index]
        second_index = test_code[op_index + 3] + 1
        second_val = test_code[second_index]
        output_index = test_code[op_index + 4] + 1
        if op_value == 1
            # addition test_code
            output_val = first_val + second_val
        elseif op_value == 2
            # multiplication test_code
            output_val = first_val * second_val
        else
            # error
            print("error")
        end
        test_code[output_index] = output_val
        op_index += 4
        op_value = test_code[op_index + 1]
    end
    return test_code
end

function intcode(code, noun, verb)
    test_code = copy(code)
    setindex!(test_code,[noun,verb],[2,3]) # initialize the noun verb into code
    return intcode(test_code)
end
# tests
intcode([1,0,0,0,99]) == [2,0,0,0,99]
intcode([2,3,0,3,99]) == [2,3,0,6,99]
intcode([2,4,4,5,99,0]) == [2,4,4,5,99,9801]
intcode([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]

intcode([1,0,0,0,99],0,0) == [2,0,0,0,99]
intcode([2,3,0,3,99],3,0) == [2,3,0,6,99]
intcode([2,4,4,5,99,0],4,4) == [2,4,4,5,99,9801]
intcode([1,1,1,4,99,5,6,0,99],1,1) == [30,1,1,4,2,5,6,0,99]

noun = 12
verb = 2

processed_code = intcode(input_arr,noun,verb)

output = getindex(processed_code,1)

# part2
function get_sol_pairs(code,output)
    # return (noun, verb) tuple for which intcode(code,noun,verb)[1] = output
    for noun = 0:99, verb = 0:99
        this_output = intcode(code,noun,verb)[1]
        if this_output == output
            return tuple(noun,verb)
        end
    end
end

intcode_output = 19690720
sol_pairs = get_sol_pairs(input_arr, intcode_output)

output = 100sol_pairs[1] + sol_pairs[2]
