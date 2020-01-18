# https://adventofcode.com/2019/day/3

using DelimitedFiles

input_arr = readdlm("day3\\input.txt", ',', String)

wire1 = input_arr[1, :]

wire2 = input_arr[2, :]

function getWireBoundaries(wire)
    Xmin = 0
    Xmax = 0
    Ymin = 0
    Ymax = 0
    Xnow = 0
    Ynow = 0
    # extract move magnitude
    for instruction in wire
        change_mag = parse(Int, instruction[2:end])
        letter = instruction[1]
        if letter == 'R'
            # positive horizontal shift
            Xnow += change_mag
            if Xmax < Xnow
                Xmax = Xnow
            end
        elseif letter == 'L'
            # negative horizontal shift
            Xnow -= change_mag
            if Xmin > Xnow
                Xmin = Xnow
            end
        elseif letter == 'U'
            # positive vertical shift
            Ynow += change_mag
            if Ymax < Ynow
                Ymax = Ynow
            end
        elseif letter == 'D'
            # negative vertical shift
            Ynow -= change_mag
            if Ymin > Ynow
                Ymin = Ynow
            end
        else
            # error
        end
    end
    return tuple(Xmin, Xmax, Ymin, Ymax)
end

function getBoardBoundaries(wire1, wire2)
    Xmin = min(wire1[1], wire2[1])
    Xmax = max(wire1[2], wire2[2])
    Ymin = min(wire1[3], wire2[3])
    Ymax = max(wire1[4], wire2[4])
    return tuple(Xmin, Xmax, Ymin, Ymax)
end

function getOriginCoor(BoardBoundaries)
    origin_coor = [BoardBoundaries[4] + 1, -BoardBoundaries[1] + 1]
end

function initiateBoard(BoardBoundaries)
    xDim = BoardBoundaries[2] - BoardBoundaries[1] + 1
    yDim = BoardBoundaries[4] - BoardBoundaries[3] + 1
    myBoard = fill(".", (yDim, xDim))
    origin_coor = getOriginCoor(BoardBoundaries)
    myBoard[origin_coor[1], origin_coor[2]] = "o"
    return myBoard
end

function traceWire(
    board::Array{String,2},
    wireInstructions,
    label = "1",
    cross = "x",
)
    thisBoard = copy(board)
    originCoor = findfirst(i -> i == "o", thisBoard)
    originCoor = [originCoor[1], originCoor[2]]
    coor = copy(originCoor)
    for instruction in wireInstructions
        change_mag = parse(Int, instruction[2:end])
        letter = instruction[1]
        axis = 2
        direction_vector = 1
        if letter in ('U', 'D')
            axis = 1
        end
        if letter in ('L', 'U')
            direction_vector = -1
        end
        for i = 1:change_mag
            coor[axis] += direction_vector
            new_value = thisBoard[coor[1], coor[2]]
            if new_value == "."
                thisBoard[coor[1], coor[2]] = label
            elseif new_value != label
                thisBoard[coor[1], coor[2]] = cross
            end
        end
    end
    thisBoard[originCoor[1], originCoor[2]] = "o"
    return thisBoard
end

function getMinCrossD(board, cross = "x")
    # find all indices where crosses exit in the board
    cross_indices = findall(i -> i == "x", board)

    # find distance to origin "o" for all crosses
    origin_index = findall(x -> x == "o", board)

    # return minimum distance
    minimum(getManhattanDistance.(cross_indices, origin_index))
end

function getManhattanDistance(cross_index, origin_index)
    return abs(cross_index[1] - origin_index[1]) +
           abs(cross_index[2] - origin_index[2])
end

#test
getWireBoundaries(["R1"]) == (0, 1, 0, 0)
getBoardBoundaries((-1, 1, 0, 0), (0, 1, -1, 1)) == (-1, 1, -1, 1)
initiateBoard((-1, 1, -1, 1))
getOriginCoor((-1, 1, -1, 1))
traceWire(initiateBoard((-1, 1, -1, 1)),  ["R1"])
traceWire(initiateBoard((-1, 1, -1, 1)),  ["U1"])
traceWire(initiateBoard((-1, 1, -1, 1)),  ["L1"])
traceWire(initiateBoard((-1, 1, -1, 1)),  ["D1"])
traceWire(initiateBoard((-1, 1, -1, 1)),  ["R1", "L1", "D1", "U1"])

traceWire(initiateBoard((-2, 2, -2, 2)),  ["R2"])
traceWire(initiateBoard((-2, 2, -2, 2)),  ["U2"])
traceWire(initiateBoard((-2, 2, -2, 2)),  ["L2"])
traceWire(initiateBoard((-2, 2, -2, 2)),  ["D2"])
traceWire(initiateBoard((-2, 2, -2, 2)),  ["R2", "D2", "L2", "U2"])

# apply
wire1Boundaries = getWireBoundaries(wire1)

wire2Boundaries = getWireBoundaries(wire2)

boardBoundaries = getBoardBoundaries(wire1Boundaries, wire2Boundaries)

originCoor = getOriginCoor(boardBoundaries)

cleanBoard = initiateBoard(boardBoundaries)

trace1 = traceWire(cleanBoard, wire1)

trace2 = traceWire(trace1, wire2, "2")

minCrossD = getMinCrossD(trace2)
