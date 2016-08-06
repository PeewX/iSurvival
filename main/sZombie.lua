local _setElementData = setElementData
local _getElementData = getElementData

local function setElementData(element, key, value, sync)
	if not isElement(element) then
		outputConsole(debug.traceback())
		return
	end
	return _setElementData(element, key, value, sync)
end

local function getElementData(element, key, inhernit)
	if not isElement(element) then
		outputConsole(debug.traceback())
		return
	end
	if inhernit == nil then inhernit = true end
	return _getElementData(element, key, inhernit)
end
-----------------------------------------------------------------------------------------------------------------------------------------
ZombiePedSkins = {9, 10, 13, 14, 16, 20, 195, 196, 197, 199, 200, 203, 204, 205, 234, 235, 236, 237, 238, 241, 242, 243, 244, 245, 264}
local normalZombies = {9, 10, 13, 14, 16, 20, 195, 196, 197, 199, 200, 203, 204, 205, 234, 235, 236, 237, 238}
local specialZombies = {241, 242, 243, 244, 245, 264}

addEvent("onServerSettings")
addEventHandler("onServerSettings", root, function()
	if getSettingValue("ZombieSpeed") == 0 then --super slow zombies (goofy looking)
		chaseanim = "WALK_drunk"
		checkspeed = 2000
	elseif getSettingValue("ZombieSpeed") == 1 then -- normal speed
		chaseanim = "run_old"
		checkspeed = 1000
	elseif getSettingValue("ZombieSpeed") == 2 then -- rocket zombies (possibly stressful on server)
		chaseanim = "Run_Wuzi"
		checkspeed = 680
	else -- defaults back to normal
		chaseanim = "run_old"
		checkspeed = 1000
	end
end)

moancount = 0
moanlimit = 10
everyZombie = { }

--IDLE BEHAVIOUR OF A ZOMBIE
function Zomb_Idle (ped)
	if isElement(ped) then
		if ( getElementData ( ped, "status" ) == "idle" ) and ( isPedDead ( ped ) == false ) and (getElementData (ped, "zombie") == true) then
			local action = math.random( 1, 6 )
			if action < 4 then -- walk a random direction
				local rdmangle = math.random( 1, 359 )
				setPedRotation( ped, rdmangle )
				setPedAnimation ( ped, "PED", "Player_Sneak", -1, true, true, true)
				setTimer ( Zomb_Idle, 7000, 1, ped )
			elseif action == 4 then -- get on the ground
				setPedAnimation ( ped, "MEDIC", "cpr", -1, false, true, true)
				setTimer ( Zomb_Idle, 4000, 1, ped )
			elseif action == 5 then -- stand still doing nothing
				setPedAnimation ( ped )
				setTimer ( Zomb_Idle, 4000, 1, ped )
			end
		end
	end
end

