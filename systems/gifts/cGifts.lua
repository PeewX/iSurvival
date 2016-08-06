local theGift, theMarker

addEvent("rotateGiftItem", true)
addEventHandler("rotateGiftItem", me, function(state, object)
	if state then
		theGift = object
		addEventHandler("onClientRender", root, rotateGifts)
		moveUpDown()
	end
end)

local startTick = getTickCount()
function rotateGifts()
	if isElement(theGift) then
		local angle = math.fmod((getTickCount() - startTick) * 360 / 3000, 360)
		setElementRotation(theGift, 0, 0, angle)
	else
		removeEventHandler("onClientRender", root, rotateGifts)
	end
end

local mT, st = {}, 0
function moveUpDown()
	mT = {}
	local function render()
		local progress = (getTickCount()-mT.sT)/(mT.eT-mT.sT)
		local height = interpolateBetween(mT.sH, 0, 0, mT.eH, 0, 0, progress, "InOutQuad")
		
		if not isElement(theGift) then removeEventHandler("onClientRender", root, rotateGifts) removeEventHandler("onClientRender", root, render) st = 0 end
		local x, y = getElementPosition(theGift)
		setElementPosition(theGift, x, y, height)
		if progress >= 1 then removeEventHandler("onClientRender", root, render) moveUpDown() end
	end
	
	if not isElement(theGift) then removeEventHandler("onClientRender", root, rotateGifts) removeEventHandler("onClientRender", root, render) st = 0 end
	local _, _, sH = getElementPosition(theGift)
	mT.sH = sH
	if st == 0 then
		mT.eH = mT.sH + 0.3
		st = 1
	else
		mT.eH = mT.sH - 0.3
		st = 0
	end
	mT.sT = getTickCount()
	mT.eT = mT.sT + 2000
	addEventHandler("onClientRender", root, render)
end