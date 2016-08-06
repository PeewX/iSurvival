--iR|HorrorClown (PewX) - iRace-mta.de - 16.05.2014 --
local window = {width = 700, height = 300, alpha = 100}

local x1, y1 = x/2-window.width/2, y/2-window.height/2
local x2, y2, a = x1 + 15, y1 + 35, 20
function renderFuelshop()
	dxDrawRectangle(x1, y1, window.width, window.height, tocolor(40, 40, 40, 240/100*window.alpha))
	dxDrawRectangle(x1, y1, window.width, 20, tocolor(200, 0, 0, 255/100*window.alpha))
	dxDrawText("iSurvival - Fuelshop", x1, y1, x1 + window.width, y1 + 20, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[11], "center", "center")
	
	local level = getElementData(me, "level")

	dxDrawText("Hey, i sell empty patrol can's. Yes, there are empty, you have to fill it up. ", x2, y2 + a*0, x, y, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[12])
	dxDrawText("Price: " .. g_PatrolCanPrice .. "$", x2, y2 + a*1, x, y, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[12])
	
	dxDrawImage(x2, y2 + a*3, 200, 40, "images/userpanel_tab.png", 0, 0, 0, tocolor(200, 0, 0, 235/100*window.alpha))
	dxDrawImage(x2+470, y2 + a*3, 200, 40, "images/userpanel_tab.png", 0, 0, 0, tocolor(200, 0, 0, 235/100*window.alpha))
	
	dxDrawText("Buy Patrol Can", x2, y2 + a*3, x2 + 200, y2 + a*3 + 40, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[12], "center", "center")
	dxDrawText("Close", x2 + 470, y2 + a*3, x2 + 470 + 200, y2 + a*3 + 40, tocolor(255, 255, 255, 255/100*window.alpha), 1, iFont[12], "center", "center")
	
	if isHover(x2, y2 + a*3, 200, 40) then
		dxDrawRectangle(x2, y2 + a*3, 1, 40, tocolor(255, 80, 0, 200/100*window.alpha))
		dxDrawRectangle(x2 + 200-1, y2 + a*3, 1, 40, tocolor(255, 80, 0, 200/100*window.alpha))
	elseif isHover(x2+470, y2 + a*3, 200, 40) then
		dxDrawRectangle(x2 + 470, y2 + a*3, 1, 40, tocolor(255, 80, 0, 200/100*window.alpha))
		dxDrawRectangle(x2 + 470 + 200-1, y2 + a*3, 1, 40, tocolor(255, 80, 0, 200/100*window.alpha))
	end
end

local function onClick(btn, btnSt)
	if window.render then
		if btn == "left" and btnSt == "down" then
			if isHover(x2, y2 + a*3, 200, 40) then
				triggerServerEvent("onClientBuyPatrolCan", me)
			elseif isHover(x2+470, y2 + a*3, 200, 40) then
				window.render = false
				removeEventHandler("onClientRender", root, renderFuelshop)
				showCursor(false, false)
			end
		end
	end
end
addEventHandler("onClientClick", root, onClick)

local function openFS1Panel()
	if not window.render then
		window.render = true
		addEventHandler("onClientRender", root, renderFuelshop)
	end
end
addEvent("onClientTogglePanel.fs1", true)
addEventHandler("onClientTogglePanel.fs1", root, openFS1Panel)