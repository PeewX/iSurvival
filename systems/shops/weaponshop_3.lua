local weaponshop = {
    button = {},
    window = {},
    label = {},
	image = {}
}

local function createGUI()
	spaz12	= {g_WeaponPrices["Spaz12"], g_WeaponLevels["Spaz12"], g_WeaponAmmo["Spaz12"]}
	m4 		= {g_WeaponPrices["M4"], g_WeaponLevels["M4"], g_WeaponAmmo["M4"]}
	mp5 	= {g_WeaponPrices["Mp5"], g_WeaponLevels["Mp5"], g_WeaponAmmo["Mp5"]}

	weaponshop.window[1] = guiCreateWindow(639, 304, 569, 284, "Amy's weapon shop", false)
	guiWindowSetSizable(weaponshop.window[1], false)
	
	weaponshop.label[1] = guiCreateLabel(74, 27, 427, 32, "Hey, I have stolen weapons from the army base. .\n But this damn fuckers try to kill me. I'm hurt and need money..", false, weaponshop.window[1])
	guiLabelSetHorizontalAlign(weaponshop.label[1], "center", false)
	
	weaponshop.label[2] = guiCreateLabel(10, 44, 549, 15, "____________________________________________________________________________________", false, weaponshop.window[1])
	guiLabelSetColor(weaponshop.label[2], 255, 50, 0)
	
	weaponshop.image["mp5"] = guiCreateStaticImage(10, 69, 128, 128, "images/mp5.png", false, weaponshop.window[1])
	weaponshop.image["spaz12"] = guiCreateStaticImage(222, 69, 128, 128, "images/spaz12.png", false, weaponshop.window[1])
	weaponshop.image["m4"] = guiCreateStaticImage(432, 69, 128, 128, "images/m4.png", false, weaponshop.window[1])
	
	weaponshop.button["mp5"] = guiCreateButton(10, 207, 128, 27, "Buy a MP5", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["mp5"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.button["spaz12"] = guiCreateButton(222, 207, 128, 27, "Buy a SPAZ-12", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["spaz12"], "NormalTextColour", "FFAAAAAA")

	weaponshop.button["m4"] = guiCreateButton(432, 207, 128, 27, "Buy a M4", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["m4"], "NormalTextColour", "FFAAAAAA")

	weaponshop.button["close"] = guiCreateButton(540, 27, 20, 20, "X", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["close"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.label["mp5"] = guiCreateLabel(10, 244, 143, 31, "Price: " ..  mp5[1] .. "$\nLevel: " .. mp5[2], false, weaponshop.window[1])
	weaponshop.label["spaz12"] = guiCreateLabel(222, 244, 143, 31, "Price: " .. spaz12[1] .. "$\nLevel: " .. spaz12[2], false, weaponshop.window[1])	
	weaponshop.label["m4"] = guiCreateLabel(432, 244, 143, 31, "Price: " .. m4[1] .. "$\nLevel: " .. m4[2], false, weaponshop.window[1])
end
 
local function onWeaponshopClick(button, state)
	if button ~= "left" then return end
	if source == weaponshop.button["close"] then
		destroyElement(weaponshop.window[1])
		showCursor(false, false)
	elseif source == weaponshop.button["mp5"] then
		triggerServerEvent("onClientBuyWeapon", me, 29, mp5)
	elseif source == weaponshop.button["spaz12"] then
		triggerServerEvent("onClientBuyWeapon", me, 27, spaz12)
	elseif source == weaponshop.button["m4"] then
		triggerServerEvent("onClientBuyWeapon", me, 31, m4)
	end
end
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onWeaponshopClick)
	
local function openWS3Panel()
	if not isElement(weaponshop.window[1]) then
		createGUI()
		showCursor(true, true)
		guiBringToFront(weaponshop.window[1])
	end
end
addEvent("onClientTogglePanel.ws3", true)
addEventHandler("onClientTogglePanel.ws3", root, openWS3Panel)