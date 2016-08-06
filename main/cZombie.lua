myZombies = { }
local _setElementData = setElementData
local _getElementData = getElementData

--helmetzombies = { 27, 51, 52, 99, 137, 153, 167, 205, 260, 277, 278, 279, 284, 285, 264, 287 }
ZombiePedSkins = {9, 10, 13, 14, 16, 20, 195, 196, 197, 199, 200, 203, 204, 205, 234, 235, 236, 237, 238, 241, 242, 243, 244, 245, 264}

local function setElementData(element, key, value, sync)
	return _setElementData(element, key, value, sync)
end

local function getElementData(element, key, inhernit)
	if inhernit == nil then inhernit = true end
	return _getElementData(element, key, inhernit)
end

--FORCES ZOMBIES TO MOVE ALONG AFTER THEIR TARGET PLAYER DIES
function playerdead ()
	setTimer(Zomb_release, 4000, 1)
end
addEventHandler("onClientPlayerWasted", me, playerdead)

function Zomb_release ()
	for k, ped in pairs( myZombies ) do
		if (isElement(ped)) then
			if (getElementData (ped, "zombie") == true) then
				setElementData ( ped, "target", nil )
				setElementData ( ped, "status", "idle" )
				table.remove(myZombies,k)
			end
		end
	end
end

--REMOVES A ZOMBIE FROM INFLUENCE AFTER ITS KILLED
function pedkilled ( killer, weapon, bodypart )
	if (getElementData (source, "zombie") == true) and (getElementData (source, "status") ~= "dead" ) then
		setElementData ( source, "target", nil )
		setElementData ( source, "status", "dead" )
	end
end
addEventHandler ( "onClientPedWasted", root, pedkilled )

--THIS CHECKS ALL ZOMBIES EVERY SECOND TO SEE IF THEY ARE IN SIGHT
function zombie_check ()
	if getElementData(me, "zProof") then return end
	if (getElementData (getLocalPlayer (), "zombie") ~= true) and ( isPlayerDead ( getLocalPlayer () ) == false ) then
		local zombies = getElementsByType ("ped",root,true)
		local Px,Py,Pz = getElementPosition( getLocalPlayer () )
		if isPedDucked ( getLocalPlayer ()) then
			local Pz = Pz-1
		end		
		for theKey,theZomb in ipairs(zombies) do
			if (isElement(theZomb)) then
				local Zx,Zy,Zz = getElementPosition( theZomb )
				if (getDistanceBetweenPoints3D(Px, Py, Pz, Zx, Zy, Zz) < 45 ) then
					if (getElementData (theZomb, "zombie") == true) then
						if ( getElementData ( theZomb, "status" ) == "idle" ) then --CHECKS IF AN IDLE ZOMBIE IS IN SIGHT
							local isclear = isLineOfSightClear (Px, Py, Pz+1, Zx, Zy, Zz +1, true, false, false, true, false, false, false) 
							if (isclear == true) then
								setElementData ( theZomb, "status", "chasing" )
								setElementData ( theZomb, "target", me )
								table.insert( myZombies, theZomb ) --ADDS ZOMBIE TO PLAYERS COLLECTION
								table.remove( zombies, theKey)
								zombieradiusalert (theZomb)
							end
						elseif (getElementData(theZomb,"status") == "chasing") and (getElementData(theZomb,"target") == nil) then --CHECKS IF AN AGGRESSIVE LOST ZOMBIE IS IN SIGHT
							local isclear = isLineOfSightClear (Px, Py, Pz+1, Zx, Zy, Zz +1, true, false, false, true, false, false, false) 
							if (isclear == true) then
								setElementData ( theZomb, "target", me )
								isthere = "no"
								for k, ped in pairs( myZombies ) do
									if ped == theZomb then
										isthere = "yes"
									end
								end
								if isthere == "no" then
									table.insert( myZombies, theZomb ) --ADDS THE WAYWARD ZOMBIE TO THE PLAYERS COLLECTION
									table.remove( zombies, theKey)
								end
							end
						elseif ( getElementData ( theZomb, "target" ) == me ) then --CHECKS IF AN ALREADY AGGRESSIVE ZOMBIE IS IN SIGHT
							local isclear = isLineOfSightClear (Px, Py, Pz+1, Zx, Zy, Zz +1, true, false, false, true, false, false, false) 
							if (isclear == false) then --IF YOUR ZOMBIE LOST YOU, MAKES IT REMEMBER YOUR LAST COORDS
								setElementData ( theZomb, "target", nil )
								triggerServerEvent ("onZombieLostPlayer", theZomb, oldPx, oldPy, oldPz)
							end
						end
					end
				end
			end
		end
	end
	for k, ped in pairs( myZombies ) do
		if (isElement(ped) == false) then
			table.remove( myZombies, k)
		end
	end
	oldPx,oldPy,oldPz = getElementPosition( getLocalPlayer () )
