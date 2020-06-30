include("day6.jl")
using Test

@testset "Example 1" begin
    input = ["COM)B" "B)C" "C)D" "D)E" "E)F" "B)G" "G)H" "D)I" "E)J" "J)K" "K)L"]
    @test partOne(input) == 42
end

@testset "Example 2" begin
    input = ["COM)B" "B)C" "C)D" "D)E" "E)F" "B)G" "G)H" "D)I" "E)J" "J)K" "K)L" "K)YOU" "I)SAN"]

    input_df = clean_input(input)
    @test partTwo(input) == 4
end