--BEHAVIOUR WHILE CHASING PLAYERS
function Zomb_chase (ped, Zx, Zy, Zz )
	if isElement(ped) then
		if (getElementData ( ped, "status" ) == "chasing") and (getElementData (ped, "zombie") == true) then
			local x, y, z = getElementPosition( ped )
			if (getElementData ( ped, "target" ) == nil) and getElementData ( ped, "Tx" ) ~= false then			
				local Px = getElementData ( ped, "Tx" )
				local Py = getElementData ( ped, "Ty" )
				local Pz = getElementData ( ped, "Tz" )
				local Pdistance = (getDistanceBetweenPoints3D( Px, Py, Pz, x, y, z ))
				if (Pdistance < 1.5 ) then
					setTimer ( function (ped) if ( isElement ( ped ) ) then setElementData ( ped, "status", "idle" ) end end, 2000, 1, ped )
				end
			end
			local distance = (getDistanceBetweenPoints3D( x, y, z, Zx, Zy, Zz ))			
			if (distance < 1 ) then -- IF THE PED HASNT MOVED
				if (getElementData ( ped, "target" ) == nil) then
					local giveup = math.random( 1, 15 )
					if giveup == 1 then
						setElementData ( ped, "status", "idle" )
					else
						local action = math.random( 1, 2 )
						if action == 1 then
							setPedAnimation ( ped )
							triggerClientEvent ( "Zomb_Punch", root, ped )
							setTimer ( function (ped) if ( isElement ( ped ) ) then setPedAnimation ( ped, "ped", chaseanim, -1, true, true, true ) end end, 800, 1, ped )
							setTimer ( Zomb_chase, 2000, 1, ped, x, y, z )
						elseif action == 2 then
							setPedAnimation ( ped )
							triggerClientEvent ( "Zomb_Jump", root, ped )
							setTimer ( Zomb_chase, 3500, 1, ped, x, y, z )
						end
					end
				else 
					local Ptarget = (getElementData ( ped, "target" ))
					if isElement(Ptarget) then
						local Px, Py, Pz = getElementPosition( Ptarget )
						local Pdistance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
						if (Pdistance < 1.2 ) then -- ATTACK A PLAYER IF THEY ARE CLOSE
							if ( isPedDead ( Ptarget ) ) then --EAT A DEAD PLAYER
								setPedAnimation ( ped )
								setPedAnimation ( ped, "MEDIC", "cpr", -1, false, true, false)
								setTimer ( function (ped) if ( isElement ( ped ) ) then setElementData ( ped, "status", "idle" ) end end, 10000, 1, ped )
								setTimer ( function (ped) if ( isElement ( ped ) ) then setPedRotation ( ped, getPedRotation(ped)-180) end end, 10000, 1, ped )
								zmoan(ped)
							else
								local action = math.random( 1, 6 )
								if action == 1 then
									setPedAnimation ( ped)
									triggerClientEvent ( "Zomb_Jump", root, ped )
									setTimer ( Zomb_chase, 2000, 1, ped, x, y, z )
								else
									setPedAnimation ( ped)
									triggerClientEvent ( "Zomb_Punch", root, ped )
									setTimer ( function (ped) if ( isElement ( ped ) ) then setPedAnimation ( ped, "ped", chaseanim, -1, true, true, true ) end end, 800, 1, ped )
									setTimer ( Zomb_chase, 2000, 1, ped, x, y, z )
								end
							end
						else
							if ( isPedDead (Ptarget) ) then
							setTimer ( function (ped) if ( isElement ( ped ) ) then setElementData ( ped, "status", "idle" ) end end, 2000, 1, ped )
							setTimer ( function (ped) if ( isElement ( ped ) ) then setPedRotation ( ped, getPedRotation(ped)-180) end end, 1800, 1, ped )
							else
								local action = math.random( 1, 2 )
								if action == 1 then
									setPedAnimation ( ped)
									triggerClientEvent ( "Zomb_Punch", root, ped )
									setTimer ( function (ped) if ( isElement ( ped ) ) then setPedAnimation ( ped, "ped", chaseanim, -1, true, true, true ) end end, 800, 1, ped )
									setTimer ( Zomb_chase, 2000, 1, ped, x, y, z )
								elseif action == 2 then
									setPedAnimation ( ped)
									triggerClientEvent ( "Zomb_Jump", root, ped )
									setTimer ( Zomb_chase, 2000, 1, ped, x, y, z )
								end
							end
						end
					else
						setElementData ( ped, "status", "idle" )
					end
				end
			else
				setPedAnimation ( ped, "ped", chaseanim, -1, true, true, true) --KEEP WALKING
				setTimer ( Zomb_chase, checkspeed, 1, ped, x, y, z ) --CHECK AGAIN
			end
		end
	end
end

