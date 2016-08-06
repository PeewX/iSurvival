local bzPositions = {{-1909.42, 278, 40.046875, 10, 6, 3}}
local zones = {}
addEventHandler("onResourceStart", getResourceRootElement(), function()
	for i, zone in ipairs(bzPositions) do
		local theZone = createColCuboid(unpack(zone))
		zones[theZone] = {}
		zones[theZone].source = theZone
	end
end)

addEventHandler("onColShapeHit", getResourceRootElement(), function(thePlayer)
	if isBurnZone(source) then
		setPedOnFire(thePlayer, true)
		setTimer(function(thePlayer)
			if isPlayerInBurnZone(thePlayer) then
				setPedOnFire(thePlayer, true)
			end
		end, 5000, 1, thePlayer)
	end
end)

function isBurnZone(theZone)
	if not zones[theZone] then return false end
	if zones[theZone].source == theZone then
		return true
	end
end

function isPlayerInBurnZone(thePlayer)
	for element, bZone in pairs(zones) do
		local insidePlayers = getElementsWithinColShape(element, "player")
		for i2, insidePlayer in ipairs(insidePlayers) do
			if insidePlayer == thePlayer then
				return true
			end
		end
	end
	return false
end