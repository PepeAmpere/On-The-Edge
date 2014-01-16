function gadget:GetInfo()
	return {
		name = "testSpawnPlayer",
		desc = "Simple gadget for spawning a player's initial unit",
		author = "KDR_11k (David Becker)",
		date = "2010-08-30",
		license = "Public Domain",
		layer = -255,
		enabled = true,
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

function gadget:GameFrame()
	local counter = 0
	for _,t in ipairs(Spring.GetTeamList()) do
		counter = counter + 1
		-- Spring.Echo("I would like")
		-- Spring.CreateUnit("ranger",counter*10,50,counter*10,0,t)
	end
	gadgetHandler:RemoveGadget("SpawnPlayer")
end

else

--UNSYNCED

return false

end

---------- just to prevent executing in non-sandbox scenarios --------------------------
local missionName	= string.lower(Spring.GetModOptions().mission_name or "none") or "none" 

function gadget:Initialize()
	if (missionName ~= "none") then
		gadgetHandler:RemoveGadget("SpawnPlayer")
	end
end

