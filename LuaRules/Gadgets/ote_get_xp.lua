------------------------------------------------------------------------------
-- OTE get XP 
-- dumb version
------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name 	= "ote_get_xp",
		desc 	= "Gadget keeping eye on heroes experience income",
		author 	= "PepeAmpere",
		date 	= "2014-01-10",
		license = "ote",
		layer 	= -255,
		enabled = true,
	}
end

include "LuaRules/Configs/ote/ote_rules.lua"

-- for k,v in pairs(UnitDefs) do
	-- Spring.Echo(v.customParams.tsp1_name)
	-- local tspList = v.customParams.tsps
	-- for i=1,#tspList do
		-- thisTsp = tspList[i]
		-- Spring.Echo(thisTsp.name, thisTsp.level, thisTsp.nextLevelName, thisTsp.nextLevelAllowed)
	-- end
-- end

local listOfTargets	= {}
local targetCounter	= 0
for k,v in pairs(oteRule.experience) do
	targetCounter					= targetCounter + 1
	listOfTargets[targetCounter] 	= k 
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	local targetName	= UnitDefs[unitDefID].name
	local revenue		= 0
	
	-- just take all hero units a single type = unit "hero"
	if (UnitDefs[unitDefID].customParams.ishero) then
		targetName = "hero"
	end
	
	-- if its target listed in our experience tab...
	-- TODO: move one day all in definition tables
	for i=1,targetCounter do
		if (listOfTargets[i] == targetName) then
			revenue	= oteRule.experience[targetName]
			-- TODO: if its hero, dont forget it multiply the base exp level by given oteRules multiplier
			if (targetName == "hero") then
				revenue = math.floor(revenue * (1.3^UnitDefs[unitDefID].customParams.level))		-- just direct level multiplier now
			end
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
			if (UnitDefs[radiusUnitDefID].customParams.ishero) then
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
		-- message: expup-unitID-experience
		local finalMsg = "EXPUP-SINGLE-" .. heroesInRadius[i] .. "-" .. finalRevenue
		Spring.Echo(finalMsg)
		Spring.SendLuaRulesMsg(finalMsg) 
		Spring.SendLuaUIMsg(finalMsg)
	end
end	
