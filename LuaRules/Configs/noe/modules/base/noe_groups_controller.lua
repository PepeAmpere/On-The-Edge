------------------------------------------------------------------------------
-- NOE GROUPS CONTROLLER
-- functions taking care about groups tables
------------------------------------------------------------------------------

function GroupEdit(groupID,parameterName,value)
	groupInfo[groupID][parameterName] = value
	return true
end

initGroup = {
	["factoriesGroupsIDs"] = function()
		for i=1,groupCount do
			local thisGroup  = groupInfo[i]
			if (thisGroup.factories ~= nil) then
				local thisFactories = thisGroup.factories
				for j=1,#thisFactories do
					local thisTeamfromGrouupsIDsList	= teamInfo[thisGroup.teamNumber].groupNameToID[thisFactories[j]]
					groupInfo[i].factoriesGroupsIDs[j]	= teamInfo[thisGroup.teamNumber].listOfGroupsIDs[thisTeamfromGrouupsIDsList]
				end
			end
		end
	end,
	["notSleeper"] = function(spiritName)
		for i=1,groupCount do
			local thisGroup  = groupInfo[i]
			if (thisGroup.spirit == spiritName) then
				groupInfo[i].notSleeper = true
			end
		end
	end,	
}

function Sleeping(groupID)
	groupInfo[groupID].sleeping            = true
	groupInfo[groupID].acceptingUnits      = true
	groupInfo[groupID].buildStatus         = "idle"
	groupInfo[groupID].operationalStatus   = "none"
	
	-- additional changes 
	local thisTeam		= teamInfo[groupInfo[groupID].teamNumber]
	-- ! silly fix with halfX, halfZ, maybe should be done better (next two lines)
	local defaultPosX								= thisTeam.mapBase.posX or halfX
	local defaultPosZ								= thisTeam.mapBase.posZ or halfZ
	groupInfo[groupID].posX,groupInfo[groupID].posZ	= GetRandomPlaceAround(defaultPosX,defaultPosZ,300,1000)	
	if (groupInfo[groupID].target.hasAny and (groupInfo[groupID].target.index ~= 0)) then
		TargetUsageChange(groupInfo[groupID].teamNumber,groupInfo[groupID].target.index,false)
		groupInfo[groupID].target.hasAny = false
	end
end 

function AddUnit(unitID,teamNumber,groupName,groupID)
	if (groupID == 0) then spEcho ("Error: not existing group") return end
	for i=1,groupInfo[groupID].membersListMax do
		if (not(groupInfo[groupID].membersListAlive[i])) then
			groupInfo[groupID].membersListAlive[i]	= true
			groupInfo[groupID].membersList[i]		= unitID
			reverseUnitsGroupID[unitID]				= groupInfo[groupID].groupED
			reverseUnitsListID[unitID]				= i
			groupInfo[groupID].membersListCounter	= groupInfo[groupID].membersListCounter + 1
			groupInfo[groupID].receivedUnit			= true
			if (groupInfo[groupID].membersListCounter == 1) then
				groupInfo[groupID].sleeping    = false
				groupInfo[groupID].status      = "idle"
				groupInfo[groupID].buildStatus = "idle"
				groupInfo[groupID].fightStatus = "idle"
			end
			if (groupInfo[groupID].membersListCounter == groupInfo[groupID].membersListMax) then
			    groupInfo[groupID].acceptingUnits = false
			end
			break
		end
	end
end
 
function KillUnit(unitID,teamNumber,groupID)
	local listID									= reverseUnitsListID[unitID]
	groupInfo[groupID].membersListAlive[listID]		= false
	groupInfo[groupID].membersListCounter			= groupInfo[groupID].membersListCounter - 1
	if (groupInfo[groupID].membersListCounter == 0) then       -- deactivation of group
	    Sleeping(groupID)
	end
end