end


--INITAL SETUP

function clientsetupstarter(startedresource)
	setTimer ( clientsetup, 1234, 1)
	MainClientTimer1 = setTimer ( zombie_check, 1000, 0)  --STARTS THE TIMER TO CHECK FOR ZOMBIES
end
addEventHandler("onClientResourceStart", resroot, clientsetupstarter)

function clientsetup()
	oldPx,oldPy,oldPz = getElementPosition( getLocalPlayer () )
	--throatcol = createColSphere ( 0, 0, 0, .3)

	--ALL ZOMBIES STFU
	local zombies = getElementsByType ( "ped" )
	for theKey,theZomb in ipairs(zombies) do
		if (isElement(theZomb)) then
			if (getElementData (theZomb, "zombie") == true) then
				setPedVoice(theZomb, "PED_TYPE_DISABLED")
			end
		end
	end
	
	--SKIN REPLACEMENTS

	--[[for i, skin in ipairs(ZombiePedSkins) do
		local txd = engineLoadTXD("skins/" .. tostring(skin) .. ".txd", skin)
		engineImportTXD(txd, skin)
		if skin ~= 264 then
			local dff = engineLoadDFF("skins/" .. tostring(skin) .. ".dff", skin)
			engineReplaceModel(dff, skin)
		end
	end
	
	local txd = engineLoadTXD("skins/specialSkins/192.txd", 192)
	local dff = engineLoadDFF("skins/specialSkins/192.dff", 192)
	engineImportTXD(txd, 192)
	engineReplaceModel(dff, 192)
	
	local txd = engineLoadTXD("skins/specialSkins/82.txd", 82)
	local dff = engineLoadDFF("skins/specialSkins/82.dff", 82)
	engineImportTXD(txd, 82)
	engineReplaceModel(dff, 82)]]
end

--UPDATES PLAYERS COUNT OF AGGRESIVE ZOMBIES
addEventHandler ( "onClientElementDataChange", root,
function ( dataName )
	if getElementType ( source ) == "ped" and dataName == "status" then
		local thestatus = (getElementData ( source, "status" ))
		if (thestatus == "idle") or (thestatus == "dead") then		
			for k, ped in pairs( myZombies ) do
				if ped == source and (getElementData (ped, "zombie") == true) then
					setElementData ( ped, "target", nil )
					table.remove( myZombies, k)
					setElementData ( me, "dangercount", tonumber(table.getn( myZombies )) )
				end
			end
		end
	end
end )

--MAKES A ZOMBIE JUMP
addEvent( "Zomb_Jump", true )
function Zjump ( ped )
	if isElementStreamedIn(ped) then
		if (isElement(ped)) then
			setPedControlState(ped, "jump", true)
			setTimer(function (ped) if isElement(ped) then setPedControlState (ped, "jump", false) end end, 800, 1, ped)
		end
	end
end
addEventHandler( "Zomb_Jump", root, Zjump )

