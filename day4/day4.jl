# https://adventofcode.com/2019/day/4

function isValidPW(number)
    # extract digit Array
    digitArray = [parse(Int,i) for i in string(number)]

    val = true
    sameCheck = false
    # loop through array testing for decreasing violation
    for i in 2:length(digitArray)
        leftDigit = digitArray[i-1]
        rightDigit = digitArray[i]
        if rightDigit == leftDigit
            sameCheck = true
        end
        if rightDigit < leftDigit
            val = false
            break
        end
    end

    return val && sameCheck
end

function isValidPW2(number)
    # extract digit Array
    digitArray = [parse(Int,i) for i in string(number)]

    val = true
    digitCount = [0 for i in 1:10]
    # loop through array testing for decreasing violation
    for i in 2:length(digitArray)
        leftDigit = digitArray[i-1]
        rightDigit = digitArray[i]
        if i == 2
            digitCount[leftDigit + 1] += 1 # 1-indexed
        end

        digitCount[rightDigit + 1] += 1

        if rightDigit < leftDigit
            val = false
            break
        end
    end

    return val && (2 in digitCount)
end
inputRange = tuple(130254,678275)

output = sum(isValidPW.(inputRange[1]:inputRange[2]))

output2 = sum(isValidPW2.(inputRange[1]:inputRange[2]))
