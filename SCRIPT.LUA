function readformatEvent()

    --local output = "" --Initialize
    local UPC = "Not Found"
    local DM = "Not Found"
    local EXP = "Not Found"
    local LOT = "Not Found"

    if result()==2 then -- read status as error 
        return ""
    end

    for i = 1 , readCount() do --for do/if then/while do ... (i , incremental end value) 
        if readResult(i):symbolType() == 10 then -- UPC Search
            UPC = readResult(i):readData()
        elseif readResult(i):symbolType() == 2 then -- DM Search
            DM = readResult(i):readData()
        end
    end

    print(UPC)
    print(DM)

    EXP = "20"..mid(DM,19,6).."000000" -- 01001950719114511729043010324198000180010062
    LOT = mid(DM,27)

    print(EXP)

    -- Checks the UPC barcode against a parsed GTIN which contains the UPC
    -- This adds an extra check to make sure the 2D barcode matches with the 1D codes scanned
    local UPCfromGTIN = string.sub(DM,5,12)
    if UPCfromGTIN ~= UPC then
        return ""
    end

    -- This ensures that the expiration date format is correct according to the AJP software
    if string.len(EXP) ~= 14 then  -- Check if the input string has exactly 14 characters
        return ""
    end
    
    -- Parse the EXP and turn them into variable integers
    local year = tonumber(string.sub(EXP, 1, 4))
    local month = tonumber(string.sub(EXP, 5, 6))
    local day = tonumber(string.sub(EXP, 7, 8))
    local hour = tonumber(string.sub(EXP, 9, 10))
    local minute = tonumber(string.sub(EXP, 11, 12))
    local second = tonumber(string.sub(EXP, 13, 14))
    
    -- Checks if the date provided is a valid date
    if year < 0 or month < 1 or month > 12 or day < 1 or day > 31 or hour < 0 or hour > 23 or minute < 0 or minute > 59 or second < 0 or second > 59 then
        return ""
    end
    
    return LOT.."\t"..UPC.."\t"..DM.."\t"..EXP.."\t"
end 




