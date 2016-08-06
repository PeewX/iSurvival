--iR|HorrorClown (PewX) - iRace-mta.de  - 29.05.2014--
local weaponToSkillID = {[22] = 69, [23] = 70, [24] = 71, [25] = 72, [26] = 73, [27] = 74, [28] = 75, [32] = 75, [29] = 76, [30] = 77, [31] = 78, [33] = 79} --28 und 32 = auf selbe skill ID
g_upgradeStats = {}


addEvent("increasePlayerStats", true)
addEventHandler("increasePlayerStats", root, function(statID)
	if not checkClient(client, source, "increasePlayerStats") then return end
	if isUpgradeAvailable(client, statID) then
		local money = getNextUpgradeTable(client, statID).price
		
		if tonumber(getElementData(client, "money")) >= money then
			addStats(client, "money", -money)
			local spT = {upStarted = true, upEndTime = getRealTime().timestamp + 3600, upValue = 0, upMaxValue = getNextUpgradeTable(client, statID).killValue, upType = statID}
			triggerClientEvent(client, "onClientUpgradeInProgress", client, spT)
			g_upgradeStats[client] = spT
		else
			outputChatBox("|Upgrades| #AD0000You need #ffffff" .. money .. "$ #AD0000to increase this weapon!", client, 255, 255, 255, true)
		end
	end
end)

addEvent("onClientUpdateStatsPanel", true)
addEventHandler("onClientUpdateStatsPanel", root, function()
	if not checkClient(client, source, "increasePlayerStats") then return end
	triggerClientEvent(client, "onClientUpgradeInProgress", client, g_upgradeStats[client])
end)

addEvent("onClientBuyLevelUpgrade", true)
addEventHandler("onClientBuyLevelUpgrade", root, function()
	if not checkClient(client, source, "onClientBuyLevelUpgrade") then return end
	local level = getElementData(client, "level")
	local money = calcMoneyForNextLevel(tonumber(level))
	
	if tonumber(getElementData(client, "money")) >= money then
		addStats(client, "money", -money)
		addStats(client, "level", 1)
		outputChatBox("|Upgrades| #AD0000You successfully bought level '" .. level + 1 .. "'", client, 255, 255, 255, true)
	else
		outputChatBox("|Upgrades| #AD0000You don't have enough money to buy level '" .. level + 1 .. "'", client, 255, 255, 255, true)
	end
end)

function skillUpdrading(player, weapon)
	local sID = weaponToSkillID[weapon]
	if g_upgradeStats[player].upType == sID then
		if isUpgradeTimeAvailable(player) then
			g_upgradeStats[player].upValue = g_upgradeStats[player].upValue + 1
		
			if g_upgradeStats[player].upValue < g_upgradeStats[player].upMaxValue then
				local kProg = 100/g_upgradeStats[player].upMaxValue*g_upgradeStats[player].upValue --killProgress
				local sProg = 100-(g_upgradeStats[player].upMaxValue-getPedStat(player, sID))
	
				if math.round(kProg, 2) >= math.round(sProg, 2) then
					local nV = (g_upgradeStats[player].upMaxValue-100) + kProg
					setPedStat(player, sID, nV)
				end
			else
				outputChatBox("|Upgrades| #AD0000You successfully increased your weapon skills!", player, 255, 255, 255, true)
				setPedStat(player, sID, g_upgradeStats[player].upMaxValue)
				resetSkillUpgradeTable(player)
			end
		end
	end
end

function getNextUpgradeTable(player, statID)
	if settings.skills[statID] then
		local ID = math.floor(getPedStat(player, statID)/100) + 1
		if settings.skills[statID][ID] then
			return settings.skills[statID][ID]
		end		
	end
	
	return false
end

function resetSkillUpgradeTable(player)
	local spT = {upStarted = 0, upEndTime = 0, upValue = 0, upMaxValue = 0, upType = 0}
	triggerClientEvent(player, "onClientUpgradeInProgress", player, spT)
	g_upgradeStats[player] = spT
end

function isUpgradeAvailable(player, statID)
	if g_upgradeStats[player] and toboolean(g_upgradeStats[player].upStarted) then
		return false
	end
	
	if settings.skills[statID] then
		local zsl = tonumber(getElementData(player, "zSkillLevel"))
		local uT = getNextUpgradeTable(player, statID)
		if uT and zsl >= uT.level then
			return true
		end
	end
	
	return false
end

function isUpgradeTimeAvailable(player)
	if getRealTime().timestamp < g_upgradeStats[player].upEndTime then
		return  true
	else
		resetSkillUpgradeTable(player)
		return false
	end
end

function isUpgradeInProgress(player)
	if g_upgradeStats[player] and toboolean(g_upgradeStats[player].upStarted) then
		return true
	end
end

function isUpgradeTableAvailable(player)
	if g_upgradeStats[player] then
		return true
	end
end