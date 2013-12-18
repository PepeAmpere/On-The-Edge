function gadget:GetInfo()
	return {
		name = "test2",
		desc = "Simple gadget for airstrike testing",
		author = "ja sam",
		date = "2013-12-13",
		license = "ote",
		layer = -255,
		enabled = true
	}
end

include "LuaRules/Configs/tsp/tsp_actions.lua"

function gadget:GameFrame(frame)
	if(frame == 100) then
		action.Airstrike(UnitDefNames["plane"].id, 800, 800, 0)
	end
end
