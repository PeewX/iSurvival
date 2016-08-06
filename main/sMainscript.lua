local weaponFire = {}
g_Admins = {}
local dataTable = {"money", "moneyEarned", "moneySpent", "level", "killedZombies", "killed_soldierZombies", "killed_explosiveZombies", "killed_clownZombies", "killed_healthZombies", "killed_bloodyZombies", "killed_darkZombies", "zPoints", "zSkillLevel", "deaths", "playtime", "jointimes", "foundGifts", "foundPickups", "killStreak"}
	
function zombieKilled(attacker, weapon, bodypart)
	triggerClientEvent("playZombieKillSound", attacker)
	local zombie = getElementModel(source)
	local zPosX, zPosY, zPosZ = getElementPosition(source)
	local accLevel = getElementData(attacker, "level")--(userID, "player_datas", "level")
	local zSkillLevel = getElementData(attacker, "zSkillLevel")--_getAccountData(userID, "player_datas", "zSkillLevel")
	local money = math.round(calcMoney(zombie, accLevel))
	local zPoints = math.round(calcZPoints(zombie, zSkillLevel))

	onSpecialZombieDropItemOrDoSomething(attacker, zombie, zPosX, zPosY, zPosZ)
	addStatForSpecialZombie(attacker, zombie)

	addStats(attacker, "money", money)
	addStats(attacker, "zPoints", zPoints)
	checkZombieKillsAchievements(attacker)
	
	if isUpgradeInProgress(attacker) then skillUpdrading(attacker, weapon) end
end
addEvent("onZombieWasted")
addEventHandler("onZombieWasted", root, zombieKilled)

function addStatForSpecialZombie(player, zombieID)
	if zombieID == 264 then
		addStats(player, "killed_clownZombies", 1)
	elseif zombieID == 245 then
		addStats(player, "killed_explosiveZombies", 1)
	elseif zombieID == 243 then
		addStats(player, "killed_soldierZombies", 1)
	elseif zombieID == 241 then
		addStats(player, "killed_healthZombies", 1)
	elseif zombieID == 244 then
		addStats(player, "killed_bloodyZombies", 1)
	elseif zombieID == 242 then
		addStats(player, "killed_darkZombies", 1)
	end
	addStats(player, "killedZombies", 1)
end

function calcZPoints(zombieID, level)
	if zombieID and level then
		if zombieID == 264 then
			return ((getSettingValue("clownZombieZPoints")/100)*level)+getSettingValue("clownZombieZPoints")
		elseif zombieID == 245 then
			return ((getSettingValue("explosiveZombieZPoints")/100)*level)+getSettingValue("explosiveZombieZPoints")
		elseif zombieID == 243 then
			return ((getSettingValue("soldierZombieZPoints")/100)*level)+getSettingValue("soldierZombieZPoints")
		elseif zombieID == 241 then
			return ((getSettingValue("healthZombieZPoints")/100)*level)+getSettingValue("healthZombieZPoints")
		elseif zombieID == 244 then
			return ((getSettingValue("bloodyZombieZPoints")/100)*level)+getSettingValue("bloodyZombieZPoints")
		elseif zombieID == 242 then
			return ((getSettingValue("darkZombieZPoints")/100)*level)+getSettingValue("darkZombieZPoints")
		else
			return ((getSettingValue("normalZombieZPoints")/100)*level)+getSettingValue("normalZombieZPoints")
		end
	end
end

function calcMoney(zombieID, level)
	if zombieID and level then
		if zombieID == 264 then
			return ((getSettingValue("clownZombieMoney")/100)*level)+getSettingValue("clownZombieMoney")
		elseif zombieID == 245 then
			return ((getSettingValue("explosiveZombieMoney")/100)*level)+getSettingValue("explosiveZombieMoney")
		elseif zombieID == 243 then
			return ((getSettingValue("soldierZombieMoney")/100)*level)+getSettingValue("soldierZombieMoney")
		elseif zombieID == 241 then
			return ((getSettingValue("healthZombieMoney")/100)*level)+getSettingValue("healthZombieMoney")
		elseif zombieID == 244 then
			return ((getSettingValue("bloodyZombieMoney")/100)*level)+getSettingValue("bloodyZombieMoney")
		elseif zombieID == 242 then
			return ((getSettingValue("darkZombieMoney")/100)*level)+getSettingValue("darkZombieMoney")
		else
			return ((getSettingValue("normalZombieMoney")/100)*level)+getSettingValue("normalZombieMoney")
		end
	end
