--iR|HorrorClown (PewX) - iRace-mta.de - 10.09.2013 --
setDevelopmentMode(true)
local globalState = false

function toggle(state)
	if state == true then
		globalState = true
		setElementData(me, "inSafetyZone", true)

		toggleControl("fire", false)
		toggleControl("aim_weapon", false)
		toggleControl("vehicle_fire", false)
		toggleControl("vehicle_secondary_fire", false)
		
		setControlState("fire", false)
		setControlState("aim_weapon", false)
	elseif state == false then
		globalState = false
		setElementData(me, "inSafetyZone", false)

		toggleControl("fire", true)
		toggleControl("aim_weapon", true)
		toggleControl("vehicle_fire", true)
		toggleControl("vehicle_secondary_fire", true)
	end
end
addEvent("toggleSafetyZone", true)
addEventHandler("toggleSafetyZone", me, toggle)

function isPlayerInSafetyZone()
	return globalState
end