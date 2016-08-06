local x, y, z = -4000, -900, -50
local width, depth, height = 3000, 2500, 400
local colShape

function nuclearEffect(player)
	if not isElementWithinColShape(player, colShape) then
		local health = getElementHealth(player)
		setElementHealth(player, health - 1)
		setTimer(nuclearEffect, 500, 1, player)
	else
		triggerClientEvent("onClientEnterSF", player)
	end
end

function createSFZone()
	colShape = createColCuboid(x, y, z, width, depth, height)
	
	addEventHandler("onColShapeLeave", colShape, function(elem)
		if isElement(elem) then
			if getElementType(elem) == "player" then
				if g_userIDs[elem] then
					if not isElementWithinColShape(elem, colShape) then
						triggerClientEvent("onClientLeaveSF", elem)
						setTimer(nuclearEffect, 2000, 1, elem)
					end
				end
			end
		end
	end)
end
addEventHandler("onResourceStart", resroot, createSFZone)

--[[addEventHandler("onResourceStart", getResourceRootElement(), function()
	colShape = createColCuboid(x, y, z, width, depth, height)
	
	addEventHandler("onColShapeLeave", colShape, function(elem)
		if isElement(elem) then
			if getElementType(elem) == "player" then
				if not isElementWithinColShape(elem, colShape) then
					outputChatBox(getPlayerName(elem) .. " leave")
					triggerClientEvent("onClientLeaveSF", elem)
					setTimer(nuclearEffect, 50, 1, elem)
				end
			end
		end
	end)
end)]]

