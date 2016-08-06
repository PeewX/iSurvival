local weaponshop = {
    button = {},
    window = {},
    label = {},
	image = {}
}

local function createGUI()
	sawnoff 		= {g_WeaponPrices["SO_Shotgun"], g_WeaponLevels["SO_Shotgun"], g_WeaponAmmo["SO_Shotgun"]}
	ak47 			= {g_WeaponPrices["AK47"], g_WeaponLevels["AK47"], g_WeaponAmmo["AK47"]}
	countrySniper 	= {g_WeaponPrices["CountryRifle"], g_WeaponLevels["CountryRifle"], g_WeaponAmmo["CountryRifle"]}
	
	weaponshop.window[1] = guiCreateWindow(639, 304, 569, 284, "Mike's weapon shop", false)
	guiWindowSetSizable(weaponshop.window[1], false)
	
	weaponshop.label[1] = guiCreateLabel(74, 27, 427, 32, "Yea, I'm too old to kill zombies. So you can get my weapon.\n I know, the weapons are old, but they do their job.", false, weaponshop.window[1])
	guiLabelSetHorizontalAlign(weaponshop.label[1], "center", false)
	
	weaponshop.label[2] = guiCreateLabel(10, 44, 549, 15, "____________________________________________________________________________________", false, weaponshop.window[1])
	guiLabelSetColor(weaponshop.label[2], 255, 50, 0)
	
	weaponshop.image["countrySniper"] = guiCreateStaticImage(10, 69, 128, 128, "images/countrySniper.png", false, weaponshop.window[1])
	weaponshop.image["sawnoff"] = guiCreateStaticImage(222, 69, 128, 128, "images/sawnoff.png", false, weaponshop.window[1])
	weaponshop.image["ak47"] = guiCreateStaticImage(432, 69, 128, 128, "images/ak47.png", false, weaponshop.window[1])
	
	weaponshop.button["countrySniper"] = guiCreateButton(10, 207, 128, 27, "Buy country Sniper", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["countrySniper"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.button["sawnoff"] = guiCreateButton(222, 207, 128, 27, "Buy a sawn-off Shotgun", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["sawnoff"], "NormalTextColour", "FFAAAAAA")

	weaponshop.button["ak47"] = guiCreateButton(432, 207, 128, 27, "Buy a AK47", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["ak47"], "NormalTextColour", "FFAAAAAA")

	weaponshop.button["close"] = guiCreateButton(540, 27, 20, 20, "X", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["close"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.label["countrySniper"] = guiCreateLabel(10, 244, 143, 31, "Price: " ..  countrySniper[1] .. "$\nLevel: " .. countrySniper[2], false, weaponshop.window[1])
	weaponshop.label["sawnoff"] = guiCreateLabel(222, 244, 143, 31, "Price: " .. sawnoff[1] .. "$\nLevel: " .. sawnoff[2], false, weaponshop.window[1])	
	weaponshop.label["ak47"] = guiCreateLabel(432, 244, 143, 31, "Price: " .. ak47[1] .. "$\nLevel: " .. ak47[2], false, weaponshop.window[1])
 end

local function onWeaponshopClick(button, state)
	if button ~= "left" then return end
	if source == weaponshop.button["close"] then
		destroyElement(weaponshop.window[1])
		showCursor(false, false)
	elseif source == weaponshop.button["countrySniper"] then
		triggerServerEvent("onClientBuyWeapon", me, 33, countrySniper)
	elseif source == weaponshop.button["sawnoff"] then
		triggerServerEvent("onClientBuyWeapon", me, 26, sawnoff)
	elseif source == weaponshop.button["ak47"] then
		triggerServerEvent("onClientBuyWeapon", me, 30, ak47)
	end
end
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onWeaponshopClick) 
 
local function openWS2Panel()
	if not isElement(weaponshop.window[1]) then
		createGUI()
		showCursor(true, true)
		guiBringToFront(weaponshop.window[1])
	end
end
addEvent("onClientTogglePanel.ws2", true)
addEventHandler("onClientTogglePanel.ws2", root, openWS2Panel)