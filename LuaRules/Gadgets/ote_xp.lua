------------------------------------------------------------------------------
-- OTE XP counter
-- dumb version
------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name 	= "ote_xp",
		desc 	= "Gadget keeping eye on heroes experience",
		author 	= "PepeAmpere",
		date 	= "2014-01-10",
		license = "ote",
		layer 	= -255,
		enabled = true,
	}
end

include "LuaRules/Configs/ote/ote_heroes.lua"
include "LuaRules/Configs/ote/ote_rules.lua"

local listOfHeroes 	= {}
local heroCounter	= 0
for k,v in pairs(heroClass) do
	heroCounter					= heroCounter + 1
	listOfHeroes[heroCounter] 	= k 
end

local listOfTargets	= {}
local targetCounter	= 0
for k,v in pairs(oteRule.experience) do
	targetCounter					= targetCounter + 1
	listOfTargets[targetCounter] 	= k 
end

local function IsHero(targetName)
	-- !! works only for old defined heroes, not for generated ones yet
	-- TODO: make here different checker via customParameter
	for i=1,heroCounter do
		if (listOfHeroes[i] == targetName) then
			return true
		end
	end
	return false
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	local targetName	= UnitDefs[unitDefID].name
	local revenue		= 0
	
	-- just take all hero units a single type = unit "hero"
	if (IsHero(targetName)) then
		targetName = "hero"
	end
	
	-- if its target listed in our experience tab...
	for i=1,targetCounter do
		if (listOfTargets[i] == targetName) then
			revenue	= oteRule.experience[targetName]
			-- TODO: if its hero, dont forget it multiply the base exp level by given oteRules multiplier
			break
		end
	end
	
	-- select all heroes in range
	local x,y,z					= Spring.GetUnitPosition(unitID)
	local unitsInRadius 		= Spring.GetUnitsInSphere(x,y,z,oteRule.experienceRadius)
	local heroesInRadius 		= {}
	local heroesinRadiusCounter = 0
	if (unitsInRadius and #unitsInRadius > 0) then
		for i=1,#unitsInRadius do 
			local radiusUnitDefID 	= Spring.GetUnitDefID(unitsInRadius[i])
			if (IsHero(UnitDefs[radiusUnitDefID].name)) then
				local heroTeam			= Spring.GetUnitTeam(unitsInRadius[i])
				local allied			= Spring.AreTeamsAllied(teamID, heroTeam)
				
				-- add exp only to enemy heroes
				if (not allied) then
					heroesinRadiusCounter 					= heroesinRadiusCounter + 1
					heroesInRadius[heroesinRadiusCounter] 	= unitsInRadius[i]
				end
			end
		end
	end
	
	-- calculate the final experience for each hero
	local finalRevenue = math.floor(revenue/heroesinRadiusCounter)
	
	-- send it message about xp update
	for i=1,heroesinRadiusCounter do
		local finalMsg = "expup-" .. heroesInRadius[i] .. "-" .. finalRevenue
		Spring.Echo(x,y,z,heroesInRadius[i],finalRevenue)
		Spring.SendLuaRulesMsg(finalMsg) 
	end
end	
