local pref = "|Gift|#D080E4 "
local spawnTime = {weekday, hour}
local giftSpawns = {}
local currentGift = {source, x, y, z, clicked = false, shape, delTimer, infoTimer1}

local _getRealTime = getRealTime
local function getRealTime()
	local t = {[0] = 7, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6}
	local l = _getRealTime() l.weekday = t[l.weekday] return l
end

function initialiseGifts()
	local sql = mysql_query(cmysql, "SELECT * FROM `system_gifts`")
	if sql then
		local gD = mysql_fetch_assoc(sql)
		while (gD) do
			local ID = #giftSpawns + 1
			giftSpawns[ID] = {}
			giftSpawns[ID].x = tonumber(gD["x"])
			giftSpawns[ID].y = tonumber(gD["y"])
			giftSpawns[ID].z = tonumber(gD["z"])
			giftSpawns[ID].xr = tonumber(gD["xr"])
			giftSpawns[ID].yr = tonumber(gD["yr"])
			giftSpawns[ID].zr = tonumber(gD["zr"])

			gD = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputChatBox("Error while get gifts from Database!", root, 255, 0, 0)
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		stopResource(getThisResource())
	end
end
addEventHandler("onResourceStart", resroot, initialiseGifts)

function getNextGiftSpawnTime()
	local t = getRealTime()
	local cWd, cH = t.weekday, t.hour	
	local rH = math.random(2, 22)
	
	if cH >= rH then
		if cWd == 7 then cWd = 1 else cWd = cWd + 1 end		
	end
	
	spawnTime.weekday = cWd
	spawnTime.hour = rH
	
	
	if spawnTime.weekday == t.weekday then
		local h = rH - t.hour
		outputChatBox(pref .. "Next gift will fall from heaven in about " .. h .. " hours", root, 255, 255, 255, true)
	else
		if rH > 12 then
			outputChatBox(pref .. "Next gift will spawn next day at " .. rH-12 .. "pm!", root, 255, 255, 255, true)
		else
			outputChatBox(pref .. "Next gift will spawn next day at " .. rH .. "am!", root, 255, 255, 255, true)
		end
	end
end
addEventHandler("onResourceStart", resroot, getNextGiftSpawnTime)

local function isSpawnTime()
	local t = getRealTime()
	if t.weekday == spawnTime.weekday then
		if t.hour >= spawnTime.hour then
			if #getLoggedInPlayers() >= 3 then 
				return true
			else
				outputChatBox(pref .. "There are not enough players to spawn a gift :(", root, 255, 255, 255, true)
				if t.hour == 23 then spawnTime.hour = 2 else spawnTime.hour = spawnTime.hour + 1 end
				if t.weekday == 7 then spawnTime.weekday = 1 else spawnTime.weekday = spawnTime.weekday + 1 end
				return false
			end
		end
	end
end                          

local function checkSpawnTime()
	if not isElement(currentGift.source) then
		if isSpawnTime() then
			spawnGift()
		end
	end
end
setTimer(checkSpawnTime, 300000 , -1) --300000

local function giftSpawnInfo()
	if not isElement(currentGift.source) then
		if not isSpawnTime() then
			local t = getRealTime()
			local cWd, cH = t.weekday, t.hour	
		
			if spawnTime.weekday == t.weekday then
				local h = spawnTime.hour - t.hour
				outputChatBox(pref .. "Next gift will fall from heaven in about " .. h .. " hours", root, 255, 255, 255, true)
			else
				if spawnTime.hour > 12 then
					outputChatBox(pref .. "Next gift will spawn next day at " .. spawnTime.hour-12 .. "pm!", root, 255, 255, 255, true)
				else
					outputChatBox(pref .. "Next gift will spawn next day at " .. spawnTime.hour .. "am!", root, 255, 255, 255, true)
				end
			end
		end
	end
end
setTimer(giftSpawnInfo, 1800000, -1) --1800000

