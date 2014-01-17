function gadget:GetInfo()
	return {
		name      = "tsp upgrader",
		desc      = "ensures upgrades of tsps and hero leveling",
		author    = "Pavel",
		date      = "2014-01-16",
		license   = "GNU GPL v2",
		layer     = -50,
		enabled   = true
	}
end

VFS.Include("LuaRules/Gadgets/Includes/utilities.lua")

local change	= false
local wait		= 5
local params	= {}
local x,y,z		= 0,0,0
local teamID	= 0

if ( gadgetHandler:IsSyncedCode()) then

-- local function Upgrade(unitID, nextLevel)
	-- x,y,z = Spring.GetUnitPosition(unitID)
	-- teamID = Spring.GetUnitTeam(unitID)
	-- Spring.DestroyUnit(unitID)
	-- Spring.CreateUnit(nextLevel, x, y, z, "south", teamID, false, false, unitID)
	-- Spring.Echo(neco)
-- end

function gadget:GameFrame(frameNumber)
	if(change) then
		if(wait == 5) then
			x,y,z = Spring.GetUnitPosition(params[1])
			teamID = Spring.GetUnitTeam(params[1])
			Spring.DestroyUnit(params[1])
		end
		wait = wait - 1
		if wait==0 then
			Spring.CreateUnit(params[2], x, y, z, "south", teamID, false, false, params[1])
			Spring.SendLuaUIMsg("LEVELUP", "a")
			wait = 5
			change = false
		end
	end
	if(wait == 0) then
		
	end
end

function gadget:RecvLuaMsg(msg, playerID)
	
	local tokens = split(msg,"-");
	--check what type of command is called
	if(tokens[1] == "UPBUTTONCLICKED")then
		params = {tokens[2], tokens[3]}
		change = true
	end
end

end