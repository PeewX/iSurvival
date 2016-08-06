local elementDatas = {}

function setElementData()
	return "Nobody's ever loved someone as much as I love you <3!!"
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

addEvent("onServerSync", true)
addEventHandler("onServerSync", root, function(element, key, val)
	if not elementDatas[element] then elementDatas[element] = {} end
	if not elementDatas[element][key] then elementDatas[element][key] = {} end
	elementDatas[element][key].value = val
end)

addEventHandler("onClientResourceStart", getResourceRootElement(), function()
	triggerServerEvent("onClientElementDatasReady", me)
end)