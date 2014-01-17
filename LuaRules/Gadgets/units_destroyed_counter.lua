function gadget:GetInfo()
	return {
		name      = "units destroyed counter",
		desc      = "Keeps track of the destroyed units in game (including unfinished units, that timeout)",
		author    = "Sunspot",
		date      = "2011-06-19",
		license   = "GNU GPL v2",
		layer     = -50,
		enabled   = false
	}
end

-- SYNCED ONLY
-- if (not gadgetHandler:IsSyncedCode()) then
	-- return
-- end

-- INCLUDES
VFS.Include("LuaRules/Gadgets/Includes/utilities.lua")
VFS.Include("LuaRules/Gadgets/Includes/messages.lua")

-- CONSTANTS
local DEBUG	= true

-- MEMBERS
local unitDestroyedCounter = 0

-- SPEEDUPS
local Echo         = Spring.Echo

function gadget:GameStart()
	unitDestroyedCounter = 0
end
	
function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID)
	unitDestroyedCounter = unitDestroyedCounter + 1
	if DEBUG then Echo("Sending message type " .. UNITDESTROYEDUPDATE .. " params ", unitDestroyedCounter) end
	Spring.SendLuaUIMsg(UNITDESTROYEDUPDATE .. "-" .. unitDestroyedCounter, "a") 
end	