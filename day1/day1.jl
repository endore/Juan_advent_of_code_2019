# https://adventofcode.com/2019/day/1
using DelimitedFiles

function get_fuel_req(mass::Int)::Int
    return fuel_req = floor(mass/3) - 2
end

input_arr = readdlm("day1\\input.txt",'\t',Int)

output = sum(get_fuel_req.(input_arr))

function get_fuel_while(mass::Int)::Int
    total_fuel = 0
    init_fuel = get_fuel_req(mass)
    while init_fuel > 0
        total_fuel += init_fuel
        init_fuel = get_fuel_req(init_fuel)
    end
    return total_fuel
end

# tests
print(get_fuel_while(14) == 2)  # expecting 2

print(get_fuel_while(1969) == 966)

print(get_fuel_while(100756) == 50346)

output2 = sum(get_fuel_while.(input_arr))

function get_fuel_recursive(mass::Int)::Int
    init_fuel = Int(floor(mass/3) - 2)
    total_fuel = init_fuel > 0 ? init_fuel + get_fuel_recursive(init_fuel) : 0
    return total_fuel
end

# tests
print(get_fuel_recursive(14) == 2)  # expecting 2

print(get_fuel_recursive(1969) == 966)

print(get_fuel_recursive(100756) == 50346)

output2_recursive = sum(get_fuel_while.(input_arr))

# benchmarking while loop vs recursive solution

using BenchmarkTools

@benchmark sum(get_fuel_recursive.(input_arr))

@benchmark sum(get_fuel_while.(input_arr))
