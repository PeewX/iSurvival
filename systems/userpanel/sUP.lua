-- iR|HorrorClown (PewX) -- 18.01.2012 --
-----------------------------------------
--level Berechnung: ((level+1)*0,5)*1200

function updatePlayerInv(player, userID)
	local sql = mysql_query(cmysql, "SELECT * FROM `player_inventory` WHERE `ID` = " .. userID)
	if sql then
		if mysql_num_rows(sql) >= 1 then
			local data = mysql_fetch_assoc(sql)
			mysql_free_result(sql)
			data["ID"] = nil
			
			inv = {}
			local i = 0
			for item, value in pairs(data) do
				if tonumber(value) ~= 0 then
					i = i + 1
					inv[i] = {}
					inv[i].name = item
					inv[i].value = tonumber(value)
				end
			end
			
			table.sort(inv, comp)
			triggerClientEvent("onClientUpdateInventory", player, inv)
		else
			mysql_free_result(sql)
		end
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
end

function comp(t1, t2)
	if t1.name < t2.name then
		return true
	end
	return false
end

addEvent("onClientUseItem", true)
addEventHandler("onClientUseItem", root, function(theItem)
	if not checkClient(client, source, "onClientUseItem") then return end
	if settings.items[theItem.name].userpanelUse then
		if theItem.value > 0 and getPlayerItemCount(client, theItem.name) > 0 then
			if playerUseItem(client, theItem.name) then
				_setAccountData(g_userIDs[source], "player_inventory", theItem.name, theItem.value-1)
				updatePlayerInv(source, g_userIDs[source])
			end
		end
	end
end)

function addPlayerItem(player, theItem, theValue)
	if player and theItem and theValue then
		local itemCount = getPlayerItemCount(player, theItem)
		if itemCount then
			_setAccountData(g_userIDs[player], "player_inventory", theItem, itemCount+theValue)
			updatePlayerInv(player, g_userIDs[player])
		else
			outputChatBox("Invalid item")
		end	
	end
end

function removePlayerItem(player, theItem, theValue)
	if player and theItem and theValue then
		local itemCount = getPlayerItemCount(player, theItem)
		if itemCount then
			_setAccountData(g_userIDs[player], "player_inventory", theItem, itemCount-math.abs(theValue))
			updatePlayerInv(player, g_userIDs[player])
		else
			outputChatBox("Invalid item")
		end	
	end
end

local dataTable = {"money", "level", "killedZombies", "killed_soldierZombies", "killed_explosiveZombies", "killed_clownZombies", "killed_healthZombies", "killed_bloodyZombies", "killed_darkZombies", "zPoints", "zSkillLevel", "deaths", "playtime", "jointimes"}
addEvent("onServerUpdatePlayerStats", true)
addEventHandler("onServerUpdatePlayerStats", root, function()
	if not checkClient(client, source, "onServerUpdatePlayerStats") then return end
	local cTable = {} -- Cache Table
	for i, data in ipairs(dataTable) do
		cTable[data] = getElementData(client, data)
	end
	triggerClientEvent("onClientUpdatePlayerStats", client, cTable)
end)

addEvent("onServerUpdatePlayerSettings", true)
addEventHandler("onServerUpdatePlayerSettings", root, function()
	if not checkClient(client, source, "onServerUpdatePlayerSettings") then return end
	local plSettings = getPlayerSettings(g_userIDs[client])
	triggerClientEvent("onClientUpdatePlayerSettings", client, plSettings)	
end)

addEvent("onClientChangeSettings", true)
addEventHandler("onClientChangeSettings", root, function(theSetting, newState)
	if not checkClient(client, source, "onClientChangeSettings") then return end
	_setAccountData(g_userIDs[client], "player_settings", theSetting, tostring(newState))	
	
	local plSettings = getPlayerSettings(g_userIDs[client])
	triggerClientEvent("onClientUpdatePlayerSettings", client, plSettings)	
end)

function getPlayerItemCount(player, theItem)
	local pID = g_userIDs[player]
	if pID then
		return tonumber(_getAccountData(pID, "player_inventory", theItem))
	end
	return false
end

function playerUseItem(thePlayer, theItem)
	if theItem == "medikit" then
		setPedAnimation(thePlayer, "MEDIC", "CPR", -1, false, true, false, false)
		setTimer(function(thePlayer)
			setElementHealth(thePlayer, getPedStat(thePlayer, 24))
		end, 3000, 1, thePlayer)
		return true
	elseif theItem == "C4" then
		local x, y, z = getElementPosition(thePlayer)
		if isElementInSafetyZone(x, y, z) then outputChatBox("You can't use C4 in a safety zone!", thePlayer, 255, 0, 0) return end
		if isPedDead(thePlayer) then outputChatBox("You can't use C4 while you are dead!", thePlayer, 255, 0, 0) return end
		
		setPedAnimation(thePlayer, "BOMBER", "BOM_Plant", -1, false, true, false, false)
		setTimer(function(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			createExplosion(x, y, z, 10, thePlayer)
			setElementHealth(thePlayer, 0)
		end, 2500, 1, thePlayer)
		return true
	elseif theItem == "fuel_f" then
		if isPedInVehicle(thePlayer) then
			local veh = getPedOccupiedVehicle(thePlayer)
			local vData = getVehicleDatas(veh)
			
			if not vData.engine then
				local updatedFuel = vData.fuel + 40
				setVehicleFuel(vData.ID, updatedFuel)
				outputChatBox("|Fuel| #AD0000You successfully refilled the car!", thePlayer ,255, 255, 255, true)
				return true
			else
				outputChatBox("|Fuel| #AD0000You can't refill the car while the engine is running!", thePlayer ,255, 255, 255, true)
			end
		else
			outputChatBox("|Fuel| #AD0000You are not in a vehicle!", thePlayer ,255, 255, 255, true)
		end
	elseif theItem == "gifts" then
		local x, y, z = getElementPosition(thePlayer)
		if isElementInSafetyZone(x, y, z) then
			if playerOpenGift(thePlayer) then
				return true
			end
		else
			outputChatBox("|Gift|#D080E4 You can only open a gift in the safety zone!", thePlayer, 255, 255, 255, true)
		end
	else
		outputChatBox("This item is currently not implemented :(", thePlayer, 255, 0, 0)
	end
	return false
end