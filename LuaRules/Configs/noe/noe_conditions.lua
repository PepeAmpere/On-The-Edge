----------------------------------------------------------
-- NOE conditions defs
-- WIKI: http://code.google.com/p/nota/wiki/NOE_conditions 
----------------------------------------------------------

local spGetTeamUnitDefCount 		= Spring.GetTeamUnitDefCount
local spGetTeamList					= Spring.GetTeamList
local spGetUnitsInRectangle 		= Spring.GetUnitsInRectangle

condition = {
    --- SPECIAL ---
	["conjunction"] = function(conditionsList)
		-- DESCRIPTION --
		-- returns TRUE, if conditionsList is empty or nil
		-- returns TRUE if all condtions in list satisfied ELSE FALSE
		if ((conditionsList == nil) or (#conditionsList < 1)) then 
			return true
		end
		
		local satisfied = true
		for c=1,#conditionsList do
			if (not(condition[conditionsList[c]]())) then
				satisfied = false
				break
			end
		end		
		return satisfied
	end,
	["disjunction"] = function(conditionsList)
		-- DESCRIPTION --
		-- returns TRUE, if conditionsList is empty or nil
		-- returns TRUE if at least on of condtions in list satisfied ELSE FALSE
		if ((conditionsList == nil) or (#conditionsList < 1)) then 
			return true
		end
		
		local satisfied = false
		for c=1,#conditionsList do
			if (condition[conditionsList[c]]()) then
				satisfied = true
				break
			end
		end		
		return satisfied
	end,
	

    --- TIME CONDITIONS ---
    ["time"] = function(askedGameTime)
		-- DESCRIPTION --
		-- returns true if current game time is equal to condition time
		-- Spring.Echo(realGameTime[1],askedGameTime[1],realGameTime[2],askedGameTime[2],realGameTime[3],askedGameTime[3])
		if ((realGameTime[1] == askedGameTime[1]) and (realGameTime[2] == askedGameTime[2]) and (realGameTime[3] == askedGameTime[3])) then
		    return true
		else
		    return false
		end
	end,
	["timeLess"] = function(askedGameTime)
		-- DESCRIPTION --
		-- returns true if current game time is lesser to condition time
		local realTime	= 3600*realGameTime[1] + 60*realGameTime[2] + realGameTime[3]
		local askedTime	= 3600*askedGameTime[1] + 60*askedGameTime[2] + askedGameTime[3]
		if (realTime < askedTime) then
		    return true
		else
			return false
		end
	end,
	["timeMore"] = function(askedGameTime)
		-- DESCRIPTION --
		-- returns true if current game time is lesser to condition time
		local realTime	= 3600*realGameTime[1] + 60*realGameTime[2] + realGameTime[3]
		local askedTime	= 3600*askedGameTime[1] + 60*askedGameTime[2] + askedGameTime[3]
		if (realTime > askedTime) then
		    return true
		else
			return false
		end
	end,
	["timeElapsed"] = function(askedElapsedTime,beginningOfAction)
		-- DESCRIPTION --
		-- returns true if current game time is lesser to condition time
		local realTime		= 3600*realGameTime[1] + 60*realGameTime[2] + realGameTime[3]
		local beginning		= 3600*beginningOfAction[1] + 60*beginningOfAction[2] + beginningOfAction[3]
		local elapsedLimit	= 3600*askedElapsedTime[1] + 60*askedElapsedTime[2] + askedElapsedTime[3]
		local elapsedTime	= realTime - beginning
		if (elapsedTime > elapsedLimit) then
		    return true
		else
			return false
		end
	end,
	["missionTimeElapsed"] = function(askedElapsedTime,nameOfBeginning)
		-- DESCRIPTION --
		-- just facelift for mission knowledge use
		local beginningTime = missionKnowledge[nameOfBeginning]
		if (beginningTime ~= nil) then
		    return condition.timeElapsed(askedElapsedTime,beginningTime)
		end
	end,	
	
	
	
	--- UNITS CONDITIONS ---
	["unitIsAlive"] = function(unitID)
		return not(Spring.GetUnitIsDead(unitID))
	end,
	["unitIsDead"] = function(unitID)
		return Spring.GetUnitIsDead(unitID)
	end,
	["unitCountEqualOrMore"] = function(nameOfUnit,numberOfUnits,teamID)
		-- DESCRIPTION --
		-- returns TRUE if more or equeal number of alive units of give "name" is in the team
		-- if teamID is not set, it answeres question about number of all alive units of given "name" in all teams 
		local unitDefID = fromNameToIDTable[nameOfUnit]
		local count     = 0  
		if (teamID == nil) then
		    local list = spGetTeamList()
		    for i=0,#list-1 do
			    count = count + spGetTeamUnitDefCount(i,unitDefID)
			end
        else
		    count = spGetTeamUnitDefCount(teamID,unitDefID)
        end		
		if (count >= numberOfUnits) then
		    return true
		else
		    return false
		end
	end,
	["isUnitInArea"] = function(areaName)
	
		-- DESCRIPTION --
		-- returns TRUE if there is one or more units in given area
		-- returns FALSE if there is no unit in given area
		local thisArea 		= map[areaName]
		local unitsInArea 	= spGetUnitsInRectangle(thisArea[1][1],thisArea[1][2],thisArea[2][1],thisArea[2][2])
		if (#unitsInArea >= 1) then
		    return true
		else
		    return false
		end
	end,
	
	--- OTHER CONDITIONS ---
	["checkAlerts"] = function(placesAlertList,alertListIndexes,alertLimit)
		if ((alertListIndexes == nil) or (#alertListIndexes < 1)) then 
			return true,0
		end
		
		local someAlert		= false
		local areaAlertID	= 0
		
		for a=1,#alertListIndexes do
			if (placesAlertList[alertListIndexes[a]] >= alertLimit) then
				-- if theres at least one big enough alert in any sector -> alert for this group
				someAlert	= true
				areaAlertID = a
				break
			end
		end
		return someAlert,alertListIndexes[areaAlertID]
	end,
	
	
	--- OTHERS ---
	-- ["realTime-0-0-10"] = function()
		-- local theTime = {0,0,10} 
		-- local answer  = condition["realTime"](theTime)
		-- if (answer) then
		    -- return true
		-- else
		    -- return false
		-- end
	-- end,
}