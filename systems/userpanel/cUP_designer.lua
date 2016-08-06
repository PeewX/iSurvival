-- iR|HorrorClown (PewX) -- 11.01.2012 --
-----------------------------------------
local pW, pH = 750, 60
local x1, y1 = (x/2)-(pW/2), (y/2)-(pH/2)
local x2, y2 = x1, y1 + 20
local x3, y3 = x2, y2 + 40
local fade, draw, al, pOut = false, false, 0, false, 0
local subPanels = {"Inventory", "Stats", "Top Players", "Achievements", "Diaries", "Settings"}
local selBox = {x = 0, y = y2, selected = 0, hovered = 0, si = 0, subAl = 0}
local subW = pW/#subPanels
local mouse = {diffX, diffY, down = false, moving = false}

local inventory, statsDatas, settingsTab = {}, {}, {cuMusic = "n/A", plSettings}

local function dxDrawDoubleLine(lx, ly, lwidth)
	ly = math.floor(ly)
	dxDrawLine(lx, ly, lx+lwidth, ly, tocolor(20, 20, 20, 255/100*al), 1)
	dxDrawLine(lx, ly+1, lx+lwidth, ly+1, tocolor(100, 100, 100, 255/100*al), 1)
end

local function dxDrawSettingsButton(x, y, enabled)
	if enabled then
		dxDrawImage(x, y, 83, 28, "files/images/gui/switch_on.png")
	else
		dxDrawImage(x, y, 83, 28, "files/images/gui/switch_off.png")
	end
end

