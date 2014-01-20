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
				
				if (missionKnowledge.goodBarracks[i]) then
					-- add good ones
					local newGood = Spring.CreateUnit(unitNames[k],goodOnesX + thisFormation[k][1],0,goodOnesZ + thisFormation[k][2],"n",teamNames["BASE1"])
					
					-- add good orders :)
					for l=1,#thisMap do
						Spring.GiveOrderToUnit(newGood, CMD.FIGHT, {thisMap[l][1], 0, thisMap[l][2]}, {"shift"})
					end
				end
				
				if (missionKnowledge.badBarracks[i]) then
					-- add bad ones
					local newBad = Spring.CreateUnit(unitNames[k],badOnesX + thisFormation[k][1],0,badOnesZ + thisFormation[k][2],"s",teamNames["BASE2"])
					
					-- add bad orders :)
					for l=#thisMap,1,-1 do
						Spring.GiveOrderToUnit(newBad, CMD.FIGHT, {thisMap[l][1], 0, thisMap[l][2]}, {"shift"})
					end
				end
				
			end
		end
        return true
	end,
	["SpawnThisHero"] = function(unitID,unitDefID,unitTeam)
		local goodPos 	= map["goodBaseSpawn"]
		local badPos 	= map["badBaseSpawn"]
		
		if (Spring.AreTeamsAllied(unitTeam,teamNames["BASE1"])) then
			Spring.CreateUnit(unitDefID, goodPos[1][1], 0, goodPos[1][2],"n",unitTeam,false,false,unitID)
		else
			Spring.CreateUnit(unitDefID, badPos[1][1], 0, badPos[1][2],"s",unitTeam,false,false,unitID)
		end
        return true
	end,
	["CheckBarracksAlive"] = function()
		local goodNames = {"goodBarracksTop", "goodBarracksMiddle", "goodBarracksBottom"}
		local badNames	= {"badBarracksTop", "badBarracksMiddle", "badBarracksBottom"}
		
		for i=1,3 do
			-- GOOD ONES --
			if (missionKnowledge.goodBarracks[i] and not unitsUnderGreatEyeNameToID[goodNames[i]].isAlive) then
				missionKnowledge.goodBarracks[i] = false
				Spring.Echo(goodNames[i] .. " were destroyed!")
			end
			-- BAD ONES --
			if (missionKnowledge.badBarracks[i] and not unitsUnderGreatEyeNameToID[badNames[i]].isAlive) then
				missionKnowledge.badBarracks[i] = false
				Spring.Echo(badNames[i] .. " were destroyed!")
			end
		end
		
        return true
	end,
	["CheckEndGame"] = function()
		-- GOOD ONES LOST --
		if (missionKnowledge.goodMain and not unitsUnderGreatEyeNameToID["goodMain"].isAlive) then
			missionKnowledge.goodMain = false
			Spring.Echo("Main bunker of good forces was destroyed!")
			for _,t in ipairs(Spring.GetTeamList()) do
				if (not Spring.AreTeamsAllied(t,teamNames["BASE2"]) and (Spring.GetGaiaTeamID ~= t)) then
					Spring.KillTeam(t)
				end
			end
		end
		-- BAD ONES LOST --
		if (missionKnowledge.badMain and not unitsUnderGreatEyeNameToID["badMain"].isAlive) then
			missionKnowledge.badMain = false
			Spring.Echo("Main bunker of bad forces was destroyed!")
			for _,t in ipairs(Spring.GetTeamList()) do
				if (not Spring.AreTeamsAllied(t,teamNames["BASE1"]) and (Spring.GetGaiaTeamID ~= t)) then
					Spring.KillTeam(t)
				end
			end
		end
		
        return true
	end,
}