end

function onSpecialZombieDropItemOrDoSomething(thePlayer, zombie, zPosX, zPosY, zPosZ)
	if zombie == 264 then
		triggerClientEvent("ClientCreateFireworks", root,zPosX, zPosY, zPosZ)
	elseif zombie == 245 then
		local explosion = math.random(1,2)
		if explosion == 1 then
			createExplosion(zPosX, zPosY, zPosZ, 1, thePlayer)
		elseif explosion == 2 then
			createExplosion(zPosX, zPosY, zPosZ, 10, thePlayer)
		end
		
	elseif zombie == 243 then
		local drop = math.random(1, 20)
		if drop == 1 then
			createPickup(zPosX, zPosY, zPosZ, 1, 100, 60000) --Schutzweste
		elseif drop == 2 then
			createPickup(zPosX, zPosY, zPosZ, 2, 31, 60000, 153) --M4
		elseif drop == 3 then
			createPickup(zPosX, zPosY, zPosZ, 2, 29, 60000, 150) --MP5
		elseif drop == 4 then
			createPickup(zPosX, zPosY, zPosZ, 2, 36, 60000, 5) --Heat-Seeking RPG
		elseif drop == 5 then
			createPickup(zPosX, zPosY, zPosZ, 2, 16, 60000, 5) -- Granade
		elseif drop == 6 then
			createPickup(zPosX, zPosY, zPosZ, 2, 27, 60000, 28) -- SPAZ-12
		end
	elseif zombie == 241 then
		local drop = math.random(1,10)
		if drop == 1 then
			createPickup(zPosX, zPosY, zPosZ, 0, 100)
		end
	elseif zombie == 244 then
		--Bloody
	elseif zombie == 242 then
		for i, p in ipairs(getLoggedInPlayers()) do
			triggerClientEvent(p, "onClientCreateDarkness", p, zPosX, zPosY, zPosZ)
		end
	else
		local dropType = math.random(1,2)
		if dropType == 1 then
			local drop = math.random(1,40)
			if drop == 1 then
				createPickup(zPosX, zPosY, zPosZ, 2, 25, 0, 10) --pickup für Shotgun
			elseif drop == 2 then
				createPickup(zPosX, zPosY, zPosZ, 2, 24, 0, 50) --Desert Eagle
			end
		elseif dropType == 2 then
			local drop = math.random(1,10)
			if drop == 1 then
				createPickup(zPosX, zPosY, zPosZ, 2, 8) --Katana
			end
		end
	end
end

function changeWeapon(tP, _, _, pickup, colShape)
	if isElement(pickup) then
		if isElementWithinColShape(tP, colShape) then
			local weapon = getPickupWeapon(pickup)
			local ammo = getPickupAmmo(pickup)
			giveWeapon(tP, weapon, ammo, true)
			destroyElement(pickup)
			unbindKey(tP, "TAB", "down", changeWeapon)
			addStats(tP, "foundPickups", 1)
			checkPickupAchievements(tP)
		end
	end
end

