local peds = {}

function initialisePeds()
	peds = {}
	local sql = mysql_query(cmysql, "SELECT * FROM `system_peds`")
	if sql then
		local pD = mysql_fetch_assoc(sql)
		while pD do
			local ID = #peds+1
			peds[ID] = {}
			peds[ID].ID = ID
			peds[ID].x = tonumber(pD["x"])
			peds[ID].y = tonumber(pD["y"])
			peds[ID].z = tonumber(pD["z"])
			peds[ID].rot = tonumber(pD["rot"])
			peds[ID].skinID = tonumber(pD["skinID"])
			peds[ID].blip = tonumber(pD["blip"])
			peds[ID].usage = pD["pedUsage"]
			
			pD = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputChatBox("Error while get gifts from Database!", root, 255, 0, 0)
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
		stopResource(getThisResource())
	end
	
	for i, ped in ipairs(peds) do
		peds[ped.ID].source = createPed(ped.skinID, ped.x, ped.y, ped.z, ped.rot, true)
		createBlip(ped.x, ped.y, ped.z, ped.blip, 2)
		setElementData(peds[ped.ID].source, "specialPed", true)
	end
end
addEventHandler("onResourceStart", resroot, initialisePeds)

addEventHandler("onElementClicked", root, function(btn, st, pl)
	if btn == "left" and st == "down" then
		for i, ped in ipairs(peds) do
			if ped.source == source then
				local px, py, pz = getElementPosition(pl)
				if getDistanceBetweenPoints3D(px, py, pz, ped.x, ped.y, ped.z) < 3 then
					systemPedClicked(pl, ped.usage)
				end
			end
		end
	end
end)

function systemPedClicked(player, pedUsage)
	triggerClientEvent(player, "onClientTogglePanel." .. pedUsage, player)
end

addEvent("onPlayerLoggedIn")
addEventHandler("onPlayerLoggedIn", root, function(player)
	triggerClientEvent(player, "onServerSendShopPeds", player, peds)
end)

