--[[
Ensure that the UPC is output first into the first textbox
Ensure the full Datamatrix is entered into Second text box
Parse out just the expiration date from the Datamatrix and enter it into the third text box. 
Please do not include the identifier in the data string. The customer also needs us to add 6 zeros (000000) to the end of the expiration date for formatting reasons.
]]--

function readformatEvent()

    local output = "" --Initialize
    local UPC = "Not Found"
    local DM = "Not Found"
    local EXP = "Not Found"
    local LOT = "Not Found"

    if result()==2 then -- read status as error 
        return "ERROR"
    end 

    for i = 1 , readCount() do --for do/if then/while do ... (i , incremental end value) 
        if readResult(i):symbolType() == 10 then -- UPC Search
            UPC = readResult(i):readData()
        elseif readResult(i):symbolType() == 2 then -- DM Search
            DM = readResult(i):readData()
        end 
    end


    local firstTwoChars = string.sub(DM, 1, 2)

    if firstTwoChars == "01" then

        print(UPC)
        print(DM)
    
        EXP = "20"..mid(DM,19,6).."000000" -- 01001950719114511729043010324198000180010062
        LOT = mid(DM,27)
    
        print(EXP)
    
        output = LOT.."\t"..UPC.."\t"..DM.."\t"..EXP.."\t"
    
        return output

    elseif firstTwoChars == "17" then
        
	    print(UPC)
        print(DM)
		
        EXP = "20"..mid(DM,3,6).."000000"
        LOT = mid(DM,11,19)
		
		print(EXP)

        output = LOT.."\t"..UPC.."\t"..DM.."\t"..EXP.."\t"
		
		return output

    else
        return "ERROR"
    end



end 
