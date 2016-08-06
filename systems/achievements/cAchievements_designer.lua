--iR|HorrorClown (PewX) - iRace-mta.de - 29.05.2014 --
local w, h = 530, 99 --Defaults
local aImg = {y = 150, w = 0, h = h, mainAl = 0, textAl = 0}

local function reversAlpha(al)
	return 255 - al
end

local function renderAchievement()
	local sX, sY = x/2-aImg.w/2, aImg.y
	dxDrawImage(sX, sY, aImg.w, aImg.h, "files/images/achievements/main.png", 0, 0, 0, tocolor(255, 255, 255, aImg.mainAl))
	
	local inX, inY = sX + 16, sY + 16
	if fileExists("files/images/achievements/" .. aImg.icon .. ".png") then
		dxDrawImage(inX, inY, 64, 64, "files/images/achievements/" .. aImg.icon .. ".png", 0, 0, 0, tocolor(255, 255, 255, aImg.mainAl))
	else
		dxDrawRectangle(inX, inY, 64, 64, tocolor(0, 0, 0, aImg.mainAl/2))
	end
	
	local inX = inX + 64 + 15
	dxDrawText("Achievement unlocked!", inX, inY, sX + (aImg.w - 120), inY + 75, tocolor(0, 0, 0, reversAlpha(aImg.textAl)/255*aImg.mainAl), 1, iFontB[14], "center", "top", true)
	dxDrawText(aImg.title, inX, inY, sX + (aImg.w - 120), inY + 75, tocolor(0, 0, 0, aImg.textAl/255*aImg.mainAl), 1, iFontB[14], "center", "top", true)
	dxDrawText(aImg.subTitle, inX, inY + 25, sX + (aImg.w - 120), inY + 75, tocolor(0, 0, 0, aImg.textAl/255*aImg.mainAl), 1, iFont[12], "center", "top", false, true)
end

local function toggleWidth(nW)
	local t = {}
	local function render()
		local progress = (getTickCount()-t.sT)/(t.eT-t.sT)
		aImg.w = interpolateBetween(t.sW, 0, 0, t.eW, 0, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	t.sW = aImg.w
	t.eW = nW
	t.sT = getTickCount()
	t.eT = t.sT + 1000
	addEventHandler("onClientRender", root, render)
end

local function toggleMainAlpha(nA)
	local t = {}
	local function render()
		local progress = (getTickCount()-t.sT)/(t.eT-t.sT)
		aImg.mainAl = interpolateBetween(t.sA, 0, 0, t.eA, 0, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	t.sA = aImg.mainAl
	t.eA = nA
	t.sT = getTickCount()
	t.eT = t.sT + 200
	addEventHandler("onClientRender", root, render)
end

local function toggleTextAlpha(nA)
	local t = {}
	local function render()
		local progress = (getTickCount()-t.sT)/(t.eT-t.sT)
		aImg.textAl = interpolateBetween(t.sA, 0, 0, t.eA, 0, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	t.sA = aImg.textAl
	t.eA = nA
	t.sT = getTickCount()
	t.eT = t.sT + 1000
	addEventHandler("onClientRender", root, render)
end

addEvent("onClientAchievementNotify", true)
local function initialise(title, subTitle, icon) 
	if not isEventHandlerAdded("onClientRender", root, renderAchievement) then
		aImg.title = title
		aImg.subTitle = subTitle
		aImg.icon = icon
		addEventHandler("onClientRender", root, renderAchievement)
		toggleWidth(w)
		toggleMainAlpha(255)
		playSound("sounds/achievement.mp3", false)
		setTimer(function() toggleTextAlpha(255) end, 2500, 1)
		setTimer(function() toggleTextAlpha(0) toggleMainAlpha(0) toggleWidth(0) end, 15000, 1)
		setTimer(function() removeEventHandler("onClientRender", root, renderAchievement) end, 16000, 1)
	else
		setTimer(initialise, 5000, 1, title, subTitle, icon) --Um 4 Uhr morgens darf man solch schlechte Lösung dafür verwenden..... xD Vergiss nicht das zu verbessern^.^
	end
end
addEventHandler("onClientAchievementNotify", me, initialise)