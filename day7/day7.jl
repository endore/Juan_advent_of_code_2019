using DelimitedFiles
using DataFrames

function partOne(input_arr = readdlm("day7\\input.txt", ',', Int))
    # set up all possible phase configurations as an input grid
    max = -Inf
    max_sequence = (NaN,NaN,NaN,NaN,NaN)
    for i = 0:4, j = 0:4, k = 0:4, l = 0:4, m = 0:4
        # only run combinations with sum = 10
        sequence = (i,j,k,l,m)
        if length(unique(sequence)) == 5
            # run sequence with input = 0 and append to list
            output = run_sequence(input_arr,sequence)
            if output > max
                max = output
                max_sequence = sequence
            end
        end
    end
    return (max_sequence,max)
end

function run_sequence(input_arr, phase_sequence)
    A = intcode(copy(input_arr),phase_sequence[1],0)
    B = intcode(copy(input_arr),phase_sequence[2],A[end])
    C = intcode(copy(input_arr),phase_sequence[3],B[end])
    D = intcode(copy(input_arr),phase_sequence[4],C[end])
    E = intcode(copy(input_arr),phase_sequence[5],D[end])
    return E[end]
end

function parseOp(testCode, opIndex::Int)
    fullCode = testCode[opIndex+1] # Julia is 1-indexed
    opCode = fullCode % 100
    paramCode = [0, 0, 0]
    paramVal = reverse(string(Int(floor(fullCode / 100))))
    for i = 1:length(paramVal)
        paramCode[i] = parse(Int, paramVal[i])
    end
    return tuple(paramCode, opCode)
end

function applyAddCode(testCode, paramCode, opIndex)
    # start assuming paramCode = [1,1,1] all immediate mode
    firstVal = testCode[opIndex+2]
    secondVal = testCode[opIndex+3]
    if paramCode[1] == 0
        # firstVal is actually position mode
        firstVal = testCode[firstVal+1]
    end
    if paramCode[2] == 0
        secondVal = testCode[secondVal+1]
    end
    # for sum operation 3rd parameter should always be position
    outputVal = firstVal + secondVal
    #TODO: throw error if 3rd parameter == 1
    outputIndex = testCode[opIndex+4] + 1
    testCode[outputIndex] = outputVal
end

function applyMultCode(testCode, paramCode, opIndex)
    # start assuming paramCode = [1,1,1] all immediate mode
    firstVal = testCode[opIndex+2]
    secondVal = testCode[opIndex+3]
    if paramCode[1] == 0
        # firstVal is actually position mode
        firstVal = testCode[firstVal+1]
    end
    if paramCode[2] == 0
        secondVal = testCode[secondVal+1]
    end
    # for sum operation 3rd parameter should always be position
    outputVal = firstVal * secondVal
    #TODO: throw error if 3rd parameter == 1
    outputIndex = testCode[opIndex+4] + 1
    testCode[outputIndex] = outputVal
end

function applyInputCode(testCode, opIndex, input)
    # start assuming paramCode = [1,1,1] all immediate mode
    firstVal =  testCode[opIndex+2]
    inputIndex = firstVal + 1
    testCode[inputIndex] = input
end

function applyOutputCode(testCode, paramCode, opIndex)
    # start assuming paramCode = [1,1,1] all immediate mode
    outputVal = testCode[opIndex+2]
    if paramCode[1] == 0
        # was by position; update accordingly
        outputVal = testCode[outputVal+1]
    end
    return outputVal
end

function applyJumpIfTrueCode(testCode,paramCode, opIndex)
    # start assuming paramCode = [1,1,1] all immediate mode
    nextOpIndex = opIndex
    firstVal = testCode[opIndex + 2]
    if paramCode[1] == 0
        firstVal = testCode[firstVal + 1]
    end
    secondVal =testCode[opIndex + 3]
    if paramCode[2] == 0
        secondVal = testCode[secondVal + 1]
    end
    if firstVal != 0
        nextOpIndex = secondVal
    else
        nextOpIndex += 3
    end
    return nextOpIndex
