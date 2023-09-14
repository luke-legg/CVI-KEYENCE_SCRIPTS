function readformatEvent()

    -- Initialize variables for output and data
    local output = ""
    local UPC = "Not Found"
    local DM = "Not Found"
    local EXP = "Not Found"
    local LOT = "Not Found"

    -- Check if the scanner is in an error state, and print "ERROR" if it is (state #2 = error in the scanner)
    if result() == 2 then
        return "ERROR"
    end

    -- Loop through the read results from the scanner bank
    for i = 1, readCount() do
        -- Check if the result is a UPC symbol (10)
        if readResult(i):symbolType() == 10 then
            UPC = readResult(i):readData()
        -- Check if the result is a DataMatrix symbol (2)
        elseif readResult(i):symbolType() == 2 then
            DM = readResult(i):readData()
        end
    end

    -- Extract the first two characters from the DM data to determine what lens we are dealing with (01, 17, MD, ..)
    local firstTwoChars = mid(DM, 1, 2)

    -- Process based on the first two characters being layout "01"
    if firstTwoChars == "01" then
        print(UPC)
        print(DM)

        -- Parse expiry date and lot number
        EXP = "20" .. mid(DM, 19, 6) .. "000000"
        LOT = mid(DM, 27)

        print(EXP)

        -- Construct the output string
        output = LOT .. "\t" .. UPC .. "\t" .. DM .. "\t" .. EXP .. "\t"

        return output

    -- Process based on the first two characters being layout "17"
    elseif firstTwoChars == "17" then
        print(UPC)
        print(DM)

        -- Parse expiry date and lot number
        EXP = "20" .. mid(DM, 3, 6) .. "000000"
        LOT = mid(DM, 11, 19)

        print(EXP)

        -- Construct the output string
        output = LOT .. "\t" .. UPC .. "\t" .. DM .. "\t" .. EXP .. "\t"

        return output

    -- Process based on the first two characters being layout "MD"
    elseif firstTwoChars == "MD"
        print(UPC)
        print(DM)

        -- Extract the month part from the datamatrix and find the last day of the month
        local month = tonumber(mid(DM, 26, 2))
        local lastDay

        -- Check if month is Febuary
        if month == 2 then
            lastDay = 28
        
        -- Check if month is April, June, September, or November)
        elseif month == 4 or month == 6 or month == 9 or month == 11 then
            lastDay = 30

        -- Check if month is January, March, May, July, August, October, December)
        elseif month == 01 or month == 03 or month == 05 or month == 07 or month == 08 or month == 10 or month == 12 then
            lastDay = 31
        end

        -- Parse expiry date and lot number
        EXP = "20" .. mid(DM, 24, 4) .. tostring(lastDay) .. "000000"
        LOT = mid(DM, 16, 8)

        print(EXP)

        -- Construct the output string
        output = LOT .. "\t" .. UPC .. "\t" .. DM .. "\t" .. EXP .. "\t"

        return output



    else
        -- Print "ERROR" for any unsupported layouts
        return "ERROR"
    end
end