function spawnGift()
	local x, y, z, xr, yr, zr = getRandomGiftSpawn()
	currentGift.source = createObject(1271, x, y, z, xr, yr, zr)
	setElementCollisionsEnabled(currentGift.source, false)
	currentGift.x, currentGift.y, currentGift.z = x, y, z
	
	for i, p in ipairs(getLoggedInPlayers()) do
		triggerClientEvent(p, "rotateGiftItem", p, true, currentGift.source)
	end
	
	currentGift.shape = createColSphere(x, y, z, 0.8)
	currentGift.delTimer = setTimer(removeGift, 3600000, 1)
	currentGift.infoTimer1 = setTimer(giftInfo, 600000, 5)
	
	outputChatBox(pref .. "A wild gift appeared! Catch it if you can!", root, 255, 255, 255, true)
end

function removeGift()
	destroyElement(currentGift.source)
	destroyElement(currentGift.shape)
	currentGift = {source, x, y, z, clicked = false, shape, delTimer, infoTimer1}
	
	outputChatBox(pref .. "The gift committed suicide, because nobody wanted it!", root, 255, 255, 255, true)
	getNextGiftSpawnTime()
end

function giftInfo()
	for i, p in ipairs(getLoggedInPlayers()) do
		local pX, pY, pZ = getElementPosition(p)
		local dis = getDistanceBetweenPoints3D(currentGift.x, currentGift.y, currentGift.z, pX, pY, pZ)
		outputChatBox(pref .. "Your distance to the gift: " .. math.round(dis, 2) .. "m", p, 255, 255, 255, true)
	end
end

