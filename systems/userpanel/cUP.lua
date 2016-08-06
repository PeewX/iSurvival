-- iR|HorrorClown (PewX) -- 18.01.2012 --
-----------------------------------------
settings = {}

addEvent("sendItemInformations", true)
addEventHandler("sendItemInformations", me, function(infoTable)
	settings.items = {}
	settings.items = infoTable
end)

function useItem(item)
	if not isItemCooldown(item.name) then
		if settings.items[item.name].userpanelUse then
			triggerServerEvent("onClientUseItem", me, item)
			setItemCooldown(item.name)
		else
			outputChatBox("So you can't use this item!")
		end
	else
		outputChatBox("Please wait before you can use this item again")
	end
end

local cd = {}
function setItemCooldown(item)
	local cooldown = settings.items[item].cooldown
	if cooldown == 0 then return end
	cd[item] = true
	
	setTimer(function(item)	cd[item] = false end, cooldown*1000, 1, item)
end

function isItemCooldown(item)
	if cd[item] then return true else return false end
end

function setPlayetSetting(theSetting, newState)
	triggerServerEvent("onClientChangeSettings", me, theSetting, newState)
	
	if theSetting == "music" then
		toggleBackgroundMusic(newState)
	end
end