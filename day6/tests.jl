include("day6.jl")
using Test

@testset "Example 1" begin
    input = ["COM)B" "B)C" "C)D" "D)E" "E)F" "B)G" "G)H" "D)I" "E)J" "J)K" "K)L"]
    @test orbit_count_checksum(input) == 42
end
