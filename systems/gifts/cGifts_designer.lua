--iR|HorrorClown (PewX) - iRace-mta.de - 01.06.2014--
local i = {w = 0, h = 0}
local b = {w = 0, h = 0}
local theItem = ""

local nRotation = 0
local function renderGiftAnim()
	nRotation = nRotation + 1 if nRotation > 360 then nRotation = 0 end
	
	local bW, bH = b.w/1920*x, b.h/1080*y
	local iW, iH = i.w/1920*x, i.h/1080*y
	dxDrawImage(x/2-bW/2, y/2-bH/2, bW, bH, "files/images/gifts/image.png", nRotation, 0, 0, tocolor(255, 255, 255, 200))
	dxDrawImage(x/2-iW/2, y/2-iH/2, iW, iH, "files/images/gifts/" .. theItem .. ".png")
end

function reziseBG()
	local t = {}
	local function render()
		local progress = (getTickCount()-t.sT)/(t.eT-t.sT)
		b.w, b.h = interpolateBetween(t.sW, t.sH, 0, t.eW, t.eH, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	t.sT = getTickCount()
	t.eT = t.sT + 2500
	t.sW = 0
	t.sH = 0
	t.eW = 600
	t.eH = 600
	addEventHandler("onClientRender", root, render)
end

function reziseIcon()
	local t = {}
	local function render()
		local progress = (getTickCount()-t.sT)/(t.eT-t.sT)
		i.w, i.h = interpolateBetween(t.sW, t.sH, 0, t.eW, t.eH, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	t.sT = getTickCount()
	t.eT = t.sT + 2500
	t.sW = 0
	t.sH = 0
	t.eW = 256
	t.eH = 256
	addEventHandler("onClientRender", root, render)
end

function resizeOut()
	local t = {}
	local function render()
		local progress = (getTickCount()-t.sT)/(t.eT-t.sT)
		
		local bIW, bIH = unpack(t.sBWH)
		local iIW, iIH = unpack(t.sIWH)
		b.w, b.h = interpolateBetween(bIW, bIH, 0, 0, 0, 0, progress, "OutQuad")
		i.w, i.h = interpolateBetween(iIW, iIH, 0, 0, 0, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientRender", root, render) removeEventHandler("onClientRender", root, renderGiftAnim) end
	end
	
	t.sT = getTickCount()
	t.eT = t.sT + 1000
	t.sBWH = {b.w, b.h}
	t.sIWH = {i.w, i.h}
	addEventHandler("onClientRender", root, render)
end

addEvent("onClientShowSpecialWin", true)
addEventHandler("onClientShowSpecialWin", me, function(item)
	theItem = item
	addEventHandler("onClientRender", root, renderGiftAnim)
	reziseBG()
	setTimer(reziseIcon, 500, 1)
	setTimer(resizeOut, 10000, 1)
end)