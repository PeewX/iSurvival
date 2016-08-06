local achievements = {}
playerAchievements, aTypes = {}, {}

function initialiseAchievements()
	local sql = mysql_query(cmysql, "SELECT * FROM `achievements`")
	if sql then
		local aD = mysql_fetch_assoc(sql)
		while aD do
			local name = aD["name"]
			achievements[name] = {}
			achievements[name].typ = aD["type"]
			achievements[name].name = name
			achievements[name].title = aD["title"]
			achievements[name].subTitle = aD["subTitle"]
			achievements[name].points = tonumber(aD["points"])
			achievements[name].state = tonumber(aD["state"])
			achievements[name].value = tonumber(aD["value"])
			aD = mysql_fetch_assoc(sql)
			
			table.insert(aTypes, name)
		end
		mysql_free_result(sql)
	end
	
	getAchievementsByType("zombie")
end
addEventHandler("onResourceStart", resroot, initialiseAchievements)

function getAchievementTitle(name)
	if achievements[name].title then
		return achievements[name].title
	end
end

function getAchievementSubTitle(name)
	if achievements[name].subTitle then
		return achievements[name].subTitle
	end
end

function getAchievementValue(name)
	if achievements[name].value then
		return achievements[name].value
	end
end

function getAchievementPoints(name)
	if achievements[name].points then
		return achievements[name].points
	end
end

function isAchievement(name)
	if achievements[name] then
		return true
	end
	return false
end

function getAchievementsByType(aType)
	local cTable = {}
	for k, v in pairs(achievements) do
		if v.typ == aType then
			table.insert(cTable, k)
		end
	end
	return cTable
end

--Players functions
function loadAchievements(userID, player)
	if createPlayerAchievementTable(player) then
		for i, achiev in ipairs(aTypes) do
			local b = _getAccountData(userID, "player_achievements", achiev)
			playerAchievements[player][achiev] = toboolean(b)
		end
	end
end

function createPlayerAchievementTable(player)
	if isElement(player) then
		if not playerAchievements[player] then
			playerAchievements[player] = {}
			return true
		end
	end
	return false
end

function destroyPlayerAchievementTable(player)
	if isElement(player) then
		playerAchievements[player] = nil
		return true
	end
	return false
end

function hasPlayerAchievement(player, name)
	if isAchievement(name) then
		if playerAchievements[player][name] then
			return true
		end
	end
	return false
end

function checkZombieKillsAchievements(player)
	local kills = getElementData(player, "killedZombies")
	for i, achiev in ipairs(getAchievementsByType("zombie")) do
		if not hasPlayerAchievement(player, achiev) then
			if kills >= getAchievementValue(achiev) then
				playerAchievements[player][achiev] = true
				addStats(player, "zPoints", getAchievementPoints(achiev))
				triggerClientEvent(player, "onClientAchievementNotify", player, getAchievementTitle(achiev), getAchievementSubTitle(achiev), "zombie")
			end
		end
	end
end

function checkDeathAchievements(player)
	local deaths = getElementData(player, "deaths")
	for i, achiev in ipairs(getAchievementsByType("death")) do
		if not hasPlayerAchievement(player, achiev) then
			if deaths >= getAchievementValue(achiev) then
				playerAchievements[player][achiev] = true
				addStats(player, "zPoints", getAchievementPoints(achiev))
				triggerClientEvent(player, "onClientAchievementNotify", player, getAchievementTitle(achiev), getAchievementSubTitle(achiev), "death")
			end
		end	
	end
end

function checkPickupAchievements(player)
	local pickups = getElementData(player, "foundPickups")
	for i, achiev in ipairs(getAchievementsByType("pickup")) do
		if not hasPlayerAchievement(player, achiev) then
			if pickups >= getAchievementValue(achiev) then
				playerAchievements[player][achiev] = true
				addStats(player, "zPoints", getAchievementPoints(achiev))
				triggerClientEvent(player, "onClientAchievementNotify", player, getAchievementTitle(achiev), getAchievementSubTitle(achiev), "pickup")
			end
		end	
	end
end

function checkKillStreakAchievements(player)
	local kStreak = getElementData(player, "killStreak")
	for i, achiev in ipairs(getAchievementsByType("killStreak")) do
		if not hasPlayerAchievement(player, achiev) then
			if kStreak >= getAchievementValue(achiev) then
				playerAchievements[player][achiev] = true
				addStats(player, "zPoints", getAchievementPoints(achiev))
				triggerClientEvent(player, "onClientAchievementNotify", player, getAchievementTitle(achiev), getAchievementSubTitle(achiev), "killStreak")
			end
		end	
	end
end

--DEV--
addCommandHandler("server", function (player, _, a, b, c)
	triggerClientEvent(player, "onClientAchievementNotify", player, a, b, c)
end)