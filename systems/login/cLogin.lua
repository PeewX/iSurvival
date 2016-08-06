-- iR|HorrorClown - 27.01.2014 --
---------------------------------
local intro = {logo = {alpha = 0}, bbHeight = 0, showIntro = true}
local showLoginIn = 52000

function onClientStart()
	loginmusic = playSound("http://irace-mta.de/servermusic/isurvival/loginmusic.mp3", false)
	showPlayerHudComponent("all", false)
	setSoundVolume(loginmusic, 1)
	showChat(false)
	fadeCamera(true, 22)
	showCursor(false)
	
	moveCamera(-1846.69, 633.11, 85.67, -1892.84, 544.98, 75.5, -2015.77, 314.88, 48.81, -1929.11, 270.46, 26.08, 20000)
	addMoveCamera(-1992, 244.16, 37.06, -2010.61, 147.09, 21.83, 10000)
	addMoveCamera(-2012.53, 205.44, 32.52, -1941.53, 138.79, 9.79, 10000)
	addMoveCamera(-2029.77, 95.86, 40.85, -1989.95, 186.52, 26.88, 13000)
	addMoveCamera(-2015.77, 314.88, 48.81, -1929.11, 270.46, 26.08, 180000)
	addEventHandler("onClientRender", root, renderIntro)
	
	if not intro.showIntro then showLoginIn = 5000 end

	setTimer(toggleBlackBars, 2000, 1, 130)
	setTimer(toggleLogoAlpha, 48000, 1 , 255)
	setTimer(toggleLogoAlpha, 52000, 1 , 0)
	setTimer(function() addEventHandler("onClientRender", root, renderWindow) toggleLoginAlpha(100)	end, showLoginIn, 1) --52000
end

addEventHandler("onClientResourceStart", resourceRoot, function() triggerServerEvent("onClientIntroPlay", me) end)

addEvent("onServerSendInfos", true)
addEventHandler("onServerSendInfos", me, function(ntbl, cS)
	setLoginNews(ntbl)
	if not toboolean(cS["showIntro"]) then intro.showIntro = false end
	--if not toboolean(cS["music"]) then toggleBackgroundMusic(false) end
	onClientStart()
end)

function renderIntro()
	dxDrawRectangle(0, 0, x, intro.bbHeight, tocolor(0, 0, 0))
	dxDrawRectangle(0, y - intro.bbHeight, x, intro.bbHeight, tocolor(0, 0, 0))
	if fileExists("files/images/environment/iSurvival.png") then
		dxDrawImage((x/2)-(492/2), (y/2)-(292/2), 492, 292, "files/images/environment/iSurvival.png", 0, 0, 0, tocolor(255, 255, 255, intro.logo.alpha))
	end
end

function toggleBlackBars(h)
	local tbl = {}
	local function render()
		local progress = (getTickCount()-tbl.sT)/(tbl.eT-tbl.sT)
		intro.bbHeight = interpolateBetween(tbl.sH, 0, 0, tbl.eH, 0, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientPreRender", root, render) end
	end
	
	tbl.sH = intro.bbHeight
	tbl.eH = h/1080*y
	tbl.sT = getTickCount()
	tbl.eT = tbl.sT + 2000
	addEventHandler("onClientPreRender", root, render)
end

function toggleLogoAlpha(al)
	local tbl = {}
	local function render()
		local progress = (getTickCount()-tbl.sT)/(tbl.eT-tbl.sT)
		intro.logo.alpha = interpolateBetween(tbl.sA, 0, 0, tbl.eA, 0, 0, progress, "OutQuad")
		if progress >= 1 then removeEventHandler("onClientPreRender", root, render) end
	end
	
	tbl.sA = intro.logo.alpha
	tbl.eA = al
	tbl.sT = getTickCount()
	tbl.eT = tbl.sT + 3000
	addEventHandler("onClientPreRender", root, render)
end