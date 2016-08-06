--iR|HorrorClown (PewX) - iRace-mta.de - 27.04.2014 --
local cheats = {"hovercars", "aircars", "extrabunny", "extrajump"}

local _ = setTimer(function()
	for i, cheat in ipairs(cheats) do
		if isWorldSpecialPropertyEnabled(cheat) then
			triggerServerEvent("onPlayerCheat", me, cheat)
		end
	end

	if isPedInVehicle(me) then
		local veh = getPedOccupiedVehicle(me)
		local vehModel = getElementModel(veh)
		triggerServerEvent("checkClientVehicleModel", me, vehModel)
	end
end, 5000, -1)