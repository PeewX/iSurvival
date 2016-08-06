local weaponshop = {
    button = {},
    window = {},
    label = {},
	image = {}
}

local function createGUI()
	silencedPistol 	= {g_WeaponPrices["SilencedPistol"], g_WeaponLevels["SilencedPistol"], g_WeaponAmmo["SilencedPistol"]}
	katana 			= {g_WeaponPrices["Katana"], g_WeaponLevels["Katana"], g_WeaponAmmo["Katana"]}
	knife 			= {g_WeaponPrices["Knife"], g_WeaponLevels["Knife"], g_WeaponAmmo["Knife"]}

	weaponshop.window[1] = guiCreateWindow(639, 304, 569, 284, "Ben's weapon shop", false)
	guiWindowSetSizable(weaponshop.window[1], false)
	
	weaponshop.label[1] = guiCreateLabel(74, 27, 427, 32, "Yo, I've picked up a few weapons from corpses.\nYou can have some for money.", false, weaponshop.window[1])
	guiLabelSetHorizontalAlign(weaponshop.label[1], "center", false)
	
	weaponshop.label[2] = guiCreateLabel(10, 44, 549, 15, "____________________________________________________________________________________", false, weaponshop.window[1])
	guiLabelSetColor(weaponshop.label[2], 255, 50, 0)
	
	weaponshop.image["silencedPistol"] = guiCreateStaticImage(10, 69, 128, 128, "images/silencedPistol.png", false, weaponshop.window[1])
	weaponshop.image["knife"] = guiCreateStaticImage(222, 69, 128, 128, "images/knife.png", false, weaponshop.window[1])
	weaponshop.image["katana"] = guiCreateStaticImage(432, 69, 128, 128, "images/katana.png", false, weaponshop.window[1])
	
	weaponshop.button["silencedPistol"] = guiCreateButton(10, 207, 128, 27, "Buy silenced pistol", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["silencedPistol"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.button["knife"] = guiCreateButton(222, 207, 128, 27, "Buy a knife", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["knife"], "NormalTextColour", "FFAAAAAA")

	weaponshop.button["katana"] = guiCreateButton(432, 207, 128, 27, "Buy a katana", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["katana"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.button["close"] = guiCreateButton(540, 27, 20, 20, "X", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["close"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.label["silencedPistol"] = guiCreateLabel(10, 244, 143, 31, "Price: " ..  silencedPistol[1] .. "$\nLevel: " .. silencedPistol[2], false, weaponshop.window[1])
	weaponshop.label["knife"] = guiCreateLabel(222, 244, 143, 31, "Price: " .. knife[1] .. "$\nLevel: " .. knife[2], false, weaponshop.window[1])	
	weaponshop.label["katana"] = guiCreateLabel(432, 244, 143, 31, "Price: " .. katana[1] .. "$\nLevel: " .. katana[2], false, weaponshop.window[1])
 end

local function onWeaponshopClick(button, state)
	if button ~= "left" then return end
	if source == weaponshop.button["close"] then
		destroyElement(weaponshop.window[1])
		showCursor(false, false)
	elseif source == weaponshop.button["silencedPistol"] then
		triggerServerEvent("onClientBuyWeapon", me, 23, silencedPistol)
	elseif source == weaponshop.button["knife"] then
		triggerServerEvent("onClientBuyWeapon", me, 4, knife)
	elseif source == weaponshop.button["katana"] then
		triggerServerEvent("onClientBuyWeapon", me, 8, katana)
	end
end
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onWeaponshopClick)
 
local function openWS1Panel()
	if not isElement(weaponshop.window[1]) then
		createGUI()
		showCursor(true, true)
		guiBringToFront(weaponshop.window[1])
	end
end
addEvent("onClientTogglePanel.ws1", true)
addEventHandler("onClientTogglePanel.ws1", root, openWS1Panel)