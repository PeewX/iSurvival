function blockChat(message, messageType)
	if messageType == 0 or messageType == 1 then
		cancelEvent()
	end
end
addEventHandler("onPlayerChat", root, blockChat)

addEventHandler("onPlayerPrivateMessage", root, function()
    cancelEvent()
end)

function localChat(message, messageType)	
	if isPlayerInSafetyZone(source) then return end

	if messageType == 0 then
		local posX, posY, posZ = getElementPosition(source)
		local chatSphere = createColSphere(posX, posY, posZ, getSettingValue("chatRadius"))
		local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
		destroyElement(chatSphere)
		
		for i, nearbyPlayer in ipairs(nearbyPlayers) do
			outputChatBox(getPlayerName(source) .. ":#ffffff ".. message, nearbyPlayer, 255, 255, 255, true)
		end
		outputServerLog(string.gsub(getPlayerName(source), "#%x%x%x%x%x%x", "") .. ": ".. message)
	end
end
addEventHandler("onPlayerChat", root, localChat)

function getPlayerFromNamePart(name)
    if name then 
        for i, player in ipairs(getElementsByType("player")) do
            if string.find(string.gsub(getPlayerName(player):lower(), "#%x%x%x%x%x%x", ""), tostring(name):lower(), 1, true) then
                return player 
            end
        end
    end
    return false
end

function onSafetyZoneRadioChat(message, messageType)
	if messageType == 0 then
		if isPlayerInSafetyZone(source) then
			sendAllPlayersInSafetyZones(source, message)
		end
	end
end
addEventHandler("onPlayerChat", root, onSafetyZoneRadioChat)

function sendAllPlayersInSafetyZones(thePlayer, theMessage)
	for element, sfZone in pairs(_safetyZones) do
		local insidePlayers = getElementsWithinColShape(element, "player")
		for i2, insidePlayer in ipairs(insidePlayers) do
			outputChatBox("|Radio| " .. getPlayerName(thePlayer) .. "#ffffff: " .. theMessage, insidePlayer, 255, 200, 0, true)
		end
	end
	outputServerLog("|Radio| " .. string.gsub(getPlayerName(thePlayer):lower(), "#%x%x%x%x%x%x", "") .. ": " .. string.gsub(theMessage, "#%x%x%x%x%x%x", ""))
end

function serverMessage(thePlayer, _, ...)
	if g_Admins[thePlayer] == true then
		for i, player in ipairs(getElementsByType("player")) do
		local text = table.concat({...}, " ")
			outputChatBox("|Admin| " .. getPlayerName(thePlayer) .. ": #D6D6D6" .. text, player, 170, 0, 0, true)
		end
	end
end
addCommandHandler("p", serverMessage)