--SET THE DIRECTION OF THE ZOMBIE
function setangle ()
	for theKey,ped in ipairs(everyZombie) do
		if isElement(ped) then
			if ( getElementData ( ped, "status" ) == "chasing" ) then
				local x, y, z, px, py, pz
				if ( getElementData ( ped, "target" ) ~= nil ) then
					local ptarget = getElementData ( ped, "target" )
					if isElement(ptarget) then
						x, y, z = getElementPosition( ptarget )
						px, py, pz = getElementPosition( ped )
					else
						setElementData ( ped, "status", "idle" )
						x, y, z = getElementPosition( ped )
						px, py, pz = getElementPosition( ped )
					end
					zombangle = ( 360 - math.deg ( math.atan2 ( ( x - px ), ( y - py ) ) ) ) % 360 --MAGIC SPELL TO MAKE PEDS LOOK AT YOU
					setPedRotation( ped, zombangle )
				elseif ( getElementData ( ped, "target" ) == nil ) and (getElementData ( ped, "Tx" ) ~= false) then --IF THE PED IS AFTER THE PLAYERS LAST KNOWN WHEREABOUTS
					x = getElementData ( ped, "Tx" )
					y = getElementData ( ped, "Ty" )
					z = getElementData ( ped, "Tz" )
					px, py, pz = getElementPosition( ped )
					zombangle = ( 360 - math.deg ( math.atan2 ( ( x - px ), ( y - py ) ) ) ) % 360 --MAGIC SPELL TO MAKE PEDS LOOK AT YOU
					setPedRotation( ped, zombangle )
				end
			end
		end
	end
end

--SETS THE ZOMBIE ACTIVITY WHEN STATUS CHANGES
addEventHandler ( "onElementDataChange", root,
function ( dataName )
	if getElementType ( source ) == "ped" and dataName == "status" then
		if (getElementData (source, "zombie") == true) then
			if ( isPedDead ( source ) == false ) then
				if (getElementData ( source, "status" ) ==  "chasing" ) then
					local Zx, Zy, Zz = getElementPosition( source )
					setTimer ( Zomb_chase, 1000, 1, source, Zx, Zy, Zz )
					local newtarget = (getElementData ( source, "target" ))
					if isElement (newtarget) then
						if getElementType ( newtarget ) == "player" then
							setElementSyncer ( source, newtarget )
						end
					end
					zmoan(source)
				elseif (getElementData ( source, "status" ) ==  "idle" ) then
					setTimer ( Zomb_Idle, 1000, 1, source)
				elseif (getElementData ( source, "status" ) ==  "throatslashing" ) then
					local tx,ty,tz = getElementPosition( source )
					local ptarget = getElementData ( source, "target" )
					if isElement(ptarget) then
						local vx,vy,vz = getElementPosition( ptarget )
						local zombdistance = (getDistanceBetweenPoints3D (tx, ty, tz, vx, vy, vz))
						if (zombdistance < .8) then
							zmoan(source)
							setPedAnimation ( source, "knife", "KILL_Knife_Player", -1, false, false, true)
							setPedAnimation ( ptarget, "knife", "KILL_Knife_Ped_Damage", -1, false, false, true)
							setTimer ( Playerthroatbitten, 2300, 1, ptarget, source) 
							setTimer ( function (source) if ( isElement ( source ) ) then setElementData ( source, "status", "idle" ) end end, 5000, 1, source )
						else
							setElementData ( source, "status", "idle" )
						end
					else
						setElementData ( source, "status", "idle" )
					end
				end
			elseif (getElementData ( source, "status" ) ==  "dead" ) then
				setTimer (Zomb_delete, 30000, 1, source)
			end
		end
	end
end)

--RESOURCE START/INITIAL SETUP
function initialiseZombieResource()
		for pKey,thep in ipairs(getElementsByType"player") do
			setElementData ( thep, "dangercount", 0 )
		end	
		
		for _, playerValue in ipairs(getAlivePlayers()) do
			setElementData ( playerValue, "alreadyspawned", true  )
		end
		
		if getSettingValue("ZombieSpeed") == 2 then
			MainTimer1 = setTimer ( setangle, 200, 0) -- KEEPS ZOMBIES FACING THE RIGHT DIRECTION (fast)
		else
			MainTimer1 = setTimer ( setangle, 400, 0) -- KEEPS ZOMBIES FACING THE RIGHT DIRECTION
		end
		MainTimer3 = setTimer(clearFarZombies, 30000, 0) --KEEPS ALL THE ZOMBIES CLOSE TO PLAYERS
		
		if getSettingValue("ZombieStreaming") == 1 then
			MainTimer2 = setTimer(SpawnZombie, 2500, 0 ) --Spawns zombies in random locations
		elseif getSettingValue("ZombieStreaming") == 2 then
			MainTimer2 = setTimer(SpawnpointZombie, 2500, 0 ) --spawns zombies in zombie spawnpoints
		end
