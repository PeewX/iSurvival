local weaponshop = {
    button = {},
    window = {},
    label = {},
	image = {}
}


local function createGUI()
	rocketlauncher 	= {g_WeaponPrices["RocketLauncher"], g_WeaponLevels["RocketLauncher"], g_WeaponAmmo["RocketLauncher"]}
	minigun 		= {g_WeaponPrices["Minigun"], g_WeaponLevels["Minigun"], g_WeaponAmmo["Minigun"]}
	bombs 			= {g_WeaponPrices["Satchel"], g_WeaponLevels["Satchel"], g_WeaponAmmo["Satchel"]}

	weaponshop.window[1] = guiCreateWindow(639, 304, 569, 284, "Tyler's weapons", false)
	guiWindowSetSizable(weaponshop.window[1], false)
	
	weaponshop.label[1] = guiCreateLabel(74, 27, 427, 32, "Damn motherfucker, don't ask me from who i get this weapons! \n Do only buy this shit..!", false, weaponshop.window[1])
	guiLabelSetHorizontalAlign(weaponshop.label[1], "center", false)
	
	weaponshop.label[2] = guiCreateLabel(10, 44, 549, 15, "____________________________________________________________________________________", false, weaponshop.window[1])
	guiLabelSetColor(weaponshop.label[2], 255, 50, 0)
	
	weaponshop.image["bombs"] = guiCreateStaticImage(10, 69, 128, 128, "images/bombs.png", false, weaponshop.window[1])
	weaponshop.image["rocketlauncher"] = guiCreateStaticImage(222, 69, 128, 128, "images/rocketlauncher.png", false, weaponshop.window[1])
	weaponshop.image["minigun"] = guiCreateStaticImage(432, 69, 128, 128, "images/minigun.png", false, weaponshop.window[1])
	
	weaponshop.button["bombs"] = guiCreateButton(10, 207, 128, 27, "Buy Bombs", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["bombs"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.button["rocketlauncher"] = guiCreateButton(222, 207, 128, 27, "Buy a Rocket Launcher", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["rocketlauncher"], "NormalTextColour", "FFAAAAAA")

	weaponshop.button["minigun"] = guiCreateButton(432, 207, 128, 27, "Buy a Minigun", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["minigun"], "NormalTextColour", "FFAAAAAA")

	weaponshop.button["close"] = guiCreateButton(540, 27, 20, 20, "X", false, weaponshop.window[1])
	guiSetProperty(weaponshop.button["close"], "NormalTextColour", "FFAAAAAA")
	
	weaponshop.label["bombs"] = guiCreateLabel(10, 244, 143, 31, "Price: " ..  bombs[1] .. "$\nLevel: " .. bombs[2], false, weaponshop.window[1])
	weaponshop.label["rocketlauncher"] = guiCreateLabel(222, 244, 143, 31, "Price: " .. rocketlauncher[1] .. "$\nLevel: " .. rocketlauncher[2], false, weaponshop.window[1])	
	weaponshop.label["minigun"] = guiCreateLabel(432, 244, 143, 31, "Price: " .. minigun[1] .. "$\nLevel: " .. minigun[2], false, weaponshop.window[1])
 end

function onWeaponshopClick(button, state)
	if button ~= "left" then return end
	if source == weaponshop.button["close"] then
		destroyElement(weaponshop.window[1])
		showCursor(false, false)
	elseif source == weaponshop.button["bombs"] then
		triggerServerEvent("onClientBuyWeapon", me, 39, bombs)
	elseif source == weaponshop.button["rocketlauncher"] then
		triggerServerEvent("onClientBuyWeapon", me, 35, rocketlauncher)
	elseif source == weaponshop.button["minigun"] then
		triggerServerEvent("onClientBuyWeapon", me, 38, minigun)
	end
end
addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), onWeaponshopClick)
 
local function openWS4Panel()
	if not isElement(weaponshop.window[1]) then
		createGUI()
		showCursor(true, true)
		guiBringToFront(weaponshop.window[1])
	end
end
addEvent("onClientTogglePanel.ws4", true)
addEventHandler("onClientTogglePanel.ws4", root, openWS4Panel)