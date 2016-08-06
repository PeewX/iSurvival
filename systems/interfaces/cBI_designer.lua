--iR|HorrorClown (PewX) - iRace-mta.de - 04.05.2014 --
local bI = {render = false, state, bgColor = {200, 0, 0}, sX = 0, sY = y-(40/1080*y), iW = 0, iH = 7/1080*y, txtAl = 0, ping = 0, fps = 0, tabs = 3, notify = false} --bI = bottomInterface
local notifications = {}
local nRotation = 0

local function dxDrawDoubleLine(lx, ly, lwidth)
	ly = math.floor(ly)
	dxDrawLine(lx, ly, lx+lwidth, ly, tocolor(20, 20, 20, 255), 1)
	dxDrawLine(lx, ly+1, lx+lwidth, ly+1, tocolor(100, 100, 100, 255), 1)
end

local function renderBottomInterface()
	refreshTabs()
	
	if isPlayerInSafetyZone() then
		dxDrawImage(x/2-(500/1920*x)/2, bI.sY - (50/1080*y), 500/1920*x, 50/1080*y, "files/images/environment/safetyzone.png")
	end
	
	if isPlayerLeaveSF() then
		local iWidth, iHeight = 128/1920*x, 128/1080*y
		nRotation = nRotation + 1
		if nRotation > 360 then nRotation = 0 end
		dxDrawImage(x - iWidth - 10/1920*x, bI.sY - iHeight - 10, iWidth, iHeight, "files/images/environment/nuclear.png", nRotation)
	end
	
	local r, g, b = unpack(bI.bgColor)
	dxDrawRectangle(bI.sX, bI.sY, bI.iW, bI.iH, tocolor(r, g, b, 130))
	dxDrawDoubleLine(bI.sX, bI.sY, bI.iW)
	dxDrawZPointsProgress()
	
	if not bI.notify then
		dxDrawMain()
			
		if isHover(bI.sX, bI.sY, bI.iW, bI.iH) and bI.state ~= "up" then
			if bI.state ~= "fixed" then
				bI.state = "up"
				setBottomInterfaceStartY(y-(40/1080*y))
				setTimer(function()	if bI.state ~= "fixed" then setBottomInterfaceStartY(y-(7/1080*y)) bI.state = nil end end, 5000, 1)
			end
		end
	else
		dxDrawNotify()
	end
end

function refreshTabs()
	if isPedInVehicle(me) then bI.tabs = 6 else bI.tabs = 3	end
end

