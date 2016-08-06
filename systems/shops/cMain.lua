g_WeaponPrices = {}
g_WeaponLevels = {}
g_WeaponAmmo = {}
g_FuelPrice = false
g_PatrolCanPrice = false

addEvent("sendShopInformations", true)
addEventHandler("sendShopInformations", root, function(weapons, levels, ammo, fuel, patrolCan)
	g_WeaponPrices = weapons
	g_WeaponLevels = levels
	g_WeaponAmmo = ammo
	g_FuelPrice = fuel
	g_PatrolCanPrice = patrolCan
end)
