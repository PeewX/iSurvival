--iR|HorrorClown (PewX) - iRace-mta.de - 04.05.2014 --
local OCRAStd = dxCreateFont("files/fonts/ocrastd.ttf", 11/1080*y, false)

local killStreak, startCount = 0, 0
function renderTopInterface()
	local usernameWithoutColorcode = string.gsub(getPlayerName(me), "#%x%x%x%x%x%x", "")
	local username = getPlayerName(me)
	local kills = getElementData(me, "killedZombies") or "ERROR"
	local deaths = getElementData(me, "deaths") or "ERROR"
	dxDrawImage((x/2)-(720/2)/1920*x, 0, 720/1920*x, 100/1080*y, "files/images/environment/TopInterface.png")
	usernameTextWidth = dxGetTextWidth(usernameWithoutColorcode, 1, OCRAStd)
	dxDrawText(username, (x/2)-(usernameTextWidth/2), 52/1080*y, 720/1920*x, 20/1080*y, tocolor(155,155,155,255), 1, OCRAStd, "left", "top", false, false, false, true, false)
	
	--if kills and deaths then
		killsTextWidth = dxGetTextWidth(kills, 1, OCRAStd)
		deathsTextWidth = dxGetTextWidth(deaths, 1, OCRAStd)
		dxDrawText(kills, (x/2)-275/1920*x, 18/1080*y, killsTextWidth, 20, tocolor(0,255,0,255), 1, OCRAStd)
		dxDrawText(deaths, (x/2)+(275-deathsTextWidth)/1920*x, 18/1080*y, deathsTextWidth, 20, tocolor(255,0,0,255), 1, OCRAStd)
	--end
	
	if getSpecialZombieAiming() then
		local zombie = getSpecialZombieAiming()
		dxDrawText("???" .. zombie .. "???", 0, 90/1080*y, x, y, tocolor(255, 210, 0, 190), 1, OCRAStd, "center", "top")
	end
	
	if killStreak >= 1 then
		local progress = ((startCount + 2000)-getTickCount()) if progress > 2000 then progress = 2000 end local alpha = (255/2000)*progress
		dxDrawText(killStreak, 0, 110/1080*y, x, y, tocolor(255, 0, 0, alpha), 1, iFont[18], "center", "top")
	end
end

addEvent("showInterfaces", true)
function toggleTopInterface(value)
	if value == false then
		removeEventHandler("onClientRender", root, renderTopInterface)
	elseif value == true then
		addEventHandler("onClientRender", root, renderTopInterface)
	end
end
addEventHandler("showInterfaces", me, toggleTopInterface)

function getSpecialZombieAiming()
	if isPedAiming(me) then
		local target = getPedTarget(me)
		if target then
			if getElementType(target) == "ped" then
				local z = getElementModel(target)
				if z == 264 then
					return "The ultimative Clown Zombie"
				elseif z == 241 then
					return "The Zombie of life"
				elseif z == 242 then
					return "Zombie of darkness"
				elseif z == 243 then
					return "The soldier zombie"
				elseif z == 244 then
					return "Bloody BooM zombie"
				elseif z == 245 then
					return "The zombie of dynamite"
				end
			end
		end
	end
	return false
end


function addKill()
	killStreak = killStreak + 1
	if startCount == 0 then
		startCount = getTickCount()
		local function killRenderTimerTarget()
			if startCount + 2000 <= getTickCount() then
				removeEventHandler("onClientPreRender", root, killRenderTimerTarget)
				triggerServerEvent("updateClientKillStreak", me, killStreak)
				killStreak, startCount = 0, 0
			end 
		end
		addEventHandler("onClientPreRender", root, killRenderTimerTarget)
	else
		startCount = getTickCount()
	end
end

addEventHandler("onClientPedWasted", root, function(killer)
	if killer == me then if isPedZombie(source) then addKill() end end
end)