end

function player_Connect()
	setElementData ( source, "dangercount", 0 )
end
addEventHandler ( "onPlayerConnect", root, player_Connect )

function WoodSetup()
	local allcols = getElementsByType ( "colshape" ) --clears off old wood cols
	for colKey, colValue in ipairs(allcols) do
		if ( getElementData ( colValue, "purpose" ) =="zombiewood" ) then
			destroyElement(colValue)
		end
	end	
	local allobjects = getElementsByType ( "object" ) --SETS UP ALL THE WOOD BARRIERS
	for objectKey, objectValue in ipairs(allobjects) do
		if ( getElementData ( objectValue, "purpose" ) =="zombiewood" ) then
			setElementDimension ( objectValue, 26 )
			local x,y,z = getElementPosition( objectValue )
			local thecol = createColSphere ( x, y, z, 1.6 )
			setElementData ( thecol, "purpose", "zombiewood" )
			setElementParent ( thecol, objectValue )
		end
	end	
end

function ReduceMoancount()
	moancount = moancount-1
end

function zmoan(zombie)
	if moancount < moanlimit then
		moancount = moancount+1
		local randnum = math.random( 1, 10 )
		triggerClientEvent ( "Zomb_Moan", root, zombie, randnum )
		setTimer ( ReduceMoancount, 2000, 1 )
	end
end

--CLEARS A DEAD ZOMBIE
function Zomb_delete (ped)
	if isElement(ped) then
		if (getElementData (ped, "zombie") == true) then
			for theKey,thePed in ipairs(everyZombie) do
				if ped == thePed then
					table.remove( everyZombie, theKey )
					break
				end
			end
			destroyElement ( ped )
		end
	end
end

--HEADSHOTS
--[[addEvent( "headboom", true )
function Zheadhit ( ped,attacker, weapon, bodypart, zskin)
	if (getElementData (ped, "zombie") == true) then
		killPed ( ped, attacker, weapon, bodypart )
		setPedHeadless  ( ped, true )
	end
end
addEventHandler( "headboom", root, Zheadhit )]]

local wDT = {[8] = 70, [9] = 500, [24] = 70, [25] = 70, [26] = 70, [27] = 70, [33] = 80, [34] = 100}
function getWeaponDamage(w)
	if wDT[w] then return wDT[w] else return false end
end

function zombieHeadKill(ped, attacker, weapon, bodypart)
	killPed(ped, attacker, weapon, bodypart)
	setPedHeadless(ped, true)
end

function reduceZombieHealth(ped, attacker, weapon, bodypart)
	local wD = getWeaponDamage(weapon)
	if not wD then return end
	
	local health = getElementHealth(ped) - wD
	if health <= 0 then
		killPed(ped, attacker, weapon, bodypart)
	else
		setElementHealth(ped, health)
	end
end

addEvent("onZombieDamage", true)
addEventHandler("onZombieDamage", root, function(attacker, weapon, bodypart)
	if not checkClient(client, attacker, "onZombieDamage") then return end
	if getElementType(source) ~= "ped" then return end
	if not getElementData(source, "zombie") then return end
	
	if getElementSyncer(source) ~= attacker then setElementSyncer(source, attacker) end
	local special = false

	local zskin = getElementModel(source)
	for k, skin in ipairs(specialZombies) do
		if skin == zskin then special = true end
	end
	
	if bodypart == 9 and not special then 											--Instant Kill bei Headshot nud normaler Zombie
		zombieHeadKill(source, attacker, weapon, bodypart)
	elseif weapon == 8 and not special then 										--Instant Kill bei Katana und normaler Zombie
		zombieHeadKill(source, attacker, weapon, bodypart)
	elseif (weapon == 25 or weapon == 26 or weapon == 27) and bodypart == 9 then 	--Instant Kill bei Headshot mit Shotgun
		zombieHeadKill(source, attacker, weapon, bodypart)
	else																			--Special weapons without Headshot
		reduceZombieHealth(source, attacker, weapon, bodypart)
	end
end)