--MAKES A ZOMBIE PUNCH
addEvent( "Zomb_Punch", true )
function Zpunch ( ped )
	if isElementStreamedIn(ped) then
		if (isElement(ped)) then
			setPedControlState( ped, "fire", true )
			setTimer ( function (ped) if ( isElement ( ped ) ) then setPedControlState ( ped, "fire", false) end end, 800, 1, ped )
		end
	end
end
addEventHandler( "Zomb_Punch", root, Zpunch )

--MAKES A ZOMBIE STFU
addEvent( "Zomb_STFU", true )
function Zstfu ( ped )
	if (isElement(ped)) then
		setPedVoice(ped, "PED_TYPE_DISABLED")
	end
end
addEventHandler( "Zomb_STFU", root, Zstfu )

--MAKES A ZOMBIE MOAN
addEvent( "Zomb_Moan", true )
function Zmoan ( ped, randnum )
	if (isElement(ped)) then
		local Zx,Zy,Zz = getElementPosition( ped )
		local sound = playSound3D("sounds/zSound"..randnum..".mp3", Zx, Zy, Zz, false)
		setSoundMaxDistance(sound, 20)
	end
end
addEventHandler( "Zomb_Moan", root, Zmoan )

--ZOMBIE HEADSHOTS TO ALL BUT HELMETED ZOMBIES
function zombiedamaged(attacker, weapon, bodypart)
	if attacker ~= me then return end
	
	if getElementType (source) == "ped" then
		if getElementData (source, "zombie") then
			triggerServerEvent("onZombieDamage", source, attacker, weapon, bodypart)
		end
	end
end
addEventHandler("onClientPedDamage", root, zombiedamaged)

--ZOMBIES ATTACK FROM BEHIND AND GUI STUFF
function movethroatcol ()
	if isElement(throatcol) then
		local playerrot = getPedRotation ( getLocalPlayer () )
		local radRot = math.rad ( playerrot )
		local radius = 1
		local px,py,pz = getElementPosition( getLocalPlayer () )
		local tx = px + radius * math.sin(radRot)
		local ty = py + -(radius) * math.cos(radRot)
		local tz = pz
		setElementPosition ( throatcol, tx, ty, tz )
	end
end
addEventHandler ( "onClientRender", root, movethroatcol )

function choketheplayer ( theElement, matchingDimension )
	if not isElement(theElement) then return end
	if getElementType ( theElement ) == "ped" and ( isPlayerDead ( getLocalPlayer () ) == false ) then
		if ( getElementData ( theElement, "target" ) == getLocalPlayer () ) and (getElementData (theElement, "zombie") == true) then
			local px,py,pz = getElementPosition( getLocalPlayer () )
			--setTimer ( checkplayermoved, 600, 1, theElement, px, py, pz)
		end
	end
end
addEventHandler ( "onClientColShapeHit", root, choketheplayer)

function checkplayermoved (zomb, px, py, pz)
	if (isElement(zomb)) then
		local nx,ny,nz = getElementPosition( getLocalPlayer () )
		local distance = (getDistanceBetweenPoints3D (px, py, pz, nx, ny, nz))
		if (distance < .7) and ( isPlayerDead ( getLocalPlayer () ) == false ) then
			setElementData ( zomb, "status", "throatslashing" )
		end
	end
end

