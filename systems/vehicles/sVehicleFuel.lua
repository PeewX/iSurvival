--iR|HorrorClown (PewX) - iRace-mta.de - 05.05.2014 --
fuelstations = {}
function initialiseFuelstations()
	local sql = mysql_query(cmysql, "SELECT * FROM `fuel_stations`")
	if sql then
		local sd = mysql_fetch_assoc(sql)
		while sd do
			local stationID = tonumber(sd["stationID"])
			local stationContent = tonumber(sd["content"])
			local stationComment = sd["comment"]
			fuelstations[stationID] = {}
			fuelstations[stationID].object = {}
			fuelstations[stationID].content = stationContent
			fuelstations[stationID].comment = stationComment
			sd = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
		
		local sql = mysql_query(cmysql, "SELECT * FROM `fuel_objects`")
		if sql then
			local fd = mysql_fetch_assoc(sql)
			while fd do
				local stationID = tonumber(fd["stationID"])
				local ID = #fuelstations[stationID].object + 1
				local fO = createObject(1686, fd["x"], fd["y"], fd["z"], fd["xr"], fd["yr"], fd["zr"])
				fuelstations[stationID].object[ID] = fO
				fd = mysql_fetch_assoc(sql)
			end
			mysql_free_result(sql)
		else
			outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		end
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
end
addEventHandler("onResourceStart", resroot, initialiseFuelstations)

function getFuelStation(object)
	for sID, k in ipairs(fuelstations) do
		for i, ob in ipairs(fuelstations[sID].object) do
			if ob == object then
				return sID
			end
		end
	end
	return false
end

local fillTimer = {}
addEventHandler("onElementClicked", root, function(btn, st, pl)
	if btn ~= "left" then return end
	if st == "down" then
		local stationID = getFuelStation(source)
		if stationID then
			local px, py, pz = getElementPosition(pl)
			local sx, sy, sz = getElementPosition(source)
			if getDistanceBetweenPoints3D(px, py, pz, sx, sy, sz) < 2 then
				if not isTimer(fillTimer[pl]) then
					playerFillFuelCan(pl, stationID)
				end
			end
		end
	elseif st == "up" then
		if isTimer(fillTimer[pl]) then 
			killTimer(fillTimer[pl]) 
			setPedAnimation(pl, false)
		end
	end
end)

function playerFillFuelCan(player, stationID)
	if not (tonumber(getElementData(player, "level")) >= 5) then
		outputChatBox("|Shop| #AD0000You must be at least level 5", player, 255, 255, 255, true)
		return
	end
	
	if not (tonumber(getElementData(player, "money")) >= g_FuelPrice*40) then
		outputChatBox("|Shop| #AD0000You need #ffffff" .. g_FuelPrice*40 .. " #AD0000to fill up your patrol can!", player, 255, 255, 255, true)
		return
	end
	
	if getPlayerItemCount(player, "fuel_e") > 0 then
		if getPlayerItemCount(player, "fuel_f") < 2 then
			if fuelstations[stationID].content >= 40 then
				fillTimer[player] = setTimer(filledUp, 10000, 1, player, stationID)
				setPedAnimation(player, "CRIB", "CRIB_Use_Switch", 10000, true, false, false, false)
			else
				outputChatBox("|Fuel| #AD0000This fuelstation doesn't have enough fuel!", player, 255, 255, 255, true)
			end
		else
			outputChatBox("|Fuel| #AD0000You can only have two full patrol cans!", player, 255, 255, 255, true)
		end
	else
		outputChatBox("|Fuel| #AD0000You don't have a empty patrol can! >.<", player, 255, 255, 255, true)
	end
end

function filledUp(player, stationID)
	if isTimer(fillTimer[player]) then killTimer(fillTimer[player]) end
	setPedAnimation(player, false)
	fuelstations[stationID].content = fuelstations[stationID].content - 40
	removePlayerItem(player, "fuel_e", 1)
	addPlayerItem(player, "fuel_f", 1)
	addStats(player, "money", -g_FuelPrice*40)
	outputChatBox("|Fuel| #AD0000Successfully filled up the empty fuel canister", player, 255, 255, 255, true)
end

function calcVehicleFuel(theVehicle)
	if getElementType(theVehicle) == "vehicle" then
		local vData = getVehicleDatas(theVehicle)
		if vData.engine then
			if vData.fuel > 0 then
				local nF = vData.fuel - calcFuelConsumption(theVehicle, vData.consumption)			
				setVehicleFuel(vData.ID, nF)
				setTimer(calcVehicleFuel, 1000, 1, theVehicle)
			else
				setVehicleFuel(vData.ID, 0)
				setVehicleEngine(vData.ID, false)
				local vehOccupant = getVehicleOccupant(theVehicle) if vehOccupant then outputChatBox("Vehicle fuel is empty!", vehOccupant, 255, 100, 0) end
			end
			setElementData(theVehicle, "fuel", vData.fuel) --Only for sync to client ;)
		end
	end	
end

function calcFuelConsumption(theVehicle, cmp)
	local vehSpeed = getVehicleSpeed(theVehicle)
	if vehSpeed then
		if math.floor(vehSpeed) == 0 then vehSpeed = 1 end
		local damage = 1-(getElementHealth(theVehicle)/1000)+1 --Calc damage multiplier
		if not cmp then cmp = 5 end
		return vehSpeed*(cmp/10000)*damage
	end
end