include("day5.jl")

using Test

@testset "parseOp" begin
    code = [1001, 4, 3, 4, 33]
    @test parseOp(code, 0) == ([0,1,0],1)

    @test parseOp(code,1) == ([0,0,0],4)

    code[1] = 1101
    @test parseOp(code,0) == ([1,1,0],1)

    code[3] = 10103
    @test parseOp(code,2) == ([1,0,1],3)

    code[1] = 10110
    @test parseOp(code,0) == ([1,0,1],10)
end

@testset "add operation" begin
    code = [1001, 4, 3, 4, 33]

    post = copy(code)
    applyAddCode(post, [1,0,0], 0)
    @test post == [1001,4,3,4,8]

    post = copy(code)
    applyAddCode(post, [0,1,0], 0)
    @test post == [1001,4,3,4,36]

    post = copy(code)
    applyAddCode(post, [1,1,0], 0)
    @test post == [1001,4,3,4,7]
end

@testset "multiply operation" begin
    code = [1002, 4, 3, 4, 33]

    post = copy(code)
    applyMultCode(post, [1,0,0], 0)
    @test post == [1002,4,3,4,16]

    post = copy(code)
    applyMultCode(post, [0,1,0], 0)
    @test post == [1002,4,3,4,99]

    post = copy(code)
    applyMultCode(post, [1,1,0], 0)
    @test post == [1002,4,3,4,12]
end

@testset "input operation" begin
    code = [1001, 4, 3, 4, 33]

    post = copy(code)
    applyInputCode(post, 0, 1)
    @test post == [1001,4,3,4,1]

    post = copy(code)
    applyInputCode(post, 0, 2)
    @test post == [1001,4,3,4,2]

    post = copy(code)
    post[2] = 3
    applyInputCode(post, 0, 2)
    @test post == [1001,3,3,2,33]
end


@testset "output operation" begin
    code = [1001, 4, 3, 4, 33]

    post = copy(code)
    @test applyOutputCode(post, [0,0,0], 0) == 33
    @test applyOutputCode(post, [1,0,0], 0) == 4
end

@testset "jump-if-true operation" begin
    code = [1005, 4, 3, 4, 33]

    post = copy(code)
    @test applyJumpIfTrueCode(post, [0,0,0], 0) == 4
    @test applyJumpIfTrueCode(post, [1,0,0], 0) == 4
    @test applyJumpIfTrueCode(post, [0,1,0], 0) == 3
    @test applyJumpIfTrueCode(post, [1,1,0], 0) == 3

    code = [1005, 0, 3, 4, 33]
    post = copy(code)
    @test applyJumpIfTrueCode(post, [1,0,0], 0) == 3
    @test applyJumpIfTrueCode(post, [1,1,0], 0) == 3

    code = [1005, 4, 3, 4, 0]
    post = copy(code)
    @test applyJumpIfTrueCode(post, [0,0,0], 0) == 3
    @test applyJumpIfTrueCode(post, [0,1,0], 0) == 3
end

@testset "jump-if-false operation" begin
    code = [1005, 4, 3, 4, 33]

    post = copy(code)
    @test applyJumpIfFalseCode(post, [0,0,0], 0) == 3
    @test applyJumpIfFalseCode(post, [1,0,0], 0) == 3
    @test applyJumpIfFalseCode(post, [0,1,0], 0) == 3
    @test applyJumpIfFalseCode(post, [1,1,0], 0) == 3

    code = [1005, 0, 3, 4, 33]
    post = copy(code)
    @test applyJumpIfFalseCode(post, [1,0,0], 0) == 4
    @test applyJumpIfFalseCode(post, [1,1,0], 0) == 3

    code = [1005, 4, 3, 4, 0]
    post = copy(code)
    @test applyJumpIfFalseCode(post, [0,0,0], 0) == 4
    @test applyJumpIfFalseCode(post, [0,1,0], 0) == 3
end

