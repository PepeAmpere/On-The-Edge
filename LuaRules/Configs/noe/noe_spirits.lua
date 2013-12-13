------------------------------
----- NOE spirits defs -------
------------------------------

local spEcho							= Spring.Echo
local spGiveOrderToUnit					= Spring.GiveOrderToUnit
local spGetCommandQueue					= Spring.GetCommandQueue
local spGetFactoryCommands				= Spring.GetFactoryCommands
local spGetUnitPosition					= Spring.GetUnitPosition
local spGetGroundHeight					= Spring.GetGroundHeight
local spGetUnitNearestEnemy				= Spring.GetUnitNearestEnemy
local spGetTeamList						= Spring.GetTeamList
local spGetTeamStartPosition			= Spring.GetTeamStartPosition
local spGetTeamUnitCount				= Spring.GetTeamUnitCount
local spGetUnitBuildFacing				= Spring.GetUnitBuildFacing
local spGetUnitsInRectangle				= Spring.GetUnitsInRectangle
local spGetUnitIsBuilding				= Spring.GetUnitIsBuilding
local spGetUnitIsDead					= Spring.GetUnitIsDead
local spGetUnitStockpile				= Spring.GetUnitStockpile
local spTestBuildOrder					= Spring.TestBuildOrder

local CMD_ATTACK						= CMD.ATTACK
local CMD_GUARD							= CMD.GUARD
local CMD_LOAD_UNITS					= CMD.LOAD_UNITS
local CMD_MOVE							= CMD.MOVE
local CMD_ONOFF							= CMD.ONOFF
local CMD_PATROL						= CMD.PATROL
local CMD_REPEAT						= CMD.REPEAT
local CMD_STOP							= CMD.STOP
local CMD_STOCKPILE						= CMD.STOCKPILE
local CMD_UNLOAD_UNITS					= CMD.UNLOAD_UNITS
local CMD_AUTOMEX						= 31243

local mCeil								= math.ceil
local mFloor							= math.floor
local mRandom							= math.random
local mAbs								= math.abs

local tidal								= Game.tidal
local wind								= (Game.windMin + Game.windMax)/2
local unitLimit							= Game.maxUnits
local mapX								= Game.mapSizeX
local mapZ								= Game.mapSizeZ

local pseudoRandom						= 1

local basicMove = {
    [1] = {0,-1},   -- down
	[2] = {-1,0},   -- left
	[3] = {0,1},    -- up
	[4] = {1,0},    -- right
}	

local function BasePositionInit(teamNumber,thisX,thisY,thisZ)
    local thisTeam = teamInfo[teamNumber]
	thisTeam.mapBase["posX"] = thisX
	thisTeam.mapBase["posY"] = thisY
	thisTeam.mapBase["posZ"] = thisZ
end

local function GetBuildSpot(startX,startZ,buildingID,space)
    local phase    = 2
	local tile     = space
	local currentX = startX + tile 
    local currentZ = startZ + tile
    for a=1,15 do	
		for i=1,4 do
			local thisMoveX = basicMove[i][1] * tile
			local thisMoveZ = basicMove[i][2] * tile
			for j=1,phase do
				currentX = currentX + thisMoveX
				currentZ = currentZ + thisMoveZ
				--spEcho("test:", currentX, currentZ .. "for " .. fromIDToNameTable[buildingID])
				local test = spTestBuildOrder(buildingID, currentX, 0 ,currentZ, 1)
				if (test ~= 0) then  --- !! need add test for metal spots, thermal wents, and factory leaving point
					-- local currentY = spGetGroundHeight(currentX,currentZ)	
					-- spEcho("found", currentX, currentZ)
					return currentX,currentZ,test
				end
			end
			if ((i==3) or (i == 4)) then
				phase = phase + 1
			end
		end
	end
	return 0,0,0
end

local function GetBuildSpotFromMap(groupID,buildingID,water)
    -- ! geo spots not solved
	-- ! factory leaving point check not solved
    local thisGroupBuildPosList
    if (water) then
	    thisGroupBuildPosList = groupInfo[groupID].buildWaterInRange
	else
	    thisGroupBuildPosList = groupInfo[groupID].buildGroundInRange
    end
	local numberOfBuildPos = #thisGroupBuildPosList
	if (numberOfBuildPos > 0) then
		local startTile = math.random(1,mCeil(numberOfBuildPos/5))
		for i=startTile,numberOfBuildPos*2 do
			local index        = (i % numberOfBuildPos) + 1
			local thisPosIndex = thisGroupBuildPosList[index]
			if (not(mapBuild[thisPosIndex].used)) then
				local buildingSizeX = UnitDefs[buildingID].xsize*10
				local buildingSizeZ = UnitDefs[buildingID].zsize*10
				local jLimit        = mCeil((buildingSizeX)/buildMapDivision)
				local kLimit        = mCeil((buildingSizeZ)/buildMapDivision)
				local ok            = true
				for j=0,jLimit-1 do
					local startIndex = thisPosIndex + j*buildMapZdivs
					for k=startIndex,startIndex + kLimit -1 do
						if(mapBuild[k] == nil) then --- ! only part fix
							ok = false
							break
						end
						if(mapBuild[k].used) then
							ok = false
							break
						end
					end
				end
				local test = spTestBuildOrder(buildingID,mapBuild[thisPosIndex].posX, 0 ,mapBuild[thisPosIndex].posZ, 2)
				if (ok and (test == 2)) then
					-- and set them used
					for j=0,jLimit-1 do
						local startIndex = thisPosIndex + j*buildMapZdivs
						for k=startIndex,startIndex + kLimit -1 do
							mapBuild[k].used = true
						end
					end
					--spEcho(buildingSizeX,buildingSizeZ,jLimit,kLimit,mapBuild[thisPosIndex].posX,mapBuild[thisPosIndex].posZ,test)
					return mapBuild[thisPosIndex].posX, mapBuild[thisPosIndex].posZ, test
				end
			end
		end
	end
	if (water) then
	    groupInfo[groupID].buildWaterAllUsed = true  -- no build space in the water
		--spEcho("No space in the water, says group: ", groupID)
	else
	    groupInfo[groupID].buildGroundAllUsed = true  -- no build space on the ground
		--spEcho("No space on the ground, says group: ", groupID)
        --- ! need to be added cleaner for buildpositions
    end
	-- !! second chance for spots of destroed buildings is not yet implemented
	return 0, 0, 0
end

local function CheckTechOneFactoriesCounts(teamNumber)
    local thisTeam = teamInfo[teamNumber]
	local botCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.botLabTech1]].count or 0
	local vehCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.vehLabTech1]].count or 0
	local airCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.airLabTech1]].count or 0
    return botCount,vehCount,airCount
end

local function CheckTechTwoGroundFactoriesCounts(teamNumber)
    local thisTeam = teamInfo[teamNumber]
	local botCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.botLabTech2]].count or 0
	local vehCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.vehLabTech2]].count or 0
	local airCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.airLabTech2]].count or 0
    return botCount,vehCount,airCount
end

local function CheckTechTwoExpansionsCounts(teamNumber)
    local thisTeam = teamInfo[teamNumber]
	local botTechCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.botTech2]].count or 0
	local vehTechCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.vehTech2]].count or 0
	local airTechCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.airTech2]].count or 0
	local defTechCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.defTech2]].count or 0
    return botTechCount,vehTechCount,airTechCount,defTechCount
end

local function CheckMohoCount(teamNumber)
    local thisTeam = teamInfo[teamNumber]
	local mohoCount = thisTeam.unitTypeCount[fromIDToNameTable[thisTeam.keyUnitIDs.mohoMiner]].count or 0
    return mohoCount
end

local function ChooseTheFactoryType(teamNumber)   -- ! not finished
    local thisTeam     = teamInfo[teamNumber]
	local pseudoNumber = pseudoRandom % 6
	local factoryType 
	if     ((pseudoNumber == 0) or (pseudoNumber == 3) or (pseudoNumber == 5)) then factoryType = thisTeam.keyUnitIDs.botLabTech1
	elseif ((pseudoNumber == 1) or (pseudoNumber == 4)) then                        factoryType = thisTeam.keyUnitIDs.vehLabTech1
	elseif (pseudoNumber == 2) then                                                 factoryType = thisTeam.keyUnitIDs.airLabTech1
	elseif (false) then factoryType = thisTeam.keyUnitIDs.shipyard   --- !! not ready the building of shipyard
	else 
	    factoryType = thisTeam.keyUnitIDs.hoversPlatform 
		spEcho("random number dont work")
	end
	pseudoRandom = pseudoRandom + 1
	return factoryType
end

local function ChooseAdvancedFactoryType(groupID,teamNumber)
    local thisTeam  = teamInfo[teamNumber]
    local thisGroup = groupInfo[groupID]
	local factoryType
	if ((thisGroup.name == "arm2kbotGroup-one") or (thisGroup.name == "arm2kbotGroup-two") or (thisGroup.name == "arm2kbotGroup-three") or (thisGroup.name == "cor2kbotGroup-one") or (thisGroup.name == "cor2kbotGroup-two") or (thisGroup.name == "cor2kbotGroup-three")) then  
		factoryType = thisTeam.keyUnitIDs.botLabTech2
	elseif ((thisGroup.name == "arm2vehGroup-one") or (thisGroup.name == "arm2vehGroup-two") or (thisGroup.name == "arm2vehGroup-three") or (thisGroup.name == "cor2vehGroup-one") or (thisGroup.name == "cor2vehGroup-two") or (thisGroup.name == "cor2vehGroup-three")) then
	    factoryType = thisTeam.keyUnitIDs.vehLabTech2
	elseif ((thisGroup.name == "arm2airGroup-one") or (thisGroup.name == "arm2airGroup-two") or (thisGroup.name == "arm2airGroup-three") or (thisGroup.name == "cor2airGroup-one") or (thisGroup.name == "cor2airGroup-two") or (thisGroup.name == "cor2airGroup-three")) then
	    factoryType = thisTeam.keyUnitIDs.airLabTech2
	else
	    factoryType = thisTeam.keyUnitIDs.botLabTech2
	    spEcho("this group dont have any factory in buildlist: ", thisGroup.name)
	end
	return factoryType
end

local function ChooseExpansionType(teamNumber)
    local thisTeam     = teamInfo[teamNumber]
	local pseudoNumber = pseudoRandom % 10         -- only first two now
	local expansionType 
	if     ((pseudoNumber == 0) or (pseudoNumber == 7) or (pseudoNumber == 8)) then expansionType = thisTeam.keyUnitIDs.botTech2
	elseif ((pseudoNumber == 1) or (pseudoNumber == 6) or (pseudoNumber == 9)) then expansionType = thisTeam.keyUnitIDs.vehTech2
	elseif ((pseudoNumber == 2) or (pseudoNumber == 5)) then expansionType = thisTeam.keyUnitIDs.airTech2
	elseif ((pseudoNumber == 3) or (pseudoNumber == 4)) then expansionType = thisTeam.keyUnitIDs.defTech2
	else 
	    expansionType = thisTeam.keyUnitIDs.botTech2 
		spEcho("expansion type randomizer dont work")
	end
	pseudoRandom = pseudoRandom + 1
	return expansionType
end

local function ChooseRandomTargetClass(groupID)
    local thisGroupClasses = groupInfo[groupID].targetClasses
	local numberOfClasses  = #thisGroupClasses
	local targetClass      = "none"
	if (numberOfClasses > 0) then
		local classPosition    = (pseudoRandom % numberOfClasses) + 1
		targetClass            = thisGroupClasses[classPosition]
	else
	    spEcho("This group has no target classes defined: ", groupID)
	end
	pseudoRandom = pseudoRandom + 1
	return targetClass
end

local function IdleTest(groupID,test)
	if (test == 0) then -- if no mex was build
		groupInfo[groupID].status      = "idle"
		groupInfo[groupID].buildStatus = "idle"
	end
end

local function ChooseMexSpot(teamNumber,kind)
    local thisTeam   = teamInfo[teamNumber]
	local hisMexes   = thisTeam.listOfMexes
	local buildingID 
	if     (kind == "ground") then
	    buildingID = thisTeam.keyUnitIDs.basicGroundMex
	elseif (kind == "water") then
	    buildingID = thisTeam.keyUnitIDs.floatingMex
	elseif (kind == "underwater") then
	    buildingID = thisTeam.keyUnitIDs.underwaterMex
	end
	local attempts      = thisTeam.minAttempts
	local numberOfMexes = #hisMexes
	for i=1,numberOfMexes do
		if (thisTeam.listOfMexesAttemptsCounter[i] == attempts) then
			local thisMex  = mapMetal[hisMexes[i]]
			-- ! here can be speedup condition for testing only right buildingIDs on the right positions, but its doesnt matter much i think
			local test     = spTestBuildOrder(buildingID,thisMex.posX, 0 ,thisMex.posZ, 2)
			if (test == 2) then
			    local adding                           = mCeil(i / (numberOfMexes/4))
			    thisTeam.listOfMexesAttemptsCounter[i] = thisTeam.listOfMexesAttemptsCounter[i] + adding
				return hisMexes[i]
			end
		end
	end
	thisTeam.minAttempts = thisTeam.minAttempts + 1
	return 0
end

