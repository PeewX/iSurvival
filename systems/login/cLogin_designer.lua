-- iR|HorrorClown (PewX) - 03.02.2014 --
----------------------------------------
local window = {width = 700, height = 300, alpha = 0, selected = 1, subMenu = {"News", "Login", "Register"}, selected = 1, news = {}, state = ""}

local menuHeight = (window.height-20)/#window.subMenu
local x1, y1 = x/2-window.width/2, y/2-window.height/2
local x2, y2 = x1 + 150, y1 + 20
local x3, y3 = x1 + window.width, y1 + window.height

function renderWindow()
	dxDrawRectangle(x1, y1, window.width, window.height, tocolor(40, 40, 40, 240/100*window.alpha))
	dxDrawRectangle(x1, y1, window.width, 20, tocolor(200, 0, 0, 255/100*window.alpha))
	dxDrawRectangle(x1, y2, 150, window.height - 20, tocolor(60, 60, 60, 255/100*window.alpha))
		
	for i, menuName in ipairs(window.subMenu) do
		if i > 1 then dxDrawDoubleLine(x1, y2+(menuHeight*(i-1)), 150) 	end
		
		dxDrawSelected(window.selected)
		dxDrawHover(i)
		
		dxDrawText(menuName, x1, y2+(menuHeight*(i-1)), x1 + 150, y2 + (menuHeight*i), tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[11], "center", "center", false, false, false, false, true)
	end
	
	dxDrawSubPanel()
	dxDrawText("iSurvival", x1, y1, x1 + window.width, y1 + 20, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[11], "center", "center", false, false, false, false, true)
	dxDrawDoubleLine(x1, y2, window.width)
end

function dxDrawDoubleLine(lx, ly, lwidth)
	ly = math.floor(ly)
	dxDrawLine(lx, ly, lx+lwidth, ly, tocolor(20, 20, 20, 255/100*window.alpha), 1)
	dxDrawLine(lx, ly+1, lx+lwidth, ly+1, tocolor(100, 100, 100, 255/100*window.alpha), 1)
end

function dxDrawSelected(index) 
	dxDrawRectangle(x1, y2+(menuHeight*(index-1)), 150, menuHeight, tocolor(0, 0, 0, 50/100*window.alpha))
	dxDrawRectangle(x1 , y2+(menuHeight*(index-1)), 4, menuHeight, tocolor(150, 0, 0, 50/100*window.alpha))
end

function dxDrawHover(index)
	if isHover(x1, y2+(menuHeight*(index-1)), 150, menuHeight) then
		if index ~= window.selected then
			dxDrawRectangle(x1, y2+(menuHeight*(index-1)), 150, menuHeight, tocolor(255, 255, 255, 15/100*window.alpha))
		end
	end
end

function dxDrawSubPanel()
	if window.selected == 1 then
		for i, news in ipairs(window.news) do
			if i > 1 then break end
			local text = news.text 
			text = string.gsub(text,"[*]ae[*]", "ä") text = string.gsub(text,"[*]oe[*]", "ö") text = string.gsub(text,"[*]ue[*]", "ü") 
			dxDrawText(news.title, x2 + 20, y2 + 20, x, y, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[18])
			dxDrawText(text, x2 + 20, y2 + 60, x1 + (window.width - 20), y1 + (window.height - 20), tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[11], "left", "top", false, true)
		end
	elseif window.selected == 2 then
		dxDrawText("Login", x2 + 20, y2 + 20, x, y, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[18])
		dxDrawText("Username:", x2 + 20, y2 + 60, x, y, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[11])
		dxDrawText("Password:", x2 + 20, y2 + 120, x, y, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[11])
		dxDrawText(window.state, x2 + 20, y2 + 180, x, y, tocolor(255, 0, 0, 255/100*window.alpha), 1, iFont[11])
		
		if isHover(x3 - 70, y3 - 70, 48, 48) then
			dxDrawImage(x3 - 70, y3 - 70, 48, 48, "files/images/gui/login.png", 0, 0, 0, tocolor(200, 0, 0, 230/100*window.alpha))
		else
			dxDrawImage(x3 - 70, y3 - 70, 48, 48, "files/images/gui/login.png", 0, 0, 0, tocolor(255, 255, 255, 230/100*window.alpha))
		end
	elseif window.selected == 3 then
		dxDrawText("Register", x2 + 20, y2 + 20, x, y, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[18])
		dxDrawText("Username:", x2 + 20, y2 + 60, x, y, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[11])
		dxDrawText("Password:", x2 + 20, y2 + 120, x, y, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[11])
		dxDrawText("Repeat password:", x2 + 250, y2 + 120, x, y, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[11])	
		dxDrawText(window.state, x2 + 20, y2 + 180, x, y, tocolor(255, 0, 0, 255/100*window.alpha), 1, iFont[11])
		
		if isHover(x3 - 70, y3 - 70, 48, 48) then
			dxDrawImage(x3 - 70, y3 - 70, 48, 48, "files/images/gui/login.png", 0, 0, 0, tocolor(200, 0, 0, 230/100*window.alpha))
		else
			dxDrawImage(x3 - 70, y3 - 70, 48, 48, "files/images/gui/login.png", 0, 0, 0, tocolor(255, 255, 255, 230/100*window.alpha))
		end
	end
