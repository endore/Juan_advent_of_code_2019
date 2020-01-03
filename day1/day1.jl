# https://adventofcode.com/2019/day/1

function get_fuel_req(mass::Int)::Int
    return fuel_req = floor(mass/3) - 2
end

input_arr = DelimitedFiles.readdlm("day1\\input.txt",'\t',Int)

output = sum(get_fuel_req.(input_arr))