function destroyPickup(tP)
	if getPedOccupiedVehicle(tP) then cancelEvent() return end
	
	local destroyPickup = true
	if getPickupType(source) == 2 then
		local pWpn = getPickupWeapon(source)
		local pWpnS = getSlotFromWeapon(pWpn)
		
		local pedWpn = getPedWeapon(tP, pWpnS)
		
		if pedWpn ~= 0 then
			if pWpn ~= pedWpn then
				cancelEvent()
				destroyPickup = false
				outputChatBox("|Weapon| #E7574APress 'TAB' to change your #ffffff" .. getWeaponNameFromID(pedWpn) .. " #E7574Ato a #ffffff" .. getWeaponNameFromID(pWpn), tP, 255, 255, 255, true)
				
				local x, y, z = getElementPosition(source)
				local col = createColSphere(x, y, z, 1.2)
				bindKey(tP, "TAB", "down", changeWeapon, source, col)
				addEventHandler("onColShapeLeave", col, function(tP)
					if getElementType(tP) == "player" then
						unbindKey(tP, "TAB", "down", changeWeapon)
						destroyElement(source)
					end				
				end)
			end
		end
	end
	
	if destroyPickup then
		setTimer(destroyElement, 100, 1, source)
		addStats(tP, "foundPickups", 1)
		checkPickupAchievements(tP)
	end
end
addEventHandler("onPickupHit", root, destroyPickup)

local function startupMainscript()
	setOcclusionsEnabled(false)
	setTrafficLightState(9)
	setGameType("iSurvival")
	setMapName("iSurvival Map")
	setFPSLimit(80)
	setWeather(9)
	setTime(0, 0)
end
addEventHandler("onResourceStart", resroot, startupMainscript)

function addStats(player, data, value)
	if data and value then
		if value >= 0 then
			local oldValue = getElementData(player, data)--_getAccountData(userID, "player_datas", data)
			if oldValue then
				setElementData(player, data, tonumber(oldValue)+tonumber(value))--_setAccountData(userID, "player_datas", data, tonumber(oldValue) + tonumber(value))
				if data == "zPoints" then
					checkZPoints(player)
				elseif data == "money" then
					setPlayerMoney(player, getElementData(player, "money"))
					addStats(player, "moneyEarned", value)
				end
			end
		else
			local oldValue = getElementData(player, data)--_getAccountData(userID, "player_datas", data)
			if oldValue then
				setElementData(player, data, tonumber(oldValue)-math.abs(tonumber(value)))--_setAccountData(userID, "player_datas", data, tonumber(oldValue) + tonumber(value))
				if data == "money" then
					setPlayerMoney(player, getElementData(player, "money"))
					addStats(player, "moneySpent", math.abs(tonumber(value)))
				end
			end
		end
	end
end

function onLogin(player, userID)
	local validated = _getAccountData(userID, "player_datas", "validated")
	local money, state, playtime = _getAccountData(userID, "player_datas", "money"), _getAccountData(userID, "player_datas", "state"), _getAccountData(userID, "player_datas", "playtime")
	local health, armor = _getAccountData(userID, "player_datas", "playerhealth"), _getAccountData(userID, "player_datas", "playerarmor")
	
	if tonumber(validated) == 0 then
		local posX, posY, posZ, posR = unpack(getRandomSpawn())
		_setAccountData(userID, "player_datas", "validated", "true")
		_setAccountData(userID, "player_datas", "state", "'Survivor'")
		
		for i, data in pairs(dataTable) do
			local d = _setAccountData(userID, "player_datas", data, 0)
		end
		
		spawnPlayer(player, posX, posY, posZ, posR, 137)
		fadeCamera (player, true)
		setCameraTarget(player, player)
		giveWeapon(player, 22, 260, true)
	else
		local posX, posY, posZ, posR, playerskin = _getAccountData(userID, "player_datas", "posX"), _getAccountData(userID, "player_datas", "posY"), _getAccountData(userID, "player_datas", "posZ"), _getAccountData(userID, "player_datas", "posR"), _getAccountData(userID, "player_datas", "playerskin")
		spawnPlayer(player, tonumber(posX), tonumber(posY), tonumber(posZ), tonumber(posR), tonumber(playerskin))
		fadeCamera (player, true)
		setCameraTarget(player, player)
		loadWeapons(userID, player)
		loadSkills(userID, player)
	end
	
	loadAchievements(userID, player)
	loadSkillsInProgress(userID, player)
	
	setPlayerMoney(player, tonumber(money))
	setElementHealth(player, tonumber(health))
	if tonumber(armor) >= 1 then setPedArmor(player, tonumber(armor)) end
	
	setElementData(player, "ID", tostring(userID))
	setElementData(player, "state", state)
	setElementData(player, "Playtime", roundTime(playtime*60))
	
	for i, data in pairs(dataTable) do
		local d = _getAccountData(userID, "player_datas", data)
		setElementData(player, data, d)
	end
	
	addStats(player, "jointimes", 1)
	triggerClientEvent("sendShopInformations", player, g_WeaponPrices, g_WeaponLevels, g_WeaponAmmo, g_FuelPrice, g_PatrolCanPrice)
	triggerClientEvent("sendSkillInformations", player, settings.skills)
	triggerClientEvent("onServerUserpanelReady", player)
	triggerClientEvent("sendItemInformations", player, settings.items)
	triggerClientEvent("onClientStartAmoCounting", player)
	triggerClientEvent("calcServerClientTimestampDiff", root, getRealTime().timestamp)
	
	if state == "Admin" then
		triggerClientEvent("showPlayers", player)
		g_Admins[player] = true
	end
	
	weaponFire[player] = {hitAmoL, usedAmoL, hitAmoD, usedAmoD, hitAmoT, usedAmoT}
	weaponFire[player].hitAmoT = _getAccountData(userID, "player_datas", "hitAmo")
	weaponFire[player].usedAmoT = _getAccountData(userID, "player_datas", "usedAmo")
	weaponFire[player].hitAmoL = 0
	weaponFire[player].usedAmoL = 0
	weaponFire[player].hitAmoD = 0
	weaponFire[player].usedAmoD = 0
	
	updatePlayerInv(player, userID)
	triggerEvent("onPlayerLoggedIn", resroot, player)
