settings = {
	zombieMoney = {},
	zombiePoints = {},
	zombieRes = {},
	spawn = {},
	items = {},
	skills = {}}

function getDatabaseSettings()
	local sql = mysql_query(cmysql, "SELECT * FROM `settings_main`")
	if sql then
		local settingsData = mysql_fetch_assoc(sql)
		while (settingsData) do
			local cat = settingsData["category"]
			if cat == "money" then
				settings.zombieMoney[settingsData["name"]] = settingsData["value"]
			elseif cat == "points" then
				settings.zombiePoints[settingsData["name"]] = settingsData["value"]
			elseif cat == "zombieRes" then
				settings.zombieRes[settingsData["name"]] = settingsData["value"]
			else
				outputDebugString("Setting '" .. settingsData["name"] .. "' without category!")
			end
			settingsData = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputChatBox("Error while get main settings from database!", root, 255, 0, 0)
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		stopResource(getThisResource())
	end
	
	local sql = mysql_query(cmysql, "SELECT * FROM `settings_items`")
	if sql then
		local settingst = mysql_fetch_assoc(sql)
		while (settingst) do
			settings.items[settingst["name"]] = {}
			settings.items[settingst["name"]].itemName = settingst["itemName"]
			settings.items[settingst["name"]].itemDescription = settingst["itemDescription"]
			settings.items[settingst["name"]].userpanelUse = toboolean(settingst["userpanelUse"])
			settings.items[settingst["name"]].maxItemCount = tonumber(settingst["maxItemCount"])
			settings.items[settingst["name"]].cooldown = tonumber(settingst["cooldown"])
			settingst = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputChatBox("Error while get item settings from database!", root, 255, 0, 0)
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		stopResource(getThisResource())
	end
	
	local sql = mysql_query(cmysql, "SELECT * FROM `settings_spawn`")
	if sql then
		local sData = mysql_fetch_assoc(sql)
		while (sData) do
			settings.spawn[tonumber(sData["ID"])] = {tonumber(sData["posX"]), tonumber(sData["posY"]), tonumber(sData["posZ"]), tonumber(sData["posR"])}
			sData = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputChatBox("Error while get spawn settings from database!", root, 255, 0, 0)
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		stopResource(getThisResource())
	end
	
	local sql = mysql_query(cmysql, "SELECT * FROM `settings_skills`")
	if sql then
		settings.skills[69] = {} settings.skills[70] = {} settings.skills[71] = {} settings.skills[72] = {} settings.skills[73] = {} settings.skills[74] = {} settings.skills[75] = {} settings.skills[76] = {} settings.skills[77] = {} settings.skills[78] = {} settings.skills[79] = {}
			
		local sData = mysql_fetch_assoc(sql)
		while sData do
			local ID, killValue, price = tonumber(sData["ID"]), tonumber(sData["killValue"]), tonumber(sData["price"])
			settings.skills[69][ID] = {level = tonumber(sData["PISTOL"]), killValue = killValue, price = price} 
			settings.skills[70][ID] = {level = tonumber(sData["PISTOL_SILENCED"]), killValue = killValue, price = price}
			settings.skills[71][ID] = {level = tonumber(sData["DESERT_EAGLE"]), killValue = killValue, price = price}
			settings.skills[72][ID] = {level = tonumber(sData["SHOTGUN"]), killValue = killValue, price = price}
			settings.skills[73][ID] = {level = tonumber(sData["SAWNOFF_SHOTGUN"]), killValue = killValue, price = price}
			settings.skills[74][ID] = {level = tonumber(sData["SPAS12_SHOTGUN"]), killValue = killValue, price = price}
			settings.skills[75][ID] = {level = tonumber(sData["MICRO_UZI"]), killValue = killValue, price = price}
			settings.skills[76][ID] = {level = tonumber(sData["MP5"]), killValue = killValue, price = price}
			settings.skills[77][ID] = {level = tonumber(sData["AK47"]), killValue = killValue, price = price}
			settings.skills[78][ID] = {level = tonumber(sData["M4"]), killValue = killValue, price = price}
			settings.skills[79][ID] = {level = tonumber(sData["SNIPERRIFLE"]), killValue = killValue, price = price}
			sData = mysql_fetch_assoc(sql)
		end	
	else
		outputChatBox("Error while get skill settings from database!", root, 255, 0, 0)
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		stopResource(getThisResource())
	end
	
	
	triggerEvent("onServerSettings", resroot)
	initialiseZombieResource()
end
addEventHandler("onResourceStart", resroot, getDatabaseSettings)

function getSettingValue(setting)
	if settings[setting] then
		return tonumber(settings[setting])
	elseif settings.zombieMoney[setting] then
		return tonumber(settings.zombieMoney[setting])
	elseif settings.zombiePoints[setting] then
		return tonumber(settings.zombiePoints[setting])
	elseif settings.zombieRes[setting] then
		return tonumber(settings.zombieRes[setting])
	else return false end
end

function getRandomSpawn()
	local rnd = math.random(1, #settings.spawn)
	return settings.spawn[rnd]
end

function getPlayerSettings(userID)
	local sql = mysql_query(cmysql, "SELECT * FROM `player_settings` WHERE `ID` = '" .. userID .. "'")
	if sql then
		if mysql_num_rows(sql) >= 1 then
			local data = mysql_fetch_assoc(sql)
			mysql_free_result(sql)
			return data
		else
			mysql_free_result(sql)
		end
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
	return false
end