--KILL FROM ZOMBIE ATTACK
addEvent( "playereaten", true )
function Playerinfected ( player, attacker, weapon, bodypart)
	if checkClient(client, player, "playereaten") then
		killPed (player, attacker, weapon, bodypart)
	end
end
addEventHandler( "playereaten", root, Playerinfected )

addEventHandler("onPlayerDamage", root, function(attacker, weapon, bodypart)
	if isPedZombie(attacker) then
		local pArmor = getPedArmor(source)
		if pArmor > 0 then
			local pArmor = pArmor - math.random(1,12)
			if pArmor > 0 then
				setPedArmor(source, pArmor)
			else
				setPedArmor(source, 0)
			end
		else
			local pHealth = getElementHealth(source) - math.random(5, 30)
			if pHealth <= 0 then
				killPed (source, attacker, weapon, bodypart)
			else
				setElementHealth(source, pHealth)
			end
		end
	end
end)

--CHECKS FOR ZOMBIE GRABBING FROM BEHIND
function Playerthroatbitten ( player, attacker)
	local Zx, Zy, Zz = getElementPosition( attacker )
	local Px, Py, Pz = getElementPosition( player )
	local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
	if (distance < 1) then
		killPed ( player, attacker, weapon, bodypart )
	else
		setPedAnimation(player, false)
	end
end

--TRIGGER EVENT IF ZOMBIE WASTED
function deanimated( ammo, attacker, weapon, bodypart )
	if (attacker) then
		if (getElementType ( attacker ) == "player") and (getElementType ( source ) == "ped") then
			if (getElementData (source, "zombie") == true) then
				setElementCollisionsEnabled(source, false)
				triggerEvent ( "onZombieWasted", source, attacker, weapon, bodypart )
			end
		end
	end
end
addEventHandler("onPedWasted", resroot, deanimated)

--STUFF TO ALLOW PLAYERS TO PLACE BOARDS
function boarditup( player, key, keyState )
	local rightspot = 0
	local allcols = getElementsByType ( "colshape" )
	for ColKey,theCol in ipairs(allcols) do
		if (getElementData ( theCol, "purpose" ) == "zombiewood" ) then
			if (isElementWithinColShape ( player, theCol )) then
				local rightcol = theCol
				local Cx, Cy, Cz = getElementPosition( rightcol )
				local Bx, By, Bz = getElementPosition( player )
				woodangle = ( 360 - math.deg ( math.atan2 ( ( Cx - Bx ), ( Cy - By ) ) ) ) % 360
				setPedRotation( player, woodangle )
				setPedAnimation(player, "riot", "RIOT_PUNCHES", 3000, true, true, true )
				local wx, wy, wz = getElementPosition( player )
				setTimer( doneboarding, 2000, 1, player, rightcol, wx, wy, wz )
			end
		end
	end
end
--addCommandHandler ( "construct", boarditup )
	
function doneboarding(player, rightcol, wx, wy, wz)
	setPedAnimation(player)
	local newx, newy, newz = getElementPosition( player )
	local distance = (getDistanceBetweenPoints3D( wx, wy, wz, newx, newy, newz ))			
	if (distance < .7 ) then
		newwood = getElementParent ( rightcol )
		setElementDimension ( newwood, 25 )
		setTimer( setElementDimension, 50, 1, newwood, 0)
	end
end


--SPAWN ZOMBIE (now can be cancelled!)

