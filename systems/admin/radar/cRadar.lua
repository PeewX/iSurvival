local playerBlips = {}
function showPlayers()
	for i, player in ipairs(getElementsByType("player")) do
		if player ~= me then
			playerBlips[player] = createBlipAttachedTo(player, 0, 2, 255, 150, 0, 255)
		end
	end
	
	addEventHandler("onClientPlayerJoin", root, function()
		playerBlips[source] = createBlipAttachedTo(source, 0, 2, 255, 150, 0, 255)
	end)
	
	addEventHandler("onClientPlayerQuit", root, function()
		if playerBlips[playerToRemove] then
			destroyElement(playerBlips[playerToRemove])
		end
	end)
end
addEvent("showPlayers", true)
addEventHandler("showPlayers", me, showPlayers)