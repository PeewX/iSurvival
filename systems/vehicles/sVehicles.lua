--[[
States:
 - quest   --> Nicht bewegbar, nicht nutzbar (außer: User muss Quest mit diesem machen)
 - movable --> Bewegbar, nicht nutzbar
 - freezed --> Nicht bewegbar, nicht nutzbar
 - normal  --> Wird random betankt, nutzbar
 - empty   --> Leerer Tank, nutzbar
 - destroyed --> Fahrzeug zerstört, nicht nutzbar
 ]]
 
function createVehicles()
	vehicles = {}
	local sql = mysql_query(cmysql, "SELECT * FROM `vehicles`")
	if sql then
		local vData = mysql_fetch_assoc(sql)
		while (vData) do
			local ID = #vehicles + 1
			local theVehicle = createVehicle(vData["vehID"], vData["x"], vData["y"], vData["z"], vData["rx"], vData["ry"], vData["rz"], vData["numberplate"])
			vehicles[ID] = {}
			vehicles[ID].ID = ID
			vehicles[ID].source = theVehicle
			vehicles[ID].state = vData["state"]
			vehicles[ID].level = getVehicleLevel(getVehicleID(theVehicle))
			vehicles[ID].consumption = getVehicleConsumption(getVehicleID(theVehicle))
			vehicles[ID].engine = false
			
			local state = vData["state"]
			if state == "freezed" or state == "quest" then
				setElementFrozen(theVehicle, true)
				setVehicleDamageProof(theVehicle, true)
			elseif state == "normal" or state == "empty" then
				toggleVehicleRespawn(theVehicle, true)
				setVehicleRespawnDelay(theVehicle, 60000)
				setVehicleIdleRespawnDelay(theVehicle, 600000)
				setVehicleEngineState(theVehicle, false)
				setVehicleOverrideLights(theVehicle, 1)
				if state == "normal" then
					math.randomseed(getRealTime().timestamp + 1970)
					vehicles[ID].fuel = math.random(0, 100)
				elseif state == "empty" then
					vehicles[ID].fuel = 0
				end
			elseif state == "movable" then
				setVehicleDamageProof(theVehicle, true)
			elseif state == "destroyed" then
				setElementFrozen(theVehicle, true)
				blowVehicle(theVehicle, false)
			end
			vData = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
	triggerEvent("onServerCreatedVehicles", getResourceRootElement())
end
addEventHandler("onResourceStart", resroot, createVehicles)

function isMyVehicle(theVehicle)
	for i, vehicle in ipairs(vehicles) do
		if vehicle.source == theVehicle then
			return true
		end
	end
	return false
end

function getVehicleDatas(theVehicle)
	for i, vehicle in ipairs(vehicles) do
		if vehicle.source == theVehicle then
			return vehicle
		end
	end
	return false
end

function setVehicleFuel(vehID, fuel)
	if vehID and fuel then
		vehicles[vehID].fuel = fuel
	end
end

function setVehicleEngine(vehID, state)
	if vehID then
		vehicles[vehID].engine = state
		setVehicleEngineState(vehicles[vehID].source, state)
	end
end

function toggleLights(thePlayer, _, _, theVehicle)
	if getVehicleOverrideLights(theVehicle) == 1 then setVehicleOverrideLights(theVehicle, 2) else setVehicleOverrideLights(theVehicle, 1)	end
end

