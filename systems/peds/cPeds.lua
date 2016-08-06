--iR|HorrorClown (PewX) - iRace-mta.de - 16.05.2014 --
local shopPeds = {}

addEventHandler("onClientPedDamage", root, function()
	for i, ped in ipairs(shopPeds) do
		if ped.source == source then
			cancelEvent()
		end
	end
end)

addEvent("onServerSendShopPeds", true)
addEventHandler("onServerSendShopPeds", root, function(peds)
	shopPeds = peds
end)