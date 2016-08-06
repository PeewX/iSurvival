--iR|HorrorClown (PewX) - iRace-mta.de - 29.05.2014 --
local settings = {}
local upStats = {}

addEvent("sendSkillInformations", true)
addEventHandler("sendSkillInformations", me, function(sTable)
	settings.skills = {}
	settings.skills = sTable
end)

addEvent("onClientUpgradeInProgress", true)
addEventHandler("onClientUpgradeInProgress", me, function(uTable)
	upStats = uTable
	
	if isUpgradeInProgress() then
		setSubTitle("", 0)
	end
end)

function getNextUpgradeTable(player, statID)
	if settings.skills[statID] then
		local ID = math.floor(getPedStat(player, statID)/100) + 1
		if settings.skills[statID][ID] then
			return settings.skills[statID][ID]
		end		
	end
	
	return false
end

function isUpgradeAvailable(player, statID)
	if upStats and toboolean(upStats.upStarted) then
		return false
	end
	
	if settings.skills[statID] then
		local zsl = tonumber(getElementData(player, "zSkillLevel"))
		local uT = getNextUpgradeTable(player, statID)
		if uT and zsl >= uT.level then
			return true
		end
	end
	
	return false
end

function isUpgradeInProgress()
	if upStats and toboolean(upStats.upStarted) then
		return true
	end
end

function getUpgradeInformations()
	return upStats
end