vehTurnTimer, vehTurnVar = {}, {}
esTimer = {}
function engineStart(thePlayer, _, keyState, theVehicle)
	local vData = getVehicleDatas(theVehicle)
	if not vData.engine then
		if keyState == "down" then
			vehTurnTimer[theVehicle] = setTimer(vehicleTurn, 100, -1, theVehicle)
			
			if vData.fuel <= 0 then
				outputChatBox("Vehicle fuel is empty!", thePlayer, 255, 100, 0)
				stopVehicleTurnAnimation(theVehicle)
				do return end
			end

			local rnd, startIn = math.random(1,4), math.random(200, 2000)
			if rnd ~= 1 then rnd = true else rnd = false end
			esTimer[thePlayer] = setTimer(function(thePlayer, theVehicle, rnd)
				if rnd then
					setVehicleEngine(vData.ID, true)
					started = true
					calcVehicleFuel(theVehicle)
					stopVehicleTurnAnimation(theVehicle)
				else
					outputChatBox("Damn, try it again!", thePlayer, 255, 100, 0)
					stopVehicleTurnAnimation(theVehicle)
				end
			end, startIn, 1, thePlayer, theVehicle, rnd)
		elseif keyState == "up" then
			if isTimer(esTimer[thePlayer]) then killTimer(esTimer[thePlayer]) end
			stopVehicleTurnAnimation(theVehicle)
		end
	else
		if keyState == "down" then
			setVehicleEngine(vData.ID, false)
			setElementData(theVehicle, "fuel", 0) --Only for snyc to clients
			stopVehicleTurnAnimation(theVehicle)
		end
	end
end

function stopVehicleTurnAnimation(theVehicle)
	if isTimer(vehTurnTimer[theVehicle]) then killTimer(vehTurnTimer[theVehicle]) end
end

function vehicleTurn(theVehicle)
	if vehTurnVar[theVehicle] == 1 then
		setVehicleTurnVelocity(theVehicle, 0.01, 0.01, 0)
		vehTurnVar[theVehicle] = 0
	else
		setVehicleTurnVelocity(theVehicle, -0.01, -0.01, 0)
		vehTurnVar[theVehicle] = 1
	end
end

---Enter/Exit---
addEventHandler("onVehicleStartEnter", root, function(thePlayer, seat, jacked)
	if isMyVehicle(source) then
		local vData = getVehicleDatas(source)
		if vData.state == "freezed" or vData.state == "movable" then
			outputChatBox("Damn, the vehicle engine is too damaged!", thePlayer, 255, 100, 0)
			cancelEvent()
		elseif vData.state == "quest" then
			outputChatBox("That is an quest car. Currently you can't drive with him!", thePlayer, 255, 100, 0)
			outputChatBox("You must unlock the quest '*QuestSystem not implemented yet*'", thePlayer, 255, 100, 0)
			cancelEvent()
		elseif seat == 0 then
			if jacked then
				cancelEvent()
			elseif getPlayerLevel(thePlayer) < vData.level then
				outputChatBox("You need level " .. vData.level .. " to drive this car!", thePlayer, 255, 100, 0)
				cancelEvent()
			end
		end
	end
end)

local vTimer =  {}
addEventHandler("onVehicleExit", root, function(thePlayer, seat)
	if isMyVehicle(source) then
		if isVehicleEmpty(source) then
			--vTimer[source] = setTimer(respawnVehicle, 600000, 1, source)
		end

		if seat == 0 then
			unbindKey(thePlayer, "x", "both", engineStart)
			unbindKey(thePlayer, "l", "down", toggleLights)
		end
	end
end)

addEventHandler("onVehicleEnter", root, function(thePlayer, seat)
	if isMyVehicle(source) then
		if isTimer(vTimer[source]) then killTimer(vTimer[source]) end
		
		if seat == 0 then
			if not getVehicleDatas(source).engine then setVehicleEngineState(source, false) else setVehicleEngineState(source, true) end
			bindKey(thePlayer, "x", "both", engineStart, source)
			bindKey(thePlayer, "l", "down", toggleLights, source)
		end
	else
		destroyElement(source)
	end
end)

addEventHandler("onVehicleRespawn", getResourceRootElement(), function()
	if isTimer(vTimer[source]) then killTimer(vTimer[source]) end
	stopVehicleTurnAnimation(source)
	
	local vData = getVehicleDatas(source)
	setElementData(source, "fuel", 0) --Only for snyc to clients
	if vData.state == "normal" then
		math.randomseed(getRealTime().timestamp + 1970)
		vehicles[vData.ID].fuel = math.random(0, 100)
	end
	setVehicleEngine(vData.ID, false)
	fixVehicle(source)
end)