end

function applyJumpIfFalseCode(testCode,paramCode, opIndex)
    # start assuming paramCode = [1,1,1] all immediate mode
    nextOpIndex = opIndex
    firstVal = testCode[opIndex + 2]
    if paramCode[1] == 0
        firstVal = testCode[firstVal + 1]
    end
    secondVal =testCode[opIndex + 3]
    if paramCode[2] == 0
        secondVal = testCode[secondVal + 1]
    end
    if firstVal == 0
        nextOpIndex = secondVal
    else
        nextOpIndex += 3
    end
    return nextOpIndex
end

function applyLessThanCode(testCode, paramCode, opIndex)
    # start assuming paramCode = [1,1,1] all immediate mode
    firstVal = testCode[opIndex+2]
    if paramCode[1] == 0
        firstVal = testCode[firstVal + 1]
    end
    secondVal = testCode[opIndex+3]
    if paramCode[2] == 0
        secondVal = testCode[secondVal + 1]
    end
    outputVal = 0
    if firstVal < secondVal
        # firstVal is actually position mode
        outputVal = 1
    end
    thirdVal = testCode[opIndex+4]
    # if paramCode[3] == 0
    #     thirdVal = testCode[thirdVal + 1]
    # end
    outputIndex = thirdVal + 1
    testCode[outputIndex] = outputVal
end

function applyEqualsCode(testCode, paramCode, opIndex)
    # start assuming paramCode = [1,1,1] all immediate mode
    firstVal = testCode[opIndex+2]
    if paramCode[1] == 0
        firstVal = testCode[firstVal + 1]
    end
    secondVal = testCode[opIndex+3]
    if paramCode[2] == 0
        secondVal = testCode[secondVal + 1]
    end
    outputVal = 0
    if firstVal == secondVal
        # firstVal is actually position mode
        outputVal = 1
    end
    thirdVal = testCode[opIndex+4]
    # if paramCode[3] == 0
    #     thirdVal = testCode[thirdVal + 1]
    # end
    outputIndex = thirdVal + 1
    testCode[outputIndex] = outputVal
end

function intcode(code::Array{Int,2}, phase_input::Int, amplifier_input::Int)::Array{Int,1}
    testCode = copy(code)
    # setup pythonic list like object to hold ouputs as they appear
    outputVector = Vector{Int}()
    opIndex = 0
    paramCode, opCode = parseOp(testCode, opIndex)
    phase_on = true
    while opCode != 99
        if opCode == 1
            # addition testCode
            applyAddCode(testCode, paramCode, opIndex)
            opIndex += 4
        elseif opCode == 2
            # multiplication testCode
            applyMultCode(testCode, paramCode, opIndex)
            opIndex += 4
        elseif opCode == 3
            # input testCode
            if phase_on
                applyInputCode(testCode, opIndex, phase_input)
                phase_on = false
            else
                applyInputCode(testCode, opIndex, amplifier_input)
            end
            opIndex += 2
        elseif opCode == 4
            # TODO:output testCode
            newOutput = applyOutputCode(testCode, paramCode, opIndex)
            append!(outputVector, newOutput)
            opIndex += 2
        elseif opCode == 5
            # jump-if-true
            opIndex = applyJumpIfTrueCode(testCode, paramCode, opIndex)
        elseif opCode == 6
            # jump-if-false
            opIndex = applyJumpIfFalseCode(testCode, paramCode, opIndex)
        elseif opCode == 7
            # less than
            applyLessThanCode(testCode, paramCode, opIndex)
            opIndex += 4
        elseif opCode == 8
            # equals
            applyEqualsCode(testCode, paramCode, opIndex)
            opIndex += 4
        else
            throw(DomainError(opcode, "opCode not valid"))
        end

        # update paramCode and opCode for next iteration
        paramCode, opCode = parseOp(testCode, opIndex)
    end
    return outputVector
end
