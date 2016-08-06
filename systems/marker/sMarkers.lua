local markers = {}

function initialiseMarkers()
	local sql = mysql_query(cmysql, "SELECT * FROM `settings_marker`")
	if sql then
		local mD = mysql_fetch_assoc(sql)
		while mD do
			local ID = #markers + 1
			markers[ID] = {}
			markers[ID].source = createMarker(mD["x"], mD["y"], mD["z"], "corona", 1, 60, 210, 235)
			markers[ID].tox = tonumber(mD["tox"])
			markers[ID].toy = tonumber(mD["toy"])
			markers[ID].toz = tonumber(mD["toz"])
			markers[ID].rot = tonumber(mD["rotation"])
			markers[ID].dimension = tonumber(mD["dimension"])
			markers[ID].interior = tonumber(mD["interior"])
			mD = mysql_fetch_assoc(sql)
		end
		mysql_free_result(sql)
	else
		outputDebugString("Mysql Error (" .. mysql_errno(cmysql) .. "):" .. mysql_error(cmysql), 1)
	end
end
addEventHandler("onResourceStart", resroot, initialiseMarkers)

function getMarkerID(m)
	for i, mT in ipairs(markers) do
		if mT.source == m then
			return i
		end
	end
end

addEventHandler("onMarkerHit", root, function(hE, mD)
	if not mD then return end
	
	if getElementType(hE) == "player" then
		if isPlayerInVehicle(hE) then return end
		
		local ID = getMarkerID(source)
		if ID then
			local x, y, z = markers[ID].tox, markers[ID].toy, markers[ID].toz
			local rot, dim, int = markers[ID].rot, markers[ID].dimension, markers[ID].interior
			setElementPosition(hE, x, y, z)
			setElementRotation(hE, 0, 0, rot)
			setElementDimension(hE, dim)
			setElementInterior(hE, int)
		end
	end
end)