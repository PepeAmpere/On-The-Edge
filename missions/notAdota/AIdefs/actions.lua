----- mission conditions settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- goodID = 0
-- badID  = 0 

-- for _,t in ipairs(Spring.GetTeamList()) do
	-- local aiName = Spring.GetTeamLuaAI(t)
	-- if (aiName == "BASE1") then
		-- goodID = t
	-- end
	-- if (aiName == "BASE2") then
		-- badID = t
	-- end
-- end

newAction = {
    ["SpawnAll"] = function()
		local mapNames = {
			"topLine",
			"middleLine",
			"bottomLane",
		}
		local unitNames = {
			"soldier",
			"soldier",
			"soldier",
			"soldier",
			"soldier",
			"soldier",
			"ranger",
			"ranger",
			"ranger",
			"mortar",
		}
		local direction = {
			"s","n","e","w",
		}
		local directionCounter = 0
		
		for i=1,3 do 
			local thisMap = map[mapNames[i]]
			local goodOnesX = thisMap[1][1]
			local goodOnesZ = thisMap[1][2]
			local badOnesX 	= thisMap[#thisMap][1]
			local badOnesZ 	= thisMap[#thisMap][2]
			
			local thisFormation = formations["swarm"]
			for k=1,#unitNames do
				directionCounter 	= directionCounter + 1
				local newDirection 	= (directionCounter % 4) + 1
				
				-- good ones
				local newGood = Spring.CreateUnit(unitNames[k],goodOnesX + thisFormation[k][1],0,goodOnesZ + thisFormation[k][2],direction[newDirection],teamNames["BASE1"])
				
				-- add good orders :)
				for l=1,#thisMap do
					Spring.GiveOrderToUnit(newGood, CMD.FIGHT, {thisMap[l][1], 0, thisMap[l][2]}, {"shift"})
				end
									
				-- bad ones
				local newBad = Spring.CreateUnit(unitNames[k],badOnesX + thisFormation[k][1],0,badOnesZ + thisFormation[k][2],direction[newDirection],teamNames["BASE2"])
				
				-- add bad orders :)
				for l=#thisMap,1,-1 do
					Spring.GiveOrderToUnit(newBad, CMD.FIGHT, {thisMap[l][1], 0, thisMap[l][2]}, {"shift"})
				end
				
			end
		end
        return true
	end,
	["SpawnThisHero"] = function(unitID,unitDefID,unitTeam)
		local goodPos 	= map["goodBaseSpawn"]
		local badPos 	= map["badBaseSpawn"]
		
		if (Spring.AreTeamsAllied(unitTeam,teamNames["BASE1"])) then
			Spring.CreateUnit(unitDefID, goodPos[1][1], 0, goodPos[1][2],"s",unitTeam,false,false,unitID)
		else
			Spring.CreateUnit(unitDefID, badPos[1][1], 0, badPos[1][2],"s",unitTeam,false,false,unitID)
		end
        return true
	end,
}