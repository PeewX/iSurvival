-- iR|HorrorClown (PewX) - 27.01.2014 --
local musicTable = {}
local music = {started = false, source = false, timer = false, enabled = true}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function()
		triggerServerEvent("onClientRequestMusic", me)
	end)


addEvent("onServerSendMusicTable", true)
addEventHandler("onServerSendMusicTable", me, function(tt)
	musicTable = tt
end)

function startBackgroundMusic()
	if not musicTable then return end
	if isElement(music.source) then stopSound(music.source) end
	if isTimer(music.timer) then killTimer(music.timer) end
	if not music.enabled then return end
	
	music.started = true
	local randomMusic = musicTable[math.random(1, #musicTable)]
	music.source = playSound("http://irace-mta.de/servermusic/isurvival/" .. randomMusic, false)
	setCurrentMusicTitle(randomMusic)
end

addEventHandler("onClientSoundStream", root, function(suc, length)
	if suc then
		music.timer = setTimer(startBackgroundMusic, (length*1000)+30000, 1) --Plus eine halbe Minute (30000 Millisekunden) Pause.
	else
		outputChatBox("Failed to play a background music. Try again in 30 seconds.")
		music.timer = setTimer(startBackgroundMusic, 30000, 1)
	end
end)

function toggleBackgroundMusic(state)
	if state then
		if not music.started then
			music.enabled = true
			startBackgroundMusic()
		end	
	else
		if isElement(music.source) then stopSound(music.source) end
		if isTimer(music.timer) then killTimer(music.timer) end
		music.started = false
		music.enabled = false
		setCurrentMusicTitle("n/A")
	end
end

function cancelRadioSwitch()
	cancelEvent()
	if getRadioChannel() ~= 0 then 
		setRadioChannel(0)
	end
end
addEventHandler("onClientPlayerRadioSwitch", root, cancelRadioSwitch)