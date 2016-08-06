g_userIDs = {}
local news = {}

function getNewsFromDatabase()
	news = {}
	local sql = mysql_query(cmysql, "SELECT * FROM `news`")
	if sql then
		local nData = mysql_fetch_assoc(sql)
		while (nData) do
			local ID = tonumber(nData["ID"])
			news[ID] = {}
			news[ID].title = nData["title"]
			news[ID].text = nData["text"]
			news[ID].date = nData["date"]
			
			nData = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
end
addEventHandler("onResourceStart", resroot, getNewsFromDatabase)

addEvent("onClientIntroPlay", true)
addEventHandler("onClientIntroPlay", root, function() 
	local playerSettings = {["showIntro"] = true, ["music"] = true}
	local userID = getIDFromSerial(getPlayerSerial(client))
	if userID then
		playerSettings = getPlayerSettings(userID)
	end 
	
	triggerClientEvent("onServerSendInfos", client, news, playerSettings)
 end)

function loginPlayer(username, pw)
	if source ~= client then return end
	local userID = getIDFromName(username)
	if userID then
		local password = md5(pw)
		local b = checkPassword(userID, password)
		if b then
			g_userIDs[client] = userID
			triggerClientEvent("onClientLoginSuccess", client)
			onLogin(client, userID)
		else
			triggerClientEvent("onLoginOrRegisterFailed", client, "Invalid password!")
		end
	else
		triggerClientEvent("onLoginOrRegisterFailed", client, "This username can not be found!")
	end
end
addEvent("onClientPlayerLogin", true)
addEventHandler("onClientPlayerLogin", root, loginPlayer)


function registerPlayer(username, pw1, pw2)
	if source ~= client then return end
	if username ~= "" and pw1 ~= "" and pw2 ~= "" and username ~= nil and pw1 ~= nil and pw2 ~= nil then
		if isNameRegistered(username) then
			triggerClientEvent("onLoginOrRegisterFailed", client, "This username is already registered")
		elseif isSerialRegistered(getPlayerSerial(client)) == true then
			triggerClientEvent("onLoginOrRegisterFailed", client, "Already registered an account with this serial!")
		else
			local password = md5(pw1)
			local serial = getPlayerSerial(client)
			local ip = getPlayerIP(client)
			local name = getPlayerName(client)
			
			local b = _setAccountData(0, "player_accounts", "name,password,serial,ip,lastPlayerName", "'" .. username .. "','".. password .. "','" .. getPlayerSerial(client) .. "','" .. getPlayerIP(client) .. "','" .. getPlayerName(client) .. "'")
			if b then
				local userID = getIDFromName(username)
				g_userIDs[client] = userID
				local b2 = _setAccountData(0, "player_datas", "ID", userID)
				local b3 = _setAccountData(0, "player_weapons", "ID", userID)
				local b4 = _setAccountData(0, "player_inventory", "ID", userID)
				local b5 = _setAccountData(0, "player_skills", "ID", userID)
				local b6 = _setAccountData(0, "player_achievements", "ID", userID)
				local b7 = _setAccountData(0, "player_settings", "ID", userID)
				if b2 and b3 and b4 and b5 and b6 and b7 then
					triggerClientEvent("onClientLoginSuccess", client)
					onLogin(client, userID)
				else
					triggerClientEvent("onLoginOrRegisterFailed", client, "Error while creating your account. Please contact an admin!")
				end
			else
				triggerClientEvent("onLoginOrRegisterFailed", client, "Error while creating your account. Please contact an admin!")
			end
		end
	else
		triggerClientEvent("onLoginOrRegisterFailed", client, "Invalid username or password!")
	end
end
addEvent("onClientRegister", true)
addEventHandler("onClientRegister", root, registerPlayer)