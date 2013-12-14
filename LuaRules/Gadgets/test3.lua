function gadget:GetInfo()
	return {
		name = "test3",
		desc = "Simple gadget for testing Minefiled and PlantMine",
		author = "ja sam",
		date = "2010-08-30",
		license = "ote",
		layer = -255,
		enabled = true
	}
end

include "LuaRules/Configs/tsp/tsp_actions.lua"

include "LuaRules/Configs/noe/noe_formations.lua"

function gadget:GameFrame(frame)
	if(frame == 200) then
		action.Minefield(200, 1800, 1, UnitDefNames["minebasic"].id, 20, "swarm", 10)
	end
end
