------------------------------------------------------------------------------
-- NOE TARGETS CONTROLLER
-- functions taking care about targets
------------------------------------------------------------------------------

function TargetUsageChange(teamNumber,targetIndex,usage)
    teamInfo[teamNumber].listOfStrategicTargets[targetIndex].isNotTarget = not(usage)
	if (usage) then
	    teamInfo[teamNumber].countOfStrategicTargetsUsed = teamInfo[teamNumber].countOfStrategicTargetsUsed + 1
	else
	    teamInfo[teamNumber].countOfStrategicTargetsUsed = teamInfo[teamNumber].countOfStrategicTargetsUsed - 1
	end
end

function AddValuableEnemy(unitID,teamNumber,teamID,valuableClass)
    local listOfValuables                        = teamInfo[teamNumber].listOfStrategicTargets
	local listOfAlive                            = teamInfo[teamNumber].listOfStrategicTargetsAlive
	local listOfReversIDs                        = teamInfo[teamNumber].reverseValuableUnitID
	local listPosition                           = #listOfValuables + 1
	local posX,posY,posZ                         = spGetUnitPosition(unitID)
	listOfValuables[listPosition]                = {
			["unitID"]      = unitID,
			["teamID"]      = teamID,
			["class"]       = valuableClass,
			["isNotTarget"] = true,
			["attacker"]    = 0, 
			["static"]      = isStaticTargetClass[valuableClass],
            ["posX"]        = posX,
            ["posY"]        = posY,		
            ["posZ"]        = posZ,				
		}
	listOfAlive[listPosition]                    = true
	listOfReversIDs[unitID]                      = listPosition
	teamInfo[teamNumber].countOfStrategicTargets = teamInfo[teamNumber].countOfStrategicTargets + 1
end

function KillValuableEnemy(unitID,teamNumber)
    local listOfAlive                            = teamInfo[teamNumber].listOfStrategicTargetsAlive
	local listOfReversIDs                        = teamInfo[teamNumber].reverseValuableUnitID
	local thisTarget                             = teamInfo[teamNumber].listOfStrategicTargets[listOfReversIDs[unitID]]
	if (thisTarget.attacker ~= 0) then
	    teamInfo[teamNumber].countOfStrategicTargetsUsed = teamInfo[teamNumber].countOfStrategicTargetsUsed - 1
		groupInfo[thisTarget.attacker].target.hasAny     = false 
		groupInfo[thisTarget.attacker].fightStatus       = "idle" 
	end
    listOfAlive[listOfReversIDs[unitID]]         = false
    listOfReversIDs[unitID]                      = nil
	teamInfo[teamNumber].countOfStrategicTargets = teamInfo[teamNumber].countOfStrategicTargets - 1	
end