function dxDrawNotify()
	local mainY, mainYW, mainYE = bI.sY + 5, 40/1080*y, bI.sY + (40/1080*y)
	for i, n in ipairs(notifications) do
		if n.start <= getTickCount() then
			if not n.fadeIn then n.fadeIn = true setNotifyAlpha(i, 100) setNotifyStartPoint(i, x*0.1) end
			--dxDrawImage(n.startX, mainY, 
			dxDrawText(n.text, n.startX, mainY, x, mainYE, tocolor(255, 255, 255, 255/100*n.alpha), 1, iFont[16], "left", "center", false, false, false, false, true)
			if n.start + n.length <= getTickCount() then
				table.remove(notifications, i)
				toggleNotifications()
			elseif n.start + n.length - 1000 <= getTickCount() then
				if not n.fadeOut then
					n.fadeOut = true
					setNotifyAlpha(i, 0)
					setNotifyStartPoint(i, x)
				end
			end
		end
	end
end

function dxDrawMain()
	local tabWidth = x/bI.tabs
	local mainY, mainYW, mainYE = bI.sY + 5, 40/1080*y, bI.sY + (40/1080*y)
	dxDrawText("FPS: " .. bI.fps, 0, mainY, tabWidth, mainYE, tocolor(255, 255, 255, 255/100*bI.txtAl), 1, iFont[16], "center", "center")
	dxDrawText("Ping: " .. bI.ping, tabWidth, mainY, tabWidth*2, mainYE, tocolor(255, 255, 255, 255/100*bI.txtAl), 1, iFont[16], "center", "center")
	dxDrawText("Playtime: " .. getElementData(me, "Playtime") .. "h", tabWidth*2, mainY, tabWidth*3, mainYE, tocolor(255, 255, 255, 255/100*bI.txtAl), 1, iFont[16], "center", "center")
	
	if bI.tabs == 6 and isPedInVehicle(me) then
		local vehicle = getPedOccupiedVehicle(me)
		if not isElement(vehicle) then return end
		
		--speed
		local speed = getVehicleSpeed(vehicle) or 0
		dxDrawRectangle(tabWidth*3 + 3, mainY + 5, tabWidth - 15, mainYW - 15, tocolor(0, 0, 0, 100))
		dxDrawText("Speed", tabWidth*3, mainY, tabWidth*4, mainYE, tocolor(255, 255, 255, 255/100*bI.txtAl), 1, iFont[16], "center", "center")
		dxDrawRectangle(tabWidth*3 + 3, mainY + 5, (((tabWidth-15)/270)*speed)/1920*x, mainYW - 15, tocolor(0, 160, 230, 200))
		
		--Fuel
		local fuel = getElementData(vehicle, "fuel") or 0
		dxDrawRectangle(tabWidth*4 + 3, mainY + 5, tabWidth - 15, mainYW - 15, tocolor(0, 0, 0, 100))
		dxDrawText("Fuel", tabWidth*4, mainY, tabWidth*5, mainYE, tocolor(255, 255, 255, 255/100*bI.txtAl), 1, iFont[16], "center", "center")
		dxDrawRectangle(tabWidth*4 + 3, mainY + 5, (((tabWidth-15)/100)*fuel)/1920*x, mainYW - 15, tocolor(220, 200, 0, 200))
		
		--Health
		local health = math.round(getElementHealth(vehicle)/10) or 0
		dxDrawRectangle(tabWidth*5 + 3, mainY + 5, tabWidth - 15, mainYW - 15, tocolor(0, 0, 0, 100))
		dxDrawText("Health", tabWidth*5, mainY, tabWidth*6, mainYE, tocolor(255, 255, 255, 255/100*bI.txtAl), 1, iFont[16], "center", "center")
		dxDrawRectangle(tabWidth*5 + 3, mainY + 5, (((tabWidth-15)/100)*health)/1920*x, mainYW - 15, toVehHealthColor(health))
	end
end

function toVehHealthColor(health)
	local greenAmount = (255/100)*health
	local redAmount = 255-greenAmount
	return tocolor(redAmount, greenAmount, 0, 200)
end

function dxDrawZPointsProgress()
	local nL = calcZPointsForNextLevel(getElementData(me, "zSkillLevel"))
	if nL then
		local zPP = (x/nL)*getElementData(me, "zPoints")
		dxDrawRectangle(bI.sX, bI.sY+2, zPP/1920*bI.iW, 1, tocolor(0, 230, 0, 200))	--Drawing with rectangles. Lines do not look good by animations
		dxDrawRectangle(bI.sX, bI.sY+3, zPP/1920*bI.iW, 1, tocolor(0, 230, 0, 200))
		dxDrawRectangle(bI.sX, bI.sY+4, zPP/1920*bI.iW, 1, tocolor(0, 230, 0, 200))
		dxDrawRectangle(bI.sX, bI.sY+5, zPP/1920*bI.iW, 1, tocolor(0, 150, 0, 200))
	end
end

addEventHandler("onClientClick", root, function(btn, st)
	if btn == "left" and st == "down" then
		if bI.state == "up" then
			if isHover(bI.sX, bI.sY, bI.iW, bI.iH) then
				bI.state = "fixed"
			end
		elseif bI.state == "fixed" then
			setTimer(function() setBottomInterfaceStartY(y-(7/1080*y)) bI.state = nil end, 5000, 1)
		end
	end
end)

addEvent("showBottomInterface", true)
addEventHandler("showBottomInterface", me, function(state)
	if state then
		if not bI.render then
			bI = {render = false, state, bgColor = {200, 0, 0}, sX = 0, sY = y-(40/1080*y), iW = 0, iH = 7/1080*y, txtAl = 0, ping = 0, fps = 0, tabs = 3, notify = false}
			bI.render = true
			addEventHandler("onClientRender", root, renderBottomInterface)
			setBottomInterfaceWidth(x)
			setTimer(function() setBottomInterfaceHeight(40/1080*y) end, 1000, 1)
			setTimer(function() setTextAlpha(100) end, 1200, 1)
			setTimer(function() setBottomInterfaceStartY(y-(7/1080*y)) end, 5000, 1)
		end
	elseif not state then
		if bI.render then
			bI.render = false
			removeEventHandler("onClientRender", root, renderBottomInterface)
		end
	end
end)


local sT, c = false, 0
addEventHandler("onClientRender",root, function() if not sT then sT = getTickCount() end c = c + 1 if getTickCount() - sT >= 1000 then bI.fps = c c = 0 sT = false end end)
setTimer(function()	bI.ping = getPlayerPing(me) end, 1000, -1)

local wt = {}
function setBottomInterfaceWidth(w)
	wt = {}
	local function render()
		local progress = (getTickCount()-wt.sT)/(wt.eT-wt.sT)
		bI.iW = interpolateBetween(wt.sW, 0, 0, wt.eW, 0, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	wt.sW = bI.iW
	wt.eW = w
	wt.sT = getTickCount()
	wt.eT = wt.sT + 1000
	addEventHandler("onClientRender", root, render)
end

local ht = {}
function setBottomInterfaceHeight(h)
	ht = {}
	local function render()
		local progress = (getTickCount()-ht.sT)/(ht.eT-ht.sT)
		bI.iH = interpolateBetween(ht.sH, 0, 0, ht.eH, 0, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	ht.sH = bI.iH
	ht.eH = h
	ht.sT = getTickCount()
	ht.eT = ht.sT + 500
	addEventHandler("onClientRender", root, render)
end

local syt = {}
function setBottomInterfaceStartY(nY)
	syt = {}
	local function render()
		local progress = (getTickCount()-syt.sT)/(syt.eT-syt.sT)
		bI.sY = interpolateBetween(syt.sY, 0, 0, syt.eY, 0, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end

	syt.sY = bI.sY
	syt.eY = nY
	syt.sT = getTickCount()
	syt.eT = syt.sT + 500
	addEventHandler("onClientRender", root, render)
end

local tT = {}
function setTextAlpha(a)
	tT = {}
	local function render()
		local progress = (getTickCount()-tT.sT)/(tT.eT-tT.sT)
		bI.txtAl = interpolateBetween(tT.sA, 0, 0, tT.eA, 0, 0, progress, "Linear")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end

	tT.sA = bI.txtAl
	tT.eA = a
	tT.sT = getTickCount()
	tT.eT = tT.sT + 2000
	addEventHandler("onClientRender", root, render)
end

local cT = {}
function setBottomInterfaceColor(r, g, b)
	cT = {}
	local function render()
		local progress = (getTickCount()-cT.sT)/(cT.eT-cT.sT)
		local sR, sG, sB = unpack(cT.sC)
		local eR, eG, eB = unpack(cT.eC)
		bI.bgColor = {interpolateBetween(sR, sG, sB, eR, eG, eB, progress, "InOutQuad")}
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	cT.sC = bI.bgColor
	cT.eC = {r, g, b}
	cT.sT = getTickCount()
	cT.eT = cT.sT + 1500
	addEventHandler("onClientRender", root, render)
end

local nT = {}
function setNotifyAlpha(id, alpha)
	nT = {}
	local function render()
		local progress = (getTickCount()-nT.sT)/(nT.eT-nT.sT)
		notifications[nT.ID].alpha = interpolateBetween(nT.sA, 0, 0, nT.eA, 0, 0, progress, "Linear")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	nT.ID = id
	nT.sA = notifications[id].alpha
	nT.eA = alpha
	nT.sT = getTickCount()
	nT.eT = nT.sT + 800
	addEventHandler("onClientRender", root, render)
end

local nT = {}
function setNotifyStartPoint(id, sP)
	nT = {}
	local function render()
		local progress = (getTickCount()-nT.sT)/(nT.eT-nT.sT)
		notifications[nT.ID].startX = interpolateBetween(nT.sY, 0, 0, nT.eY, 0, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	nT.ID = id
	nT.sY = notifications[id].startX
	nT.eY = sP
	nT.sT = getTickCount()
	nT.eT = nT.sT + 800
	addEventHandler("onClientRender", root, render)
end

addEventHandler("onClientVehicleEnter", root, function(thePlayer)
	if thePlayer == me then
		if bI.state ~= "fixed" and bI.state ~= "up" then
			bI.state = "up"
			setBottomInterfaceStartY(y-(40/1080*y))
			setTimer(function()	if bI.state ~= "fixed" then setBottomInterfaceStartY(y-(7/1080*y)) bI.state = nil end end, 5000, 1)
		end
	end
end)

--Notifications
function addNotification(text, length, icon)
	local ID = #notifications + 1
	
	notifications[ID] = {}
	notifications[ID].text = text
	notifications[ID].alpha = 0
	notifications[ID].startX = x
	notifications[ID].fadeIn = false
	notifications[ID].fadeOut = false
	notifications[ID].length = tonumber(length)
	notifications[ID].start = calcNextNotifyTime(ID - 1)
	notifications[ID].previous = ID - 1
	
	toggleNotifications()
end

function calcNextNotifyTime(pre)
	if #notifications == 1 then
		return getTickCount()
	else
		return notifications[pre].start + notifications[pre].length
	end	
end

function toggleNotifications()
	if #notifications == 0 then
		bI.notify = false
		setTimer(function()	if bI.state ~= "fixed" then if #notifications == 0 then setBottomInterfaceStartY(y-(7/1080*y)) bI.state = nil end end end, 5000, 1)
		setBottomInterfaceColor(200, 0, 0)
	else
		bI.notify = true
		bI.state = "up"
		setBottomInterfaceStartY(y-(40/1080*y))		
		setBottomInterfaceColor(0, 0, 240)
	end
end