function renderUserpanel()
	if draw then
		if fade then
			if al < 200 then al = al + 10 end
		elseif not fade then
			if al > 0 then al = al - 10 else draw = false end
		end
		
		if mouse.moving then
			local cx, cy = getCursorPosition()
			x1, y1 = cx*x - mouse.diffX, cy*y -mouse.diffY
			x2, y2 = x1, y1 + 20
			x3, y3 = x2, y2 + 40
			selBox.x, selBox.y = x1 + (subW*(selBox.selected-1)), y2
		end
		
		dxDrawRectangle(x1, y1, pW, pH, tocolor(40, 40, 40, al))
		dxDrawRectangle(x1, y1, pW, 20, tocolor(200, 0, 0, al))
		
		--dxDrawRectangle(selBox.x, selBox.y, subW, selBox.si, tocolor(200, 0, 0, al))
		dxDrawText("iSurvival - Userpanel", x1, y1, x1+pW, y2, tocolor(255, 255, 255, al), 1, iFont[11], "center", "center")
		dxDrawImage(selBox.x, selBox.y, subW, selBox.si, "files/images/gui/userpanel_tab.png", 0, 0, 0, tocolor(200, 0, 0, al))
		dxDrawDoubleLine(x1, y2, pW)
		
		for i, subPanel in ipairs(subPanels) do
			if isHover(x1 + (subW*(i-1)), y2, subW, 40) then
				if selBox.hovered ~= i then selBox.hovered = i playSound("files/sounds/hover.mp3", false) end
				dxDrawRectangle(x1 + (subW*(i-1)), y2, subW, 2, tocolor(255, 90, 0, al))
			else if i == selBox.hovered then selBox.hovered = -1 end end
			dxDrawText(subPanel, x1 + (subW*(i-1)), y2, x1 + subW*i, y3, tocolor(255, 255, 255, al), 1, iFont[12], "center", "center")
		end
		dxDrawDoubleLine(x1, y3, pW)
		
		if pOut then
			if "Inventory" == subPanels[selBox.selected] then
				if #inventory ~= 0 then
					--Item list
					for i, item in ipairs(inventory) do
						local x, y = x1 + 15, y3 + 15 + (45*(i-1))
						if y < y1 + pH then
							dxDrawImage(x, y, 300, 40, "files/images/gui/userpanel_tab.png", 0, 0, 0, tocolor(200, 0, 0, 235/100*selBox.subAl))
							dxDrawText(settings.items[item.name].itemName, x, y, x + 300, y + 40, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[11], "center", "center")
							if isHover(x, y, 300, 40) then
								dxDrawRectangle(x, y, 1, 40, tocolor(255, 80, 0, 200/100*selBox.subAl))
								dxDrawRectangle(x + 300-1, y, 1, 40, tocolor(255, 80, 0, 200/100*selBox.subAl))
								local x4, y4 = x + 300 + 10, y + 10
								dxDrawImage(x4, y4, 30, 20, "files/images/gui/item.png", 0, 0, 0, tocolor(255, 255, 255, 255/100*selBox.subAl))
								dxDrawText(item.value, x4, y4, x4 + 30, y4 + 20, tocolor(0, 0, 0, 255/100*selBox.subAl), 1, iFont[11], "center", "center")
								dxDrawText(settings.items[item.name].itemDescription, x4 + 40, y3 + 15, x1 + (pW - 10), y1 + (pH - 10), tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[11], "left", "top", true, true)
								local imagePath = "files/images/items/" .. item.name .. ".png"
								if not fileExists(imagePath) then imagePath = "files/images/items/nopic.png" end
								dxDrawImage((x4 + 40) + 64, (y3 + 60) +64, 128,128, imagePath, 0, 0, 0, tocolor(255, 255, 255, 255/100*selBox.subAl))
								if click then click = false useItem(item) end
							end
						end
					end
				else
					dxDrawText("You don't have any items :(", x1 + 15, y3 + 15, x, y, tocolor(255, 255, 255, al), 1, iFont[14])
				end
			elseif "Stats" == subPanels[selBox.selected] then
				local xs, ys, ya = x3 + 15, y3 + 15, 20																					dxDrawText("More stats will be added soon", xs + 400, ys + ya*0, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("Total zombie kills", xs, ys + ya*0, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])		dxDrawText(getElementData(me, "killedZombies"), xs + 250, ys + ya*0, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("Deaths", xs, ys + ya*1, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])					dxDrawText(getElementData(me, "deaths"), xs + 250, ys + ya*1, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("Level", xs, ys + ya*2, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])					dxDrawText(getElementData(me, "level"), xs + 250, ys + ya*2, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("Money", xs, ys + ya*3, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])					dxDrawText(getElementData(me, "money"), xs + 250, ys + ya*3, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				
				xs, ys = xs, ys + 110
				dxDrawText("Killed clown zombies", xs, ys + ya*0, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])		dxDrawText(getElementData(me, "killed_clownZombies"), xs + 250, ys + ya*0, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("Killed soldier zombies", xs, ys + ya*1, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])	dxDrawText(getElementData(me, "killed_soldierZombies"), xs + 250, ys + ya*1, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("Killed explosive zombies", xs, ys + ya*2, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])	dxDrawText(getElementData(me, "killed_explosiveZombies"), xs + 250, ys + ya*2, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("Killed health zombies", xs, ys + ya*3, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])	dxDrawText(getElementData(me, "killed_healthZombies"), xs + 250, ys + ya*3, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("Killed bloody zombies", xs, ys + ya*4, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])	dxDrawText(getElementData(me, "killed_bloodyZombies"), xs + 250, ys + ya*4, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("Killed dark zombies", xs, ys + ya*5, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])		dxDrawText(getElementData(me, "killed_darkZombies"), xs + 250, ys + ya*5, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])

				xs, ys = xs, ys + 145
				dxDrawText("zPoints", xs, ys + ya*0, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])					dxDrawText(getElementData(me, "zPoints"), xs + 250, ys + ya*0, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("zSkillLevel", xs, ys + ya*1, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])				dxDrawText(getElementData(me, "zSkillLevel"), xs + 250, ys + ya*1, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
				dxDrawText("zPoints for next Level", xs, ys + ya*2, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])	dxDrawText(calcZPointsForNextLevel(getElementData(me, "zSkillLevel"))-getElementData(me, "zPoints"), xs + 250, ys + ya*2, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[12])
			elseif "Achievements" == subPanels[selBox.selected] then
				dxDrawText("Achievements are not available yet :(", x1 + 15, y3 + 15, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[14])
			elseif "Diarys" == subPanels[selBox.selected] then
				dxDrawText("This awesome feature is currently not available :(", x1 + 15, y3 + 15, x, y, tocolor(255, 255, 255, selBox.subAl), 1, iFont[14])
			elseif "Top Players" == subPanels[selBox.selected] then
				dxDrawText("Coming soon", x1 + 15, y3 + 15, x, y, tocolor(255, 255, 255, selBox.subAl), 1, iFont[14])
			elseif "Settings" == subPanels[selBox.selected] then
				local xs, ys, ya = x3 + 15, y3 + 15, 35
				for sName, sValue in pairs(settingsTab.plSettings) do
					if sName == "music" then
						dxDrawText("Background music", xs, ys + ya*0, x, ys + ya*0 + 28, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[14], "left", "center")
						dxDrawSettingsButton(xs + 250, ys + ya*0, toboolean(sValue))
						if isHover(xs + 250, ys + ya*0, 83, 28) then
							if click then click = false setPlayetSetting(sName, not toboolean(sValue)) end
						end
					elseif sName == "showIntro" then
						dxDrawText("Show intro on login", xs, ys + ya*1, x, ys + ya*1 + 28, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[14], "left", "center")
						dxDrawSettingsButton(xs + 250, ys + ya*1, toboolean(sValue))
						if isHover(xs + 250, ys + ya*1, 83, 28) then
							if click then click = false setPlayetSetting(sName, not toboolean(sValue)) end
						end
					end
				end
				dxDrawText("Background music: " .. settingsTab.cuMusic, xs, ys + ya*8, x, y, tocolor(255, 255, 255, 255/100*selBox.subAl), 1, iFont[14])
			end
		end
	end
end