end

function onSpawn(posX, posY, posZ)
	if isElementInSafetyZone(posX, posY, posZ) then triggerClientEvent("toggleSafetyZone", source, true) end
	setTimer(function(source)
		triggerClientEvent("showInterfaces", source, true)
		triggerClientEvent("showBottomInterface", source, true)
	end, 3500, 1, source)
end
addEventHandler("onPlayerSpawn", root, onSpawn)

function playtime()
	for i, player in ipairs(getElementsByType("player")) do
		local playtime = getElementData(player, "playtime")
		if playtime then
			addStats(player, "playtime", 1)
			setElementData(player, "Playtime", roundTime(getElementData(player, "playtime")*60))
			if isUpgradeInProgress(player) then isUpgradeTimeAvailable(player) end
		end
	end
end
setTimer(playtime, 60000, 0)

function loadWeapons(userID, player)
	local weapons = {_getAccountData(userID, "player_weapons", "weapon0"), _getAccountData(userID, "player_weapons", "weapon1"), _getAccountData(userID, "player_weapons", "weapon2"), _getAccountData(userID, "player_weapons", "weapon3"), _getAccountData(userID, "player_weapons", "weapon4"), _getAccountData(userID, "player_weapons", "weapon5"), _getAccountData(userID, "player_weapons", "weapon6"), _getAccountData(userID, "player_weapons", "weapon7"), _getAccountData(userID, "player_weapons", "weapon8"), _getAccountData(userID, "player_weapons", "weapon9"), _getAccountData(userID, "player_weapons", "weapon10"), _getAccountData(userID, "player_weapons", "weapon11"), _getAccountData(userID, "player_weapons", "weapon12")}
	local ammo = {_getAccountData(userID, "player_weapons", "ammo2"), _getAccountData(userID, "player_weapons", "ammo3"), _getAccountData(userID, "player_weapons", "ammo4"), _getAccountData(userID, "player_weapons", "ammo5"), _getAccountData(userID, "player_weapons", "ammo6"), _getAccountData(userID, "player_weapons", "ammo7"), _getAccountData(userID, "player_weapons", "ammo8"), _getAccountData(userID, "player_weapons", "ammo9")}
	
	for i, weapon in pairs(weapons) do
		if i >= 2 and i <= 9 then
			giveWeapon(player, weapon, ammo[i-2])
		else
			giveWeapon(player, weapon, 1)
		end
	end
