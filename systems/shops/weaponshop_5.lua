local weaponshop = {
    button = {},
    window = {},
    label = {},
	image = {}
}

local function createGUI()
	tec9	 = {g_WeaponPrices["Tec9"], g_WeaponLevels["Tec9"], g_WeaponAmmo["Tec9"]}
	uzi		 = {g_WeaponPrices["Uzi"], g_WeaponLevels["Uzi"], g_WeaponAmmo["Uzi"]}
	deagle 	 = {g_WeaponPrices["Deagle"], g_WeaponLevels["Deagle"], g_WeaponAmmo["Deagle"]}
	
	weaponshop.window[1] = guiCreateWindow(639, 304, 569, 284, "Mary's weapons", false)
	guiWindowSetSizable(weaponshop.window[1], false)
	
	weaponshop.label[1] = guiCreateLabel(74, 27, 427, 32, "Hey hey, i have some nice weapons. \n Buy what do you want..", false, weaponshop.window[1])
	guiLabelSetHorizontalAlign(weaponshop.label[1], "center", false)
	
	weaponshop.label[2] = guiCreateLabel(10, 44, 549, 15, "____________________________________________________________________________________", false, weaponshop.window[1])
	guiLabelSetColor(weaponshop.label[2], 255, 50, 0)
	
	weaponshop.image["deagle"] = guiCreateStaticImage(10, 69, 128, 128, "images/deagle.png", false, weaponshop.window[1])
	weaponshop.image["tec9"] = guiCreateStaticImage(222, 69, 128, 128, "images/tec9.png", false, weaponshop.window[1])
	weaponshop.image["uzi"] = guiCreateStaticImage(432, 69, 128, 128, "images/uzi.png", false, weaponshop.window[1])
	
	weaponshop.button["deagle"] = guiCreateButton(10, 207, 128, 27, "Buy a Deagle", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["deagle"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.button["tec9"] = guiCreateButton(222, 207, 128, 27, "Buy a Tec9", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["tec9"], "NormalTextColour", "FFAAAAAA")

	weaponshop.button["uzi"] = guiCreateButton(432, 207, 128, 27, "Buy a Uzi", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["uzi"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.button["close"] = guiCreateButton(540, 27, 20, 20, "X", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["close"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.label["deagle"] = guiCreateLabel(10, 244, 143, 31, "Price: " ..  deagle[1] .. "$\nLevel: " .. deagle[2], false, weaponshop.window[1])
	weaponshop.label["tec9"] = guiCreateLabel(222, 244, 143, 31, "Price: " .. tec9[1] .. "$\nLevel: " .. tec9[2], false, weaponshop.window[1])	
	weaponshop.label["uzi"] = guiCreateLabel(432, 244, 143, 31, "Price: " .. uzi[1] .. "$\nLevel: " .. uzi[2], false, weaponshop.window[1])
 end
	
function onWeaponshopClick(button, state)
	if button ~= "left" then return end
	if source == weaponshop.button["close"] then
		destroyElement(weaponshop.window[1])
		showCursor(false, false)
	elseif source == weaponshop.button["deagle"] then
		triggerServerEvent("onClientBuyWeapon", me, 24, deagle)
	elseif source == weaponshop.button["tec9"] then
		triggerServerEvent("onClientBuyWeapon", me, 32, tec9)
	elseif source == weaponshop.button["uzi"] then
		triggerServerEvent("onClientBuyWeapon", me, 28, uzi)
	end
end
	addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onWeaponshopClick)
	
local function openWS5Panel()
	if not isElement(weaponshop.window[1]) then
		createGUI()
		showCursor(true, true)
		guiBringToFront(weaponshop.window[1])
	end
end
addEvent("onClientTogglePanel.ws5", true)
addEventHandler("onClientTogglePanel.ws5", root, openWS5Panel)