function onClick(btn, btnSt)
	if btnSt == "down" and btn == "left" then click = true else click = false end
	if isHover(x1, y1, pW, 20) and btn == "left" and btnSt == "down" and isCursorShowing() then
		local cx, cy = getCursorPosition()
		mouse.diffX, mouse.diffY = cx*x-(x1), cy*y-(y1)
		mouse.moving = true
	else
		mouse.moving = false
	end
	
	if btn == "left" and btnSt == "down" then
		if isHover(x1 + (subW*(selBox.hovered-1)), y2, subW, 40) then panelMoveInOut() selBoxInOut() end
	end
end
addEventHandler("onClientClick", root, onClick)

function selBoxInOut()
	local function render()
		local progress = (getTickCount()-selBox.siST)/(selBox.siET-selBox.siST)
		selBox.si, _, _ = interpolateBetween(selBox.siSP, 0, 0, selBox.siEP, 0, 0, progress, "OutBack")
	end
	if pOut then selBox.siEP = 40 elseif not pOut then selBox.siEP = 0 end
	selBox.siSP = selBox.si
	selBox.siST = getTickCount()
	selBox.siET = selBox.siST + 600
	addEventHandler("onClientPreRender", root, render)
end

function selectionMove(selected, hovered)
	if selected == 0 then selBox.x = x1 + (subW*(hovered-1)) selBox.selected = hovered return end
	local function render()
		selBox.selected = hovered
		local progress = (getTickCount()-selBox.sT)/(selBox.eT-selBox.sT)
		selBox.x, _, _ = interpolateBetween(selBox.sP, 0, 0, selBox.eP, 0, 0, progress, "InOutQuad")
		if progress >= 1 then removeEventHandler("onClientPreRender", root, render) end
	end
	
	selBox.sP = selBox.x
	selBox.eP = x1 + (subW*(hovered-1))
	selBox.sT = getTickCount()
	selBox.eT = selBox.sT + 400
	addEventHandler("onClientPreRender", root, render)
end

local subAl = {}
function toggleSubAlpha(a)
	local function render()
		local progress = (getTickCount()-subAl.sT)/(subAl.eT-subAl.sT)
		selBox.subAl, _, _ = interpolateBetween(subAl.sA, 0, 0, subAl.eA, 0, 0, progress, "Linear")
		if progress >= 1 then removeEventHandler("onClientPreRender", root, render) end
	end
	
	subAl.sA = selBox.subAl
	subAl.eA = a
	subAl.sT = getTickCount()
	subAl.eT = subAl.sT + 1500
	addEventHandler("onClientPreRender", root, render)
end

local rIT = {}
function panelMoveInOut(special)
	if not special then
		selectionMove(selBox.selected, selBox.hovered)
		if pOut then if selBox.hovered ~= selBox.selected then return end end
	end
	
	local function render()
		local progress = (getTickCount()-rIT.sT)/(rIT.eT-rIT.sT)
		_, pH, _ = interpolateBetween(0, rIT.sP, 0, 0, rIT.eP, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientPreRender", root, render) addedP = false end
	end
	
	pOut = not pOut
	
	if pOut then rIT.eP = 400 toggleSubAlpha(100) elseif not pOut then rIT.eP = 60 selBox.subAl = 0 end
	rIT.sP = pH
	rIT.sT = getTickCount()
	rIT.eT = rIT.sT + 500
	
	if not addedP then addedP = true addEventHandler("onClientPreRender", root, render) end
end

function setCurrentMusicTitle(theMusicTitle)
	theMusicTitle = string.gsub(theMusicTitle, ".mp3", "")
	settingsTab.cuMusic = theMusicTitle
end

addEvent("onServerUserpanelReady", true)
addEventHandler("onServerUserpanelReady", me, function()
	outputChatBox(":UP: #ff3300Press 'U' to open your userpanel", 210, 210, 210, true)
	bindKey("u", "down", function()
		fade = not fade
		showCursor(fade, fade)
		
		if fade then
			triggerServerEvent("onServerUpdatePlayerStats", me)
			triggerServerEvent("onServerUpdatePlayerSettings", me)
		end
		
		if (not fade) and (pOut) then
			panelMoveInOut(true)
			selBoxInOut()
		end
		
		if not draw then draw = not draw end
		if not isEventHandlerAdded("onClientRender", root, renderUserpanel) then addEventHandler("onClientRender", root, renderUserpanel) end
	end)
end)

addEvent("onClientUpdateInventory", true)
addEventHandler("onClientUpdateInventory", me, function(invTable)
	inventory = invTable
end)

addEvent("onClientUpdatePlayerStats", true)
addEventHandler("onClientUpdatePlayerStats", me, function(sTable)
	statsDatas = sTable
end)

addEvent("onClientUpdatePlayerSettings", true)
addEventHandler("onClientUpdatePlayerSettings", me, function(psTable)
	settingsTab.plSettings = psTable
end)