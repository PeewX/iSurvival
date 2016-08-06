_safetyZones = {}

function initialiseSafetyZones()
	local sql = mysql_query(cmysql, "SELECT * FROM `settings_safetyzones`")
	if sql then
		local sfRow = mysql_fetch_assoc(sql)
		while (sfRow) do
			local sZone = createColCuboid(sfRow["x"], sfRow["y"], sfRow["z"], sfRow["width"], sfRow["height"], sfRow["depth"])
			_safetyZones[sZone] = {}
			_safetyZones[sZone].ID = sfRow["ID"]
			_safetyZones[sZone].comment = sfRow["comment"]
			_safetyZones[sZone].box = {tonumber(sfRow["x"]), tonumber(sfRow["y"]), tonumber(sfRow["z"]), tonumber(sfRow["width"]), tonumber(sfRow["height"]), tonumber(sfRow["depth"])}
			_safetyZones[sZone].source = sZone
			sfRow = mysql_fetch_assoc(sql)
		end
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
end
addEventHandler("onResourceStart", resroot, initialiseSafetyZones)

function enteringSafetyZones(theElement)
	if isSafetyZone(source) then
		if isPedZombie(theElement) then
			local x, y, z = getElementPosition(theElement)
			triggerClientEvent("onZombieEnterSafetyZone", root, x, y, z)
			destroyElement(theElement)
		elseif getElementType(theElement) == "player" then
			triggerClientEvent("toggleSafetyZone", theElement, true)
		end
	end
end
addEventHandler("onColShapeHit", getResourceRootElement(getThisResource()), enteringSafetyZones)

function leaveSafetyZones(theElement)
	if getElementType(theElement) then
		triggerClientEvent("toggleSafetyZone", theElement, false)
	end
end
addEventHandler("onColShapeLeave", getResourceRootElement(getThisResource()), leaveSafetyZones)

function isSafetyZone(theZone)
	if not _safetyZones[theZone] then return false end
	if _safetyZones[theZone].source == theZone then
		return true
	end
end

function isPlayerInSafetyZone(thePlayer)
	for element, sfZone in pairs(_safetyZones) do
		local insidePlayers = getElementsWithinColShape(element, "player")
		for i2, insidePlayer in ipairs(insidePlayers) do
			if insidePlayer == thePlayer then
				return true
			end
		end
	end
	return false
end

function isElementInSafetyZone(x, y, z)
	for element, sfZone in pairs(_safetyZones) do
		local c = sfZone.box
		if x >= c[1] and x <= (c[1]+c[4]) then
			if y >= c[2] and y <= (c[2]+c[5]) then
				if z >= c[3] and z <= (c[3]+c[6]) then
					return true
				end
			end
		end
	end
	return false
end

--[[addCommandHandler("rebuild", function()
	for element, sfZone in pairs(_safetyZones) do
		destroyElement(element)
	end
	_safetyZones = {}
	initialiseSafetyZones()
end)]]