addEvent( "onZombieSpawn", true )
function RanSpawn_Z(gx, gy, gz, rot)
	if isElementInSafetyZone(gx, gy, gz) then return end
	if table.getn(everyZombie) < getSettingValue("ZombieLimit") then
		if not rot then	rot = math.random (1,360) end
		local rnd = math.random(1, 100)
		if rnd <= 90 then
			rndSkin = normalZombies[math.random(1, #normalZombies)]
		else
			rndSkin = specialZombies[math.random(1, #specialZombies)]
		end

		local zomb = createPed(rndSkin, gx, gy, gz, rot)
		if zomb ~= false then
			setElementData ( zomb, "zombie", true  )
			table.insert( everyZombie, zomb )	
			setTimer ( function (zomb) if ( isElement ( zomb ) ) then setPedAnimation ( zomb, "ped", chaseanim, -1, true, true, true ) end end, 1000, 1, zomb )
			setTimer ( function (zomb) if ( isElement ( zomb ) ) then setElementData ( zomb, "status", "idle" ) end end, 2000, 1, zomb )
			triggerClientEvent ( "Zomb_STFU", root, zomb )
		end
	end
end
addEventHandler( "onZombieSpawn", root, RanSpawn_Z )


--SPAWNS ZOMBIES RANDOMLY NEAR PLAYERS
function SpawnZombie ()
	local pacecount = 0
	while pacecount < 2 do	--3 ZOMBIES AT A TIME TO PREVENT FPS DROP
		if (table.getn( everyZombie )+pacecount < getSettingValue("ZombieLimit") ) and (getSettingValue("ZombieStreaming") == 1) then	
			local xcoord, ycoord = 0, 0

			if math.random(1,2) == 1 then xcoord = math.random(15,40) else xcoord = math.random(-40,-15) end
			if math.random(1,2) == 1 then ycoord = math.random(15,40) else ycoord = math.random(-40,-15) end
			
			local alivePlayers = getLoggedInPlayers()
			if #alivePlayers > 0 then
				local lowestcount = 99999
				local lowestguy = nil
				for _, thePlayer in ipairs(alivePlayers) do
					if not isElementInSafetyZone(getElementPosition(thePlayer)) then
						if isElement(thePlayer) then
							if not isPedDead(thePlayer) then
								if (getElementData (thePlayer, "dangercount")) and (getElementData(thePlayer, "alreadyspawned" ) == true) then
									if (getElementData (thePlayer, "dangercount") < lowestcount) then
										lowestguy = thePlayer
										lowestcount = getElementData (thePlayer, "dangercount")
									end
								end
							end
						end
					end
				end
				pacecount = pacecount+1
				if isElement(lowestguy) then
					triggerClientEvent ( "Spawn_Placement", lowestguy, ycoord, xcoord )
				else
					pacecount = pacecount+1
				end
			else
				pacecount = pacecount+1
			end
		else
			pacecount = pacecount+1
		end
	end
end

--SPAWNS ZOMBIES IN SPAWNPOINTS NEAR PLAYERS
function SpawnpointZombie ()
	local pacecount = 0
	while pacecount < 6 do	--5 ZOMBIES AT A TIME TO PREVENT FPS DROP
		if (table.getn( everyZombie )+pacecount < getSettingValue("ZombieLimit") ) and (getSettingValue("ZombieStreaming") == 2) then	
			local liveplayers = getAlivePlayers ()
			if (table.getn( liveplayers ) > 0 ) then
				local lowestcount = 99999
				local lowestguy = nil
				for PKey,thePlayer in ipairs(liveplayers) do --THIS PART GETS THE PLAYER WITH THE LEAST ZOMBIES ATTACKING
					if (getElementData (thePlayer, "dangercount")) and (getElementData(thePlayer, "zombieProof") ~= true) then
						if (getElementData (thePlayer, "dangercount") < lowestcount) then
							lowestguy = thePlayer
							lowestcount = getElementData (thePlayer, "dangercount")
						end
					end
				end
				if isElement(lowestguy) then
					local zombiespawns = { }
					local possiblezombies = getElementsByType ( "Zombie_spawn" )
					local Px, Py, Pz = getElementPosition( lowestguy )
					for ZombKey,theZomb in ipairs(possiblezombies) do
						local Zx, Zy, Zz = getElementPosition( theZomb )
						local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
						if (distance < 8) then
							table.remove( possiblezombies, ZombKey) --IF SPAWN IS TOO CLOSE TO ANY PLAYER
						end
					end
					local Px, Py, Pz = getElementPosition( lowestguy )
					for ZombKey2,theZomb2 in ipairs(possiblezombies) do
						local Zx, Zy, Zz = getElementPosition( theZomb2 )
						local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
						if (distance < 60) then --AS LONG AS THE SPAWN IS CLOSE ENOUGH TO A PLAYER
							table.insert( zombiespawns, theZomb2 )
						end
					end
					if (table.getn( zombiespawns ) >0 ) then--IF THE LOWEST PLAYER HAS ANY CLOSE SPAWNS,USE ONE
						local random = math.random ( 1, table.getn ( zombiespawns ) )
						local posX = getElementData(zombiespawns[random], "posX") 
						local posY = getElementData(zombiespawns[random], "posY") 
						local posZ = getElementData(zombiespawns[random], "posZ")
						local rot = getElementData(zombiespawns[random], "rotZ")
						pacecount = pacecount+1
						triggerEvent ( "onZombieSpawn",zombiespawns[random], posX, posY, posZ, rot )			
					else--IF THE LOWEST PLAYERS DOESNT HAVE ANY SPAWNS, THEN SEE IF ANYONE HAS ANY
						local zombiespawns = { }
						local possiblezombies = getElementsByType ( "Zombie_spawn" )
						local allplayers = getAlivePlayers ()
						for theKey,thePlayer in ipairs(allplayers) do
							local Px, Py, Pz = getElementPosition( thePlayer )
							for ZombKey,theZomb in ipairs(possiblezombies) do
								local Zx, Zy, Zz = getElementPosition( theZomb )
								local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
								if (distance < 8) then
									table.remove( possiblezombies, ZombKey) --IF SPAWN IS TOO CLOSE TO ANY PLAYER
								end
							end
						end
						for theKey,thePlayer in ipairs(allplayers) do
							local Px, Py, Pz = getElementPosition( thePlayer )
							for ZombKey2,theZomb2 in ipairs(possiblezombies) do
								local Zx, Zy, Zz = getElementPosition( theZomb2 )
								local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
								if (distance < 60) then --AS LONG AS THE SPAWN IS CLOSE ENOUGH TO A PLAYER
									table.insert( zombiespawns, theZomb2 )
								end
							end
						end
						if (table.getn( zombiespawns ) >1 ) then
							local random = math.random ( 1, table.getn ( zombiespawns ) )
							local posX = getElementData(zombiespawns[random], "posX") 
							local posY = getElementData(zombiespawns[random], "posY") 
							local posZ = getElementData(zombiespawns[random], "posZ")
							local rot = getElementData(zombiespawns[random], "rotZ")
							pacecount = pacecount+1
							triggerEvent ( "onZombieSpawn",zombiespawns[random], posX, posY, posZ, rot )			
						else
							pacecount = pacecount+1
						end
					end
				else
					pacecount = pacecount+1
				end
			else
				pacecount = pacecount+1
			end
		else
			pacecount = pacecount+1
		end
	end
end

--DELETES ZOMBIES THAT ARE TOO FAR FROM ANY PLAYERS TO KEEP THEM MORE CONCENTRATED WHILE STREAMING ZOMBIES
function clearFarZombies ()
	if getSettingValue("ZombieLimit") ~= false then
		local toofarzombies = {}
		
		for ZombKey,theZomb in ipairs(everyZombie) do
			if isElement(theZomb) then
				if (getElementData (theZomb, "zombie") == true) then
					far = 1
					local Zx, Zy, Zz = getElementPosition( theZomb )
					
					for _,thePlayer in ipairs(getElementsByType"player") do
						local Px, Py, Pz = getElementPosition( thePlayer )
						if not isElementInSafetyZone(Px, Py, Pz) then
							if getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ) < 75 then
								far = 0
							end
						end
					end
					
					if far == 1 then
						table.insert( toofarzombies, theZomb )
					end
				end
			else
				table.remove( everyZombie, ZombKey )
			end
		end
		if (table.getn( toofarzombies ) >1 ) then
			for ZombKey,theZomb in ipairs(toofarzombies) do
				if (getElementData (theZomb, "zombie") == true) and  ( getElementData ( theZomb, "forcedtoexist" ) ~= true) then
					Zomb_delete(theZomb)
				end
			end
		end
	end
end

-- DESTROYS UP TO 13 ZOMBIES THAT ARE IDLE WHEN A PLAYER SPAWNS (TO FORCE NEW ZOMBIES TO SPAWN NEAR THE NEW GUY)
function player_Spawn ()
	if getSettingValue("ZombieStreaming") == 1 or getSettingValue("ZombieStreaming") == 2 then
		local relocatecount = 0
		for ZombKey,theZomb in ipairs(everyZombie) do
			if relocatecount < 14 then
				if ( getElementData ( theZomb, "forcedtoexist" ) ~= true) then
					if ( getElementData ( theZomb, "status" ) == "idle" ) and ( isPedDead ( theZomb ) == false ) and (getElementData (theZomb, "zombie") == true) then
						relocatecount = relocatecount+1
						Zomb_delete(theZomb)
					end
				end
			end
		end
	end
	if ( getElementData ( source, "alreadyspawned" ) ~= true) then
		setElementData ( source, "alreadyspawned", true  )
	end
end
addEventHandler ( "onPlayerSpawn", root, player_Spawn )

--EXPORTED FUNCTIONS!!!!!!!!!!!!!!
function createZombie ( x, y, z, rot, skin, interior, dimension )
	if (table.getn( everyZombie ) < getSettingValue("ZombieLimit") ) then
	--this part handles the args
		if not x then return false end
		if not y then return false end
		if not z then return false end
		if not rot then
			rot = math.random (1,359)
		end
		if not skin then
			randomZskin = math.random ( 1, table.getn ( ZombiePedSkins ) )			
			skin = ZombiePedSkins[randomZskin]
		end
		if not interior then interior = 0 end
		if not dimension then dimension = 0 end
	--this part spawns the ped
		local zomb = createPed (tonumber(skin),tonumber(x),tonumber(y),tonumber(z))--spawns the ped
	--if successful, this part applies the zombie settings/args
		if (zomb ~= false) then
			setTimer ( setElementInterior, 100, 1, zomb, tonumber(interior)) --sets interior
			setTimer ( setElementDimension, 100, 1, zomb, tonumber(dimension)) --sets dimension
			setElementData ( zomb, "zombie", true  )
			setElementData ( zomb, "forcedtoexist", true  )
			setTimer ( function (zomb, rot) if ( isElement ( zomb ) ) then setPedRotation ( zomb, rot ) end end, 500, 1, zomb, rot )
			setTimer ( function (zomb) if ( isElement ( zomb ) ) then setElementData ( zomb, "status", "idle" ) end end, 2000, 1, zomb )
			setTimer ( function (zomb) if ( isElement ( zomb ) ) then setElementData ( zomb, "forcedtoexist", true ) end end, 1000, 1, zomb )
			setTimer ( function (zomb) if ( isElement ( zomb ) ) then table.insert( everyZombie, zomb ) end end, 1000, 1, zomb )
			triggerClientEvent ( "Zomb_STFU", root, zomb )
			return zomb --returns the zombie element
		else
			return false --returns false if there was a problem
		end
	else
		return false --returns false if there was a problem
	end
end

--check if a ped is a zombie or not
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

addEvent( "onZombieLostPlayer", true )
function ZombieTargetCoords ( x,y,z )
	setElementData ( source, "Tx", x, false )
	setElementData ( source, "Ty", y, false )
	setElementData ( source, "Tz", z, false )
end
addEventHandler( "onZombieLostPlayer", root, ZombieTargetCoords )

function setPlayerZombieProof(pl, state)
	if state == true or state == false then
		setElementData(pl, "zProof", state)
	end
end

function getPlayerZombieProof(pl)
	return getElementData(pl, "zProof")
end