end

function setLoginNews(ntbl)	window.news = ntbl end

local edits = {}
function createGUIEdits(selected)
	for i, edit in ipairs(edits) do
		if isElement(edit) then
			destroyElement(edit)
		end
	end
	
	edits = {}
	if selected == 2 then
		edits[1] = guiCreateEdit(x2 + 20, y2 + 80, 200, 21, "", false)
		edits[2] = guiCreateEdit(x2 + 20, y2 + 140, 200, 21, "", false)
		guiEditSetMasked(edits[2], true)
	elseif selected == 3 then
		edits[1] = guiCreateEdit(x2 + 20, y2 + 80, 200, 21, "", false)
		edits[2] = guiCreateEdit(x2 + 20, y2 + 140, 200, 21, "", false)
		edits[3] = guiCreateEdit(x2 + 250, y2 + 140, 200, 21, "", false)
		guiEditSetMasked(edits[2], true)
		guiEditSetMasked(edits[3], true)
	end
	guiSetInputMode("no_binds_when_editing")
end

function onLoginWindowClick(mbutton, state)
	if mbutton == "left" and state == "down" then
		if window.selected == 2 then
			if isHover(x3 - 70, y3 - 70, 48, 48) then
				triggerServerEvent("onClientPlayerLogin", me, guiGetText(edits[1]), guiGetText(edits[2]))
				return
			end
		elseif  window.selected == 3 then
			if isHover(x3 - 70, y3 - 70, 48, 48) then
				triggerServerEvent("onClientRegister", me, guiGetText(edits[1]), guiGetText(edits[2]), guiGetText(edits[3]))
				return
			end
		end

		for i, menuName in ipairs(window.subMenu) do
			if isHover(x1, y2+(menuHeight*(i-1)), 150, menuHeight) then
				window.state = ""
				window.selected = i
				createGUIEdits(i)
			end
		end
	end
end
addEventHandler("onClientClick", root, onLoginWindowClick)

addEvent("onClientLoginSuccess", true)
addEventHandler("onClientLoginSuccess", me, function()
	stopMoveCamera()
	toggleLoginAlpha(0)
	toggleBlackBars(0)
	for i, edit in ipairs(edits) do
		if isElement(edit) then
			destroyElement(edit)
		end
	end
	removeEventHandler("onClientRender", root, renderWindow)
	removeEventHandler("onClientClick", root, onLoginWindowClick)
	showCursor(false)
	showChat(true)
	showPlayerHudComponent("all", true)
	showPlayerHudComponent("area_name", false)
	showPlayerHudComponent("vehicle_name", false)
	
	setTimer(function()
		removeEventHandler("onClientRender", root, renderIntro)
	end, 5000, 1)
end)

addEvent("onLoginOrRegisterFailed", true)
addEventHandler("onLoginOrRegisterFailed", me, function(state)
	window.state = state
end)

local wAnim = {}
function toggleLoginAlpha(al)
	local function render()
		local progress = (getTickCount()-wAnim.sT)/(wAnim.eT-wAnim.sT)
		window.alpha = interpolateBetween(wAnim.sA, 0, 0, wAnim.eA, 0, 0, progress, "OutQuad")		
		if math.abs(progress) >= 1 then removeEventHandler("onClientPreRender", root, render) wAnim = {} if window.alpha < 10 then showCursor(false, false) else showCursor(true, true) end end
	end
	
	wAnim.sA = window.alpha
	wAnim.eA = al
	wAnim.sT = getTickCount()
	wAnim.eT = wAnim.sT + 1500
	addEventHandler("onClientPreRender", root, render)
end