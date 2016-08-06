local host = "localhost"
local user = "root"
local password = ""
local database = "isurvival_main"

addEventHandler("onResourceStart", resroot,
	function()
		cmysql = mysql_connect(host, user, password, database)
		if cmysql then
			outputDebugString("Connected to MySQL Server")
		else
			outputDebugString("Failed to connect")
			outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
			stopResource(getThisResource())
		end
	end
)

function checkMySQLConnection()
  if (mysql_ping(cmysql) == false) then
    outputServerLog("Lost connection to the MySQL server, reconnecting..")
    mysql_close(cmysql)
    cmysql = mysql_connect(host, user, password, database)
  end
end
addEventHandler("onPlayerJoin", root, checkMySQLConnection)


function getIDFromName(username)
	local username = mysql_escape_string(cmysql, username)
	local sql = mysql_query(cmysql, "SELECT `ID` FROM `player_accounts` WHERE `name` = '" .. username .. "'")
	if sql then
		if mysql_num_rows(sql) >= 1 then
			local data = mysql_fetch_assoc(sql)
			mysql_free_result(sql)
			return data["ID"]
		else
			mysql_free_result(sql)
		end
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
	return false
end


function getIDFromSerial(serial)
	local serial = mysql_escape_string(cmysql, serial)
	local sql = mysql_query(cmysql, "SELECT `ID` FROM `player_accounts` WHERE `serial` = '" .. serial .. "'")
	if sql then
		if mysql_num_rows(sql) >= 1 then
			local data = mysql_fetch_assoc(sql)
			mysql_free_result(sql)
			return tonumber(data["ID"])
		else
			mysql_free_result(sql)
		end
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
	return false
end

function getNameFromID(id)
	local id = mysql_escape_string(cmysql, id)
	local sql = mysql_query(cmysql, "SELECT `name` FROM `player_accounts` WHERE `ID` = '" .. id .. "'")
	if sql then
		if mysql_num_rows(sql) >= 1 then
			local data = mysql_fetch_assoc(sql)
			mysql_free_result(sql)
			return data["name"], data["lastPlayerName"]
		else
			mysql_free_result(sql)
		end
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
	return false
end

function _setAccountData(userID, theTable, theData, theValue)
	if not (userID and theTable and theData and theValue) then return end
	--theValue = mysql_escape_string(cmysql, theValue)
	if userID == 0 then
		local sql2 = mysql_query(cmysql, "INSERT INTO `" .. theTable .. "` (" .. theData .. ") VALUES (" .. tostring(theValue) .. ")")
		if sql2 then
			return true
		else
			outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		end
	else
		--outputChatBox("UPDATE `" .. theTable .. "` SET `" .. theData .. "` = " .. theValue .. " WHERE `ID` = " .. userID)
		local sql = mysql_query(cmysql, "UPDATE `" .. theTable .. "` SET `" .. theData .. "` = " .. tostring(theValue) .. " WHERE `ID` = " .. userID)
		if sql then
			mysql_free_result(sql)
			return true
		else
			outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		end
	end
	return false
end

function _getAccountData(userID, theTable, theData)
	local sql = mysql_query(cmysql, "SELECT " .. theData .." FROM `" .. theTable .. "` WHERE `ID` = " .. userID) --Column = spalte; condition = Bedingung
	if sql then
		if mysql_num_rows(sql) >= 1 then
			local data = mysql_fetch_assoc(sql)
			mysql_free_result(sql)
			return data[theData]
		else
			mysql_free_result(sql)
			return false
		end
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		return false
	end
end

function isSerialRegistered(serial)
	local sql = mysql_query(cmysql, "SELECT * FROM player_accounts WHERE serial = '" .. serial .. "'")
	if sql then
		if mysql_num_rows(sql) >= 1 then
			mysql_free_result(sql)
			return true
		else
			return false
		end
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
end

function isNameRegistered(username)
	username = mysql_escape_string(cmysql, username)
	local sql = mysql_query(cmysql, "SELECT * FROM player_accounts WHERE name = '" .. username .. "'")
	if sql then
		if mysql_num_rows(sql) >= 1 then
			mysql_free_result(sql)
			return true
		else
			return false
		end
	end
end

function checkPassword(userID, password)
	if userID and password then
		local passwordDB = _getAccountData(userID, "player_accounts", "password")
		if password == passwordDB then
			return true
		end
	else
		return false
	end
end