--ALERTS ANY IDLE ZOMBIES WITHIN A RADIUS OF 10 WHEN GUNSHOTS OCCUR OR OTHER ZOMBIES GET ALERTED
function zombieradiusalert (theElement)
	local Px,Py,Pz = getElementPosition( theElement )
	local zombies = getElementsByType ( "ped" )
	for theKey,theZomb in ipairs(zombies) do
		if (isElement(theZomb)) then
			if (getElementData (theZomb, "zombie") == true) then
				if ( getElementData ( theZomb, "status" ) == "idle" ) then
					local Zx,Zy,Zz = getElementPosition( theZomb )
					local distance = (getDistanceBetweenPoints3D (Px, Py, Pz, Zx, Zy, Zz))
					if (distance < 10) and ( isPlayerDead ( getLocalPlayer () ) == false ) then
						isthere = "no"
						for k, ped in pairs( myZombies ) do
							if ped == theZomb then
								isthere = "yes"
							end
						end
						if isthere == "no" and (getElementData (getLocalPlayer (), "zombie") ~= true) then
							if (getElementType ( theElement ) == "ped") then
								local isclear = isLineOfSightClear (Px, Py, Pz, Zx, Zy, Zz, true, false, false, true, false, false, false) 
								if (isclear == true) then
									setElementData ( theZomb, "status", "chasing" )
									setElementData ( theZomb, "target", getLocalPlayer () )
									table.insert( myZombies, theZomb ) --ADDS ZOMBIE TO PLAYERS COLLECTION
								end
							else
								setElementData ( theZomb, "status", "chasing" )
								setElementData ( theZomb, "target", getLocalPlayer () )
								table.insert( myZombies, theZomb ) --ADDS ZOMBIE TO PLAYERS COLLECTION
							end
						end
					end
				end
			end
		end
	end
end

function shootingnoise ( weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if alertspacer ~= 1 then
		if (weapon == 9) then
			alertspacer = 1
			setTimer ( resetalertspacer, 5000, 1 )
			zombieradiusalert(getLocalPlayer ())
		elseif (weapon > 21) and (weapon ~= 23) then
			alertspacer = 1
			setTimer ( resetalertspacer, 5000, 1 )
			zombieradiusalert(getLocalPlayer ())
		end
	end
	if hitElement then
		if (getElementType ( hitElement ) == "ped") then
			if (getElementData (hitElement, "zombie") == true) then			
				isthere = "no"
				for k, ped in pairs( myZombies ) do
					if ped == hitElement then
						isthere = "yes"
					end
				end
				if isthere == "no" and (getElementData (getLocalPlayer (), "zombie") ~= true) then
					setElementData ( hitElement, "status", "chasing" )
					setElementData ( hitElement, "target", getLocalPlayer () )
					table.insert( myZombies, hitElement ) --ADDS ZOMBIE TO PLAYERS COLLECTION
					zombieradiusalert (hitElement)
				end
			end
		end
	end
end
addEventHandler ( "onClientPlayerWeaponFire", getLocalPlayer (), shootingnoise )

function resetalertspacer ()
	alertspacer = nil
end

function choketheplayer ( theElement, matchingDimension )
	if getElementType ( theElement ) == "ped" and ( isPlayerDead ( getLocalPlayer () ) == false ) and (getElementData (theElement , "zombie") == true) then
        if ( getElementData ( theElement, "target" ) == getLocalPlayer () ) then
			local px,py,pz = getElementPosition( getLocalPlayer () )
			setTimer ( checkplayermoved, 600, 1, theElement, px, py, pz)
		end
    end
end

addEvent( "Spawn_Placement", true )
function Spawn_Place(xcoord, ycoord)
	local x,y,z = getElementPosition(me)
	local posx, posy = x+xcoord, y+ycoord
	local gz = getGroundPosition ( posx, posy, z+500 )
	triggerServerEvent ("onZombieSpawn", me, posx, posy, gz+1 )
end
addEventHandler("Spawn_Placement", root, Spawn_Place)

function isPedZombie(ped)
	if (isElement(ped)) then
		if (getElementData (ped, "zombie") == true) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function onDeadZombieSteamInOut()
	if getElementType(source) == "ped" then
		if isPedZombie(source) then
			if isPedDead(source) then
				destroyElement(source)
			end
		end
	end
end

addEventHandler("onClientElementStreamOut", root, onDeadZombieSteamInOut)
addEventHandler("onClientElementStreamIn", root, onDeadZombieSteamInOut)