local weaponshop = {
    button = {},
    window = {},
    label = {},
	image = {}
}

function createGUI()
	molotov = {g_WeaponPrices["Molotov"], g_WeaponLevels["Molotov"], g_WeaponAmmo["Molotov"]}
	teargas = {g_WeaponPrices["Teargas"], g_WeaponLevels["Teargas"], g_WeaponAmmo["Teargas"]}
	grenade = {g_WeaponPrices["Grenade"], g_WeaponLevels["Grenade"], g_WeaponAmmo["Grenade"]}
		
	weaponshop.window[1] = guiCreateWindow(639, 304, 569, 284, "Sam's weapons", false)
	guiWindowSetSizable(weaponshop.window[1], false)
	
	weaponshop.label[1] = guiCreateLabel(74, 27, 427, 32, "Yeah, i have a lot of projectiles. \n I think, you find something what do you like..", false, weaponshop.window[1])
	guiLabelSetHorizontalAlign(weaponshop.label[1], "center", false)
	
	weaponshop.label[2] = guiCreateLabel(10, 44, 549, 15, "____________________________________________________________________________________", false, weaponshop.window[1])
	guiLabelSetColor(weaponshop.label[2], 255, 50, 0)
	
	weaponshop.image["granade"] = guiCreateStaticImage(10, 69, 128, 128, "images/granade.png", false, weaponshop.window[1])
	weaponshop.image["molotov"] = guiCreateStaticImage(222, 69, 128, 128, "images/molotov.png", false, weaponshop.window[1])
	weaponshop.image["teargas"] = guiCreateStaticImage(432, 69, 128, 128, "images/teargas.png", false, weaponshop.window[1])
	
	weaponshop.button["granade"] = guiCreateButton(10, 207, 128, 27, "Buy a Granade", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["granade"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.button["molotov"] = guiCreateButton(222, 207, 128, 27, "Buy a Molotov", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["molotov"], "NormalTextColour", "FFAAAAAA")

	weaponshop.button["teargas"] = guiCreateButton(432, 207, 128, 27, "Buy a Tear Gas", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["teargas"], "NormalTextColour", "FFAAAAAA")

	weaponshop.button["close"] = guiCreateButton(540, 27, 20, 20, "X", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["close"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.label["granade"] = guiCreateLabel(10, 244, 143, 31, "Price: " ..  grenade[1] .. "$\nLevel: " .. grenade[2], false, weaponshop.window[1])
	weaponshop.label["molotov"] = guiCreateLabel(222, 244, 143, 31, "Price: " .. molotov[1] .. "$\nLevel: " .. molotov[2], false, weaponshop.window[1])	
	weaponshop.label["teargas"] = guiCreateLabel(432, 244, 143, 31, "Price: " .. teargas[1] .. "$\nLevel: " .. teargas[2], false, weaponshop.window[1])
 end

function onWeaponshopClick(button, state)
	if button ~= "left" then return end
	if source == weaponshop.button["close"] then
		destroyElement(weaponshop.window[1])
		showCursor(false, false)
	elseif source == weaponshop.button["granade"] then
		triggerServerEvent("onClientBuyWeapon", me, 16, grenade)
	elseif source == weaponshop.button["molotov"] then
		triggerServerEvent("onClientBuyWeapon", me, 18, molotov)
	elseif source == weaponshop.button["teargas"] then
		triggerServerEvent("onClientBuyWeapon", me, 17, teargas)
	end
end
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onWeaponshopClick)
 
local function openWS6Panel()
	if not isElement(weaponshop.window[1]) then
		createGUI()
		showCursor(true, true)
		guiBringToFront(weaponshop.window[1])
	end
end
addEvent("onClientTogglePanel.ws6", true)
addEventHandler("onClientTogglePanel.ws6", root, openWS6Panel)