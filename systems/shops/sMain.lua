g_WeaponPrices = {}
g_WeaponLevels = {}
g_WeaponAmmo = {}
g_FuelPrice = false
g_PatrolCanPrice = false

function getPricesOnStart()
	local sql = mysql_query(cmysql, "SELECT * FROM `shop`")
	if sql then
		local shopDatas = mysql_fetch_assoc(sql)
		while (shopDatas) do
			if tonumber(shopDatas["ID"]) >= 1 and tonumber(shopDatas["ID"]) <= 20 then
				local randomPrice = math.floor(tonumber(shopDatas["price"])/100*math.random(85, 115))
				
				if getPriceDifference(tonumber(shopDatas["originalPrice"]), tonumber(randomPrice), shopDatas["type"]) >= 40 then
					randomPrice = math.floor(tonumber(shopDatas["originalPrice"])/100*math.random(85, 115))
				end
				
				g_WeaponPrices[shopDatas["type"]] = tostring(randomPrice)
				g_WeaponLevels[shopDatas["type"]] = tostring(shopDatas["level"])
				g_WeaponAmmo[shopDatas["type"]] = tonumber(shopDatas["ammo"])
			elseif tonumber(shopDatas["ID"]) == 21 then
				local randomPrice = math.floor(tonumber(shopDatas["price"])/100*math.random(80, 120))
				
				if getPriceDifference(tonumber(shopDatas["originalPrice"]), tonumber(randomPrice), shopDatas["type"]) >= 80 then
					randomPrice = math.floor(tonumber(shopDatas["originalPrice"])/100*math.random(80, 120))
				end
				
				g_FuelPrice = tonumber(randomPrice)
			elseif tonumber(shopDatas["ID"]) == 22 then
				local randomPrice = math.floor(tonumber(shopDatas["price"])/100*math.random(80, 120))
				
				if getPriceDifference(tonumber(shopDatas["originalPrice"]), tonumber(randomPrice), shopDatas["type"]) >= 80 then
					randomPrice = math.floor(tonumber(shopDatas["originalPrice"])/100*math.random(80, 120))
				end
			
				g_PatrolCanPrice = tonumber(randomPrice)
			end
			shopDatas = mysql_fetch_assoc(sql)
		end
		saveWeaponPrices()
		saveFuelPrice()
		mysql_free_result(sql)
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
end
addEventHandler("onResourceStart", resRoot,  getPricesOnStart)

function saveWeaponPrices()
	for weapon, price in pairs(g_WeaponPrices) do
		local sql = mysql_query(cmysql, "UPDATE shop SET price='" .. tostring(price) .. "' WHERE type='" .. tostring(weapon) .. "'")
		if sql then
			mysql_free_result(sql)
		else
			outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
			return false
		end
	end
end

function saveFuelPrice()
	local sql = mysql_query(cmysql, "UPDATE shop SET price='" .. tostring(g_FuelPrice) .. "' WHERE type='fuel'")
	if sql then
		mysql_free_result(sql)
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		return false
	end
end

function calcNewPrices()
	getPricesOnStart()
	setTimer(function()
		triggerClientEvent("sendShopInformations", root, g_WeaponPrices, g_WeaponLevels, g_WeaponAmmo, g_FuelPrice, g_PatrolCanPrice)
	end, 1000, 1)
end
setTimer(calcNewPrices, 21600000, -1) --Alle 6 Stunden, neue Preise (6h --> 21600000)

function getPriceDifference(originalPrice, currentPrice, name)
	return math.abs(tonumber(100/originalPrice*(originalPrice-currentPrice)))
end

addEvent("onClientBuyWeapon", true)
addEventHandler("onClientBuyWeapon", root, function(weaponID, weaponTable)
		if not checkClient(client, source, "onClientBuyWeapon") then return end
		local playerLevel = tonumber(getElementData(source, "level"))
		if playerLevel >= tonumber(weaponTable[2]) then
			addStats(source, "money", -weaponTable[1])
			giveWeapon(source, weaponID, weaponTable[3])
			outputChatBox("|Shop| #AD0000You bought successfully a " .. getWeaponNameFromID(weaponID) .. "!", source, 255, 255, 255, true)
		else
			outputChatBox("|Shop| #AD0000You must be at least level " .. weaponTable[2], source, 255, 255, 255, true)
		end
end)

addEvent("onClientBuyPatrolCan", true)
addEventHandler("onClientBuyPatrolCan", root, function()
	if not checkClient(client, source, "onClientBuyPatrolCan") then return end
	local playerLevel = tonumber(getElementData(source, "level"))
	if playerLevel >= 5 then
		if not (tonumber(getElementData(source, "money")) >= g_PatrolCanPrice) then
			outputChatBox("|Shop| #AD0000You need #ffffff" .. g_FuelPrice*40 .. " #AD0000to fill up your patrol can!", source, 255, 255, 255, true)
			return
		end
	
		if getPlayerItemCount(source, "fuel_e") < 5 then
			addStats(source, "money", -g_PatrolCanPrice)
			addPlayerItem(source, "fuel_e", 1)
		else
			outputChatBox("|Shop| #AD0000You can only have 5 empty patrol cans!", player, 255, 255, 255, true)
		end
	else
		outputChatBox("|Shop| #AD0000You must be at least level 5", source, 255, 255, 255, true)
	end
end)