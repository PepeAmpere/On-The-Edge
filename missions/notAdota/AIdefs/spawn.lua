----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {

}

newSpawnThis = {
	
}

-- just add all units in game in spawnDef
for id,unitDef in pairs(UnitDefs) do
	local uName 			= unitDef.name
	local tName				= "t_" .. uName
	newSpawnDef[tName] 		= {unit = uName, class = "single"}
end

local function notAdotaSpawn(spots,firstAxis,firstAxisInc,secondAxis,secondAxisInc)
	-- prepare start positions on notAdotaMap
	local spawnSpotsGood 	= {}
	local spanwSpotsBad		= {}
	
	for i=1,10 do
		local newFirstAxis 	= firstAxis + firstAxisInc * (i-1)
		local newSecondAxis = secondAxis + secondAxisInc * (i-1)
		spawnSpotsGood[i] 	= {newFirstAxis,newSecondAxis}
		spanwSpotsBad[i] 	= {newSecondAxis,newFirstAxis}
	end

	local counterGood		= 0
	local counterBad		= 0
    for _,t in ipairs(Spring.GetTeamList()) do
		local _,_,_,ai,faction,allyTeam = Spring.GetTeamInfo(t)
		local unitname = Spring.GetSideData(faction)
		
		-- base check (then add bad faction)
		if (ai) then
			local AIname = Spring.GetTeamLuaAI(t)
			if (AIname == "BASE Team 1" or AIname == "BASE Team 2" or AIname == "WILDERNESS") then
				faction = "pir"
			end
		end
		
		-- Spring.Echo(unitname,faction)
		if unitname and (allyTeam >= 0) and (allyTeam < 2) and (faction ~= "pir") then
			
			-- ! rewrite - fast change :) 
			local restOfName = "_0_0_0_0"
			unitname = teamHeroUnitDef[tostring(t)]   -- this structure from LuaRules/Configs/ote/ote_heroes_game_setup.lua
			if (unitname == nil) then
				unitname = faction .. "_h0_w0_b0_b0_3"
				Spring.Echo("ERROR!!!: NOE spawner: fixed hero name")
			end
			unitname = unitname .. restOfName
			
			local good = true
			if (allyTeam == 1) then
				good = false
				counterBad 	= counterBad + 1
			else
				counterGood = counterGood + 1
			end
			
			local sx,sz
			if good then
				sx = spawnSpotsGood[counterGood][1]
				sz = spawnSpotsGood[counterGood][2]
			else
				sx = spanwSpotsBad[counterBad][1]
				sz = spanwSpotsBad[counterBad][2]
			end
			
			-- use spawn planner
			newSpawnThis[#newSpawnThis+1] = {name = "t_" .. unitname, posX = sx, posZ = sz, facing = "s", teamName = teamIDtoName[tostring(t)], checkType = "none", gameTime = 0}
		end
	end
end

notAdotaSpawn(8,500,100,6750,100)	

function NewSpawner()
	--Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end