end

function loadSkillsInProgress(userID, player)
	if toboolean(_getAccountData(userID, "player_skills", "upStarted")) then
		local spT = {upStarted = true, upEndTime = tonumber(_getAccountData(userID, "player_skills", "upEndTime")), upValue = tonumber(_getAccountData(userID, "player_skills", "upValue")), upMaxValue = tonumber(_getAccountData(userID, "player_skills", "upMaxValue")), upType = tonumber(_getAccountData(userID, "player_skills", "upType"))}
		triggerClientEvent(player, "onClientUpgradeInProgress", player, spT)
		g_upgradeStats[player] = spT
	end
end

local sID = {["MAX_HEALTH"] = 24, ["STAMINA"] = 22, ["PISTOL"] = 69, ["PISTOL_SILENCED"] = 70, ["DESERT_EAGLE"] = 71, ["SHOTGUN"] = 72, ["SAWNOFF_SHOTGUN"] = 73, ["SPAS12_SHOTGUN"] = 74, ["MICRO_UZI"] = 75, ["MP5"] = 76, ["AK47"] = 77, ["M4"] = 78, ["SNIPERRIFLE"] = 79}
function loadSkills(userID, player)
	for stat, id in pairs(sID) do
		local value = _getAccountData(userID, "player_skills", stat)
		setPedStat(player, id, value)
	end
end

function getPlayerLevel(thePlayer)
	if getElementType(thePlayer) == "player" then
		return tonumber(getElementData(thePlayer, "level"))
	end
end

function getDatabaseTime()
	local time = getRealTime()
	local timestamp = tostring(time.year+1900) .. "-" .. tostring(time.month+1) .. "-" .. tostring(time.monthday) .. " " .. tostring(time.hour) .. ":" .. tostring(time.minute) .. ":" .. tostring(time.second)
	return timestamp
end

function savePlayerDatas(source)
	if not g_userIDs[source] then return false end
		
	local posX, posY, posZ = getElementPosition(source)
	
	_setAccountData(g_userIDs[source], "player_datas", "ID", g_userIDs[source])
	_setAccountData(g_userIDs[source], "player_datas", "posX", posX)
	_setAccountData(g_userIDs[source], "player_datas", "posY", posY)
	_setAccountData(g_userIDs[source], "player_datas", "posZ", posZ)
	_setAccountData(g_userIDs[source], "player_datas", "posR", getPedRotation(source))
	_setAccountData(g_userIDs[source], "player_datas", "playerskin", tonumber(getElementModel(source)))
	_setAccountData(g_userIDs[source], "player_datas", "playerhealth", tonumber(getElementHealth(source)))
	_setAccountData(g_userIDs[source], "player_datas", "playerarmor", tonumber(getPedArmor(source)))
	_setAccountData(g_userIDs[source], "player_datas", "money", tonumber(getPlayerMoney(source)))
	_setAccountData(g_userIDs[source], "player_datas", "usedAmo", weaponFire[source].usedAmoT)
	_setAccountData(g_userIDs[source], "player_datas", "hitAmo", weaponFire[source].hitAmoT)

	_setAccountData(g_userIDs[source], "player_accounts", "lastPlayerName", "'" .. getPlayerName(source) .. "'")
	_setAccountData(g_userIDs[source], "player_accounts", "lastTimePlayed", "'" .. getDatabaseTime() .. "'")
	
	for i, data in ipairs(dataTable) do
		_setAccountData(g_userIDs[source], "player_datas", data, getElementData(source, data))
	end
	
	for i = 0, 12 do
		_setAccountData(g_userIDs[source], "player_weapons", "weapon" .. tostring(i) , getPedWeapon(source, i))
		if i >= 2 and i <=9 then
			_setAccountData(g_userIDs[source], "player_weapons", "ammo" .. i, getPedTotalAmmo(source, i))
		end
	end
	
	for i, achiev in ipairs(aTypes) do
		if hasPlayerAchievement(source, achiev) then
			_setAccountData(g_userIDs[source], "player_achievements", achiev, 1)
		end
	end
		
	if isUpgradeTableAvailable(source) then
		for k, v in pairs(g_upgradeStats[source]) do
			_setAccountData(g_userIDs[source], "player_skills", k, v)
		end
	end
	
	for stat, id in pairs(sID) do
		_setAccountData(g_userIDs[source], "player_skills", stat, getPedStat(source, id))
	end
	
	destroyPlayerAchievementTable(source)
	deleteElementDatas(source)
	g_userIDs[source] = nil
	weaponFire[source] = nil
