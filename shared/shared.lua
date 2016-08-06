function toboolean(x)
	if x == "true" or x == 1 or x == "1" or x == true then
		return true
	elseif x == "false" or x == 0 or x == "0" or x == false then
		return false
	end
	return false
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if 	type( sEventName ) == 'string' and 	isElement( pElementAttachedTo ) and type( func ) == 'function' 	then
		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			for i, v in ipairs( aAttachedFunctions ) do
				if v == func then
					return true
				end
			end
		end
	end
 
	return false
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getVehicleSpeed(theVehicle)
	if isElement(theVehicle) then
		local x, y, z = getElementVelocity(theVehicle)
		return ((x^2 + y^2 + z^2)^(0.5))* 180
	else
		return false
	end
end

function calcZPointsForNextLevel(level)
	if type(level) == "number" then
		return (level*1.2)^2+(100*level)
	elseif tonumber(level) then
		return (tonumber(level)*1.2)^2+(100*tonumber(level))
	else
		outputDebugString("CalcZPointsForNextLevel Error!", 1)
	end	
end

function calcMoneyForNextLevel(level)
	if type(level) == "number" then
		local level = level + 1
		return level*3.3^2*100 --Keine klammern setzen! o.O
	else
		outputDebugString("calcMoneyForNextLevel Error! Got type: " .. type(level), 1)
	end
end

function convertNumber(number)
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end

function isVehicleEmpty(vehicle)
	if not isElement( vehicle ) or getElementType( vehicle ) ~= "vehicle" then
		return true
	end
 
	local passengers = getVehicleMaxPassengers( vehicle )
	if type( passengers ) == 'number' then
		for seat = 0, passengers do
			if getVehicleOccupant( vehicle, seat ) then
				return false
			end
		end
	end
	return true
end

function secondsToTimeDesc( seconds )
	if seconds then
		local days = 0
		local hours = 0
		local minutes = 0
		local secs = 0
		local theseconds = seconds
		if theseconds >= 60*60*24 then
			days = math.floor(theseconds / (60*60*24))
			theseconds = theseconds - ((60*60*24)*days)
		end
		if theseconds >= 60*60 then
			hours = math.floor(theseconds / (60*60))
			theseconds = theseconds - ((60*60)*hours)
		end
		if theseconds >= 60 then
			minutes = math.floor(theseconds / (60))
			theseconds = theseconds - ((60)*minutes)
		end
		if theseconds >= 1 then
			secs = theseconds
			theseconds = theseconds - theseconds
		end
		local results = {}
		if days > 1 then table.insert(results, days.." days") end
		if days == 1 then table.insert(results, days.." day") end
		if hours > 1 then table.insert(results, hours.." hours") end
		if hours == 1 then table.insert(results, hours.." hour") end
		if minutes > 1 then table.insert(results, minutes.." minutes") end
		if minutes == 1 then table.insert(results, minutes.." minute") end
		if secs > 1 then table.insert(results, secs.." seconds") end
		if secs == 1 then table.insert(results, secs.." second") end
		if seconds == 0 then table.insert(results, "0 seconds") end
		return table.concat(results, ", "):reverse():gsub((", "):reverse(), (" and "):reverse(), 1):reverse()
	end
	return ""
end