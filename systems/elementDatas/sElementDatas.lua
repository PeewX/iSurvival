local elementDatas = {}
local thePlayers = {}
--_setElementData = setElementData
--_getElementData = getElementData


function setElementData(element, key, value, sync)
	assert(isElement(element), "element is not an element")
    assert(type(key) == "string", "key is not an string")
	if value == nil then return false end
	if sync == nil then sync = true end --sync = sync or true

	if not elementDatas[element] then elementDatas[element] = {} end
    if not elementDatas[element][key] then elementDatas[element][key] = {} end
	elementDatas[element][key].value = value
	elementDatas[element][key].sync = sync
    syncToClient(element, key)
	return true
end

function getElementData(element, key)
    if element == nil then return false end
	if key == nil then return false end
    if elementDatas[element] and elementDatas[element][key] then
        return elementDatas[element][key].value
    else
        return false
    end
end

function syncToClient(element, key)
	if elementDatas[element][key].sync then
		local val = elementDatas[element][key].value
		for i, player in ipairs (thePlayers) do triggerClientEvent("onServerSync", player, element, key, val) end
	end
end

function deleteElementDatas(element)
	assert(isElement(element), "element is not an element")
	if elementDatas[element] then
		elementDatas[element] = nil
		return true
	else
		return false
	end
end

addEvent("onClientElementDatasReady", true)
addEventHandler("onClientElementDatasReady", root, function()
	if client ~= source then kickPlayer(client, root, "Security :3") return end
	
	for i, player in ipairs(thePlayers) do
		if player == client then return end
	end

	table.insert(thePlayers, client)
end)

addEventHandler("onPlayerQuit", root, function()
	for i, player in ipairs(thePlayers) do
		if player == source then
			table.remove(thePlayers, i)
		end
	end
end)