local function ChooseClosestSpot(teamNumber,kind,posX,posZ)
    local thisTeam   = teamInfo[teamNumber]
	local hisMexes   = thisTeam.listOfMexes
	local buildingID 
	if     (kind == "ground") then
	    buildingID = thisTeam.keyUnitIDs.basicGroundMex
	elseif (kind == "water") then
	    buildingID = thisTeam.keyUnitIDs.floatingMex
	elseif (kind == "underwater") then
	    buildingID = thisTeam.keyUnitIDs.underwaterMex
	end
	local numberOfMexes = #mapMetal
	local distance      = 1000*1000*1000*1000
	local resultID
	for i=1,numberOfMexes do
	    local thisMex   = mapMetal[i]
		local test      = spTestBuildOrder(buildingID,thisMex.posX, 0 ,thisMex.posZ, 2)
		if (test == 2) then
		    local thisDistance = GetDistance2DSQ(thisMex.posX,thisMex.posZ,posX,posZ) * ((thisTeam.listOfMexesAttemptsCounter[i] + 1)/2)
			--Spring.Echo(i,thisDistance)
			if (thisDistance < distance) then
			    distance = thisDistance
			    resultID = i
			end
		end
	end
	---
	if (resultID == nil) then
	    return 0
	else
	    --Spring.Echo(resultID)
		--- change the table of attempts
		thisTeam.listOfMexesAttemptsCounter[resultID] = thisTeam.listOfMexesAttemptsCounter[resultID] + 1
		--- return result
	    return resultID
	end
end

local function ChooseClosestTargetGivenClass(teamNumber,class,posX,posZ)

    --- derived from choose closest spot + get one valuable target
    local thisTeam      = teamInfo[teamNumber]
	local distance      = 1000*1000*1000*1000
	local resultID
	local valuablesAlive = teamInfo[teamNumber].listOfStrategicTargetsAlive
	local valuablesInfo  = teamInfo[teamNumber].listOfStrategicTargets
	local valuablesCount = #valuablesAlive
	for i=1,valuablesCount do
	    if (valuablesAlive[i]) then
			local thisValuable = valuablesInfo[i]
			if ((thisValuable.class == class) or (class == "all")) then
				local thisDistance = GetDistance2DSQ(thisValuable.posX,thisValuable.posZ,posX,posZ)
				--Spring.Echo(i,thisDistance)
				if (thisDistance < distance) then
					distance = thisDistance
					resultID = i
				end
				-- if (thisDistance <= 1000000) then
				    -- resultID = i
					-- break
				-- end
			end
		end
	end
	---
	if (resultID == nil) then
	    return 0
	else
	    --Spring.Echo(resultID)
	    return resultID
	end
end

local function GetOneValuableTarget(groupID,teamNumber,class)
    local valuablesAlive = teamInfo[teamNumber].listOfStrategicTargetsAlive
	local valuablesInfo  = teamInfo[teamNumber].listOfStrategicTargets
	local valuablesCount = #valuablesAlive
	local startIndex     = OwnRandom(1,valuablesCount)
	if (class == "none") then spEcho("NOE error: no class ",groupID,teamNumber) end
	for i=startIndex,2*valuablesCount do
	    local realIndex = (i % valuablesCount) + 1
	    if (valuablesAlive[realIndex]) then
		    local thisValuable = valuablesInfo[realIndex]
		    if (thisValuable.class == class and thisValuable.isNotTarget) then
			    if (class == "metal") then
			        thisValuable.isNotTarget = false
				    teamInfo[teamNumber].countOfStrategicTargetsUsed = teamInfo[teamNumber].countOfStrategicTargetsUsed + 1
				end
				thisValuable.attacker    = groupID
				--!test things.. these /commented/ lines of code, or in condition
			    return realIndex  ---- returning only index from tab, not real unitID
			end
		end
	end
	return 0
end

local function BuildMex(thisID,teamNumber,mexID)
	local mexX      = mapMetal[mexID].posX
	local mexY      = mapMetal[mexID].height
	local mexZ      = mapMetal[mexID].posZ
	local waterSpot = mapMetal[mexID].water
	local targetID
	if (waterSpot) then
		targetID = teamInfo[teamNumber].keyUnitIDs.floatingMex
	else
		targetID = teamInfo[teamNumber].keyUnitIDs.basicGroundMex
	end
	local test = spTestBuildOrder(targetID,mexX, mexY ,mexZ, 2)
	if (test == 2) then
		spGiveOrderToUnit(thisID, -targetID , {mexX,mexY,mexZ}, {"shift"})
	end
	return test
end


local function BuildSolar(groupID,teamNumber)
    -- ! make it later
end