--items = {[1] = "random weapon", [2] = "random item", [3] = "random zPoints", [4] = "random money", [5] = "free level up", [6] = "Chainsaw", [7] = "special"}
--specials = {[1] = "Chainsaw", [2] = "random money", [3] = "random zPoints", [4] = "free steam game key"}
local sgk = {[1] = {item = "wd", name = "Watch_Dogs"}, [2] = {item = "csgo", name = "Counter Strik: Global Offensive"}, [3] = {item = "dayz", name  = "DayZ"}, [4] = {item = "gs", name = "Goat simulator"}, [5] = {item = "pd2", name = "Payday 2"}, [6] = {item = "pi", name = "Plague Inc."}, [7] = {item = "rust", name = "Rust"}, [8] = {item = "sb", name = "Starbound"}, [9] = {item = "smb", name = "Super Meat Boy"}, [10] = {item = "ac", name = "Assassin's Creed"}}
function playerOpenGift(player)
	local rnd = math.random(1, 7)
	if rnd ~= 7 then
		if rnd == 1 then
			local weapons = {30, 31, 35, 38, 16, 39}
			local ammo = {[30] = 1000, [31] = 1000, [35] = 50, [38] = 5000, [16] = 20, [39] = 20}
			local wpn = weapons[math.random(1, #weapons)]
			giveWeapon(player, wpn, ammo[wpn], true)
			outputChatBox(pref .. "Congratulations! You get a #ffffff" .. getWeaponNameFromID(wpn) .. " #D080E4from the gift!", player, 255, 255, 255, true)
		elseif rnd == 2 then
			local items = {"fuel_e", "fuel_f", "fireworks", "C4", "medikit", "food"}
			local rndItem = items[math.random(1, #items)]
			outputChatBox(pref .. "Congratulations! You get some #ffffff" .. settings.items[rndItem].itemName .. " #D080E4from the gift!", player, 255, 255, 255, true)
			addPlayerItem(player, rndItem, 10)
		elseif rnd == 3 then
			local p = math.random(100, 1000)
			outputChatBox(pref .. "Congratulations! You get #ffffff" .. p .. " #D080E4zPoints from the gift!", player, 255, 255, 255, true)
			addStats(player, "zPoints", p)
		elseif rnd == 4 then
			local m = math.random(1000, 5000)
			outputChatBox(pref .. "Congratulations! You get #ffffff" .. m .. "$ #D080E4from the gift!", player, 255, 255, 255, true)
			addStats(player, "money", m)
		elseif rnd == 5 then
			outputChatBox(pref .. "Congratulations! You get a free level up!", player, 255, 255, 255, true)
			addStats(player, "level", 1)
		elseif rnd == 6 then
			outputChatBox(pref .. "Congratulations! You get a awesome chainsaw!", player, 255, 255, 255, true)
			giveWeapon(player, 9, 1, true)
		end	
	else
		local rndS = math.random(1, 4)
		if rndS == 1 then
			outputChatBox(pref .. "Congratulations! You get a awesome chainsaw!", player, 255, 255, 255, true)
			giveWeapon(player, 9, 1, true)
		elseif rndS == 2 then
			local m = math.random(10000, 50000)
			outputChatBox(pref .. "Congratulations! You get #ffffff" .. m .. "$ #D080E4from the gift!", player, 255, 255, 255, true)
			addStats(player, "money", m)
		elseif rndS == 3 then
			local p = math.random(1000, 2000)
			outputChatBox(pref .. "Congratulations! You get #ffffff" .. p .. " #D080E4zPoints from the gift!", player, 255, 255, 255, true)
			addStats(player, "zPoints", p)
		elseif rndS == 4 then
			local rndG = math.random(1, 10)
			local won = sgk[rndG]
			triggerClientEvent(player, "onClientShowSpecialWin", player, won.item)
			setTimer(function(pl, tbl)
				outputChatBox("|Gift| " .. getPlayerName(pl) .. " #D080E4 won a free steam game key for #ffffff" .. won.name, root, 255, 255, 255, true)
				local ts = getRealTime().timestamp
				outputDebugString("Player [" .. getPlayerName(pl) .. ", " .. getPlayerSerial(pl) .. ", " .. getPlayerIP(pl) .. "] won: " .. won.name .. "[Code: " .. ts .. "]")
				outputChatBox(pref .. "To get your steam key, contact HorrorClown in Teamspeak (IP: ts.irace-mta.de) or our forum: iRace-mta.de", pl, 255, 255, 255, true)
				outputChatBox(pref .. "Your code: " .. ts .. "(Remember!)", pl, 255, 255, 255, true)
			end, 2000, 1, player, won)
		end
	end
	return true
end

function getRandomGiftSpawn()
	local rnd = math.random(1, #giftSpawns)
	return giftSpawns[rnd].x, giftSpawns[rnd].y, giftSpawns[rnd].z + 0.3, giftSpawns[rnd].xr, giftSpawns[rnd].yr, giftSpawns[rnd].zr
end

addCommandHandler("giftTime", function(pl)
	if isTimer(currentGift.delTimer) then
		local r, _, _ = getTimerDetails(currentGift.delTimer)
		local mText = ""
		if math.floor((r/1000/60)+0.5) <= 1 then mText = " minute!" else mText = " minutes!" end
		outputChatBox(pref .. "The gift will be destroy itself in " .. math.floor((r/1000/60)+0.5) .. mText, pl, 255, 255, 255, true)	
	else
		local t = getRealTime()
		local cWd, cH = t.weekday, t.hour	
	
		if spawnTime.weekday == t.weekday then
			local h = spawnTime.hour - t.hour
			outputChatBox(pref .. "Next gift will fall from heaven in about " .. h .. " hours", pl, 255, 255, 255, true)
		else
			if spawnTime.hour > 12 then
				outputChatBox(pref .. "Next gift will spawn next day at " .. spawnTime.hour-12 .. "pm!", pl, 255, 255, 255, true)
			else
				outputChatBox(pref .. "Next gift will spawn next day at " .. spawnTime.hour .. "am!", pl, 255, 255, 255, true)
			end
		end
	end
end)

addEventHandler("onColShapeHit", root, function(hitElement, mD)
	if source == currentGift.shape and mD then
		if getElementType(hitElement) ~= "player" then return end
		
		if not currentGift.clicked then
			currentGift.clicked = true
			if isTimer(currentGift.delTimer) then killTimer(currentGift.delTimer) end
			outputChatBox(pref .. "YaY! " .. getPlayerName(hitElement) .. "#D080E4 found the gift! :)", root, 255, 255, 255, true)
			destroyElement(currentGift.source)
			destroyElement(currentGift.shape)
			currentGift = {source, x, y, z, clicked = false, shape, delTimer}
			
			addPlayerItem(hitElement, "gifts", 1)
			addStats(hitElement, "foundGifts", 1)
			getNextGiftSpawnTime()
		end	
	end
end)

addEvent("onPlayerLoggedIn")
addEventHandler("onPlayerLoggedIn", resroot, function(thePlayer)
	if currentGift.source then
		outputChatBox(pref .. "A wild gift appeared! Catch it if you can!", thePlayer, 255, 255, 255, true)
		triggerClientEvent(thePlayer, "rotateGiftItem", thePlayer, true, currentGift.source)
	end
end)