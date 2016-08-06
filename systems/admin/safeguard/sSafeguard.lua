--iR|HorrorClown (PewX) - iRace-mta.de - 27.04.2014 --
addEvent("onPlayerCheat", true)
addEventHandler("onPlayerCheat", root, function(cheat)
	kickPlayer(client, root, "You are not allowed to use " .. cheat)
end)

addEvent("checkClientVehicleModel", true)
addEventHandler("checkClientVehicleModel", root, function(cVM)
	if client ~= source then kickPlayer(client, root, "STFU") end
	
	if isPedInVehicle(client) then
		local veh = getPedOccupiedVehicle(client)
		local vehModel = getElementModel(veh)

		if vehModel ~= cVM then
			removePlayerFromVehicle(client)
		end
	end
end)


function checkClient(client, source, event)
	if client ~= source then
		outputDebugString("|Hack| '" .. getPlayerName(client) .. "' triggered Event '" .. event .. "' for player '" .. getPlayerName(source) .. "' [Serial: " .. getPlayerSerial(client) .. " IP: " .. getPlayerIP(client) .. "]")
		return false
	else
		return true
	end
end