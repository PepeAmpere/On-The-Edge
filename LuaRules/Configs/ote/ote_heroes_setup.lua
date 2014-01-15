------------------------------------------------------------------------------
-- OTE HERO SETTINGS
-- prepare data structure which contains hero defs
------------------------------------------------------------------------------

local defaultItems 	= "_h0_w0_b0_b0_3"

local teamList		= Spring.GetTeamList()
-- local teamList		= Spring.GetPlayerList()

Spring.Echo("--------------------- HERO SETTINGS ---------------------")
Spring.Echo("... current heros+item combos have to be generated ")

for i=1,#teamList do
	local teamID 				= teamList[i]
	local _,leader,_,ai,_,side 	= Spring.GetTeamInfo(teamID)
	if (leader and not ai) then
		local name,_,_,_,_,_,_,_,_,something = Spring.GetPlayerInfo(leader)
		if (something) then
			Spring.Echo(name,something)
			Spring.Echo(name,something[1])
			Spring.Echo(name,something.hero)
		end
	elseif (leader and ai) then
		
	end

end

Spring.Echo("------------------ HERO SETTINGS END --------------------")
