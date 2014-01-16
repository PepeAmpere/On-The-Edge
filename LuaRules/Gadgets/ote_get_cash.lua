------------------------------------------------------------------------------
-- OTE CASH counter
-- dumb version
------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name 	= "ote_get_cash",
		desc 	= "Gadget keeping eye on heroes money income",
		author 	= "PepeAmpere",
		date 	= "2014-01-16",
		license = "ote",
		layer 	= -255,
		enabled = true,
	}
end

include "LuaRules/Configs/ote/ote_rules.lua"
include "LuaRules/Gadgets/Includes/utilities.lua"

local listOfTargets	= {}
local targetCounter	= 0
for k,v in pairs(oteRule.money) do
	targetCounter					= targetCounter + 1
	listOfTargets[targetCounter] 	= k 
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeamID)
	local targetName	= UnitDefs[unitDefID].name
	local revenue		= 0
	
	-- just take all hero units a single type = unit "hero"
	if (UnitDefs[unitDefID].customParams.ishero) then
		targetName = "hero"
	end
	
	-- TODO: move one day all in definition tables
	for i=1,targetCounter do
		if (listOfTargets[i] == targetName) then
			revenue	= oteRule.money[targetName]
			-- TODO: if its hero, dont forget it multiply the base exp level by given oteRules multiplier
			if (targetName == "hero") then
				revenue = math.floor(revenue * (1.1^UnitDefs[unitDefID].customParams.level))		-- just direct level multiplier now
			end
			break
		end
	end
	
	-- send it message about xp update	
	-- only if target and attacker are not allied
	if (not (Spring.AreTeamsAllied(teamID,attackerTeamID))) then
		-- if attacker hero, send just to him
		-- Spring.Echo(ToBool(UnitDefs[attackerDefID].customParams.ishero),attackerDefID,UnitDefs[attackerDefID].name,UnitDefs[attackerDefID].customParams.ishero)
		if (UnitDefs[attackerDefID].customParams.ishero) then								
			local finalMsg = "cashup-single-" .. attackerID .. "-" .. revenue
			Spring.Echo(finalMsg)
			Spring.SendLuaRulesMsg(finalMsg)
			Spring.SendLuaUIMsg(finalMsg)
		else
		-- send whole team
			local finalMsg = "cashup-team-" .. attackerTeamID .. "-" .. revenue
			Spring.Echo(finalMsg)
			Spring.SendLuaRulesMsg(finalMsg)
			Spring.SendLuaUIMsg(finalMsg)
		end
	end	
end
