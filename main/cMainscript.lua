-- iR|HorrorClown (PewX) - 05.02.2013 --
----------------------------------------
g_shaderDistance = 0

function stopPVP(attacker)
	if not attacker then return end
	if me == attacker then
		--nothing
	elseif getElementType(attacker) == "player" then--elseif isDamageFromPlayer(attacker) then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", me, stopPVP)

addEvent("onZombieEnterSafetyZone", true)
addEventHandler("onZombieEnterSafetyZone", root, function(x, y, z)
	createExplosion(x, y, z, 12, false, 0, false)
end)

function killSound()
	local sound = playSound("sounds/ding.mp3", false)
	setSoundVolume(sound, 0.5)
end
addEvent("playZombieKillSound", true)
addEventHandler("playZombieKillSound", me, killSound)

-- settings --
	number = 20 -- number of fireworks to launch (default = 150)
	height = 1.5 -- this is the velocity of the shell when launched (default = 1.8)
	randomness = 0.5 -- how far off vertical the fireworks can launch (default = 0.30)
	maxsize = 25 -- (default = 25) acual size of marker would be maxsize * 5 
-- settings ^^

resetdelay = number * 200
function CreateFireworks(fx,fy,fz)
		setTimer (function()
			delay = math.random(350,750)
			setTimer (function()
				local shell = createVehicle (594,fx,fy,fz)
				if isElement(shell) then
					setElementAlpha(shell,0)
					local flair = createMarker (fx,fy,fz,"corona",5,255, 255, 255, 255)
					attachElements(flair,shell)
					local smoke = createObject(2780,0,0,0)
					setElementCollidableWith (smoke,shell,false)
					setElementAlpha(smoke,0)
					attachElements (smoke,shell)
					setElementVelocity (shell, math.random(-2,2)*randomness, math.random(-2,2)*randomness,height)
					setTimer (function(shell,flair,smoke)
						local ex,ey,ez = getElementPosition(shell)
						createExplosion(ex,ey,ez,11, true, 2, false)
						setMarkerColor(flair,math.random(0,255),math.random(0,255),math.random(0,255),155)
						sizetime=math.random(7,maxsize)
						setTimer (function(shell,flair,smoke)
							if isElement(flair)then
								local size = getMarkerSize(flair)
								setMarkerSize(flair,size+5)
							end
							setTimer (function(shell,flair,smoke)
								if isElement(flair)then
									destroyElement(flair)
								end
								if isElement(shell) then
									destroyElement(shell)
								end
								if isElement(smoke) then
									destroyElement(smoke)
								end
							end,sizetime*100,1,shell,flair,smoke)
						end,100,sizetime,shell,flair,smoke)
					end,1400,1,shell,flair,smoke)
				end
			end,delay,1,vehicle)
		end,230,number,vehicle)
end
addEvent("ClientCreateFireworks",true)
addEventHandler( "ClientCreateFireworks", root, CreateFireworks)

addEvent("onClientStartAmoCounting", true)
addEventHandler("onClientStartAmoCounting", me, function()
	addEventHandler("onClientPlayerWeaponFire", root, function(weapon, _, _, _, _, _, hitElement)
		if source == me then
			triggerServerEvent("onPlayerWeaponFire", me, weapon, hitElement)
		end	
	end)
end)

local sX, sY = guiGetScreenSize()
local dT, render = {}, false
function createDarkness(x, y, z)
	local id = #dT + 1
	dT[id] = {}
	dT[id].pos = {x, y, z}
	dT[id].sT = getTickCount()
	dT[id].eT = dT[id].sT + 15000
end
addEvent("onClientCreateDarkness", true)
addEventHandler("onClientCreateDarkness", me, createDarkness)

local function render()
	local px, py, pz = getElementPosition(me)
	for i, d in ipairs(dT) do
		local x, y, z = unpack(d.pos)
		local distance = getDistanceBetweenPoints3D(x,y,z, px, py, pz)
		if distance < 80 then
			g_shaderDistance = distance
			toggleBlurShader(true)
			dxDrawRectangle(0, 0, sX, sY, tocolor(0, 0, 0, 255/80*(80-distance)), true)
		end
		if d.eT <= getTickCount() then table.remove(dT, i) toggleBlurShader(false) end
	end
end
addEventHandler("onClientHUDRender", root, render)

local tDiff = 0
addEvent("calcServerClientTimestampDiff", true)
addEventHandler("calcServerClientTimestampDiff", root, function(sT)
	local cT = getRealTime().timestamp
	tDiff = sT - cT
end)

function getSyncedTimestamp()
	local cT = getRealTime().timestamp
	return cT+(tDiff)
end

--[[addEventHandler("onClientResourceStart", resourceRoot, function()
	bindKey("n", "down", startBoost)
	bindKey("n", "up", stopBoost)
end)

local boostTimer
function startBoost (key, keyState)
  	local vehicle = getPlayerOccupiedVehicle (me)
	if (vehicle) then
		if getVehicleController(vehicle) == me then
			boostTimer = setTimer(startCarBoost, 50, 0, vehicle)
		end
	end
end

function stopBoost()
	if isTimer(boostTimer) then killTimer(boostTimer) end
end

local mul = 1.3
addCommandHandler("multi", function(_, a)
	outputChatBox("Multiplier is now: " .. a)
	mul = tonumber(a)
end)

function startCarBoost(vehicle)
	local vehSpeedX, vehSpeedY, vehSpeedZ = getElementVelocity ( vehicle )
	setElementVelocity ( vehicle, vehSpeedX*mul, vehSpeedY*mul, vehSpeedZ*mul)
	setElementHealth(vehicle, 1000)
end]]