local vehicleSettings = {}
function getVehicleSettings()
	vehicleSettings = {}
	local sql = mysql_query(cmysql, "SELECT * FROM `vehiclesettings`")
	if sql then
		local vsData = mysql_fetch_assoc(sql)
		while (vsData) do
			local vehID = tonumber(vsData["vehID"])
			vehicleSettings[vehID] = {}
			vehicleSettings[vehID].level = tonumber(vsData["level"])
			vehicleSettings[vehID].consumption = tonumber(vsData["consumption"])
			vsData = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
end
addEventHandler("onResourceStart", resroot, getVehicleSettings)
--[[addCommandHandler("vehSet", getVehicleSettings)]]

function getVehicleLevel(theID)
	if vehicleSettings[theID] then
		return vehicleSettings[theID].level
	else
		outputChatBox("|Warnung| Fahrzeug ID '" .. theID .. "' existiert nicht in der Datenbank (getVehicleLevel)!", root, 255, 0, 0)
	end
end

function getVehicleConsumption(theID)
	if vehicleSettings[theID] then
		return vehicleSettings[theID].consumption
	else
		outputChatBox("|Warnung| Fahrzeug ID '" .. theID .. "' existiert nicht in der Datenbank (getVehicleConsumption)!", root, 255, 0, 0)
	end
end