plan = {
	---- GROUP FUNCTIONS ---
	["changeTaskStatus"] = function(groupID,status,accept)
		groupInfo[groupID].taskStatus 		= status
		groupInfo[groupID].acceptingUnits	= accept
		return true
	end,
	["operationalStatusCheck"] = function(groupID)
		local thisGroup = groupInfo[groupID]
		local oldStatus = thisGroup.operationalStatus
		if     (thisGroup.membersListCounter <= thisGroup.operationalStatusLimits[1]) then
			thisGroup.operationalStatus = "IOA"
		elseif (thisGroup.membersListCounter <= thisGroup.operationalStatusLimits[2]) then
			thisGroup.operationalStatus = "HL"
		elseif (thisGroup.membersListCounter <= thisGroup.operationalStatusLimits[3]) then
			thisGroup.operationalStatus = "LL"
		elseif (thisGroup.membersListCounter <= thisGroup.operationalStatusLimits[4]) then
			thisGroup.operationalStatus = "ready"
		else
			thisGroup.operationalStatus = "full"
		end
		if (oldStatus ~= thisGroup.operationalStatus) then  -- so: status changed
			thisGroup.target.hasAny = false
			local thisTeam          = teamInfo[thisGroup.teamNumber]
			local targetIndex       = thisGroup.target.index
			thisGroup.constrainLevel= thisGroup.constrainLevel + 8
			if (thisTeam.listOfValuables ~= nil) then
				thisTeam.listOfValuables[targetIndex].isNotTarget = true -- changing target, so this target is no longer aimed 
			end
		end
		return thisGroup.operationalStatus
	end,
	["mexesBucketInit"] = function(teamNumber)
		local counter              = 1
		local thisTeam             = teamInfo[teamNumber]
		local distanceClassesTable = {}
		local startX,_,startZ      = spGetTeamStartPosition(thisTeam.teamID)
		local theBiggestClass      = 1
		local bucket               = 800
		local bucketSQ             = bucket*bucket
		for j=1,#mapMetal do
			local distance       = GetDistance2DSQ(startX,startZ,mapMetal[j].posX,mapMetal[j].posZ)
			local distanceClass  = mFloor(distance / bucketSQ) + 1
			local index          = "i" .. distanceClass
			if (distanceClassesTable[index]  == nil) then
				distanceClassesTable[index]  = {}
			end
			local thisClassTable  = distanceClassesTable[index]
			thisClassTable[#thisClassTable + 1] = j           --- saving the id of spot on the end of the list of given class
			if (distanceClass > theBiggestClass) then
				theBiggestClass = distanceClass
			end
		end
		for k=1,theBiggestClass do
			local index          = "i" .. k
			local thisClassTable = distanceClassesTable[index]
			if (thisClassTable ~= nil) then
				for l=1,#thisClassTable do
					thisTeam.listOfMexes[counter]                = thisClassTable[l]
					thisTeam.listOfMexesAttemptsCounter[counter] = 0
					counter                                      = counter + 1
					--spEcho(thisClassTable[l])
				end
			end
			--spEcho("..")
		end
	end,
	["giveArea"] = function(areaCenter,radius)
		local posX,posZ = areaCenter[1],areaCenter[2]
		return posX - radius, posZ - radius, posX + radius, posZ + radius
	end,
	["getOneTargetInArea"] = function(posMinX,posMinZ,posMaxX,posMaxZ,enemyAllyTeamID)
		local enemyAllyTeams 	= spGetTeamList(enemyAllyTeamID)
		local unitID 			= 0
		--Spring.Echo(enemyAllyTeamID,enemyAllyTeams[1],#enemyAllyTeams)
		for i=1,#enemyAllyTeams do
			local unitsInArea = spGetUnitsInRectangle(posMinX,posMinZ,posMaxX,posMaxZ,enemyAllyTeams[i])
			--Spring.Echo(unitsInArea[1])
			if ((unitsInArea ~= nil) and (#unitsInArea > 0)) then
				--for j=1,#unitsInArea do Spring.Echo(unitsInArea[randomID]) end
				local randomID 	= mRandom(1,#unitsInArea)
				unitID 			= unitsInArea[randomID]
				break
			end
		end
		return unitID
	end,	
	["facingToGatheringPoint"] = function(unitID)
		local facing 			= spGetUnitBuildFacing(unitID)
		local posX,posY,posZ 	= spGetUnitPosition(unitID)
		local facingTable		= {			
			{0,1},						-- south
			{1,0},						-- east
			{0,-1},						-- north
			{-1,0},						-- west
		}
		local scale				= 250
		spGiveOrderToUnit(unitID, CMD_MOVE , {posX + (facingTable[facing+1][1]*scale),posY,posZ + (facingTable[facing+1][2]*scale)}, {"shift"})
	end,
    ---- BUFFER STUFF ---
	["bufferTransfer"] = function(groupID)
		local thisGroup          = groupInfo[groupID]
		local listOfDependantIDs = thisGroup.bufferGroupIDs
		for i=1,#listOfDependantIDs do
			local secondGroup 	= groupInfo[listOfDependantIDs[i]]
			if ((thisGroup.membersListCounter >= secondGroup.transferCount) and secondGroup.acceptingUnits and secondGroup.active) then
				PrepareFirstUnit(secondGroup.groupED)  -- to prevent returning to "new leader's pos"
				local success = ChangeUnitGroup(secondGroup.transferCount,thisGroup.groupED,secondGroup.groupED)
				if (success) then 
					return true
				end
			end
		end
		return false
	end,
	["bufferDirectTransfer"] = function(groupID,targetGroupListID)
		local thisGroup				= groupInfo[groupID]
		local listOfDependantIDs	= thisGroup.bufferGroupIDs
		local secondGroup 			= groupInfo[listOfDependantIDs[targetGroupListID]]
		local leaderActive 			= true
		--- section for dependant buffers ---
		-- if (thisGroup.dependant) then
			-- thisLeader 			= groupInfo[thisGroup.itsLeaderID]
			-- leadersDependantIDs	= thisLeader.bufferGroupIDs
			-- directLeader		= groupInfo[leadersDependantIDs[targetGroupListID]]
			-- if (not directLeader.active) then
				-- leaderActive	= false
			-- end
		-- end
		--- main direct transfer
		if ((thisGroup.membersListCounter >= secondGroup.transferCount) and secondGroup.acceptingUnits and secondGroup.active and leaderActive) then
			PrepareFirstUnit(secondGroup.groupED)  -- to prevent returning to "new leader's pos"
			local success = ChangeUnitGroup(secondGroup.transferCount,thisGroup.groupED,secondGroup.groupED)
			if (success) then 
				return true
			end
		end
		return false
	end,
	["bufferCommand"] = function(groupID)
		local thisGroup          = groupInfo[groupID]
		-- how many members i have?
		-- Spring.Echo(thisGroup.name,thisGroup.membersListCounter,thisGroup.membersListMax,thisGroup.waitingOrders,thisGroup.transferCount)
		
		if (thisGroup.membersListCounter >= thisGroup.membersListMax) then
			-- if full - i do nothing
			return true
		else
			-- if not - we have to build something
			if (thisGroup.waitingOrders > thisGroup.transferCount) then
				-- if eq or more then my transfer number odered - do nothing
				return true
			else
				-- if less -> order to one of my factories
				
				-- choose factory from list
				local factoryGroupID = plan.factoryGroupChoose(thisGroup.factoriesGroupsIDs)
			
				-- and update buildlist
				if (thisGroup.name == "TGInstigatorBuffer") then Spring.Echo(thisGroup.name,thisGroup.membersListCounter,thisGroup.membersListMax,thisGroup.waitingOrders,thisGroup.transferCount,factoryGroupID,groupID,thisGroup.unitName,thisGroup.transferCount) end
				plan.factoryCommand(factoryGroupID,groupID,thisGroup.unitName,thisGroup.transferCount)
				return true
			end
		end
	end,
	["factoryCommand"] = function(factoryGroupID,orderingGroupID,unitDefName,numberOfUnits)
		if (factoryGroupID == 0) then
			return false
		else
			-- ! for more factories
			local unitsOrdered							= 0
			local thisGroup								= groupInfo[factoryGroupID]
			local unitDefID 							= fromNameToIDTable[unitDefName]				-- unit i build
			for i=1,thisGroup.membersListMax do
				if (thisGroup.membersListAlive[i]) then
					for c=1,numberOfUnits do
						spGiveOrderToUnit(thisGroup.membersList[i], -unitDefID, {}, {})						-- give order itself
					end	
					unitsOrdered = unitsOrdered + numberOfUnits
				end
			end
			groupInfo[factoryGroupID].waitingOrders 	= thisGroup.waitingOrders + unitsOrdered		-- update orders in factory - .waitingOrders
			groupInfo[orderingGroupID].waitingOrders	= thisGroup.waitingOrders + unitsOrdered		-- update buffer counter - .waitingOrders
			groupInfo[factoryGroupID].lastOrderID		= orderingGroupID								-- update last factory user		
			return true
		end
	end,
	["factoryGroupChoose"] = function(factoriesGroupsIDs)	
		if ((factoriesGroupsIDs == nil) or (#factoriesGroupsIDs < 1)) then
			return 0
		else
			local factoryGroupID				= 0
			local theMostLazyFactoryRating		= 100
			
			-- find the most lazy factory under my command
			for i=1,#factoriesGroupsIDs do
				local queueSize					= plan.factoriesQueuesSize(factoriesGroupsIDs[i])
				if (theMostLazyFactoryRating >= queueSize) then
					factoryGroupID				= factoriesGroupsIDs[i]
					theMostLazyFactoryRating	= queueSize
				end
			end
			return factoryGroupID
		end
	end,
	["factoriesQueuesSize"] = function(factoryGroupID)	
		local thisGroup			= groupInfo[factoryGroupID]
		local totalSizeOfQueues	= 0
		for i=1,thisGroup.membersListMax do
			if (thisGroup.membersListAlive[i]) then
				local queue			= spGetFactoryCommands(thisGroup.membersList[i])
				local queueLentght	= 0
				if (queue ~= nil) then queueLentght = #queue end
				totalSizeOfQueues	= totalSizeOfQueues + queueLentght
			end
		end
		return totalSizeOfQueues
	end,
	---- START QUEQUE FOR TOWER ----
    ["buildFirstThreeMexes"] = function(groupID,teamNumber)
	    local thisGroup  = groupInfo[groupID]
		local thisID     = thisGroup.membersList[1]
	    local mexIDs     = thisGroup.metalListInRange
		local test       = 2  
	    for i=1,3 do
		    if (mexIDs[i] == nil) then
			    test = 0
				break
			else
				test = BuildMex(thisID,teamNumber,mexIDs[i])
			end
	    end
		thisGroup.buildStatus = "buildingMexes"
		IdleTest(groupID,test)
	end,
    ["buildTwoSolars"] = function(groupID,teamNumber)
	    local thisGroup         = groupInfo[groupID]
		local thisTeam          = teamInfo[teamNumber]
		local thisID            = thisGroup.membersList[1]
		local targetID          = thisTeam.keyUnitIDs.basicStableGroundEnergyResource
		local spotX,spotZ,test
		for i=1,2 do
			spotX,spotZ,test  = GetBuildSpotFromMap(groupID,targetID,false)
			local spotY       = 0 -- spGetGroundHeight(spotX,spotZ)	
			-- local test        = spTestBuildOrder(targetID, spotX, 0 ,spotZ, 0)
			-- spEcho(test,spotX,spotY,spotZ,thisGroup.posX,thisGroup.posZ,GetDistance2D(spotX,spotZ,thisGroup.posX,thisGroup.posZ))
			spGiveOrderToUnit(thisID, -targetID , {spotX,spotY,spotZ}, {"shift"})
	    end
		thisGroup.buildStatus = "buildingSolars"
		IdleTest(groupID,test)
		--spEcho("building solars ", reverseUnitsGroupID[thisID],fromIDToNameTable[targetID])
	end,
	["buildAnotherThreeMexes"] = function(groupID,teamNumber)
	    local thisGroup  = groupInfo[groupID]
		local thisID     = thisGroup.membersList[1]
	    local mexIDs     = thisGroup.metalListInRange
		local test       = 2
	    for i=4,6 do
		    if (mexIDs[i] == nil) then
			    test = 0
				break
			else
				test = BuildMex(thisID,teamNumber,mexIDs[i])
			end
	    end
		thisGroup.buildStatus = "buildingMexes"
		IdleTest(groupID,test)
	end,
	["buildAllMexes"] = function(groupID,teamNumber)
	    local thisGroup  = groupInfo[groupID]
		local thisID     = thisGroup.membersList[1]
	    local mexIDs     = thisGroup.metalListInRange
		local test       = 2     
	    for i=1,#mexIDs do
			test = BuildMex(thisID,teamNumber,mexIDs[i])
	    end
		thisGroup.buildStatus = "buildingMexes"
		IdleTest(groupID,test)
	end,
	["buildAllMexesFirst"] = function(groupID,teamNumber)
	    plan["buildAllMexes"](groupID,teamNumber)
	end,
	["buildFactory"] = function(groupID,teamNumber,factoryType)
	    local thisGroup         = groupInfo[groupID]
		local thisTeam          = teamInfo[teamNumber]
		local thisID            = thisGroup.membersList[1]
		local spotX,spotZ,test  = GetBuildSpot(thisGroup.posX,thisGroup.posZ,factoryType,200)
		if (test == 0) then 
		    spotX,spotZ,test  = GetBuildSpotFromMap(groupID,factoryType,false)
		end
		spGiveOrderToUnit(thisID, -factoryType , {spotX,0,spotZ}, {"shift"})
		thisGroup.buildStatus = "buildingFactory"
		IdleTest(groupID,test)
	end,
	["buildKbotFactoryFirst"] = function(groupID,teamNumber)
	    plan["buildFactory"](groupID,teamNumber,teamInfo[teamNumber].keyUnitIDs.botLabTech1)
	end,
	["buildFiveSolars"] = function(groupID,teamNumber)
	    local thisGroup         = groupInfo[groupID]
		local thisTeam          = teamInfo[teamNumber]
		local thisID            = thisGroup.membersList[1]
		local targetID          = thisTeam.keyUnitIDs.basicStableGroundEnergyResource
		local spotX,spotZ,test
		for i=1,5 do
		    spotX,spotZ,test  = GetBuildSpotFromMap(groupID,targetID,false)
			local spotY       = 0 -- spGetGroundHeight(spotX,spotZ)	
			spGiveOrderToUnit(thisID, -targetID , {spotX,spotY,spotZ}, {"shift"})
	    end
		thisGroup.buildStatus = "buildingSolars"
		IdleTest(groupID,test)
	end,
	["buildAditionalEnergy"] = function(groupID,teamNumber,incomeEnergy)
	    local thisGroup         = groupInfo[groupID]
		local thisTeam          = teamInfo[teamNumber]
		local thisID            = thisGroup.membersList[1]
		local targetID
		local waterSource       = false
		local howMany           = 1
		if (incomeEnergy <= 1100) then
			if     ((wind >= 15) and not(groupInfo[groupID].buildGroundAllUsed)) then
			   targetID    = thisTeam.keyUnitIDs.basicUnStableGroundEnergyResource
			   howMany     = 5
			elseif ((tidal >= 15) and not(groupInfo[groupID].buildWaterAllUsed)) then
			   targetID    = thisTeam.keyUnitIDs.basicWaterStableEnergyResource
			   howMany     = 5
			   waterSource = true
			elseif ((wind >= 9) and not(groupInfo[groupID].buildGroundAllUsed)) then
			   targetID    = thisTeam.keyUnitIDs.basicUnStableGroundEnergyResource
			   howMany     = 5
			elseif ((tidal >= 12) and not(groupInfo[groupID].buildWaterAllUsed)) then
			   targetID    = thisTeam.keyUnitIDs.basicWaterStableEnergyResource
			   waterSource = true
			   howMany     = 5
			else
			   targetID    = thisTeam.keyUnitIDs.basicStableGroundEnergyResource
			end
		else
		    targetID = thisTeam.keyUnitIDs.advancedStableGroundEnergyResource
			howMany  = 1
		end
		local spotX,spotZ,test
		for i=1,howMany do
		    spotX,spotZ,test  = GetBuildSpotFromMap(groupID,targetID,waterSource)
			local spotY       = 0 -- spGetGroundHeight(spotX,spotZ)	
			spGiveOrderToUnit(thisID, -targetID , {spotX,spotY,spotZ}, {"shift"})
	    end
		thisGroup.buildStatus = "buildingAditionalEnergy"
		if (targetID == thisTeam.keyUnitIDs.advancedStableGroundEnergyResource) then             -- if making fusion, make storage
		    plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.basicEnergyStorage)
		end
		IdleTest(groupID,test)
	end,
	["buildAditionalEnergyFirst"] = function(groupID,teamNumber)
	    plan["buildAditionalEnergy"](groupID,teamNumber,100)
	end,
    ["buildRadar"] = function(groupID,teamNumber)
	    local thisGroup         = groupInfo[groupID]
		local thisTeam          = teamInfo[teamNumber]
		local thisID            = thisGroup.membersList[1]
		local targetID          = thisTeam.keyUnitIDs.groundRadar
		local spots             = {}
		local maxY              = 0
		local maxIndex          = 1
		for i=1,15 do
		    spots[i]                                  = {} 
		    spots[i].posX,spots[i].posZ,spots[i].test = GetBuildSpot(thisTeam.mapBase.posX,thisTeam.mapBase.posZ,targetID,450)
			spots[i].posY                             = spGetGroundHeight(spots[i].posX,spots[i].posZ)
			if (spots[i].posY > maxY) then maxIndex = i end
	    end
		spGiveOrderToUnit(thisID, -targetID , {spots[maxIndex].posX,spots[maxIndex].posY,spots[maxIndex].posZ}, {"shift"})
		thisGroup.buildStatus = "buildingRadar"
		IdleTest(groupID,spots[maxIndex].test)
	end,
	["buildRadarFirst"] = function(groupID,teamNumber)
	    plan["buildRadar"](groupID,teamNumber)
	end,
	---- END OF START QUEQUE FOR TOWER ----
	["staticBuild"] = function(groupID,teamNumber,buildingID)
	    local thisGroup        = groupInfo[groupID]
		local thisID           = thisGroup.membersList[1]
		local spotX,spotZ,test = GetBuildSpotFromMap(groupID,buildingID,false)
		local spotY            = 0 -- spGetGroundHeight(spotX,spotZ)
		spGiveOrderToUnit(thisID, -buildingID , {spotX,spotY,spotZ}, {"shift"})
		thisGroup.buildStatus  = "building"
		IdleTest(groupID,test)
	end,
	["buildMetalMaker"] = function(groupID,teamNumber)
	    local thisGroup        = groupInfo[groupID]
		local thisID           = thisGroup.membersList[1]
		local targetID         = teamInfo[teamNumber].keyUnitIDs.basicMetalMaker
		local spotX,spotZ,test = GetBuildSpotFromMap(groupID,targetID,false)
		local spotY            = 0 -- spGetGroundHeight(spotX,spotZ)	
		spGiveOrderToUnit(thisID, -targetID , {spotX,spotY,spotZ}, {"shift"})
		thisGroup.buildStatus  = "buildingMetalMaker"
		IdleTest(groupID,test)
	end,
	["buildAdvancedFactory"] = function(groupID,teamNumber,factoryType)
	    -- ? maybe this plan is not needed
	    local thisGroup         = groupInfo[groupID]
		local thisTeam          = teamInfo[teamNumber]
		local thisID            = thisGroup.membersList[1]
		local spotX,spotZ,test  = GetBuildSpot(thisGroup.posX,thisGroup.posZ,factoryType,200)
		if (test == 0) then 
		    spotX,spotZ,test  = GetBuildSpotFromMap(groupID,factoryType,false)
		end
		spGiveOrderToUnit(thisID, -factoryType , {spotX,0,spotZ}, {"shift"})
		thisGroup.buildStatus = "buildingFactory"
		IdleTest(groupID,test)
	end,
	["addQueueLevel"] = function(groupID,teamNumber,factory,level)
        local thisGroup = groupInfo[groupID]
		local thisTeam  = teamInfo[teamNumber]
		local source    = "buildOrders" .. factory
		for i=1,thisGroup.membersListCounter do
		    if (thisGroup.membersListAlive[i]) then
				local thisMemberID  = thisGroup.membersList[i]
				local thisLevelList = thisTeam[source][level]
				for j=1,#thisLevelList do
					local thisUnitID    = fromNameToIDTable[thisLevelList[j][1]]
					local numberOfUnits = thisLevelList[j][2]
					if (thisUnitID == nil) then spEcho(groupID,teamNumber,source,level,thisMemberID) end  -- debug only
					for k=1,numberOfUnits do
						spGiveOrderToUnit(thisMemberID, -thisUnitID, {}, {})
					end
				end
			end
		end
		thisGroup.buildStatus = "makingUnitsOfLevel"
		-- ? doin' nothing test here?
	end,
	["expansion2zero"] = function(groupID,teamNumber)
	    local thisGroup = groupInfo[groupID]
		local thisTeam  = teamInfo[teamNumber]
		local factoryLimit = (thisTeam.metalStorage/5)*3
		if     (thisTeam.metalLevel >= factoryLimit) then
		    local factoryType = ChooseAdvancedFactoryType(groupID,teamNumber)
			-- make the factory of choosen type --
		    plan["buildAdvancedFactory"](groupID,teamNumber,factoryType)
			if (factoryType == thisTeam.keyUnitIDs.airLabTech2) then
			    plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticAirpad)
			    plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticAirpad)
				plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticAirpad)
			end
            plan["tryMohoNeed"](groupID,teamNumber)
		else
		    -- waiting or doing diff things 
		end
		if (thisGroup.buildGroundAllUsed) then
			thisGroup.buildStatus = "patroling"
		end
		thisGroup.buildStatus = "doingZero"
	end,
	["expansion2defZero"] = function(groupID,teamNumber)
	    local thisGroup  = groupInfo[groupID]
		local thisTeam   = teamInfo[teamNumber]
		local buildLimit = (thisTeam.metalStorage/5)*3
		if     (thisTeam.metalLevel >= buildLimit) then
		    plan["tryMohoNeed"](groupID,teamNumber)
			-- make the factory of choosen type --
		    plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.nukeSilo)
			plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticFlak)
			plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticFlak)
			plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticFlak)
			plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticFlak)
			plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticFlak)
			plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.lrpc)
			plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.anniLaser)
		else
		    -- waiting or doing diff things 
		end
		if (thisGroup.buildGroundAllUsed) then
			thisGroup.buildStatus = "patroling"
		end
		thisGroup.buildStatus = "doingZero"
	end,	
    ["tryMohoNeed"] = function(groupID,teamNumber)
	    thisTeam = teamInfo[teamNumber]
		local mohoCount = CheckMohoCount(teamNumber)
		if (mohoCount <= 1) then
			plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.mohoMiner)
		end
	end,	
	["zeroLevel"] = function(groupID,teamNumber)
	    local thisGroup    = groupInfo[groupID]
		local thisTeam     = teamInfo[teamNumber]
		local mmkrLimit    = (thisTeam.energyStorage/10)*8
		local factoryLimit = (thisTeam.metalStorage/5)*3
		local minimalEnergy= (thisTeam.energyStorage/3)
		--spEcho(teamNumber,thisTeam.metalLevel,thisTeam.metalStorage,thisTeam.energyLevel,thisTeam.energyStorage)
		local bot,veh,air = CheckTechOneFactoriesCounts(teamNumber)
		if     ((thisTeam.metalLevel >= factoryLimit) and (thisTeam.energyLevel >= minimalEnergy)) then
			if (((bot + veh + air) >= 4) and (bot >= 2)) then
			    local bot2,veh2,air2 = CheckTechTwoGroundFactoriesCounts(teamNumber)
			    if (((bot2 + veh2 + air2) % 5) == 3) then
				    plan["buildFactory"](groupID,teamNumber,thisTeam.keyUnitIDs.airLabTech1)
					plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticAirpad)
					plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticAirpad)
					plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.airLabTech1)
					plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticAirpad)
					plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticAirpad)
				else
				    local botTechCount,vehTechCount,airTechCount,defTechCount = CheckTechTwoExpansionsCounts(teamNumber)
					if ((botTechCount + vehTechCount + airTechCount + defTechCount) >= 3) then
					    plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.plasmaBattery)
						plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.llt)
						plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticFlak)
						plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticFlak)
						plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.basicMetalStorage)
						plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.basicEnergyStorage)
					else
						-- choose expainsion type
						-- !! here it needs more more clever procedure or brain decision
						local expansionType = ChooseExpansionType(teamNumber)
						-- make the factory of choosen type --
						plan["staticBuild"](groupID,teamNumber,expansionType)
					end
				end
			else
				local factoryType = ChooseTheFactoryType(teamNumber)
				-- make the factory of choosen type --
				plan["buildFactory"](groupID,teamNumber,factoryType)
				if (factoryType == thisTeam.keyUnitIDs.airLabTech1) then
					plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticAirpad)
					plan["staticBuild"](groupID,teamNumber,thisTeam.keyUnitIDs.staticAirpad)
			    end
			end			
		elseif (thisTeam.energyLevel >= mmkrLimit) then
		    --spEcho(teamNumber .. " .. is choosing MM + add")
		    plan["buildMetalMaker"](groupID,teamNumber)
		else
		    plan["buildAditionalEnergy"](groupID,teamNumber,thisTeam.energyIncome)
		end
		plan["buildAllMexes"](groupID,teamNumber)  -- test (restoring dead mexes)
		if (bot < 1) then
		    plan["buildFactory"](groupID,teamNumber,thisTeam.keyUnitIDs.botLabTech1)
		end
		if (thisGroup.buildGroundAllUsed) then
			thisGroup.planCurrent = "firstLevel"
		end
		thisGroup.buildStatus = "doingZero"
	end,
	["firstLevel"] = function(groupID,teamNumber)
	    -- nothing yet
		plan["buildAllMexes"](groupID,teamNumber)  -- test (restoring dead mexes)
		thisGroup.buildStatus = "doinFirst"
	end,
	["stop"] = function(groupID,teamNumber)
	    -- = do nothing
		local thisGroup       = groupInfo[groupID]
		thisGroup.buildStatus = "stopped"
		--thisGroup.planCurrent = "staticPatrol"
	end,
    ["staticPatrol"] = function(groupID,teamNumber)
	    -- = do nothing
		local thisGroup       = groupInfo[groupID]
		if (thisGroup.buildStatus ~= "patroling") then	
			for i=1,thisGroup.membersListMax do
				if (thisGroup.membersListAlive[i]) then
					spGiveOrderToUnit(thisGroup.membersList[i], CMD_PATROL, { thisGroup.posX+50, 0, thisGroup.posZ +50 }, {})				
				end
			end
		end
		thisGroup.buildStatus = "patroling"
	end,
    --- ADVANCED BATTLE PLANS --- => the plans i planned in first design idea of NOE, but there was no time to do it this way _:)
	["pathCleaner"] = function(groupID,teamNumber)
		-- group is waiting at WaitingPoint until at least one alert or/and conditions are satisfied and until there is enough units in group ("ready", "full")
		-- when completed task, group fights and try to clear area along the taskPath until IOA
		-- when IOA or task is finished, group returns on ReturnPoint
	
	    PrepareFirstUnit(groupID)
		-- init --
		if (groupInfo[groupID].initialization) then
			groupInfo[groupID].initialization	= false
			groupInfo[groupID].taskStatus		= "startPosition"
			groupInfo[groupID].taskInfo			= {
				spotNumber	= 1,
			}
		end
		
		local thisGroup						= groupInfo[groupID]
		local thisPosX,thisPosY,thisPosZ	= GetPositionOfGroup(groupID)
		local status						= plan.operationalStatusCheck(groupID)
		local thisTask						= task[thisGroup.taskName]
		local returnPoint					= thisTask.pathName .. "ReturnPoint"
		local waitingPoint					= thisTask.pathName .. "WaitingPoint"
		
		-- startPosition --
		if (thisGroup.taskStatus == "startPosition") then
			-- alerts + conditions
			local someAlert		= condition.checkAlerts(missionKnowledge.areasAlert,thisTask.alertListIndexes,thisTask.alertLimit)
			local conditions	= condition.conjunction(thisTask.conditionNames)
			
			-- full or ready + enemy in area
			if ((status == "full" or status == "ready") and someAlert and conditions)  then
				plan.changeTaskStatus(groupID,"onTask",false)
				local moveX,moveZ	= map[thisTask.pathName][1][1],map[thisTask.pathName][1][2]
				local moveY			= spGetGroundHeight(moveX,moveZ)
				BigMove(groupID,moveX,moveY,moveZ,0,thisGroup.formation,waiting)
			-- if not, waiting
			else
				-- wait
			end
			
		-- onTask --
		elseif (thisGroup.taskStatus == "onTask") then
			-- ioa?
			if (status == "IOA") then
				plan.changeTaskStatus(groupID,"returning",false)
				groupInfo[groupID].taskInfo.spotNumber	= 1
				local moveX,moveZ						= map[returnPoint][1],map[returnPoint][2]
				local moveY								= spGetGroundHeight(moveX,moveZ)
				BigMove(groupID,moveX,moveY,moveZ,1,thisGroup.formation,waiting)
			-- if not, continue in task
			else
				-- TASK itself:
				
				-- distance --
				local spotID		= thisGroup.taskInfo.spotNumber
				local choosenPath	= map[thisTask.pathName]
				local pathType		= 0				-- ! maybe choose the pathType marking 
				if ((spotID == 1) or (spotID == 2) or (spotID == #choosenPath)) then pathType = 1 end
				local distanceSQ	= GetDistance2DSQ(thisPosX,thisPosZ,choosenPath[spotID][1],choosenPath[spotID][2])
				-- close?
				if (distanceSQ <= thisTask.limitDistance) then
					groupInfo[groupID].taskInfo.spotNumber	= spotID + 1
					-- if last, go home 
					if ((spotID + 1) > #choosenPath) then
						-- prepare default for next attack
						groupInfo[groupID].taskInfo.spotNumber	= 1
						-- and change status
						plan.changeTaskStatus(groupID,"returning",false)
						local moveX,moveZ	= map[returnPoint][1],map[returnPoint][2]
						local moveY			= spGetGroundHeight(moveX,moveZ)
						BigMove(groupID,moveX,moveY,moveZ,pathType,thisGroup.formation,waiting)
					end
				-- if not, continue in move
				else
					local moveX,moveZ	= map[thisTask.pathName][spotID][1],map[thisTask.pathName][spotID][2]
					local moveY			= spGetGroundHeight(moveX,moveZ)
					BigMove(groupID,moveX,moveY,moveZ,pathType,thisGroup.formation,waiting)
				end
			end
			
		-- returning --
		elseif (thisGroup.taskStatus == "returning") then
			local distanceSQ    = GetDistance2DSQ(thisPosX,thisPosZ,map[returnPoint][1],map[returnPoint][2])

			-- is at home?
			if (distanceSQ <= thisTask.limitDistance) then
				plan.changeTaskStatus(groupID,"startPosition",true)
				local moveX,moveZ	= map[waitingPoint][1],map[waitingPoint][2]
				local moveY			= spGetGroundHeight(moveX,moveZ)
				BigMove(groupID,moveX,moveY,moveZ,0,thisGroup.formation,waiting)
			-- if not, wait
			else	
				-- still go home
				local moveX,moveZ	= map[returnPoint][1],map[returnPoint][2]
				local moveY			= spGetGroundHeight(moveX,moveZ)
				BigMove(groupID,moveX,moveY,moveZ,1,thisGroup.formation,waiting)

			end
		end
	end,
	["areaAirPatrol"] = function(groupID,teamNumber)
		-- just patrol around the given path --
		local thisGroup = groupInfo[groupID]
		if (thisGroup.receivedUnit) then
			for i=1,thisGroup.membersListMax do
				if (thisGroup.membersListAlive[i]) then
					local thisTask = task[thisGroup.taskName]
					local thisPath = map[thisTask.pathName]
					spGiveOrderToUnit(thisGroup.membersList[i], CMD_PATROL, { thisPath[1][1], 0, thisPath[1][2] }, {})
					for p=2,#thisPath do
						spGiveOrderToUnit(thisGroup.membersList[i], CMD_PATROL, { thisPath[p][1], 0, thisPath[p][2] }, {"shift"})
					end
					thisGroup.fightStatus = "patroling"
				end
			end
			thisGroup.receivedUnit = false
		end
	end,
	["strongUnitHunter"] = function(groupID,teamNumber)

	end,
	
}

local function RealBufferJob(groupID)
    local thisGroup          = groupInfo[groupID]
	local listOfDependantIDs = thisGroup.bufferGroupIDs
	local listSize           = #listOfDependantIDs
	local startIndex         = OwnRandom(1,listSize)
    for i=startIndex,2*listSize do
	    local realIndex   = (i % listSize) + 1
		local secondGroup = groupInfo[listOfDependantIDs[realIndex]]
		if ((thisGroup.membersListCounter >= secondGroup.transferCount) and secondGroup.acceptingUnits and secondGroup.active) then
		    PrepareFirstUnit(secondGroup.groupED)  -- to prevent returning to "new leader's pos"
			local success = ChangeUnitGroup(secondGroup.transferCount,thisGroup.groupED,secondGroup.groupED)
			if (success) then 
			    --spEcho("Not sleeping and moving units " .. thisGroup.name,secondGroup.transferCount,thisGroup.membersListCounter,secondGroup.name,secondGroup.membersListCounter,tostring(secondGroup.acceptingUnits))
				break 
			end
		end
		-- ! can be added adding with lower count then transfer when all groups tries (close to full)
	end
end

local function BuildInitOfExpansion(groupID,teamNumber)
    local thisGroup          = groupInfo[groupID]
	local thisTeam           = teamInfo[teamNumber]
	if (thisGroup.spirit == "tower") then
	    thisGroup.buildRange     = 1500                 --- ! only for test, later it will be driven from unitDefs and groupDefs
	else
	    thisGroup.buildRange     = 950                 --- ! only for test, later it will be driven from unitDefs and groupDefs
	end
	local thisX,thisY,thisZ  = GetPositionOfGroup(groupID)
	thisGroup.posX           = thisX
	thisGroup.posZ           = thisZ
	---thisGroup.posY           = thisY
	local buildRangeSQ       = thisGroup.buildRange * thisGroup.buildRange
	local thisSpotsList      = thisGroup.metalListInRange
	local counter            = 1
	---- preparing list of mexes near tower
	for i=1,#mapMetal do
		local distanceSQ = GetDistance2DSQ(thisX,thisZ,mapMetal[i].posX,mapMetal[i].posZ)
		if (distanceSQ < buildRangeSQ) then
			thisSpotsList[counter] = i
			counter                = counter + 1
		end
	end
	---- preparing list of buildpositions near tower
	-- speeded version:
	local listGrBuildPos = thisGroup.buildGroundInRange
	local listWaBuildPos = thisGroup.buildWaterInRange
	local groundCounter  = 1
	local waterCounter   = 1
	local theRange       = thisGroup.buildRange - buildMapDivision
	local doubleRange    = 2*theRange
	local buildSquareX   = thisX - theRange
	local buildSquareZ   = thisZ - theRange
	local firstID        = GetIDofTile(buildSquareX,buildSquareZ,buildMapDivision,buildMapZdivs)
	local downID         = GetIDofTile(buildSquareX,buildSquareZ + doubleRange,buildMapDivision,buildMapZdivs)
	local rightID        = GetIDofTile(buildSquareX + doubleRange,buildSquareZ,buildMapDivision,buildMapZdivs)
	-- local downRightID    = GetIDofTile(buildSquareX + doubleRange,buildSquareZ + doubleRange,buildMapDivision,buildMapZdivs)
	local squareSize     = downID - firstID
	--spEcho(firstID,rightID,downID,buildMapZdivs)
	for a=1,4 do
		local ratingLimit = a*50        --- ! only for test, localized
		for i=firstID,rightID,buildMapZdivs do
			local endLimit = i + squareSize
			--spEcho("-" .. i,endLimit)
			for j=i,endLimit do
				if (mapBuild[j] ~= nil) then
					local thisTile   = mapBuild[j]
					local distanceSQ = GetDistance2DSQ(thisX,thisZ,thisTile.posX,thisTile.posZ)  --- its not correct circle, but doesnt matter
					local border     = IsFarFromEdge(thisTile.posX,thisTile.posZ,45)
					if ((distanceSQ < buildRangeSQ) and border) then
						if (thisTile.groundBuild and (thisTile.groundRating <= ratingLimit)) then
							listGrBuildPos[groundCounter] = j
							groundCounter                 = groundCounter + 1
						end
						if (thisTile.waterBuild and (a == 1)) then
							listWaBuildPos[waterCounter]  = j
							waterCounter                  = waterCounter + 1
						end
					end
				end
			end
		end
	end
	if (groundCounter == 1 ) then thisGroup.buildGroundAllUsed = true end
	if (waterCounter == 1) then thisGroup.buildWaterAllUsed = true end
end

spiritDef = {
    ["noSpirit"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- fake spirit
	end,
    ["brain"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- ! guy, that leads all global thinking processes, has own personalities
		--- ! thor,cake
		--- ! Morphdog
		--- ! calculating mex distances
		if (mode == "prepare") then
			-- init first --
			if (groupInfo[groupID].initialization) then
				-- mexes distances
				-- plan.mexesBucketInit(teamNumber)
				groupInfo[groupID].initialization = false
			end
			-- end of init --
			-- !no regular prepare part yet
		else
		    -- !no execute part yet
		end
	end,
    ["tower"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- main builder, ! supporter
	    --- ! not able to do something valuable if only in water now
		--- ! build range need to be driven from unitDefs
		if (mode == "prepare") then
		    local thisGroup              = groupInfo[groupID]
			local thisTeam               = teamInfo[teamNumber]
		    --- init ---
			if (thisGroup.initialization and thisTeam.startInitNeeded) then -- only once at start
				BuildInitOfExpansion(groupID,teamNumber)
				BasePositionInit(teamNumber,thisGroup.posX,0,thisGroup.posZ)  --! it is not zero, i know
				local thisX = thisGroup.posX
				local thisZ = thisGroup.posZ
				--- defence perimeter init ---
			    local smallSizeOfHex = thisGroup.buildRange/4  
				local bigSizeOfHex = 2 * smallSizeOfHex	
				local hexGenerationMove = {
					[1]  = {smallSizeOfHex,-bigSizeOfHex*math.sin(30)},
					[2]  = {-smallSizeOfHex,-bigSizeOfHex*math.sin(30)},
					[3]  = {-bigSizeOfHex,0},
					[4]  = {-smallSizeOfHex,bigSizeOfHex*math.sin(30)},
					[5]  = {smallSizeOfHex,bigSizeOfHex*math.sin(30)},
					[6]  = {bigSizeOfHex,0},
				}
				for a=1,6 do
				    thisTeam.defencePerimeter[a] = {}
					for b=1,3 do                             --- three levels, three perimeters
					    thisTeam.defencePerimeter[a][b] = {}
						local resultX = hexGenerationMove[a][1]*b + thisX
						local resultZ = hexGenerationMove[a][2]*b + thisZ
						if ((resultZ <= 0) or (resultZ > mapZ) or (resultX <= 0) or (resultX > mapX)) then
						    resultX,resultZ = GetRandomPlaceAround(thisGroup.posX,thisGroup.posZ,1,smallSizeOfHex*b)
						end
					    thisTeam.defencePerimeter[a][b].posX = resultX 
					    thisTeam.defencePerimeter[a][b].posZ = resultZ
					end
				end
				--- radar pos init --- not yet
				--- no other init needed
				thisGroup.initialization = false
				thisTeam.startInitNeeded = false
			end
			--- something ---
			if (thisGroup.buildStatus == "idle") then
			    local thisHistory      = thisGroup.plansHistory
				local thisHistoryCount = #thisHistory
				if    (thisGroup.planCurrent == "none") then
		            thisGroup.planCurrent             = "buildFirstThreeMexes"   -- here have to be unique names
					thisHistory[thisHistoryCount + 1] = "buildFirstThreeMexes"
				elseif(thisHistory[thisHistoryCount] == "buildFirstThreeMexes") then
				    thisGroup.planCurrent             = "buildTwoSolars"
					thisHistory[thisHistoryCount + 1] = "buildTwoSolars"
				elseif(thisHistory[thisHistoryCount] == "buildTwoSolars") then
					thisGroup.planCurrent             = "buildAnotherThreeMexes"
					thisHistory[thisHistoryCount + 1] = "buildAnotherThreeMexes"
				elseif(thisHistory[thisHistoryCount] == "buildAnotherThreeMexes") then
				    thisGroup.planCurrent             = "buildKbotFactoryFirst"
					thisHistory[thisHistoryCount + 1] = "buildKbotFactoryFirst"
			    elseif(thisHistory[thisHistoryCount] == "buildKbotFactoryFirst") then
				    thisGroup.planCurrent             = "buildFiveSolars"
					thisHistory[thisHistoryCount + 1] = "buildFiveSolars"
				elseif(thisHistory[thisHistoryCount] == "buildFiveSolars") then
				    thisGroup.planCurrent             = "buildAllMexesFirst"
					thisHistory[thisHistoryCount + 1] = "buildAllMexesFirst"
				elseif(thisHistory[thisHistoryCount] == "buildAllMexesFirst") then
				    thisGroup.planCurrent             = "buildAditionalEnergyFirst"
					thisHistory[thisHistoryCount + 1] = "buildAditionalEnergyFirst"
				elseif(thisHistory[thisHistoryCount] == "buildAditionalEnergyFirst") then
				    thisGroup.planCurrent             = "buildRadarFirst"
					thisHistory[thisHistoryCount + 1] = "buildRadarFirst"
				elseif(thisHistory[thisHistoryCount] == "buildRadarFirst") then
				    thisGroup.planCurrent             = "zeroLevel"
					thisHistory[thisHistoryCount + 1] = "zeroLevel"
					--spEcho("finished basic stuff")
				elseif(thisHistory[thisHistoryCount] == "zeroLevel") then
				    --- now this basement for new prepare part, here will be zerolevelcondtions check
					thisGroup.planCurrent             = "zeroLevel"
				end
			end
		else
		    local thisGroup = groupInfo[groupID]
			if (thisGroup.buildStatus == "idle") then
			    plan[thisGroup.planCurrent](groupID,teamNumber)
			end
		end
	end,
	["commander"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- ! commanding unit called commander
		if (mode == "prepare") then
		    local thisGroup              = groupInfo[groupID]
		     --- init ---
			if (thisGroup.initialization and thisTeam.startInitNeeded) then -- only once at start
			    local thisX,thisY,thisZ  = GetPositionOfGroup(groupID)
				BasePositionInit(teamNumber,thisX,thisY,thisZ)
				thisGroup.initialization = false
				thisTeam.startInitNeeded = false			    
			end
		end
	end,
	["factory"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- ! commanding factory buildqueues, dependant on brain decisions
		--- adding units to queues
		if (mode == "prepare") then
		    local regroup   = PrepareFirstUnit(groupID)
		    local thisGroup = groupInfo[groupID]
			if (regroup) then thisGroup.buildStatus = "idle" end
		    if ((thisGroup.buildStatus == "idle") or (thisGroup.receivedUnit)) then
				thisGroup.planCurrent  = "addQueueLevel"
				thisGroup.buildStatus  = "idle"
				thisGroup.receivedUnit = false
				-- ! missing add to history 
			else
			    for i=1,thisGroup.membersListMax do
				    if (thisGroup.membersListAlive[i]) then
					    local doing      = spGetFactoryCommands(thisGroup.membersList[i])   -- if some factory is idle and we dont know that
						local unitsCount = spGetTeamUnitCount(thisGroup.teamID)
						if ((doing == nil) and (unitsCount <= unitLimit-50)) then
						    thisGroup.buildStatus = "idle"
							break
						end
					end
				end
			end
		else
		    local thisGroup = groupInfo[groupID]
			if ((thisGroup.buildStatus == "idle") and (thisGroup.planCurrent ~= "none")) then
			    local factory                                                      ---------- !ONLY FOR TESTS, WILL BE MOVED TO SPECIAL FUNCTION
				if     ((thisGroup.name == "armlabGroup") or (thisGroup.name == "corlabGroup")) then factory = "Bot1"				    
				elseif ((thisGroup.name == "armvpGroup") or (thisGroup.name == "corvpGroup")) then factory = "Veh1"
				elseif ((thisGroup.name == "armapGroup") or (thisGroup.name == "corapGroup")) then factory = "Air1"
				elseif ((thisGroup.name == "armcsyGroup") or (thisGroup.name == "corcsyGroup")) then factory = "Ship"
				elseif ((thisGroup.name == "armalabGroup") or (thisGroup.name == "coralabGroup")) then factory = "Bot2"
				elseif ((thisGroup.name == "armavpGroup") or (thisGroup.name == "coravpGroup")) then factory = "Veh2"
                elseif ((thisGroup.name == "armaapGroup") or (thisGroup.name == "coraapGroup")) then factory = "Air2"					
				end
				local level = (pseudoRandom % 7) + 1
				pseudoRandom = pseudoRandom + 1
				if (plan[thisGroup.planCurrent] ~= nil) then
			        plan[thisGroup.planCurrent](groupID,teamNumber,factory,level)
				else
				    --!! here some strange calling of this spirit
					--spEcho("Someone thinks this group has no plan: " .. thisGroup.name)  --only debug
				end
			end
		end
	end,
	["advancedBuffer"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- do the buffer job
		--- each buffer can control only custom number of factories, that create unit of given type
		if (mode == "execute") then
			plan.bufferTransfer(groupID)
		else
			plan.bufferCommand(groupID)
		end
	end,
	["advancedFactory"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- ! do the factory job, depends on advanced buffer now (on its orders)
		--- => currently do nothing
			-- ! would just check if idle
			-- ! and send or save reports
		-- local thisGroup = groupInfo[groupID]
		
		-- init WORSE WITHOUT WIDGET --
		-- if (groupInfo[groupID].initialization) then
			-- groupInfo[groupID].initialization	= false
			-- for i=1,thisGroup.membersListMax do
				-- if (thisGroup.membersListAlive[i]) then
					-- plan.facingToGatheringPoint(thisGroup.membersList[i])					
				-- end
			-- end
		-- end
		
	end,
	["building"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- ! command buildings that have some powers
	end,
	["botBuffer"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- keep all made bots and transfere them into attack groups
	    if (mode == "execute") then
		    RealBufferJob(groupID)
		end
	end,
	["vehBuffer"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- ! keep all made vehicles and transfere them into attack groups
	    if (mode == "execute") then
		    RealBufferJob(groupID)
		end
	end,
    ["airBuffer"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- ! keep all made aircrafts and transfere them into attack groups
	    if (mode == "execute") then
		    RealBufferJob(groupID)
		end
	end,
	["shipBuffer"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- ! keep all made ships and transfere them into attack groups
	    if (mode == "execute") then
		    RealBufferJob(groupID)
		end
	end,
    ["raider"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! hunting unit types specified in groupDef
	    if (mode == "prepare") then
	        local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
     		if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then
				local class       = ChooseRandomTargetClass(groupID)
			    local targetIndex
                if (class == "metal") then
				    PrepareFirstUnit(groupID)
			        local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
                    targetIndex = ChooseClosestTargetGivenClass(teamNumber,"metal",thisPosX,thisPosZ) 
				else
				    targetIndex = GetOneValuableTarget(groupID,teamNumber,class)
				end
			    if (targetIndex ~= 0) then
					thisGroup.target.hasAny = true
					thisGroup.target.index  = targetIndex
				else
				    thisGroup.target.hasAny = false
				end
			else
				if (not(thisTeam.listOfStrategicTargetsAlive[thisGroup.target.index])) then
				    thisGroup.target.hasAny = false
				end
			end
	    else
		    local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
		    if (thisGroup.target.hasAny) then
			    -- spEcho("attacking target " .. thisGroup.target.index .. " (".. thisTeam.listOfStrategicTargets[thisGroup.target.index].class .. "), im group.: " .. thisGroup.name)
			    local thisTarget = thisTeam.listOfStrategicTargets[thisGroup.target.index]
				local targetX,targetY,targetZ 
				if (thisTarget ~= nil) then
					if (thisTarget.static) then
						targetX = thisTarget.posX
						targetY = thisTarget.posY
						targetZ = thisTarget.posZ
					else
						targetX,targetY,targetZ = spGetUnitPosition(thisTarget.unitID)
					end
					if (targetX ~= nil) then
						BigMove(groupID,targetX,targetY,targetZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
					end
				end
			end
		end  
	end,
	["cloacked-raider"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! hunting unit types specified in groupDef
	    if (mode == "prepare") then
	        local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
     		if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then
				PrepareFirstUnit(groupID)
				local targetIndex
				local class                      = ChooseRandomTargetClass(groupID)
				local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
				targetIndex = ChooseClosestTargetGivenClass(teamNumber,class,thisPosX,thisPosZ) 
				if (targetIndex ~= 0) then
					thisGroup.target.hasAny = true
					thisGroup.target.index  = targetIndex
				else
					thisGroup.target.hasAny = false
				end
			else
				if (not(thisTeam.listOfStrategicTargetsAlive[thisGroup.target.index])) then
					thisGroup.target.hasAny = false
				end
			end
	    else
		    local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			PrepareFirstUnit(groupID)	
		    if (thisGroup.target.hasAny) then
				-- spEcho("attacking target " .. thisGroup.target.index .. " (".. thisTeam.listOfStrategicTargets[thisGroup.target.index].class .. "), im group.: " .. thisGroup.name)
			    local thisTarget = thisTeam.listOfStrategicTargets[thisGroup.target.index]
				if (thisTarget ~= nil) then
					local targetX,targetY,targetZ 
					if (thisTarget.static) then
						targetX = thisTarget.posX
						targetY = thisTarget.posY
						targetZ = thisTarget.posZ
					else
						targetX,targetY,targetZ = spGetUnitPosition(thisTarget.unitID)
					end
					if (targetX ~= nil) then
						local distanceSQ    = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,targetX,targetZ)
						local range         = thisGroup.range 
						if (thisGroup.membersListAlive[1]) then
							local enemy     = spGetUnitNearestEnemy(thisGroup.membersList[1],range)
							if (enemy ~= nil) then
								--- stop ---
								for i=1,thisGroup.membersListMax do
									if (thisGroup.membersListAlive[i]) then
										spGiveOrderToUnit(thisGroup.membersList[i], CMD_STOP, {},{})
									end
								end
							else
								BigMove(groupID,targetX,targetY,targetZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
							end
						end
					end
				end
			end
		end  
	end,
    ["flanker"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! - group that keeps back itself from fight and support only when main attackgroup is in fight
		if (mode == "prepare") then
		    local thisGroup                  = groupInfo[groupID]
			local itsLeader                  = groupInfo[thisGroup.itsLeaderID]
			local distanceSQ                 = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,itsLeader.posX,itsLeader.posZ) 
			if (distanceSQ >= 1200*1200) then
			    if (not(thisGroup.target.hasAny)) then
					local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
					local distanceForm               = mAbs(thisGroup.dependancyPosition[1])
					thisGroup.target.attackPosX,thisGroup.target.attackPosZ = GetRandomPlaceAround(itsLeader.posX,itsLeader.posZ,distanceForm,distanceForm+300)
					thisGroup.target.hasAny = true
				else
				    thisGroup.fightStatus   = "regrouping"
				end
			else
			    distanceSQ = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,thisGroup.target.attackPosX,thisGroup.target.attackPosZ) 
			    if (distanceSQ <= 200*200) then
			        thisGroup.fightStatus   = "onPlace"
					thisGroup.target.hasAny = false
				else
				    thisGroup.fightStatus   = "flanking"
				end
			end
		else
			local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			if (thisGroup.target.hasAny) then
				local attackPosX = thisGroup.target.attackPosX
				local attackPosZ = thisGroup.target.attackPosZ
				BigMove(groupID,attackPosX,0,attackPosZ,0,thisGroup.formation,waiting) -- only for tests
			end
		end
	end,
    ["lightDefender"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION ---
		--- ! - group that spend time somewhere near the base, face raiders and units attacking the base
		--- ! - patroling on some 4-5 waypoints patrol around the base
		--- ! - commanded by brain
        if (mode == "prepare") then
		    -- preparation work is done by brain
			-- ! preparations below are only for test
			local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
			if (not(thisGroup.target.hasAny)) then
				--thisGroup.target.posX,thisGroup.target.posZ = GetRandomPlaceAround(thisTeam.mapBase.posX,thisTeam.mapBase.posZ,300,1200)
				local rand = (pseudoRandom % 6) + 1
				thisGroup.target.posX,thisGroup.target.posZ = thisTeam.defencePerimeter[rand][2].posX,thisTeam.defencePerimeter[rand][2].posZ
				pseudoRandom = pseudoRandom + 1
				--
				thisGroup.target.hasAny = true
				thisGroup.fightStatus   = "regrouping"
		    end
		else
		    local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			--spEcho(tostring(thisGroup.target.hasAny),thisGroup.target.posX,thisGroup.target.posZ)
		    if (thisGroup.target.hasAny) then
			    -- spEcho("attacking target " .. thisGroup.target.index)
			    local targetX    = thisGroup.target.posX
				local targetZ    = thisGroup.target.posZ
				local distanceSQ = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,targetX,targetZ) 
				if (distanceSQ >= 200*200) then
		            BigMove(groupID,targetX,0,targetZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
				else
				    thisGroup.target.hasAny = false
					thisGroup.fightStatus   = "waitingForOrders"
				end
			end
		end
	end,
	["builderDefender"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
	    --- - keep near the main line and support it
		PrepareFirstUnit(groupID)
		local thisTeam  = teamInfo[teamNumber]
		local thisGroup = groupInfo[groupID]
		local itsLeader  = groupInfo[thisGroup.itsLeaderID]
		if (not(itsLeader.sleeping)) then
		    local attackPosX,attackPosY,attackPosZ
            if (itsLeader.buildStatus == "idle") then	
				attackPosX = itsLeader.posX
				attackPosY = 0
				attackPosZ = itsLeader.posZ
			else
			    attackPosX = itsLeader.target.posX
				attackPosY = 0
				attackPosZ = itsLeader.target.posZ
			end
			BigMove(groupID,attackPosX,attackPosY,attackPosZ,0,thisGroup.formation,waiting) -- only for tests
		end
	end,
    ["lightAttacker"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! - group that attacks small targets as def buildings, secondary targets, clean the map or assist bigger operations
		--- ! - 
	    if (mode == "prepare") then
	        local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			PrepareFirstUnit(groupID)	
			--- check the OPstatus
			local status = plan.operationalStatusCheck(groupID)
			if (status == "ready" or status == "full") then
				if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then
					local class       = ChooseRandomTargetClass(groupID)
					local targetIndex
					if (class == "metal") then
						PrepareFirstUnit(groupID)
						local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
						targetIndex = ChooseClosestTargetGivenClass(teamNumber,"metal",thisPosX,thisPosZ) 
					else
						targetIndex = GetOneValuableTarget(groupID,teamNumber,class)
					end
					if (targetIndex ~= 0) then
						thisGroup.target.hasAny = true
						thisGroup.target.index  = targetIndex
					else
						thisGroup.target.hasAny = false
					end
				else
					if (not(thisTeam.listOfStrategicTargetsAlive[thisGroup.target.index])) then
				    thisGroup.target.hasAny = false
				end
			end
			elseif (status == "IOA" or status == "HL") then
				if (not(thisGroup.target.hasAny)) then
					--thisGroup.target.posX,thisGroup.target.posZ = GetRandomPlaceAround(thisTeam.mapBase.posX,thisTeam.mapBase.posZ,300,1200)
					local rand = (pseudoRandom % 6) + 1
					thisGroup.target.posX,thisGroup.target.posZ = thisTeam.defencePerimeter[rand][3].posX,thisTeam.defencePerimeter[rand][3].posZ
					pseudoRandom = pseudoRandom + 1
					--
					thisGroup.target.hasAny = true
					thisGroup.fightStatus   = "regrouping"
				end
			end
	    else
		    local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
		    if (thisGroup.target.hasAny) then
			    if (thisGroup.fightStatus == "regrouping") then
				    local targetX    = thisGroup.target.posX
					local targetZ    = thisGroup.target.posZ
					local distanceSQ = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,targetX,targetZ) 
					if (distanceSQ >= 200*200) then
						BigMove(groupID,targetX,0,targetZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
					else
						thisGroup.target.hasAny = false
						thisGroup.fightStatus   = "waitingForOrders"
					end
				else
					-- spEcho("attacking target " .. thisGroup.target.index)
					local thisTarget = thisTeam.listOfStrategicTargets[thisGroup.target.index]
					if (thisTarget ~= nil) then
						local targetX,targetY,targetZ 
						if (thisTarget.static) then
							targetX = thisTarget.posX
							targetY = thisTarget.posY
							targetZ = thisTarget.posZ
						else
							targetX,targetY,targetZ = spGetUnitPosition(thisTarget.unitID)
						end
						if (targetX ~= nil) then
							BigMove(groupID,targetX,targetY,targetZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
						end
					end
				end
			end
		end  
	end,
	["cleaner"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! - group that attacks small targets as def buildings, secondary targets, clean the map or assist bigger operations
		--- ! - 
	    if (mode == "prepare") then
	        local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			PrepareFirstUnit(groupID)	
			--- check the OPstatus
			local status = plan.operationalStatusCheck(groupID)
			if (status == "ready" or status == "full") then
				if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then
					PrepareFirstUnit(groupID)
					local targetIndex
					local class                      = ChooseRandomTargetClass(groupID)
					local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
					targetIndex = ChooseClosestTargetGivenClass(teamNumber,class,thisPosX,thisPosZ) 
					if (targetIndex ~= 0) then
						thisGroup.target.hasAny = true
						thisGroup.target.index  = targetIndex
					else
						thisGroup.target.hasAny = false
					end
				else
					if (not(thisTeam.listOfStrategicTargetsAlive[thisGroup.target.index])) then
				    thisGroup.target.hasAny = false
				end
			end
			elseif (status == "IOA" or status == "HL") then
				if (not(thisGroup.target.hasAny)) then
					--thisGroup.target.posX,thisGroup.target.posZ = GetRandomPlaceAround(thisTeam.mapBase.posX,thisTeam.mapBase.posZ,300,1200)
					local rand = (pseudoRandom % 6) + 1
					thisGroup.target.posX,thisGroup.target.posZ = thisTeam.defencePerimeter[rand][3].posX,thisTeam.defencePerimeter[rand][3].posZ
					pseudoRandom = pseudoRandom + 1
					--
					thisGroup.target.hasAny = true
					thisGroup.fightStatus   = "regrouping"
				end
			end
	    else
		    local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
		    if (thisGroup.target.hasAny) then
			    if (thisGroup.fightStatus == "regrouping") then
				    local targetX    = thisGroup.target.posX
					local targetZ    = thisGroup.target.posZ
					local distanceSQ = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,targetX,targetZ) 
					if (distanceSQ >= 200*200) then
						BigMove(groupID,targetX,0,targetZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
					else
						thisGroup.target.hasAny = false
						thisGroup.fightStatus   = "waitingForOrders"
					end
				else
					-- spEcho("attacking target " .. thisGroup.target.index)
					local thisTarget = thisTeam.listOfStrategicTargets[thisGroup.target.index]
					if (thisTarget ~= nil) then
						local targetX,targetY,targetZ 
						if (thisTarget.static) then
							targetX = thisTarget.posX
							targetY = thisTarget.posY
							targetZ = thisTarget.posZ
						else
							targetX,targetY,targetZ = spGetUnitPosition(thisTarget.unitID)
						end
						if (targetX ~= nil) then
							BigMove(groupID,targetX,targetY,targetZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
						end
					end
				end
			end
		end  
	end,
    ["standardMainLine"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION ---
		--- - main battle group doing the main job
		--- - attack point leaded by dangerMap
		--- - return when heavily damaged - HEALTH STATUS DECISIONS
		--- ! - formations changing dependant on fight situation - BATTLE STATUS DECISIONS
		--- - have many dependant groups assisting the fight
		--- - have own buffer
		--- - need to be added some start position if group killed or seriously dmged
		--- ! - basic navigation by dangerous places is right, but it needs better recognition of enemy stuff for battle mode
		--- ! - checking hills around after GetPositionForAttack
	    if (mode == "prepare") then
		    -- ! here start pos init or base pos for sleeping units
		    PrepareFirstUnit(groupID)
	        local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
			--- check the OPstatus
			local status = plan.operationalStatusCheck(groupID)
			if     (status == "IOA") then
			    if (not(thisGroup.target.hasAny)) then
				    local targetPosX        = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerX
					local targetPosZ        = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerZ
					thisGroup.target.posX   = targetPosX
					thisGroup.target.posZ   = targetPosZ
					thisGroup.target.attackPosX,thisGroup.target.attackPosZ = GetRandomPlaceAround(thisTeam.mapBase.posX,thisTeam.mapBase.posZ,200,400) -- 2200--base before
					thisGroup.target.hasAny = true
				end
				thisGroup.acceptingUnits = true
			elseif (status == "HL") then
			    if (not(thisGroup.target.hasAny)) then 
				    local targetPosX        = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerX
					local targetPosZ        = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerZ
					thisGroup.target.posX   = targetPosX
					thisGroup.target.posZ   = targetPosZ
					thisGroup.target.attackPosX,thisGroup.target.attackPosY,thisGroup.target.attackPosZ = GetPositionForAttack(thisPosX,thisPosZ,targetPosX,targetPosZ,2800) -- 1800 --1200 --1000
					thisGroup.target.hasAny = true
				end
				thisGroup.acceptingUnits = true
			elseif (status == "LL") then
			    if (not(thisGroup.target.hasAny)) then 
				    --- ! here should be first time check - if enemy is around, if not, so look at map
					local targetPosX        = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerX
					local targetPosZ        = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerZ
					thisGroup.target.posX   = targetPosX
					thisGroup.target.posZ   = targetPosZ
					thisGroup.target.attackPosX,thisGroup.target.attackPosY,thisGroup.target.attackPosZ = GetPositionForAttack(thisPosX,thisPosZ,targetPosX,targetPosZ,1800) --1200 --900 --600
					thisGroup.target.hasAny = true
				end
				thisGroup.acceptingUnits = true
			elseif (status == "ready") then
			    if (not(thisGroup.target.hasAny)) then 
				    --- ! here should be first time check - if enemy is around, if not, so look at map
					local targetPosX        = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerX
					local targetPosZ        = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerZ
					thisGroup.target.posX   = targetPosX
					thisGroup.target.posZ   = targetPosZ
					thisGroup.target.attackPosX,thisGroup.target.attackPosY,thisGroup.target.attackPosZ = GetPositionForAttack(thisPosX,thisPosZ,targetPosX,targetPosZ,600) --450
					thisGroup.target.hasAny = true
				end
				thisGroup.acceptingUnits = true
			elseif (status == "full") then
			    local distanceSQ = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,thisGroup.target.posX,thisGroup.target.posZ) 
			    if (not(thisGroup.target.hasAny) or (distanceSQ < 500*500)) then  --- 400*400
					--- ! here should be first time check - if enemy is around, if not, so look at map
					local targetPosX        = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerX
					local targetPosZ        = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerZ
					thisGroup.target.posX   = targetPosX
					thisGroup.target.posZ   = targetPosZ
					thisGroup.target.attackPosX,thisGroup.target.attackPosY,thisGroup.target.attackPosZ = GetPositionForAttack(thisPosX,thisPosZ,targetPosX,targetPosZ,OwnRandom(1,100))
					thisGroup.target.hasAny = true
				end
				if (thisGroup.membersListCounter >= thisGroup.membersListMax) then
   				    thisGroup.acceptingUnits = false
				end
			end
	    else
		    local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
		    if (thisGroup.target.hasAny) then
			    --spEcho("attacking target " .. thisGroup.target.index)
				--spEcho(thisGroup.operationalStatus,thisGroup.membersListCounter)
			    local targetX    = thisGroup.target.posX
				local targetZ    = thisGroup.target.posZ
				local attackPosX = thisGroup.target.attackPosX
				local attackPosY = thisGroup.target.attackPosY
				local attackPosZ = thisGroup.target.attackPosZ
				local distanceSQ = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,attackPosX,attackPosZ) 
				if (distanceSQ < 150*150) then
		            BigMove(groupID,attackPosX,attackPosY,attackPosZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
				else
				    BigMove(groupID,attackPosX,attackPosY,attackPosZ,0,thisGroup.formation,waiting)
				end
			end
		end  
	end,
	["secondaryLine"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
	    --- - keep near the main line and support it
		if (mode == "prepare") then
		    PrepareFirstUnit(groupID)
     		local thisGroup = groupInfo[groupID]
			local itsLeader = groupInfo[thisGroup.itsLeaderID]
			if     ((thisGroup.membersListCounter >= itsLeader.transferCount) and itsLeader.acceptingUnits) then
				local success = ChangeUnitGroup(itsLeader.transferCount,thisGroup.groupED,itsLeader.groupED)
			else
			    -- local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
			    -- thisGroup.target.posX = itsLeader.target.attackPosX   
				-- thisGroup.target.posZ = itsLeader.target.attackPosZ  
			    -- thisGroup.target.attackPosX,thisGroup.target.attackPosY,thisGroup.target.attackPosZ = GetPositionForAttack(thisPosX,thisPosZ,itsLeader.posX,itsLeader.posZ, - thisGroup.dependancyPosition[2])
				-- thisGroup.target.hasAny = true
				-- !! need to add shoot distance instead of 300 for each group, it should be driven from unitDefs
			end
		else
			local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			local itsLeader  = groupInfo[thisGroup.itsLeaderID]
			if (itsLeader.target.hasAny) then			    
				local targetX    = itsLeader.target.posX
				local targetZ    = itsLeader.target.posZ
				local attackPosX = itsLeader.target.attackPosX
				local attackPosY = itsLeader.target.attackPosY
				local attackPosZ = itsLeader.target.attackPosZ
				BigMove(groupID,attackPosX,attackPosY,attackPosZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
			end
		end
	end,
    ["heavySupportLine"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
	    --- - keep near the main line and support it
		--- - derived from secondary line
		if (mode == "prepare") then
		    PrepareFirstUnit(groupID)
		else
			local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			local itsLeader  = groupInfo[thisGroup.itsLeaderID]
			if (itsLeader.target.hasAny) then			    
				local targetX    = itsLeader.target.posX
				local targetZ    = itsLeader.target.posZ
				local attackPosX = itsLeader.target.attackPosX
				local attackPosY = itsLeader.target.attackPosY
				local attackPosZ = itsLeader.target.attackPosZ
				BigMove(groupID,attackPosX - 50,attackPosY,attackPosZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
			end
		end
	end,
    ["supportLine"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
	    --- ! - keep somewhere near the leader
		--- ! - do the job spciefied in groupInfo
		if (mode == "prepare") then
		    local thisGroup = groupInfo[groupID]
			local itsLeader = groupInfo[thisGroup.itsLeaderID]
			local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
			thisGroup.target.posX = itsLeader.posX   
			thisGroup.target.posZ = itsLeader.posZ
			thisGroup.target.attackPosX,thisGroup.target.attackPosY,thisGroup.target.attackPosZ = GetPositionForAttack(thisPosX,thisPosZ,itsLeader.posX,itsLeader.posZ, - thisGroup.dependancyPosition[2])
			thisGroup.target.hasAny = true
		else
			local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			if (thisGroup.target.hasAny) then
				local targetX    = thisGroup.target.posX
				local targetZ    = thisGroup.target.posZ
				local attackPosX = thisGroup.target.attackPosX
				local attackPosY = thisGroup.target.attackPosY
				local attackPosZ = thisGroup.target.attackPosZ
				local name       = thisGroup.name   --- ! things below only test.. these with contsbots
				if ((name == "mainOne-necroSupport-reclaim") or (name == "mainOne-necroSupport-repair") or (name == "mainOne-farkSupport-reclaim") or (name == "mainOne-farkSupport-repair") or (name == "base-farkReclaim") or (name == "base-necroReclaim")) then
				    PrepareFirstUnit(groupID)	
					local distanceSQ = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,attackPosX,attackPosZ) 
				    if (thisGroup.membersListAlive[1]) then
					    local askedDistance = thisGroup.dependancyPosition[2] + 1500
						local itsLeader     = groupInfo[thisGroup.itsLeaderID]
					    if (distanceSQ >= askedDistance*askedDistance) then
						    spGiveOrderToUnit(thisGroup.membersList[1], CMD_MOVE, { attackPosX, attackPosY, attackPosZ }, {})
							thisGroup.fightStatus = "moving"
						else
						    if (thisGroup.fightStatus ~= "patroling") then
								spGiveOrderToUnit(thisGroup.membersList[1], CMD_PATROL, { attackPosX, attackPosY, attackPosZ }, {})
								thisGroup.fightStatus = "patroling"
							end
						end
						if (thisGroup.receivedUnit) then --- ! in some situations wont work, i know, but will be rare
							for i=2,thisGroup.membersListMax do
								if (thisGroup.membersListAlive[i]) then
									spGiveOrderToUnit(thisGroup.membersList[i], CMD_GUARD, {thisGroup.membersList[1]},{})
								end
							end
							thisGroup.receivedUnit = false
						end
					end
				elseif ((name == "tower-necroAssist") or (name == "tower-farkAssist")) then
				    PrepareFirstUnit(groupID)	
				    local itsLeader = groupInfo[thisGroup.itsLeaderID]
				    if (thisGroup.membersListAlive[1] and (thisGroup.fightStatus == "idle") and itsLeader.membersListAlive[1]) then
						spGiveOrderToUnit(thisGroup.membersList[1], CMD_GUARD, {itsLeader.membersList[1]}, {})
						thisGroup.fightStatus = "guarding"
						if (thisGroup.receivedUnit) then
							for i=2,thisGroup.membersListMax do
								if (thisGroup.membersListAlive[i]) then
									spGiveOrderToUnit(thisGroup.membersList[i], CMD_GUARD, {itsLeader.membersList[1]},{})
								end
							end
							thisGroup.receivedUnit = false
						end
					end
				else
				    PrepareFirstUnit(groupID)	
					local distanceSQ    = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,attackPosX,attackPosZ)
				    local range         = thisGroup.range 
					local askedDistance = thisGroup.dependancyPosition[2]
					local itsLeader     = groupInfo[thisGroup.itsLeaderID]
					if (thisGroup.membersListAlive[1] and itsLeader.membersListAlive[1]) then
						local enemy     = spGetUnitNearestEnemy(thisGroup.membersList[1],range)
						if ((distanceSQ < askedDistance*askedDistance) or (enemy ~= nil)) then
							--- stop ---
							for i=1,thisGroup.membersListMax do
								if (thisGroup.membersListAlive[i]) then
									spGiveOrderToUnit(thisGroup.membersList[i], CMD_STOP, {},{})
								end
							end
						else
							BigMove(groupID,attackPosX,attackPosY,attackPosZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
						end
					end
				end
			end
		end
	end,
    ["eco"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- - able to do main eco jobs - build, assist, reclaim
		--- - expanding and getting mexes
		if (groupInfo[groupID].initialization) then
			-- mexes distances
			plan.mexesBucketInit(teamNumber)
			groupInfo[groupID].initialization = false
		end
		
		if (mode == "prepare") then
		    PrepareFirstUnit(groupID)
			local thisGroup = groupInfo[groupID]
			if (not(thisGroup.sleeping)) then
				thisGroup.posX,_,thisGroup.posZ = GetPositionOfGroup(groupID,1)
			end
		else
		    local thisGroup = groupInfo[groupID]
			local thisID    = thisGroup.membersList[1]
			if (thisGroup.buildStatus == "idle") then
				--- local mexID = ChooseMexSpot(teamNumber,"ground") -- old second silly
				local mexID = ChooseClosestSpot(teamNumber,"ground",thisGroup.posX,thisGroup.posZ)
				------spEcho(mexID)
				if (mexID > 0) then 
					local waterSpot = mapMetal[mexID].water
					if (thisGroup.buildStatus == "idle" and thisGroup.membersListAlive[1]) then
						local test = BuildMex(thisID,teamNumber,mexID)
						if (test == 0) then
							thisGroup.buildStatus = "idle"
						else
							thisGroup.buildStatus = "makingMex"
							thisGroup.target.posX = mapMetal[mexID].posX
							thisGroup.target.posZ = mapMetal[mexID].posZ
						end
					end
				end
			end
			if (thisGroup.membersListAlive[1]) then 
				for i=2,thisGroup.membersListMax do
					if (thisGroup.membersListAlive[i]) then
					    spGiveOrderToUnit(thisGroup.membersList[i], CMD_GUARD, {thisID},{})
					end
				end
			end
		end
	end,
	["mohobuilder"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- - makes moho mines
		if (mode == "prepare") then
		    PrepareFirstUnit(groupID)			
		else
		    local thisGroup = groupInfo[groupID]
			local thisID    = thisGroup.membersList[1]
			if (thisGroup.membersListAlive[1]) then 
			    if (thisGroup.buildStatus == "idle") then
				    local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
					spGiveOrderToUnit(thisGroup.membersList[1], CMD_MOVE, {thisPosX+10,thisPosY,thisPosZ+10},{})
					spGiveOrderToUnit(thisGroup.membersList[1], CMD_AUTOMEX, {'1'},{})
					thisGroup.buildStatus = "upgrading"
				end
				if (thisGroup.receivedUnit) then
					for i=2,thisGroup.membersListMax do
						if (thisGroup.membersListAlive[i]) then
							spGiveOrderToUnit(thisGroup.membersList[i], CMD_GUARD, {thisID},{})
						end
					end
					thisGroup.receivedUnit = false
				end
			end
		end
	end,
    ["mainTank"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! independent attack group of tanks unleashed by brain
	    if (mode == "prepare") then
	        local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			PrepareFirstUnit(groupID)
			local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
			--- check the OPstatus
			local status = plan.operationalStatusCheck(groupID)
			if     (status == "IOA") then
			    if (not(thisGroup.target.hasAny)) then
				    thisGroup.target.posX,thisGroup.target.posZ = GetRandomPlaceAround(thisTeam.mapBase.posX,thisTeam.mapBase.posZ,800,1200)
					thisGroup.target.hasAny = true
				end
			elseif (status == "HL") then
			    if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then 
					local targetIndex = GetOneValuableTarget(groupID,teamNumber,"metal")
					if (targetIndex == 0) then
					else
						thisGroup.target.hasAny = true
						thisGroup.target.index  = targetIndex
						thisGroup.target.posX   = thisTeam.listOfStrategicTargets[targetIndex].posX
					    thisGroup.target.posZ   = thisTeam.listOfStrategicTargets[targetIndex].posZ
					end
				end
			elseif (status == "LL") then
			    if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then 
					local targetIndex = GetOneValuableTarget(groupID,teamNumber,"factories")
					if (targetIndex == 0) then
					else
						thisGroup.target.hasAny = true
						thisGroup.target.index  = targetIndex
					    thisGroup.target.posX   = thisTeam.listOfStrategicTargets[targetIndex].posX
					    thisGroup.target.posZ   = thisTeam.listOfStrategicTargets[targetIndex].posZ
					end
				end
			elseif (status == "ready") then
			    if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then 
					local targetIndex = GetOneValuableTarget(groupID,teamNumber,"factories")
					if (targetIndex == 0) then
					else
						thisGroup.target.hasAny = true
						thisGroup.target.index  = targetIndex
						thisGroup.target.posX   = thisTeam.listOfStrategicTargets[targetIndex].posX
					    thisGroup.target.posZ   = thisTeam.listOfStrategicTargets[targetIndex].posZ
					end
				end
			elseif (status == "full") then
			    if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then 
					local class       = ChooseRandomTargetClass(groupID)
					local targetIndex
					if (class == "metal") then
						PrepareFirstUnit(groupID)
						local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
						targetIndex = ChooseClosestTargetGivenClass(teamNumber,"metal",thisPosX,thisPosZ) 
					else
						targetIndex = GetOneValuableTarget(groupID,teamNumber,class)
					end
					if (targetIndex ~= 0) then
						thisGroup.target.hasAny = true
						thisGroup.target.index  = targetIndex
					else
						thisGroup.target.hasAny = false
					end
				else
					if (not(thisTeam.listOfStrategicTargetsAlive[thisGroup.target.index])) then
						thisGroup.target.hasAny = false
					end
				end
			end
	    else
		    local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			--spEcho(tostring(thisGroup.target.hasAny),thisGroup.target.posX,thisGroup.target.posZ)
		    if (thisGroup.target.hasAny) then
			    local targetX    = thisGroup.target.posX
				local targetZ    = thisGroup.target.posZ
				BigMove(groupID,targetX,0,targetZ,0,thisGroup.formation,waiting) -- only for tests
			end
		end 
	end,
    ["artileryCommander"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! supportLine with specific move orders
		if (mode == "prepare") then
		    local thisGroup = groupInfo[groupID]
			local itsLeader = groupInfo[thisGroup.itsLeaderID]
			local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
			thisGroup.target.posX = itsLeader.posX   
			thisGroup.target.posZ = itsLeader.posZ
			thisGroup.target.attackPosX,thisGroup.target.attackPosY,thisGroup.target.attackPosZ = GetPositionForAttack(thisPosX,thisPosZ,itsLeader.posX,itsLeader.posZ, - thisGroup.dependancyPosition[2])
			thisGroup.target.hasAny = true
		else
		    PrepareFirstUnit(groupID)	
			local thisGroup     = groupInfo[groupID]
			local thisTeam      = teamInfo[teamNumber]
			local itsLeader     = groupInfo[thisGroup.itsLeaderID]
			local distanceSQ    = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,itsLeader.posX,itsLeader.posZ)
			local range         = (3*thisGroup.range)/4 -- test 3/4
			local askedDistance = thisGroup.dependancyPosition[2]	
			if (thisGroup.membersListAlive[1] and itsLeader.membersListAlive[1]) then
				local enemy     = spGetUnitNearestEnemy(thisGroup.membersList[1],range)
				if ((distanceSQ < askedDistance*askedDistance) or (enemy ~= nil)) then
					--- stop ---
					--for i=1,thisGroup.membersListMax do
						if (thisGroup.membersListAlive[1]) then
							spGiveOrderToUnit(thisGroup.membersList[1], CMD_STOP, {},{})
						end
					--end
				else
					BigMove(groupID,itsLeader.posX,0,itsLeader.posZ,0,thisGroup.formation,waiting) -- only for tests
				end
			end
			-- local thisTeam   = teamInfo[teamNumber]
			-- local thisGroup  = groupInfo[groupID]
			-- local itsLeader  = groupInfo[thisGroup.itsLeaderID]
			-- local moveDist   = 5*mAbs(thisGroup.dependancyPosition[2])
			-- local moveDistSQ = moveDist*moveDist
			-- if (thisGroup.target.hasAny) then
				-- local targetX    = thisGroup.target.posX
				-- local targetZ    = thisGroup.target.posZ
				-- local attackPosX = thisGroup.target.attackPosX
				-- local attackPosY = thisGroup.target.attackPosY
				-- local attackPosZ = thisGroup.target.attackPosZ
				-- local distanceSQ = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,attackPosX,attackPosZ) 
				-------- spEcho(attackPosX,attackPosZ,targetX,targetZ,distanceSQ,200*200)
				-- if (distanceSQ >= moveDistSQ) then   -- !? or when attacked?
				    -- BigMove(groupID,attackPosX,attackPosY,attackPosZ,0,thisGroup.formation,waiting,targetX,targetZ) -- only for tests
				-- end
			-- end
		end
	end,
    ["antigroundAir"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! basic airForce support, hunting raiders, supporting attack
		if (mode == "prepare") then
	        local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			local thisPosX,thisPosY,thisPosZ = GetPositionOfGroup(groupID)
			--- check the OPstatus
			local status = plan.operationalStatusCheck(groupID)
			if     (status == "IOA") then
			    if (not(thisGroup.target.hasAny)) then
				    local targetX    = thisGroup.target.posX
					local targetZ    = thisGroup.target.posZ
					local distanceSQ = GetDistance2DSQ(thisGroup.posX,thisGroup.posZ,targetX,targetZ) 
					if (distanceSQ >= 1000*1000) then   -- !? or when attacked?
						thisGroup.target.posX,thisGroup.target.posZ = GetRandomPlaceAround(thisTeam.mapBase.posX,thisTeam.mapBase.posZ,400,800)
						thisGroup.target.hasAny = false
						thisGroup.fightStatus   = "regrouping"
					end
				end
			elseif (status == "HL") then
			    if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then 
					local targetIndex = GetOneValuableTarget(groupID,teamNumber,"builders")
					if (targetIndex == 0) then
					else
						thisGroup.target.hasAny = true
						thisGroup.target.index  = targetIndex
						thisGroup.fightStatus   = "preparingForAttack"
					end
				end
			elseif (status == "LL") then
			    if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then 
					local targetIndex = GetOneValuableTarget(groupID,teamNumber,"defences")
					if (targetIndex == 0) then
					else
						thisGroup.target.hasAny = true
						thisGroup.target.index  = targetIndex
						thisGroup.fightStatus   = "preparingForAttack"
					end
				end
			elseif (status == "ready") then
			    if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then 
					local targetIndex = GetOneValuableTarget(groupID,teamNumber,"defences")
					if (targetIndex == 0) then
						local class       = ChooseRandomTargetClass(groupID)
						--spEcho("random class: ", class)
						local targetIndex = GetOneValuableTarget(groupID,teamNumber,class)
						if (targetIndex ~= 0) then
							thisGroup.target.hasAny = true
							thisGroup.target.index  = targetIndex
							thisGroup.fightStatus   = "preparingForAttack"
						end
					else
						thisGroup.target.hasAny = true
						thisGroup.target.index  = targetIndex
						thisGroup.fightStatus   = "preparingForAttack"
				    end
				end
			elseif (status == "full") then
			    if (not(thisGroup.target.hasAny) and (thisTeam.countOfStrategicTargets > thisTeam.countOfStrategicTargetsUsed)) then 
					local targetIndex = GetOneValuableTarget(groupID,teamNumber,"expTowers")
					if (targetIndex == 0) then
						--spEcho("No target of asked class found")
						local class       = ChooseRandomTargetClass(groupID)
						local targetIndex = GetOneValuableTarget(groupID,teamNumber,class)
						if (targetIndex ~= 0) then
							thisGroup.target.hasAny = true
							thisGroup.target.index  = targetIndex
							thisGroup.fightStatus   = "preparingForAttack"
						end
					else
						thisGroup.target.hasAny = true
						thisGroup.target.index  = targetIndex
						thisGroup.fightStatus   = "preparingForAttack"
					end
				end
			end
			--spEcho(groupID,"prep:",status,thisGroup.fightStatus,thisGroup.target.index,thisGroup.membersListCounter)
			--if (thisGroup.target.index ~= 0) then
			    --spEcho(thisTeam.listOfStrategicTargets[thisGroup.target.index].unitID)
			    --spEcho(UnitDefs[Spring.GetUnitDefID(thisTeam.listOfStrategicTargets[thisGroup.target.index].unitID)].name)
			--end
	    else
		    local thisTeam  = teamInfo[teamNumber]
			local thisGroup = groupInfo[groupID]
			--spEcho(groupID,"fight:",thisGroup.operationalStatus,thisGroup.fightStatus,thisGroup.target.index,thisGroup.membersListCounter)
			if (thisGroup.target.hasAny and (thisGroup.operationalStatus ~= "IOA")) then
				if (thisGroup.fightStatus == "preparingForAttack" or thisGroup.fightStatus == "attacking") then
				    local targetUnitID = thisTeam.listOfStrategicTargets[thisGroup.target.index].unitID
					local isDead       = spGetUnitIsDead(targetUnitID)
					--spEcho(tostring(isDead))
					if (not(isDead) and (isDead ~= nil)) then
						--local targetX,targetY,targetZ = spGetUnitPosition(targetUnitID)
						local targetX = 1
						for i=1,thisGroup.membersListMax do
							if (thisGroup.membersListAlive[i] and (targetX ~= 0)) then
								spGiveOrderToUnit(thisGroup.membersList[i], CMD_ATTACK , {targetUnitID}, {}) --{targetX,targetY,targetZ}
							end
						end
						thisGroup.fightStatus = "attacking"
					else
					    thisGroup.fightStatus   = "preparingForAttack"
						thisGroup.target.hasAny = false
					end
				end
			else
				local targetX    = thisGroup.target.posX
				local targetZ    = thisGroup.target.posZ
			    BigMove(groupID,targetX,0,targetZ,0,thisGroup.formation,waiting)
			end
		end
	end,
	["makers"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- metal makers on/off
		if (mode == "prepare") then
		    local thisTeam      = teamInfo[teamNumber]
		    local thisGroup     = groupInfo[groupID]
            local levelEnergy   = thisTeam.energyLevel
	        local storageEnergy = thisTeam.energyStorage
			local offLimit      = storageEnergy/5
			local onLimit       = (storageEnergy/10)*7
		    if (levelEnergy <= offLimit) then
			    for i=thisTeam.makersOn-1,thisGroup.membersListMax-1 do
				    if (thisGroup.membersListAlive[i+1]) then
						spGiveOrderToUnit(thisGroup.membersList[i+1], CMD_ONOFF, { 0 }, { })
						--spEcho(thisTeam.makersOn,"offing")
					end
				end
				thisTeam.makersOn = 0
            end
            if (levelEnergy >= onLimit) then
			    for i=thisTeam.makersOn,thisGroup.membersListMax-1 do
				    if (thisGroup.membersListAlive[i+1]) then
						spGiveOrderToUnit(thisGroup.membersList[i+1], CMD_ONOFF, { 1 }, { })
						thisTeam.makersOn = thisTeam.makersOn + 1
						--spEcho("onning")	
						break
					end
				end
            end			
		end
	end,
	["expansion2"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- makes advanced tech things
		--- ! makes mohobot
		if (mode == "prepare") then
		    local thisGroup              = groupInfo[groupID]
			local thisTeam               = teamInfo[teamNumber]
		    --- init ---
			if (thisGroup.initialization) then -- only once at start
                BuildInitOfExpansion(groupID,teamNumber)
				--- no other init needed
				thisGroup.initialization = false
			end
			--- something ---
			--spEcho(thisGroup.planCurrent,thisGroup.buildStatus)
			if (thisGroup.planCurrent ~= "stop") then
				thisGroup.planCurrent = "expansion2zero"
			end
			-- test if its idle
			if (thisGroup.membersListAlive[1]) then
				isBuildingNow = spGetUnitIsBuilding(thisGroup.membersList[1])
				if ((isBuildingNow == nil) and (thisGroup.buildStatus == "doingZero")) then
				    thisGroup.buildStatus = "patroling"
				end
			end
		else
		    local thisGroup = groupInfo[groupID]
			if    (thisGroup.buildStatus == "idle") then
			    plan[thisGroup.planCurrent](groupID,teamNumber)
			elseif(thisGroup.buildStatus == "patroling") then
			   	plan["staticPatrol"](groupID,teamNumber)
			end
		end
	end,
	["expansion2def"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION --- 
		--- makes advanced tech things
		--- ! makes mohobot
		if (mode == "prepare") then
		    local thisGroup              = groupInfo[groupID]
			local thisTeam               = teamInfo[teamNumber]
		    --- init ---
			if (thisGroup.initialization) then -- only once at start
                BuildInitOfExpansion(groupID,teamNumber)
				--- no other init needed
				thisGroup.initialization = false
			end
			--- something ---
			--spEcho(thisGroup.planCurrent,thisGroup.buildStatus)
			if (thisGroup.planCurrent ~= "stop") then
				thisGroup.planCurrent = "expansion2defZero"
			end
			-- test if its idle
			if (thisGroup.membersListAlive[1]) then
				isBuildingNow = spGetUnitIsBuilding(thisGroup.membersList[1])
				if ((isBuildingNow == nil) and (thisGroup.buildStatus == "doingZero")) then
				    thisGroup.buildStatus = "patroling"
				end
			end
		else
		    local thisGroup = groupInfo[groupID]
			if (thisGroup.buildStatus == "idle") then
			    plan[thisGroup.planCurrent](groupID,teamNumber)
			elseif(thisGroup.buildStatus == "patroling") then
			   	plan["staticPatrol"](groupID,teamNumber)
			end
		end
	end,
    ["airSupreme"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! basic air commander
		if (mode == "prepare") then
		    --- nothing
		else
		    local thisGroup = groupInfo[groupID]
			local thisTeam  = teamInfo[teamNumber]
		    if (thisGroup.receivedUnit) then
			    for i=1,thisGroup.membersListMax do
					if (thisGroup.membersListAlive[i]) then
						spGiveOrderToUnit(thisGroup.membersList[i], CMD_PATROL, { thisTeam.mapBase.posX, 0, thisTeam.mapBase.posZ }, {})
						spGiveOrderToUnit(thisGroup.membersList[i], CMD_PATROL, { halfX, 0, halfZ }, {"shift"})
						thisGroup.fightStatus = "patroling"
					end
				end
     			thisGroup.receivedUnit = false
			end
		end
	end,
	["strategicDefence-nuke"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- basic nuke commander
		if (mode == "prepare") then
		    local thisGroup = groupInfo[groupID]
			local thisTeam  = teamInfo[teamNumber]
			if (thisGroup.receivedUnit) then
				for i=1,thisGroup.membersListMax do
					if (thisGroup.membersListAlive[i]) then
						spGiveOrderToUnit(thisGroup.membersList[i], CMD_STOCKPILE, {}, { "ctrl", "shift" })
					end
				end
				thisGroup.receivedUnit = false
			end
		else
		    local thisGroup = groupInfo[groupID]
			local thisTeam  = teamInfo[teamNumber]
		    for i=1,thisGroup.membersListMax do
				if (thisGroup.membersListAlive[i]) then
					local numberOfRockets = spGetUnitStockpile(thisGroup.membersList[i])
					if (numberOfRockets >= 1) then
					    thisGroup.target.posX   = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerX
				        thisGroup.target.posZ   = mapDanger[teamNumber][thisTeam.mapMinSafetyIndexTileIndex].centerZ
					    spGiveOrderToUnit(thisGroup.membersList[i], CMD_ATTACK , {thisGroup.target.posX,0,thisGroup.target.posZ}, {})
					end
				end
			end
		end		
	end,
	["basicAdmiral"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! basic ships commander
	end,
    ["superunit"] = function(groupID,teamNumber,mode)
	    --- DESCRIPTION ---
		--- ! AI commanding special unit, leader/queen of some spaceinvaders (Bugs, Replicators, Pirates)
	end,	
}