@testset "less-than operation" begin
    code = [1006, 4, 3, 4, 4]

    post = copy(code)
    applyLessThanCode(post, [0,0,0], 0)
    @test post == [1006, 4, 3, 4, 0]

    post = copy(code)
    applyLessThanCode(post, [1,0,0], 0)
    @test post == [1006, 4, 3, 4, 0]

    post = copy(code)
    applyLessThanCode(post, [0,1,0], 0)
    @test post == [1006, 4, 3, 4, 0]

    # post = copy(code)
    # applyLessThanCode(post, [0,0,1], 0)
    # @test post == [1006, 4, 3, 4, 0]

    post = copy(code)
    applyLessThanCode(post, [1,1,0], 0)
    @test post == [1006, 4, 3, 4, 0]

    # post = copy(code)
    # applyLessThanCode(post, [1,0,1], 0)
    # @test post == [1006, 4, 3, 4, 0]

    # post = copy(code)
    # applyLessThanCode(post, [0,1,1], 0)
    # @test post == [1006, 4, 3, 4, 0]

    code = [1006, 4, 3, 4, 2]
    post = copy(code)
    applyLessThanCode(post, [0,0,0], 0)
    @test post == [1006, 4, 3, 4, 1]

    post = copy(code)
    applyLessThanCode(post, [1,0,0], 0)
    @test post == [1006, 4, 3, 4, 0]

    post = copy(code)
    applyLessThanCode(post, [0,1,0], 0)
    @test post == [1006, 4, 3, 4, 1]

    # post = copy(code)
    # applyLessThanCode(post, [0,0,1], 0)
    # @test post == [1006, 4, 3, 4, 1]
    #
    post = copy(code)
    applyLessThanCode(post, [1,1,0], 0)
    @test post == [1006, 4, 3, 4, 0]

    # post = copy(code)
    # applyLessThanCode(post, [1,0,1], 0)
    # @test post == [1006, 4, 3, 4, 0]
    #
    # post = copy(code)
    # applyLessThanCode(post, [0,1,1], 0)
    # @test post == [1006, 4, 3, 4, 1]
end

@testset "equals operation" begin
    code = [1007, 4, 3, 4, 4]

    post = copy(code)
    applyEqualsCode(post, [0,0,0], 0)
    @test post == [1007, 4, 3, 4, 1]

    post = copy(code)
    applyEqualsCode(post, [1,0,0], 0)
    @test post == [1007, 4, 3, 4, 1]

    post = copy(code)
    applyEqualsCode(post, [0,1,0], 0)
    @test post == [1007, 4, 3, 4, 0]

    post = copy(code)
    applyEqualsCode(post, [0,0,1], 0)
    @test post == [1007, 4, 3, 4, 1]

    post = copy(code)
    applyEqualsCode(post, [1,1,0], 0)
    @test post == [1007, 4, 3, 4, 0]

    post = copy(code)
    applyEqualsCode(post, [1,0,1], 0)
    @test post == [1007, 4, 3, 4, 1]

    post = copy(code)
    applyEqualsCode(post, [0,1,1], 0)
    @test post == [1007, 4, 3, 4, 0]
end

@testset "example 1" begin
    code = [3 9 8 9 10 9 4 9 99 -1 8]
    post = copy(code)
    @test intcode(post,3)[end] == 0
    @test intcode(post,8)[end] == 1
end

@testset "example 2" begin
    code = [3 9 7 9 10 9 4 9 99 -1 8]
    post = copy(code)
    @test intcode(post,3)[end] == 1
    @test intcode(post,8)[end] == 0
end

@testset "example 3" begin
    code = [3 3 1108 -1 8 3 4 3 99]
    post = copy(code)
    @test intcode(post,3)[end] == 0
    @test intcode(post,8)[end] == 1
end

@testset "example 4" begin
    code = [3 3 1107 -1 8 3 4 3 99]
    post = copy(code)
    @test intcode(post,3)[end] == 1
    @test intcode(post,8)[end] == 0
end

@testset "example 5" begin
    code = [3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9]
    post = copy(code)
    @test intcode(post,0)[end] == 0
    @test intcode(post,22)[end] == 1
end

@testset "example 6" begin
    code = [3 3 1105 -1 9 1101 0 0 12 4 12 99 1]
    post = copy(code)
    @test intcode(post,0)[end] == 0
    @test intcode(post,22)[end] == 1
end

@testset "example 7" begin
    code = [3 21 1008 21 8 20 1005 20 22 107 8 21 20 1006 20 31 1106 0 36 98 0 0 1002 21 125 20 4 20 1105 1 46 104 999 1105 1 46 1101 1000 1 20 4 20 1105 1 46 98 99]
    post = copy(code)
    @test intcode(post,1)[end] == 999
    @test intcode(post,8)[end] == 1000
    @test intcode(post,9)[end] == 1001
end
