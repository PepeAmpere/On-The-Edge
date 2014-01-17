------------------------------------------------------------------------------
-- OTE HERO SETUP
-- default defs for players
------------------------------------------------------------------------------

local defaultItems 	= "_h0_w0_b0_b0_3"
local teamList		= Spring.GetTeamList()
teamHeroUnitDef		= {}

Spring.Echo("------------------ HERO SETUP ---------------------")
Spring.Echo("... players and their heroes (IN GAME) ")

for i=1,#teamList do
	local teamID 				= teamList[i]
	local _,leader,_,ai,side,_ 	= Spring.GetTeamInfo(teamID)
	if (leader and not ai) then
		local name,_,_,_,_,_,_,_,_,something = Spring.GetPlayerInfo(leader)
		if (something) then
			for k,v in pairs(something) do
				if (k == "hero") then
					teamHeroUnitDef[tostring(teamID)] = v
				end
			end		
		end
	elseif (leader and ai) then
		local aiInfo = Spring.GetTeamLuaAI(teamID)
		if (aiInfo == "BASE1" or aiInfo == "BASE2" or aiInfo == "WILDERNESS" or aiInfo == "Mission AI") then
			teamHeroUnitDef[tostring(teamID)] = "none"
		else
			teamHeroUnitDef[tostring(teamID)] = side .. defaultItems
		end
	else
		teamHeroUnitDef[tostring(teamID)] = "none"
	end
	Spring.Echo(teamHeroUnitDef[tostring(teamID)])

end

Spring.Echo("------------------ END OF SETUP -------------------")