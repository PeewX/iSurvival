--iR|HorrorClown (PewX) - iRace-mta.de - 22.05.2014--
setDevelopmentMode(true)
local w = {w = 700, h = 300, render = false, sub = {"Handguns", "Shotguns", "Machine Guns", "Others"}, subTitle, subActive = 0}
local click = false

local sIDs = {69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79}
local sIDName = {[24] = "Health", [22] = "Stamina", [69] = "Pistol", [70] = "Silenced pistol", [71] = "Deagle", [72] = "Shotgun", [73] = "Sawn-off Shotgun", [74] = "SPAS-12", [75] = "UZI", [76] = "MP5", [77] = "AK47", [78] = "M4", [79] = "Sniper"}

local x1, y1 = x/2-w.w/2, y/2-w.h/2
local x2, y2 = x1 + 15, y1 + 35
local x3, y3 = x2, y2 + 45
local function renderStatspanel()
	dxDrawWindow(x1, y1, w.w, w.h, "iSurvival - Upgrades", true, closeStatsPanel)
	
	local bWidth = (w.w-(#w.sub+1)*15)/#w.sub
	for i, btn in ipairs(w.sub) do
		local sx, sel = x2 + ((i-1)*bWidth) + ((i-1)*15), false
		if i == w.subActive then sel = true end
		dxDrawButton(sx, y2, bWidth, 35, btn, true, true, sel, iFontB[13], setSubTitle, "Upgrades - " .. btn, i)
	end
	
	if w.subActive == 0 then
		--Skill
		if isUpgradeInProgress() then
			local t = getUpgradeInformations()
			local progress = 100/t.upMaxValue*t.upValue
			dxDrawText(sIDName[t.upType] .. " upgrade progress", x1+ 50, y3 + 40 - dxGetFontHeight(1, iFont[11]), x, y, tocolor(255, 255, 255), 1, iFont[11])
			dxDrawRectangle(x1 + 50, y3 + 40, 600, 30, tocolor(0, 0, 0, 100))
			dxDrawRectangle(x1 + 52, y3 + 42, 596/100*progress, 26, tocolor(255, 100, 0))
			dxDrawText(t.upValue .. "/" .. t.upMaxValue, x1 + 50, y3 + 40, x1 + 50 + 600, y3 + 40 + 30, tocolor(255, 255, 255), 1, iFont[12], "center", "center")
			
			local timeleft = t.upEndTime - getSyncedTimestamp() if timeleft < 0 then timeleft = 0 end
			dxDrawText("Timeleft", x1+ 50, y3 + 90 - dxGetFontHeight(1, iFont[11]), x, y, tocolor(255, 255, 255), 1, iFont[11])
			dxDrawRectangle(x1 + 50, y3 + 90, 600, 30, tocolor(0, 0, 0, 100))
			dxDrawRectangle(x1 + 52, y3 + 92, 596/3600*timeleft, 26, tocolor(0, 170, 255))
			dxDrawText(secondsToTimeDesc(timeleft), x1 + 50, y3 + 90, x1 + 50 + 600, y3 + 90 + 30, tocolor(255, 255, 255), 1, iFont[12], "center", "center")
		else
			local aUp = 0
			for _, ID in ipairs(sIDs) do
				if isUpgradeAvailable(me, ID) then
					aUp = aUp + 1
				end
			end
			dxDrawText("Hey, here you can increase weapon skills or buy a level upgrade. \nTo complete the upgrade, you have to kill enough zombies in one hour!", x3, y3, x1 + w.w, y1 + w.h, tocolor(255, 255, 255), 1, iFont[12], "left", "top", false, true)
			dxDrawText("Your zSkillLevel: " .. getElementData(me, "zSkillLevel"), x3, y3 + 60, x1 + w.w, y1 + w.h, tocolor(255, 255, 255), 1, iFont[12])
			if aUp ~= 0 then dxDrawText("So you have access to " .. aUp .. " upgrades!", x3, y3 + 80, x1 + w.w, y1 + w.h, tocolor(255, 255, 255), 1, iFont[12]) else dxDrawText("So you don't have access to any upgrade :(", x3, y3 + 80, x1 + w.w, y1 + w.h, tocolor(255, 255, 255), 1, iFont[12]) end
		end
		
		--Level
		local level = getElementData(me, "level")
		local money = calcMoneyForNextLevel(tonumber(level))
		
		dxDrawText("Current level: " .. level, x3, y1 + w.h - 15 - 40, x, y, tocolor(255, 255, 255), 1, iFont[12])
		dxDrawText("Next level price: " .. money, x3, y1 + w.h - 15 - 20, x, y, tocolor(255, 255, 255), 1, iFont[12])
		dxDrawButton(x1 + w.w - 15 - 200, y1 + w.h - 15 - 30, 200, 30, "Buy next level", true, false, false, iFont[11], buyNextLevel)
	elseif w.subActive == 1 then
		local statIDs = {69, 70, 71}
		local space = (y3 - w.h)/#statIDs
		
		dxDrawText(w.subTitle, x3, y3, x1 + w.w, y1 + w.h, tocolor(255, 255, 255), 1, iFont[12])
		for i, stat in ipairs(statIDs) do
			local btnEnabled, nextProgress = false, 0
			if isUpgradeAvailable(me, stat) then btnEnabled, nextProgress = true, (math.floor(getPedStat(me, stat)/100) + 1)*10 end
			dxDrawButton(x3 + 125 + 465, y3 + space*i, 80, 30, "Increase", btnEnabled, false, false, iFont[11], increaseClickedStat, stat)
			
			dxDrawText(sIDName[stat], x3, y3 + space*i, x1 + w.w, y3 + space*i + 30, tocolor(255, 255, 255), 1, iFont[11], "left", "center")
			local progress = getPedStat(me, stat)/10
			dxDrawRectangle(x3 + 125, y3 + space*i, 450, 30, tocolor(0, 0, 0, 100))			
			dxDrawRectangle(x3 + 127, y3 + space*i+2, 446/100*nextProgress, 26, tocolor(255, 100, 0, 120))
			dxDrawRectangle(x3 + 127, y3 + space*i+2, 446/100*progress, 26, tocolor(255, 100, 0))
			dxDrawText(math.round(progress, 2) .. "%", x3 + 125, y3 + space*i, x3 + 125 + 450, y3 + space*i + 30, tocolor(255, 255, 255), 1, iFont[12], "center", "center")
		end
	elseif w.subActive == 2 then
		local statIDs = {72, 73, 74}
		local space = (y3 - w.h)/#statIDs
		
		dxDrawText(w.subTitle, x3, y3, x1 + w.w, y1 + w.h, tocolor(255, 255, 255), 1, iFont[12])
		for i, stat in ipairs(statIDs) do
			local btnEnabled, nextProgress = false, 0
			if isUpgradeAvailable(me, stat) then btnEnabled, nextProgress = true, (math.floor(getPedStat(me, stat)/100) + 1)*10 end
			dxDrawButton(x3 + 125 + 465, y3 + space*i, 80, 30, "Increase", btnEnabled, false, false, iFont[11], increaseClickedStat, stat)
			
			dxDrawText(sIDName[stat], x3, y3 + space*i, x1 + w.w, y3 + space*i + 30, tocolor(255, 255, 255), 1, iFont[11], "left", "center")
			local progress = getPedStat(me, stat)/10
			dxDrawRectangle(x3 + 125, y3 + space*i, 450, 30, tocolor(0, 0, 0, 100))	
			dxDrawRectangle(x3 + 127, y3 + space*i+2, 446/100*nextProgress, 26, tocolor(255, 100, 0, 120))
			dxDrawRectangle(x3 + 127, y3 + space*i+2, 446/100*progress, 26, tocolor(255, 100, 0))
			dxDrawText(math.round(progress, 2) .. "%", x3 + 125, y3 + space*i, x3 + 125 + 450, y3 + space*i + 30, tocolor(255, 255, 255), 1, iFont[12], "center", "center")
		end
	elseif w.subActive == 3 then
		local statIDs = {75, 76, 77, 78}
		local space = (y3 - w.h)/#statIDs
		
		dxDrawText(w.subTitle, x3, y3, x1 + w.w, y1 + w.h, tocolor(255, 255, 255), 1, iFont[12])
		for i, stat in ipairs(statIDs) do
			local btnEnabled, nextProgress = false, 0
			if isUpgradeAvailable(me, stat) then btnEnabled, nextProgress = true, (math.floor(getPedStat(me, stat)/100) + 1)*10 end
			dxDrawButton(x3 + 125 + 465, y3 + space*i, 80, 30, "Increase", btnEnabled, false, false, iFont[11], increaseClickedStat, stat)
			
			dxDrawText(sIDName[stat], x3, y3 + space*i, x1 + w.w, y3 + space*i + 30, tocolor(255, 255, 255), 1, iFont[11], "left", "center")
			local progress = getPedStat(me, stat)/10
			dxDrawRectangle(x3 + 125, y3 + space*i, 450, 30, tocolor(0, 0, 0, 100))		
			dxDrawRectangle(x3 + 127, y3 + space*i+2, 446/100*nextProgress, 26, tocolor(255, 100, 0, 120))
			dxDrawRectangle(x3 + 127, y3 + space*i+2, 446/100*progress, 26, tocolor(255, 100, 0))
			dxDrawText(math.round(progress, 2) .. "%", x3 + 125, y3 + space*i, x3 + 125 + 450, y3 + space*i + 30, tocolor(255, 255, 255), 1, iFont[12], "center", "center")
		end
	elseif w.subActive == 4 then
		local statIDs = {24, 22, 79}
		local space = (y3 - w.h)/#statIDs
		
		dxDrawText(w.subTitle, x3, y3, x1 + w.w, y1 + w.h, tocolor(255, 255, 255), 1, iFont[12])
		for i, stat in ipairs(statIDs) do
			local btnEnabled, nextProgress = false, 0
			if isUpgradeAvailable(me, stat) then btnEnabled, nextProgress = true, (math.floor(getPedStat(me, stat)/100) + 1)*10 end
			dxDrawButton(x3 + 125 + 465, y3 + space*i, 80, 30, "Increase", btnEnabled, false, false, iFont[11], increaseClickedStat, stat)
			
			dxDrawText(sIDName[stat], x3, y3 + space*i, x1 + w.w, y3 + space*i + 30, tocolor(255, 255, 255), 1, iFont[11], "left", "center")
			local progress = getPedStat(me, stat)/10		
			dxDrawRectangle(x3 + 125, y3 + space*i, 450, 30, tocolor(0, 0, 0, 100))	
			dxDrawRectangle(x3 + 127, y3 + space*i+2, 446/100*nextProgress, 26, tocolor(255, 100, 0, 120))
			dxDrawRectangle(x3 + 127, y3 + space*i+2, 446/100*progress, 26, tocolor(255, 100, 0))
			dxDrawText(math.round(progress, 2) .. "%", x3 + 125, y3 + space*i, x3 + 125 + 450, y3 + space*i + 30, tocolor(255, 255, 255), 1, iFont[12], "center", "center")
		end
	end
	
	click = false
end

local oT = false
local function openStatsPanel()
	if not w.render then
		triggerServerEvent("onClientUpdateStatsPanel", me)
		oT = getTickCount()
		w.render = true
		addEventHandler("onClientRender", root, renderStatspanel)
		showCursor(true)
	end
end
addEvent("onClientTogglePanel.stats", true)
addEventHandler("onClientTogglePanel.stats", root, openStatsPanel)

function closeStatsPanel()
	if w.render then
		oT = false
		w.render = false
		removeEventHandler("onClientRender", root, renderStatspanel)
		showCursor(false)
	end
end

local function onClick(btn, btnSt)
	if oT and (getTickCount() - oT > 1000) then
		if btnSt == "down" and btn == "left" then click = true end
	end
end
addEventHandler("onClientClick", root, onClick)

function increaseClickedStat(statID)
	triggerServerEvent("increasePlayerStats", me, statID)
end

function buyNextLevel()
	triggerServerEvent("onClientBuyLevelUpgrade", me)
end

function setSubTitle(text, numb)
	if w.subActive == numb then
		w.subActive = 0
	else
		w.subTitle = text
		w.subActive = numb
	end
end

--[[local function dxDrawDoubleLine(lx, ly, lwidth)
	ly, lx, lwidth = math.floor(ly), math.floor(lx), math.floor(lwidth)
	dxDrawLine(lx, ly, lx+lwidth, ly, tocolor(20, 20, 20, 255), 1)
	dxDrawLine(lx, ly+1, lx+lwidth, ly+1, tocolor(100, 100, 100, 255), 1)
end

local function dxDrawDoubleLineR(lx, ly, lwidth)
	ly, lx, lwidth = math.floor(ly), math.floor(lx), math.floor(lwidth)
	dxDrawLine(lx, ly+1, lx+lwidth, ly+1, tocolor(20, 20, 20, 255), 1)
	dxDrawLine(lx, ly, lx+lwidth, ly, tocolor(100, 100, 100, 255), 1)
end

function dxDrawWindow(sx, sy, width, height, title)
	dxDrawRectangle(sx, sy, width, height, tocolor(40, 40, 40, 240))
	dxDrawRectangle(sx, sy, width, 20, tocolor(200, 0, 0))
	dxDrawText(title, sx, sy, sx + width, sy + 20, tocolor(255, 255, 255), 1, iFont[11], "center", "center")
	dxDrawDoubleLine(sx, sy + 20, width)
	
	Close
	if isHover(sx + width - 18, sy + 2, 16, 16) then dxDrawImage(sx + width - 18, sy + 2, 16, 16, "images/close.png", 0, 0, 0, tocolor(0, 0, 0)) if click then toggleStatsPanel() end else dxDrawImage(sx + width - 18, sy + 2, 16, 16, "images/close.png", 0, 0, 0, tocolor(50, 50, 50))	end
end]]

function dxDrawButton(sx, sy, w, h, title, enabled, lines, active, font, aFunction, ...)
	local bC, tC = tocolor(255, 30, 0), tocolor(255, 255, 255)
	if enabled then
		if isHover(sx, sy, w, h) then bC, tC = tocolor(255, 70, 0), tocolor(180, 180, 180) end
		if active then bC, tC = tocolor(255, 0, 20), tocolor(255, 255, 255) end
	else
		bC, tC = tocolor(120, 120, 120), tocolor(255, 255, 255)
	end
	
	dxDrawImage(sx, sy, w, h, "files/images/gui/button.png", 0, 0, 0, bC)
	if lines then
		dxDrawDoubleLineR(sx, sy -1, w)
		dxDrawDoubleLine(sx, sy + h, w)
	end
	
	dxDrawText(title, sx, sy, sx + w, sy + h, tC, 1, font, "center", "center")
	if enabled then	if isHover(sx, sy, w, h) then if click then aFunction(...) end end end
end