end

addEventHandler("onPlayerQuit", root, function()
	savePlayerDatas(source)
end)

addEventHandler("onResourceStop", resroot, function()
	for i, player in ipairs(getElementsByType("player")) do
		savePlayerDatas(player)
	end
end)

function checkZPoints(thePlayer)
	if thePlayer then
		local zSkillLevel = getElementData(thePlayer, "zSkillLevel")
		local zPointsForNextLevel = calcZPointsForNextLevel(zSkillLevel)
		local zPoints = getElementData(thePlayer, "zPoints")
		if zPoints == zPointsForNextLevel then
			addStats(thePlayer, "zSkillLevel", 1)
			setElementData(thePlayer, "zPoints", 0)
		elseif zPoints > zPointsForNextLevel then
			addStats(thePlayer, "zSkillLevel", 1)
			setElementData(thePlayer, "zPoints", zPoints-zPointsForNextLevel)
		end
	end
end

function roundTime(value)
	if value then
		local time = getRealTime(value)
		local yearday = time.yearday
		local hours = time.hour
		local minutes = time.minute
		return hours-1+(yearday*24)..":"..minutes
	end
	return false
end

local antiDoubleKill = {} 
function onWasted()
	local thePlayer = source
	--local theAccount = getPlayerAccount(thePlayer)
	if not isTimer(antiDoubleKill[thePlayer]) then
		antiDoubleKill[thePlayer] = setTimer(function(thePlayer) antiDoubleKill[thePlayer] = nil end, 2000, 1, thePlayer) 
		triggerClientEvent("showInterfaces", thePlayer, false)
		triggerClientEvent("showBottomInterface", thePlayer, false)
		addStats(thePlayer, "deaths", 1)
		local posX, posY, posZ, posR = unpack(getRandomSpawn())
		_setAccountData(g_userIDs[thePlayer], "player_datas", "posX", posX)
		_setAccountData(g_userIDs[thePlayer], "player_datas", "posY", posY)
		_setAccountData(g_userIDs[thePlayer], "player_datas", "posZ", posZ)
		_setAccountData(g_userIDs[thePlayer], "player_datas", "playerhealth", 100)
		
		weaponFire[thePlayer].hitAmoD = 0
		weaponFire[thePlayer].usedAmoD = 0
		
		checkDeathAchievements(thePlayer)
		dropWeaponsOnDeath(thePlayer)
		setTimer(function(posX, posY, posZ, posR)
			if isElement(thePlayer) then
				local playerskin = _getAccountData(g_userIDs[thePlayer], "player_datas", "playerskin")
				spawnPlayer(thePlayer, posX, posY, posZ, posR, tonumber(playerskin))
				giveWeapon(thePlayer, 22, 260, true)
				setElementModel(thePlayer, tonumber(_getAccountData(g_userIDs[thePlayer], "player_datas", "playerskin")))
			end
		end, 10000, 1, posX, posY, posZ, posR)
		
		outputDebugString(getPlayerName(thePlayer) .. " is died!")
	end
end
addEventHandler("onPlayerWasted", root, onWasted)

