function gadget:GetInfo()
	return {
		name      = "tsp action call",
		desc      = "executes action for heroes that player called",
		author    = "Pavel",
		date      = "2014-01-17",
		license   = "GNU GPL v2",
		layer     = -50,
		enabled   = true
	}
end

VFS.Include("LuaRules/Gadgets/Includes/utilities.lua")

include "LuaRules/Configs/tsp/tsp_actions.lua"
include "LuaRules/Configs/noe/noe_formations.lua"

local change		= false
local params		= {}


if ( gadgetHandler:IsSyncedCode()) then

local function CallAction(unitID, actionName, actionLevel)
	Spring.Echo("Vola se:", unitID, actionName, actionLevel)
	if (tonumber(actionLevel) == 0) then return end 
	local teamID 		= Spring.GetUnitTeam(unitID)
	local teamEnergy	= Spring.GetTeamResources(teamID, "energy")
	local actionPrices = {
		[1] = 75,
		[2] = 100,
		[3] = 125,
		[4] = 150,
		[5] = 175
	}

	if(teamEnergy >= actionPrices[tonumber(actionLevel)]) then
		if(actionName == "drone") then
			action.SpawnAssistDrone(unitID, teamID, actionLevel)
		end
		
		if(actionName == "bugs") then
			local sets = {
				[1] = { "bug1"},
				[2] = { "bug1", "bug1"},
				[3] = { "bug1", "bug2", "bug1"},
				[4] = { "bug2", "bug2"},
				[5] = { "bug2", "bug3", "bug2"}
			}
			action.BugsWard(unitID, teamID, sets[tonumber(actionLevel)],"swarm")
		end
		
		if(actionName == "minefield") then
			local heroPosX, heroPosY, heroPosZ 	= Spring.GetUnitPosition(unitID)
			action.Minefield(heroPosX, heroPosZ, teamID, "minebasic", actionLevel*2, "swarm", 10)
		end
		
		Spring.SetTeamResource(teamID, "e", teamEnergy-actionPrices[tonumber(actionLevel)])
	end
end

function gadget:GameFrame(frameNumber)
	if (change) then
		CallAction(params["unitID"], params["actionName"], params["actionLevel"])
		change = false
	end
end

function gadget:RecvLuaMsg(msg, playerID)

	Spring.Echo("Akce se nejak vola")
	
	local tokens = split(msg,"-");
	--check what type of command is called
	if(tokens[1] == "TSPACTION") then
		Spring.Echo("projde testem")
		params = {
			unitID		= tokens[2],
			actionName	= tokens[3],
			actionLevel	= tokens[4],
		}
		change = true
	end
end

end