local tmpMusicTable = {}
local musicTable = {}

addEventHandler("onResourceStart", getResourceRootElement(), function()
	fetchRemote("http://irace-mta.de/servermusic/iSurvival.php", callBack)
end)

function callBack(jsonString, errno)
	if jsonString == "ERROR" then outputChatBox("ERROR:" .. errno) end
	tmpMusicTable = fromJSON("[" .. jsonString .. "]")
	for i, song in pairs(tmpMusicTable) do
		if (string.find(song, ".mp3") or string.find(song, ".ogg")) then
			table.insert(musicTable, song)
		end
	end
end

addEvent("onClientRequestMusic", true)
addEventHandler("onClientRequestMusic", root, function()
	if client ~= source then kickPlayer(client, root, "Don't try this again!") end
	triggerClientEvent(client, "onServerSendMusicTable", client, musicTable)
end)