function ChangeUnitGroup(howMany,oldGroupID,newGroupID,unitID)
    -- Possible use
    --- 1) nil, nil, newGroupID, unitID
	--- 2) howMany, oldGroupID, newGroupID, nil
    local newCount = groupInfo[newGroupID].membersListCounter
	local newMax   = groupInfo[newGroupID].membersListMax
	if (oldGroupID == nil) then
	    oldGroupID       = reverseUnitsGroupID[unitID]
	    local oldCount   = groupInfo[oldGroupID].membersListCounter
	    
		if ((newCount == newMax) or (oldCount == 0)) then  ---- condintion if new group is full
	        --spEcho("Unit cannot be moved, newgroup is full or old empty (unit: " .. unitID .. " from " .. oldGroupName .. " to " .. newGroupName .. ")")
		    return false
	    end
		
		for i=1,newMax do
			if (not(groupInfo[newGroupID].membersListAlive[i])) then
				groupInfo[newGroupID].membersListAlive[i]							= true
				groupInfo[oldGroupID].membersListAlive[reverseUnitsListID[unitID]]	= false
				groupInfo[newGroupID].membersList[i]								= unitID
				groupInfo[oldGroupID].membersList[reverseUnitsListID[unitID]]		= nil			
				reverseUnitsGroupID[unitID]											= groupInfo[newGroupID].groupED
				reverseUnitsListID[unitID]											= i
				groupInfo[newGroupID].membersListCounter							= groupInfo[newGroupID].membersListCounter + 1
				groupInfo[oldGroupID].membersListCounter							= groupInfo[oldGroupID].membersListCounter - 1
				groupInfo[newGroupID].receivedUnit									= true
				if (groupInfo[oldGroupID].membersListCounter == 0) then --- if last unit moved from old group, deactivation of group
					Sleeping(groupID)
				end
				if (groupInfo[newGroupID].sleeping) then 
				    groupInfo[newGroupID].sleeping = false
				end
				break
			end
		end	
	else    ---- so we are moving anonymous group of units
	    local IDsList		= {}
		local countMoved	= 0
		local oldMax		= groupInfo[oldGroupID].membersListMax                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
		
		if (((groupInfo[oldGroupID].membersListCounter - howMany) < 0) or ((newCount + howMany) > newMax)) then  ---- condintion if new group is full
	        --spEcho("Unit cannot be moved, newgroup has to many units or old has to few (from " .. groupInfo[oldGroupID].name .. " to " .. groupInfo[newGroupID].name .. " moveCount: " .. howMany .. ")")
		    return false
	    end
		
		for i=1,oldMax do
		    if (groupInfo[oldGroupID].membersListAlive[i]) then
				countMoved									= countMoved + 1
				IDsList[countMoved]							= groupInfo[oldGroupID].membersList[i]
				groupInfo[oldGroupID].membersListCounter	= groupInfo[oldGroupID].membersListCounter - 1
				groupInfo[oldGroupID].membersListAlive[i]	= false
				-- spEcho("member: " .. IDsList[countMoved])
				if (countMoved == howMany) then
				    break
                end				
			end
		end
		
		countMoved           = 0
		if (#IDsList ~= howMany) then spEcho("BUG") end
		for i=1,newMax do
			if (not(groupInfo[newGroupID].membersListAlive[i])) then
			    countMoved									= countMoved + 1
				groupInfo[newGroupID].membersListAlive[i]	= true
				local thisID								= IDsList[countMoved]
				groupInfo[newGroupID].membersList[i]		= thisID
				reverseUnitsGroupID[thisID]					= groupInfo[newGroupID].groupED
				reverseUnitsListID[thisID]					= i
				groupInfo[newGroupID].membersListCounter	= groupInfo[newGroupID].membersListCounter + 1
				groupInfo[newGroupID].receivedUnit			= true
				if (groupInfo[oldGroupID].membersListCounter == 0) then --- if last unit moved from old group, deactivation of group
					Sleeping(groupInfo[oldGroupID].groupED)
				end
				if (groupInfo[newGroupID].sleeping) then 
				    groupInfo[newGroupID].sleeping = false
				end
			end
			if (countMoved == howMany) then
				if (groupInfo[newGroupID].membersListCounter > (groupInfo[newGroupID].membersListMax - groupInfo[newGroupID].transferCount)) then
	                groupInfo[newGroupID].acceptingUnits = false
	            end 
				--spEcho("from " .. groupInfo[oldGroupID].name .. " to " .. groupInfo[newGroupID].name .. " moveCount: " .. howMany .. ")")
				return true
			end
		end
	end
end

function TestBeforeAddUnit(unitID,name,teamNumber)
    local thisTeam = teamInfo[teamNumber]
	for i=1,thisTeam.numberOfGroups do
		local thisGroupID   = thisTeam.listOfGroupsIDs[i]
		local thisGroup     = groupInfo[thisGroupID]
		local groupName     = thisGroup.name
		local groupUnitName = thisGroup.unitName
		-- !! this is old, preference should be "this unitDefId buffer first (to exclude not first buffer in groupDef list bug) and later try all other groups"
		if ((name == groupUnitName) and (thisGroup.active) and (thisGroup.acceptingUnits) and (thisGroup.membersListCounter < thisGroup.membersListMax)) then  
			--spEcho("Unit added: " .. unitID,teamNumber,groupName,groupUnitName)
			
			-- ADDITION THE UNIT - MAIN PURPOSE OF THIS FUNCTION --
			AddUnit(unitID,teamNumber,groupName,thisGroupID)
			
			-- UPDATE COUNTERS OR IF NEEDED CREATE NEW --
			if (teamInfo[teamNumber].unitTypeCount[name] == nil) then
				teamInfo[teamNumber].unitTypeCount[name] = {
					count		= 0,
					percent		= 0,
					limit		= 100,  -- ! temporary of course
				}
			else
				teamInfo[teamNumber].unitTypeCount[name].count   	= teamInfo[teamNumber].unitTypeCount[name].count + 1
				teamInfo[teamNumber].unitTypeCount[name].percent 	= teamInfo[teamNumber].unitTypeCount[name].count / teamInfo[teamNumber].unitTypeCount[name].limit
			end
			
			-- UPDATE ORDERS FOR BUFFERS
			groupInfo[thisGroupID].waitingOrders 			= groupInfo[thisGroupID].waitingOrders - 1
			break
		end
	end 
end

function PrepareFirstUnit(groupID)
    local thisGroup = groupInfo[groupID]
	if (not(thisGroup.membersListAlive[1]) and (thisGroup.membersListCounter > 1)) then
		ChangeUnitGroup(1,groupID,groupID)
		return true
	end
	return false
end

function GetPositionOfGroup(groupID,membersLimit)
    local thisGroup    = groupInfo[groupID]
    local listAlive    = thisGroup.membersListAlive
	local membersList  = thisGroup.membersList
	local done         = false
	local limit        = membersLimit or thisGroup.membersListMax
	local counter      = 0 
	local unitPosX,unitPosY,unitPosZ
    for i=1,limit do   
		if (listAlive[i]) then 
			unitPosX,unitPosY,unitPosZ = spGetUnitPosition(membersList[i])
			groupInfo[groupID].posX    = unitPosX
	        groupInfo[groupID].posZ    = unitPosZ
			done                       = true
			counter                    = counter + 1
			break
     	end
	end
	if (done) then
	    return unitPosX,unitPosY,unitPosZ
	else
	    -- spEcho("NOE debug: This group " .. thisGroup.name .. " has no unit (" .. counter .. "), why it is not sleeping?")
		-- !! here should be added some start position or operational position
		Sleeping(groupID)
	    return teamInfo[thisGroup.teamNumber].mapBase.posX,_,teamInfo[thisGroup.teamNumber].mapBase.posZ
	end
end