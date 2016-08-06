local geigerSound, geigerTimer, SFLeaveState = false

addEvent("onClientLeaveSF", true)
addEventHandler("onClientLeaveSF", me, function()
	geigerSound = playSound("sounds/geiger_01.mp3", true)
	SFLeaveState = true
end)

addEvent("onClientEnterSF", true)
addEventHandler("onClientEnterSF", me, function()
	if isTimer(geigerTimer) then killTimer(geigerTimer) end
	stopSound(geigerSound)
	SFLeaveState = false
end)

function isPlayerLeaveSF()
	return SFLeaveState
end