function dropWeaponsOnDeath(thePlayer)
	function getRandomWeaponPos(diff)
		if not diff then return false end
		local e, ee, eee = math.random(-diff, diff), math.random(0, 9), math.random(0, 9)
		local total = tonumber(e .. "." .. ee .. eee)
		return total
	end
	
	local posX, posY, posZ = getElementPosition(thePlayer)
	for i = 0, 12 do
		local weapon = getPedWeapon(source, i)
		if i >= 2 and i <= 9 then
			local weaponAmmo = getPedTotalAmmo(source, i)
			if weaponAmmo > 0 then
				createPickup(posX + getRandomWeaponPos(1),posY + getRandomWeaponPos(1), posZ, 2, weapon, 60000, weaponAmmo)
			end
		else
			createPickup(posX + getRandomWeaponPos(1),posY + getRandomWeaponPos(1), posZ, 2, weapon, 60000, 1)
		end
	end
end

function addWeaponFire(player, data)
	if data == "usedAmo" then
		weaponFire[player].usedAmoT = weaponFire[player].usedAmoT + 1
		weaponFire[player].usedAmoL = weaponFire[player].usedAmoL + 1
		weaponFire[player].usedAmoD = weaponFire[player].usedAmoD + 1
	elseif data == "hitAmo" then
		weaponFire[player].hitAmoT = weaponFire[player].hitAmoT + 1
		weaponFire[player].hitAmoL = weaponFire[player].hitAmoL + 1
		weaponFire[player].hitAmoD = weaponFire[player].hitAmoD + 1
	end
end

addEvent("onPlayerWeaponFire", true)
addEventHandler("onPlayerWeaponFire", root, function(weapon, hitElement)
	local hit = 0
	if isElement(hitElement) then
		if isPedZombie(hitElement) then
			if getElementHealth(hitElement) > 0 then
				hit = 1
			end
		end
	end
	
	addWeaponFire(client, "usedAmo")
	if hit == 1 then addWeaponFire(client, "hitAmo") end
end)

addEvent("updateClientKillStreak", true)
addEventHandler("updateClientKillStreak", root, function(killStreak)
	if not checkClient(client, source, "updateClientKillStreak") then return end
	
	local current = getElementData(client, "killStreak")
	if killStreak > tonumber(current) then
		outputChatBox("|Streak| #F8D26CYou got a new kill streak (" .. killStreak .. ")!", client, 255, 255, 255, true)
		setElementData(client, "killStreak", killStreak)
		checkKillStreakAchievements(client)
	end	
end)

function getLoggedInPlayers()
	local lPl = {}
	for i, p in ipairs(getElementsByType"player") do
		if g_userIDs[p] then
			table.insert(lPl, p)
		end
	end
	return lPl
end

local gmxTimer
addCommandHandler("gmx", function(pl, _, tL)
	if g_Admins[pl] then
		local tMs = tonumber(tL)*60*1000
		
		if tMs then
			outputChatBox("|Update| #AA0000You will be kicked from the server in " .. tL .. " minutes!", root, 255, 255, 255, true)
			
			gmxTimer = setTimer(function(rsn)
				for i, player in ipairs(getElementsByType"player") do
					kickPlayer(player, root, "Update! (Changelog: iRace-mta.de)")
				end
			end, tMs, 1, reason)
			
			setTimer(function() 
				local r, _, _ = getTimerDetails(gmxTimer)
				local mText = ""
				if math.floor((r/1000/60)+0.5) <= 1 then mText = " minute!" else mText = " minutes!" end
				outputChatBox("|Update| #AA0000You will be kicked from the server in " .. math.floor((r/1000/60)+0.5) .. mText, root, 255, 255, 255, true)			
			end, 60000, -1)
		else
			outputChatBox("Invalid length!", pl, 255, 0, 0)
		end		
	end
end)

addCommandHandler("gm", function(pl)
	if g_Admins[pl] then
		if not getPlayerZombieProof(pl) then
			setPlayerZombieProof(pl, true)
			outputChatBox("|GM| You are now zombie proof", pl, 255, 255, 255, true)	
		else
			setPlayerZombieProof(pl, false)
			outputChatBox("|GM| You are not longer zombie proof", pl, 255, 255, 255, true)	
		end	
	end
end)