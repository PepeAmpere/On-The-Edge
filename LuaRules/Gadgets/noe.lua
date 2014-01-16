--        --
-- N.O.E. --
--        --

function gadget:GetInfo()
  return {
    name      = "N.O.E.",
    desc      = "Framework",		-- for AI and scenario making
    author    = "PepeAmpere",
    date      = "March 15, 2012",	-- huge update in winter 2013/14
    license   = "notAlicense",  	-- CC BY-NC-SA if not specified on website
    layer     = 0,
    enabled   = true --  loaded by default?
  }
end

-- all files from LuaRules/Configs/noe/ are used, too
-- optionaly all lua files from missions/<mission_name>/ folder are used

if (gadgetHandler:IsSyncedCode()) then
-- BEGIN SYNCED

local Spring                           = Spring
local math                             = math
local Game                             = Game
local table                            = table
local ipairs                           = ipairs
local pairs                            = pairs

local floor                            = math.floor
local ceil                             = math.ceil
local deg                              = math.deg
local sin                              = math.sin
local cos                              = math.cos
local asin                             = math.asin
local acos                             = math.acos
local atan                             = math.atan
local abs                              = math.abs
local sqrt                             = math.sqrt
local random                           = math.random
local PI                               = math.pi

local pseudoRandom                     = 1
realGameTime		                   = {0,0,0}      -- hours, minutes, seconds

local spAreTeamsAllied                 = Spring.AreTeamsAllied
local spEcho                           = Spring.Echo
local spGetModOptions                  = Spring.GetModOptions
local spGetGroundHeight                = Spring.GetGroundHeight
local spGetUnitPosition                = Spring.GetUnitPosition
local spGetUnitsInCylinder             = Spring.GetUnitsInCylinder
local spGetUnitsInRectangle            = Spring.GetUnitsInRectangle
local spGetTeamUnitCount               = Spring.GetTeamUnitCount
local spGetTeamResources               = Spring.GetTeamResources
local spGiveOrderToUnit                = Spring.GiveOrderToUnit
local spSetTeamResource                = Spring.SetTeamResource
local spAddTeamResource                = Spring.AddTeamResource

------ SETTINGS ----------
local frameworkOFFwithoutAI			   = true		 -- depends on setting here or on modoptions in initialization
--- !? some of the values rewritten in init depending on size of map and lobby settings now !? ---
local step                             = 60          -- how much frames for each step -- more then 14 needed now
local timeStep                         = 1           -- recalculation of time if step is changed
local mapSmallCycleLength              = 8           -- how long is small cycle   (speedup for counting map)
local stepBeginMapping                 = 1           -- frame of start of mapping
local stepEndMapping                   = stepBeginMapping + mapSmallCycleLength - 1    -- frame of end of mapping
local stepSetGlobals                   = stepEndMapping + 1 -- frame of globals vars setting
local stepExecute                      = stepSetGlobals + 1 -- frame of executes
local executePartLenght                = 4           -- how many frames used for execution (used these: <stepExecute,(stepExecute+executePartLenght>)
local minimalStep                      = stepExecute + executePartLenght  --- ending frame
local mapMediumCycleLength             = 150         -- how long is medium cycle
--local mapTileUnitConstant              = 4           -- how many units in tile is full tile
local mapHugeTile                      = 8           -- how big is Huge tile (for searching algoritm)
local mapHugeTileEdge                  = 1           -- edgecut of search tile (for tile 8x8 edge 1 means 6x6 searching space) => !! max 1/2 mapHugeTile
local edgeDistance                     = 200         -- how far point from map edge have to be choosen
-- local superUnitName                    = "repdrone"  --"repmum"    -- name of leader type unit
-- local unitOfGroupOne                   = "bug1"      -- unit for first team !temporary

-- mapping settings --
mapDivision                            = 256         -- how big tiles i use for mapping
local divConst                         = 1.9 --1.9   -- danger transmition division constant - main
local divConst2                        = 2.6 --3     -- danger transmition division constant 2
local divConst3                        = 3.2 --4     -- danger transmition division constant 3
local unitDangerMultiplier             = 5           -- how much danger is one unit
local fullSafe                         = 25          -- safeTileIndex for supersafe tile
local splitMapping                     = false       -- mapping can be splitted for bigger maps
-- xAnts --
antDecreaseValue                       = 0.9
antDecreaseTimes                       = 1
antCounter                             = 0
antValue                               = 1

--- global for testing
_G.mapDivision                         = mapDivision

-- formations/move settings

----- END OF SETTINGS ----

local splitter  
local firstID

----- MAP ----------------
local mapX                             = Game.mapSizeX
local mapZ                             = Game.mapSizeZ
local mapXdivs                         = floor(mapX / mapDivision)
local mapZdivs                         = floor(mapZ / mapDivision)
local mapCount                         = mapXdivs * mapZdivs
local mapXdivsStep                     = floor(mapXdivs / mapSmallCycleLength)
halfX                                  = mapX/2
halfZ                                  = mapZ/2
mapDanger                              = {}  -- map special for each team
mapDefault                             = {}  -- tiles that are not part of map
mapNeutral                             = {}  -- physical part of map
mapMetal                               = {}  -- posX, posZ, amount, water Y/N,
mapBuild                               = {}  -- posX, posZ,... 
local iStartPoint                      = 0                -- only speedup
local iEndPoint                        = mapXdivsStep-1   -- only speedup
local mapSmallCycles                   = 0           -- number of small cycles
local mapMediumCycles                  = 0           -- number of medium cycles

-- map globals for testing
_G.mapXdivs                            = mapXdivs
_G.mapZdivs                            = mapZdivs
_G.mapDanger                           = mapDanger
_G.mapNeutral                          = mapNeutral
_G.mapSmallCycles                      = mapSmallCycles
_G.mapMediumCycles                     = mapMediumCycles
_G.mapMediumCycleLength                = mapMediumCycleLength
_G.mapTileUnitConstant                 = mapTileUnitConstant
_G.mapMetal                            = mapMetal
_G.mapBuild                            = mapBuild

mapTilesAroundIndex                    = {  --- index map for looking on neigbours of one tile
	[1]  = -1,              -- up
	[2]  = mapZdivs - 1,    -- uppright
	[3]  = mapZdivs,        -- right
	[4]  = mapZdivs + 1,    -- downright
	[5]  = 1,               -- down
	[6]  = -mapZdivs + 1,   -- downleft
	[7]  = -mapZdivs,       -- left
	[8]  = -mapZdivs - 1,   -- upleft
}

local mapMaxHeight                     = 0
_G.mapMaxHeight                        = mapMaxHeight
----- END MAP ------------
----- CTRL VARIABLES -----
---- main tables and variables, globals

gaiaID									= Spring.GetGaiaTeamID()
missionName								= string.lower(Spring.GetModOptions().mission_name or "none") or "none" -- name of scenario
playMission								= false	-- do we play scenario?
aiOptions								= {}
teamNames								= {}	-- info for spawner, some the same as in aiOptions, but for all teams, hash "name" -> teamNumber
teamIDtoName							= {}	-- opposite direction then previouse table
numberOfMissionAIs						= 0
numberOfNoeAITeams						= 0
numberOfOtherAITeams					= 0		-- for testing multiplayer games
maximumOfMissionPlayers					= 0
missionPlayersCount						= 0
groupInfo								= {}	-- main AI agent table
groupCount								= 0		-- number of special units
teamInfo								= {}	-- main AI side table
sideIDcount								= 0		-- number of teams commanded by AI
AITeamID								= {} 
reverseAITeamID							= {}  
teamList								= {}	-- all teams in game
reverseUnitsGroupID						= {}	-- unitID -> groupID of current group
reverseUnitsListID						= {}	-- unitID -> position in list in current group
fromIDToNameTable						= {}	-- unitDefID -> unitName
fromNameToIDTable						= {}	-- unitName  -> unitDefID 
valuableUnits							= {}	-- list of names of units that are considered to be valuable
isStaticTargetClass						= {}	-- class name -> true/false
sourcesList								= {}	-- list of names of factories creating units that AI knows
unitTypesList							= {}	-- names of units that AI knows
unitsUnderGreatEyeNameToID				= {}	-- units that NOE keeps eye on becouse some trigger reason
unitsUnderGreatEyeIDtoName				= {}	-- units that NOE keeps eye on becouse some trigger reason

---- for testing
_G.teamInfo                            = teamInfo

------
local listOfTypesOfPathing = {
    ["RunAway"]                        = "run",
}

-- unit specific --

---- PLANS ----
---- SoloWarrior --- ONLY FOR REPLICATOR QUEEN  ... example:
local zeroClassPlans           = {"RunAway"}                                                                 -- survival plans
local firstClassPlans          = {"Heal", "GuardHive"}                                                       -- res plans
local secondClassPlans         = {"GuardImportant", "BuildHive"}                                             -- start plans
local thirdClassPlans          = {"GuardBase", "BasicEnergy", "BasicMetal"}                                  -- basic plans
local fourthClassPlans         = {"BuildUnits", "BuildFactory", "MoreEnergy", "MoreMetal", "SmallAttack"}    -- standard plans
local fifthClassPlans          = {"BuildBasicDef", "MediumAttack"}                                           -- advanced plans
--- end of plans

local function AddTeam(teamNumber,teamID,side,difficulty)
	--- now only for REPlicators, later if here depending "side"
	teamInfo[sideIDcount + 1] =
	{
	    --- basics
		["kind"]                       = side,           
        ["difficulty"]		           = difficulty,      
		["personality"]                = "normal",        -- ! some update needed, not implemented yet
		["teamID"]                     = teamID,          -- spring teamID
		["teamNumber"]                 = teamNumber,      -- noe ID
    	--- settings lists
		--["listOfSpirits"]            = {},		-- prepare function, that uses some files settings
		["numberOfGroups"]             = 0,
		["listOfGroupsIDs"]            = {},
		["listOfGroupsNames"]          = {},
		["groupNameToID"]			   = {},		-- groupName -> groupID of given group
		--- orders lists ---
		["unitTypeCount"]              = {},
		-- now these four structures are made automaticly
		-- ["buildOrdersBot1"]            = {{},{},{},{},{},{},{}},
		-- ["buildOrdersVeh1"]            = {{},{},{},{},{},{},{}},
		-- ["buildOrdersAir1"]            = {{},{},{},{},{},{},{}},
		-- ["buildOrdersShip"]            = {{},{},{},{},{},{},{}},
		
		["startInitNeeded"]            = true,     -- if its needed to be done
		
		--- map positions
		["mapBase"]                    = {},       -- where units are gathered
		["mapBattleLine"]              = {},       -- where the main fight is  --- test
		["mapSupportPos"]              = {},       -- where the support units are gathered
		["mapEnemyBase"]               = {},       -- test
		--- map lists
		["listOfMexes"]                = {},
		["listOfMexesAttemptsCounter"] = {},
		["minAttempts"]                = 0,
        -- ["listOfConst"]                = {},
        -- ["listOfDFens"]                = {},
		-- ["listOfPower"]                = {},
		-- ["listOfFactr"]                = {},
		-- ["listOfTargets"]              = {},
		---
		["keyUnitIDs"]                 = {},       -- hashTable
		---
		["listOfStrategicTargets"]     = {}, -- used
		["listOfStrategicTargetsAlive"]= {}, -- used
		["reverseValuableUnitID"]      = {}, -- used
		["countOfStrategicTargets"]    = 0, -- used
		["countOfStrategicTargetsUsed"]= 0, -- used
		---
		-- ["listOfImportantFriendly"]    = {},
		-- ["listOfAttackers"]            = {},
		-- ["listOfPlannedBuildings"]     = {},
		["listOfSafePlaces"]           = {},
		-- ["listOfDangers"]              = {},
		--- vars for map lists
		["listOfSafePlacesCount"]      = 0,
		["defencePerimeter"]           = {},
		--- ctrlvars
		["historyAlert"]               = {"0", "0", "0", "0", "0", "0", "0", "0", "0", "0",}, --- last 10 alerts
		["currentAlert"]               = 0, ---- number of important friendly units attacked in last iteration 
		["historyCasus"]               = {"0", "0", "0", "0", "0", "0", "0", "0", "0", "0",}, --- last 10 casus
		["currentCasus"]               = 0, ---- number of friendly units attacked in last iteration 
		-- ["historyMetalStorages"]       = {"1", "1", "1", "1", "1", "1", "1", "1", "1", "1",}, --- last 10 storages
		-- ["currentMetalStorages"]       = 0,
		-- ["historyEnergyStorages"]      = {"1", "1", "1", "1", "1", "1", "1", "1", "1", "1",}, --- last 10 storages
		-- ["currentEnergyStorages"]      = 0,
		["metalLevel"]                 = 0,
		["metalStorage"]               = 0,
		["metalIncome"]                = 0,
		["metalExpense"]               = 0,
		["energyLevel"]                = 0,
		["energyStorage"]              = 0,
		["energyIncome"]               = 0,
		["energyExpense"]              = 0,
		["makersOn"]                   = 0,
		--- map counters
		["mapMaxHoldedTile"]           = 1,   -- the most holded tile
		["mapMaxHoldedTileCycle"]      = 0,   -- the most holded tile per cycle
		["mapMaxAntIndex"]             = 1,   -- the most holded tile by xAnts
		["mapMaxAntIndexCycle"]        = 1,   -- the most holded tile by xAnts per cycle
		["mapMaxZeroHoldTile"]         = 1,   -- the most non-occupied tile
		["mapMaxZeroHoldTileCycle"]    = 0,   -- the most non-occupied tile per cycle
		["mapMaxSafetyIndexTile"]      = 1,   -- the most safe tile
		["mapMaxSafetyIndexTileCycle"] = 0,   -- the most safe tile per cycle
		["mapMinSafetyIndexTile"]      = fullSafe,  -- the most dangerous tile
		["mapMinSafetyIndexTileCycle"] = fullSafe,  -- the most dangerous tile value per cycle
		["mapMinSafetyIndexTileIndex"] = 1,         -- index of that tile 
		["mapMinSafetyIndexTileIndexCycle"] = 1,    -- index of that tile 
		["mapMaxHoldPowerRank"]        = 0,   -- the most holde tile in history
		["mapMaxHoldPowerRankIndex"]   = 1,   -- the most holde tile in history
		--- other
		["hiveAlive"]                  = false, -- is hive constructed??
		
	}
	sideIDcount = sideIDcount + 1
	side = teamInfo[sideIDcount]
	spEcho("AI" .. side.teamID .. " of kind: " .. side.kind .. ", Difficulty: " .. side.difficulty .. ", Personality: " .. side.personality )
end

local function AddDef(groupID,teamNumber,teamID,groupSpirit,groupName,groupDependance,groupLeaderName,factory,bufferFactories,groupDepPos,groupUnitName,groupSourceName,groupPreference,taskName)
  --- spEcho("Hey, Im new group: ", groupID)
  groupInfo[groupID] =
    {
		["groupED"]						= groupID,				-- noe groupID
		["teamID"]						= teamID,				-- springID
		["teamNumber"]					= teamNumber,			-- noe dataID
		
		["dependant"]					= groupDependance,		-- have this group free will or not?
		["itsLeaderName"]				= groupLeaderName,		-- groupName of leader, IF dependant
		["itsLeaderID"]					= 0,					-- groupID of leader, IF dependant	
		["factory"]						= factory,				-- is this group factory?
		["factories"]					= bufferFactories,		-- list of factories groupNames, IF buffer
		["factoriesGroupsIDs"]			= {},					-- list of factories groupIDs, IF buffer
		["dependancyPosition"]			= groupDepPos,			-- relative position to leaders group		
		["spirit"]						= groupSpirit,			-- unitAI type
		["name"]						= groupName,
		["formation"]					= "hexagon",			-- formation of group of units
		["moveModeChanged"]				= false,				-- when changed move mode
		["constrainLevel"]				= 0,					-- when changed move mode, first unit waits for some time until formation is reached
		["unitName"]					= groupUnitName,
		["sourceName"]					= groupSourceName,
		
		["posX"]						= halfX,
		["posZ"]						= halfZ,
		["rotation"] 					= 1,
		
		["initialization"]				= true,        
		
		["bufferGroupIDs"]				= {},					-- if this group is spirit buffer, it has list of dependant groups
		["bufferOrders"]				= 0,					-- new property of Buffer holding the number of orders waiting for execution
		["waitingOrders"]				= 0,					-- dependant group orders counter
		["lastOrderID"]					= 0,					-- ID of group that added the last order
		
		["transferCount"]				= 1,					-- how many units are added in one unit transfer
		["active"]						= true,
		["sleeping"]					= true,
		["notSleeper"]					= false,				
		["acceptingUnits"]				= true,
		["receivedUnit"]				= false,          
		["preference"]					= groupPreference,		-- !OBSOLETE! how many units in which level i need 
		["buildStatus"]					= "idle",				-- not building as default
		["operationalStatus"]			= "IOA",				-- others are none,IOA, HL, LL, rdy,full,...
		["operationalStatusLimits"]		= {},					-- numbers of units
		["fightStatus"]					= "idle",				-- idle, figting, waiting for other groups...
		["taskStatus"]					= "none",				-- mission status names (various)
		["taskName"]					= taskName,				-- generalIdentifier
		["taskInfo"]					= {},					-- specific mission iformation
		["attacked"]					= false,				-- is group attacked
		["attackersPosition"]			= {},					-- last position of last relevant attacker
		["endangeredIndex"]				= 0,					-- how much is group attacked
		["range"]						= 1,					-- shoot/build distance of unit           
		
		["membersList"]					= {},					-- units of the group by unitID
		["membersListCounter"]			= 0,
		["membersListMax"]				= 0,
		["membersListAlive"]			= {},
			
		["targetClasses"]				= {},					--- list of all target classes possible to be attacked from groupDef  
		["target"]						= {
		    ["hasAny"]     = false,
			["index"]      = 0,				--- index of target, that links to side list of valuable targets
			["posX"]       = 0,				--- if not valuable target, so attack position
			["posZ"]       = 0,
			["attackPosX"] = 0,				--- these there means "attack from possition"
			["attackPosY"] = 0,
			["attackPosZ"] = 0,
		},
		
		["attackGroundRange"]			= 0,
		["attackAARange"]				= 0,
		["attackAGRange"]				= 0,
		["attackTorpRange"]				= 0,
		["controlRange"]				= 0,
		["buildRange"]					= 0,
		["metalListInRange"]			= {},					--- IDs of metal spots in buildRange
		["buildGroundInRange"]			= {},					--- IDs of ground build spots in buildRange, bucket sorted
		["buildWaterInRange"]			= {},					--- IDs of water build spots in buildRange, bucket sorted 
		["buildWaterAllUsed"]			= false,				-- is all space in the water taken?
		["buildGroundAllUsed"]			= false,				-- is all space on the ground taken?
		
		["planCurrent"]					= "none", 
		["plansHistory"]				= {},					--- all plans started in history of unit
	}

	-- local thisTeam = teamInfo[teamNumber]
    -- local lister = thisTeam.listOfSpirits
	-- if (#lister ~= 0) then
		-- groupInfo[#groupInfo].spirit = table.remove(lister)       -- add its spirit from prepared list
	-- else
		-- groupInfo[#groupInfo].spirit = "none"
	-- end
  ------ groupInfoByID[unitID] = #groupInfo  --- bidirectional way to number of unit
end
  
local function KillDef(unitID,teamID)
    -- local killThisOne
	-- local currentTeam = "t" .. teamID
    -- for i=1,#groupInfo do
        -- if (groupInfo[i].unitED == unitID) then
	        -- killThisOne = i
	    -- end
    -- end
    -- spEcho("Unit killed:", killThisOne)
	-- local itsSpirit = groupInfo[killThisOne].spirit
    -- table.remove(groupInfo, killThisOne)                -- clear table with AI variables
	-- spEcho("It was:", itsSpirit) 
    -- table.insert(teamInfo[reverseAITeamID[currentTeam]].listOfSpirits, itsSpirit) -- add back personality type back to listOfSpirits
	-- groupCount = groupCount - 1
end

function GroupEdit(groupID,parameterName,value)
	groupInfo[groupID][parameterName] = value
	return true
end

-- ! LETS MOVE all stuff in initialze part editing the group here
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

-- groupsEnds
----------- SOME MATH

function OwnRandom(minimal,maximal)
    pseudoRandom = pseudoRandom + 1
    local result = 0
	for i=1,(pseudoRandom % 7) + 2 do
	    result = math.random(minimal,maximal)
	end
	return result
end

function GetRandomPlaceAround(placeX,placeZ,distanceMin,distanceMax)
    local diff    = distanceMax - distanceMin
    local randX   = OwnRandom(-diff,diff)
	local randZ   = OwnRandom(-diff,diff)
	--spEcho(placeX,placeZ,randX,randZ)
	if (randX >= 0) then randX = randX + distanceMin else randX = randX - distanceMin end
	if (randZ >= 0) then randZ = randZ + distanceMin else randZ = randZ - distanceMin end
	randX = randX + placeX
	randZ = randZ + placeZ
	if ((randZ <= 0) or (randZ > mapZ) or (randX <= 0) or (randX > mapX)) then 
		randX,randZ = GetRandomPlaceAround(placeX,placeZ,distanceMin,distanceMax)
	end
	return randX, randZ
end

function GetRandomPlaceOnTheMap()
    -- ? can be added some parameters like: water, hill, or something
	local randX = OwnRandom(1,mapX)
	local randZ = OwnRandom(1,mapZ)
	return randX, randZ
end

function ToBool(something)
	if (something == 0 or something == "false" or something == "0" or something == false or something == nil) then
		return false
	else
		return true
	end
end

function TargetUsageChange(teamNumber,targetIndex,usage)
    teamInfo[teamNumber].listOfStrategicTargets[targetIndex].isNotTarget = not(usage)
	if (usage) then
	    teamInfo[teamNumber].countOfStrategicTargetsUsed = teamInfo[teamNumber].countOfStrategicTargetsUsed + 1
	else
	    teamInfo[teamNumber].countOfStrategicTargetsUsed = teamInfo[teamNumber].countOfStrategicTargetsUsed - 1
	end
end

local function Sleeping(groupID)
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

local function AddUnit(unitID,teamNumber,groupName,groupID)
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
 
local function KillUnit(unitID,teamNumber,groupID)
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

local function TestBeforeAddUnit(unitID,name,teamNumber)
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

local function AddValuableEnemy(unitID,teamNumber,teamID,valuableClass)
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

local function KillValuableEnemy(unitID,teamNumber)
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

local function SetResources()
	---- RESOURCES SETTING FOR ALL NOE GAMES -----
	for i=1,#teamList do
		local id = teamList[i]
		local _,_,_,isAI,side 	= Spring.GetTeamInfo(id)
		local aiInfo          	= Spring.GetTeamLuaAI(id)
		local m,ms,e,es
		local setThem 			= {true,true,true,true}
		if ((isAI) and (aiInfo == "Mission AI") and (sideSettings[teamIDtoName[tostring(id)]].startMetal ~= nil)) then
			m  = sideSettings[teamIDtoName[tostring(id)]].startMetal
			ms = sideSettings[teamIDtoName[tostring(id)]].startMetalStorage
			e  = sideSettings[teamIDtoName[tostring(id)]].startEnergy
			es = sideSettings[teamIDtoName[tostring(id)]].startEnergyStorage
		else
			-- hotfix for OTE
			if (heroClass and oteRule) then
				-- TODO: get metal value and class from setup
				local metalCurrent 	= 0
				setThem[1]	= false
				setThem[2]	= false
				setThem[4]	= false
				-- Spring.Echo(oteRule.energy[heroClass[class].statsClass[3]])
				-- m  = metalCurrent
				ms = 100000
				-- e  = oteRule.energy[heroClass[class].statsClass[3]]
				-- es = oteRule.energy[heroClass[class].statsClass[3]]
			else
				m  = floor((missionInfo.playersMetal or 1000)/missionPlayersCount)
				ms = floor((missionInfo.playersMetal or 1000)/missionPlayersCount)
				e  = floor((missionInfo.playersEnergy or 1000)/missionPlayersCount) 
				es = floor((missionInfo.playersEnergy or 1000)/missionPlayersCount)
			end
		end
		--Spring.Echo("res",id,m,e,ms,es)
		if (setThem[1]) then spSetTeamResource(id, "m", m) end
		if (setThem[2]) then spSetTeamResource(id, "e", e) end 
		if (setThem[3]) then spSetTeamResource(id, "ms", ms) end 
		if (setThem[4]) then spSetTeamResource(id, "es", es) end
	end
	---- END OF RESOURCES SETTING ----
end
-------------------------
------------------------- 
-- utility
local function DefaultTileReset() --- making default tile for map border for mapping
        local clev = 0.1
    	mapDefault[1] = {
		-- this part is needed for Mapping/safety
	    ["safetyTransmission"] = {["xDown"]=clev,["xUp"]=clev,["zLeft"]=clev,["zRight"]=clev},
		["safetySecondary"]    = {["xDown"]=clev,["xUp"]=clev,["zLeft"]=clev,["zRight"]=clev},
		["safetyTertiary"]     = {["xDown"]=clev,["xUp"]=clev,["zLeft"]=clev,["zRight"]=clev},
		-- this is of SetSafePositionn
		["safetyIndex"]        = 0, 
	} 
end

local function CreateDangerMap(teamNumber)
    --mapMaxHeight = 0
	mapDanger[teamNumber] = {}
    thisTeam = teamInfo[teamNumber]	
    for i=0,mapXdivs do
        for j=0,mapZdivs do
		    --spEcho("Hey adding", i, j)
			local cornerX = i*mapDivision
			local cornerZ = j*mapDivision
			local height
			    local h1 = spGetGroundHeight(cornerX+mapDivision/4,cornerZ+mapDivision/4)
				local h2 = spGetGroundHeight(cornerX+(mapDivision/4)*3,cornerZ+mapDivision/4)
				local h3 = spGetGroundHeight(cornerX+mapDivision/4,cornerZ+(mapDivision/4)*3)
				local h4 = spGetGroundHeight(cornerX+(mapDivision/4)*3,cornerZ+(mapDivision/4)*3)
			local height = (h1 + h2 + h3 + h4)/4	
			
			local dataIndex = i*mapZdivs+j+1
	        ---- MAP OBJECT ----
			mapDanger[teamNumber][dataIndex]  = {
				["cornerX"]            = cornerX,  -- X axis
				["cornerZ"]            = cornerZ,  -- Z axis
				["centerX"]            = cornerX + mapDivision/2,
				["centerZ"]            = cornerZ + mapDivision/2,
				["holdPower"]          = 0,        -- how many units currently ocupy the tile
				["holdPowerHistory"]   = {},       -- holdPower numbers in history
				["holdPowerRank"]      = 0,        -- holdPower counter number through all iterations
				["antIndex"]           = 0,      -- the same like powerRank, but it lowers down by time
				["isHolded"]           = false,    -- holdPower > 0 or not
				["isHoldedHistory"]    = {},       -- is Holded history
				["zeroHoldPower"]      = 0,        -- how many iterations is holdPower = 0  
				["safetyIndex"]        = 0,        -- index counted through evaluation of map based on zeroHoldPower and holdPower
				["safetyTransmission"] = {["xDown"]=0,["xUp"]=0,["zLeft"]=0,["zRight"]=0}, -- direct way transmission
				["safetySecondary"]    = {["xDown"]=0,["xUp"]=0,["zLeft"]=0,["zRight"]=0}, -- secondary trans
				["safetyTertiary"]     = {["xDown"]=0,["xUp"]=0,["zLeft"]=0,["zRight"]=0}, -- tertiary trans
				["lessSafeTileIndex"]  = 0,        -- index of tile where is the biggest danger
				["tileNotCovered"]     = 0,        -- number of iterations that tile is not covered by radar (basic number for Incertainity)				
			}
			
			mapNeutral[dataIndex] = {
			    ["tileHeight"]         = height, 
			}
			
			if (height > mapMaxHeight) then
			    mapMaxHeight = height
			end
		end	
	end
	--- table for crossing unsafe iterations
	DefaultTileReset() 
	--- only for testing ---
	_G.mapMaxHeight = mapMaxHeight
	_G.mapNeutral = mapNeutral
end

local function Mapping(part,teamNumber,splitMapping)
    local thisTeam = teamInfo[teamNumber]
    --- this is only speedup part
	if (part == stepBeginMapping) then  
		thisTeam.mapMaxHoldedTileCycle      = 0
		thisTeam.mapMaxAntIndexCycle        = 0
		thisTeam.mapMaxZeroHoldTileCycle    = 0
		thisTeam.mapMaxSafetyIndexTileCycle = 0
		thisTeam.mapMinSafetyIndexTileCycle = fullSafe
	end
	--- end of speedup part
	-- spEcho(iStartPoint,iEndPoint)
	
    for i = part+1,mapCount,mapSmallCycleLength do   ---- normaly from 0 to mapXdivs-1, now speeded
	    local j           = (i % mapZdivs)+1
		local thisIndex   = i
		local dngr        = mapDanger[teamNumber][thisIndex] -- only speedup for acces to table
		local startPointX = dngr.cornerX 
		local startPointZ = dngr.cornerZ
		local allUnits    = spGetUnitsInRectangle(startPointX,startPointZ,(startPointX + mapDivision),(startPointZ + mapDivision)) 
		local power       = #allUnits
		
		for a = 1, #teamList do   -- how many units/tile
			local allied = (spAreTeamsAllied(teamList[a],AITeamID[teamNumber]))
			if (allied) then
				local units = spGetUnitsInRectangle(startPointX,startPointZ,(startPointX + mapDivision),(startPointZ + mapDivision),teamList[a])  
				power       = power - #units
			end	
		end			
		
		dngr.holdPower     = power                                           -- change up holdPower of tile
		dngr.holdPowerRank = dngr.holdPowerRank + power                      -- grow up holdPowerRank of tile
		---- safety part
		local dngrUp   = mapDanger[teamNumber][thisIndex-1]  --or mapDefault[1]    -- only speedup for acces to table
		local dngrDown = mapDanger[teamNumber][thisIndex+1] --or mapDefault[1]     -- only speedup for acces to table
		if (j == 1) then                                                     -- fix against top/down safety transition
			dngrUp = mapDefault[1]
		end
		if (j == mapZdivs) then 			
			dngrDown = mapDefault[1]
		end
		local dngrLeft  = mapDanger[teamNumber][thisIndex-mapZdivs] --or mapDefault[1]    -- only speedup for acces to table
		local dngrRight = mapDanger[teamNumber][thisIndex+mapZdivs] --or mapDefault[1]    -- only speedup for acces to table
		if (i <= mapZdivs) then                                                            -- fix for left/right safety border
			dngrLeft = mapDefault[1]
		end
		if (i >= mapCount - mapZdivs) then 			
			dngrRight = mapDefault[1]
		end
		-- spEcho(teamNumber .. " " .. i*mapZdivs+j+1 .. " ")
		local somePower = dngr.holdPower * unitDangerMultiplier
		local up, down, right, left
		down  = dngrUp.safetyTransmission.xDown + (dngrUp.safetySecondary.xDown + dngrUp.safetyTertiary.xDown)/2
		up    = dngrDown.safetyTransmission.xUp + (dngrDown.safetySecondary.xUp + dngrDown.safetyTertiary.xUp)/2
		right = dngrLeft.safetyTransmission.zRight + (dngrLeft.safetySecondary.zRight + dngrLeft.safetyTertiary.zRight)/2
		left  = dngrRight.safetyTransmission.zLeft + (dngrRight.safetySecondary.zLeft + dngrRight.safetyTertiary.zLeft)/2
		dngr.safetyIndex = fullSafe - down
									- up
									- right
									- left
									- somePower  		                             -- prepare safeindex for tile
		dngr.safetyTransmission.xDown  = (dngrUp.safetyTransmission.xDown    + somePower) / divConst
		dngr.safetyTransmission.xUp    = (dngrDown.safetyTransmission.xUp    + somePower) / divConst
		dngr.safetyTransmission.zRight = (dngrLeft.safetyTransmission.zRight + somePower) / divConst
		dngr.safetyTransmission.zLeft  = (dngrRight.safetyTransmission.zLeft + somePower) / divConst			
		
		dngrUp.safetyTertiary.zRight   = (dngrLeft.safetyTertiary.zRight     + somePower) / divConst2 + up / divConst3
		dngrUp.safetyTertiary.zLeft    = (dngrRight.safetyTertiary.zLeft     + somePower) / divConst2 + up / divConst3
		dngrDown.safetySecondary.zRight = (dngrLeft.safetySecondary.zRight   + somePower) / divConst2 + down / divConst3
		dngrDown.safetySecondary.zLeft  = (dngrRight.safetySecondary.zLeft   + somePower) / divConst2 + down / divConst3
		dngrLeft.safetyTertiary.xUp    = (dngrDown.safetySecondary.xUp       + somePower) / divConst2 + left / divConst3
		dngrLeft.safetyTertiary.xDown  = (dngrUp.safetyTertiary.xDown        + somePower) / divConst2 + left / divConst3
		dngrRight.safetySecondary.xUp  = (dngrDown.safetySecondary.xUp       + somePower) / divConst2 + right / divConst3
		dngrRight.safetySecondary.xDown = (dngrUp.safetySecondary.xDown      + somePower) / divConst2 + right / divConst3

		if (dngr.safetyIndex >= (fullSafe - 0.1)) then dngr.safetyIndex = fullSafe end
		
		---- ANTS ---
		dngr.antIndex = (dngr.antIndex + (dngr.holdPower*antValue))
        local decrease = antCounter % antDecreaseTimes
		if (decrease == 0) then
			dngr.antIndex = dngr.antIndex * antDecreaseValue
		end
		---- endANTS ---
		--- end safety part
		--------------- maxconditions
		--- isHolded condition and notHolded
		if (power >= 1) then  
			dngr.isHolded = true                            -- tile is holded by some unit
			--- maxHold condition
			if (dngr.holdPower > thisTeam.mapMaxHoldedTile) then
				thisTeam.mapMaxHoldedTile = dngr.holdPower
			end
			if (dngr.holdPower > thisTeam.mapMaxHoldedTileCycle) then 
				thisTeam.mapMaxHoldedTileCycle = dngr.holdPower
			end
			--- end of maxHold condition
		else                   
			dngr.isHolded = false                           -- tile is not holded by unit
			dngr.zeroHoldPower = dngr.zeroHoldPower + 1     -- tile is not holded for another turn
			--- maxZeroHold condition
			if (dngr.zeroHoldPower > thisTeam.mapMaxZeroHoldTile) then
				thisTeam.mapMaxZeroHoldTile = dngr.zeroHoldPower
			end
			if (dngr.zeroHoldPower > thisTeam.mapMaxZeroHoldTileCycle) then 
				thisTeam.mapMaxZeroHoldTileCycle = dngr.zeroHoldPower
			end
			--- end of maxZeroHold condition
		end
		--- maxSafetyIndex condition
		if (dngr.safetyIndex > thisTeam.mapMaxSafetyIndexTileCycle) then 
			thisTeam.mapMaxSafetyIndexTileCycle = dngr.safetyIndex
		end
		--- end of maxconditions
		--- minSafetyIndex conditon
		if (dngr.safetyIndex < thisTeam.mapMinSafetyIndexTileCycle) then 
			thisTeam.mapMinSafetyIndexTileCycle      = dngr.safetyIndex
			thisTeam.mapMinSafetyIndexTileIndexCycle = thisIndex
		end
		--- end of minSafetyIndex
		--- mapMaxHoldPowerRank ---
		if (dngr.holdPowerRank > thisTeam.mapMaxHoldPowerRank) then
		    thisTeam.mapMaxHoldPowerRank      = dngr.holdPowerRank
			thisTeam.mapMaxHoldPowerRankIndex = thisIndex
		end
		--- end of mapMaxHoldPowerRank
		--- maxANT ---
		if (dngr.antIndex > thisTeam.mapMaxAntIndexCycle) then
		    thisTeam.mapMaxAntIndexCycle = dngr.antIndex
		end
		--- end of maxANT --
		DefaultTileReset() 
	end
	-- when last mapping part, grow cycle counter and send it to graphic part
	if (part == stepEndMapping) then
	    --mapSmallCycles = mapSmallCycles + mapTileUnitConstant   -- color of tile depends on this line
		--- decrease the mapMaxHoldedTile when the most occupied tile constant is not occupied
		if (thisTeam.mapMaxHoldedTile > thisTeam.mapMaxHoldedTileCycle) then
     		thisTeam.mapMaxHoldedTile = thisTeam.mapMaxHoldedTileCycle
		end
		--- the same with min/max index
		thisTeam.mapMaxAntIndex             = thisTeam.mapMaxAntIndexCycle
		thisTeam.mapMaxSafetyIndexTile      = thisTeam.mapMaxSafetyIndexTileCycle
     	thisTeam.mapMinSafetyIndexTile      = thisTeam.mapMinSafetyIndexTileCycle
		thisTeam.mapMinSafetyIndexTileIndex = thisTeam.mapMinSafetyIndexTileIndexCycle
        ----- send to globals - for testing only
	    _G.mapDa = mapDanger
        _G.teamInfo = teamInfo
		----- clearing values
	end
    antCounter    = antCounter + 1
end

-- end of utility
-- begin functions

function TimeCounter(n)
    local frameTime = n/30
	
    local hours	    = floor(frameTime/3600)
	if (hours > 0) then
		frameTime = frameTime - hours*3600 
	end
	
	local minutes  = floor(frameTime/60)
	if (minutes > 0) then
		frameTime = frameTime - minutes*60
	end

	local seconds  = floor(frameTime)
	
    local countedTime = {0,0,0}
	countedTime[1] = hours
	countedTime[2] = minutes
	countedTime[3] = seconds
    return countedTime
end

function GetIDofTile(posX,posZ,thisDivision,zdivs)
    local ID = 0
	ID = floor(posX/thisDivision)*zdivs + ceil(posZ/thisDivision)
	if (ID == 0) then spEcho("The position is not on map.") end
    return ID
end

function IsFarFromEdge(posX,posZ,dist)   --- controls if place is far (far = dist) from border of map
    --- start of settings
	local distance = dist or edgeDistance
    --- end of settings
	if  ((posX >= distance) and (posX <= (mapX - distance)) and (posZ >= distance) and posZ <= (mapZ-distance)) then
	    return true
	else
	    return false
	end
end

function FindOneBest(searchMode,lenghtOfBox,startX,startZ,team)
    local defaultTile = mapDefault[1]
	local chosenTile
	-- spEcho(startX .. " " .. startZ)	
	if (searchMode == "safePlaces") then
	    local safety = 0
		for k = 0 + mapHugeTileEdge, lenghtOfBox - 1 - mapHugeTileEdge do
			for l = 0 + mapHugeTileEdge, lenghtOfBox - 1 - mapHugeTileEdge do
			    local tileNumber = startX*(mapZdivs*lenghtOfBox)+k*mapZdivs+startZ*lenghtOfBox+l+1
				-- spEcho(tileNumber)
				local tile = mapDanger[team][tileNumber] or defaultTile
				if (tile.safetyIndex > safety) then
				    chosenTile = tileNumber
					safety = tile.safetyIndex
				end
				-- spEcho(tile.safetyIndex)
				--- here is bug, NOTcomming more then mapXdivs
				if (tileNumber % mapZdivs == 0) then  -- bugfix
				    break
				end
			end
		end
		return chosenTile
    end	
end

function SearchFirstBestTiles(searchMode,lenghtOfBox,numberOfResults,team)
    if (searchMode == "safePlaces") then
	    local defaultTile = mapDefault[1]
	    local bestOf = {}  -- unsorted list of best results
		local added = 0    -- how many places i have added		
		local side = teamInfo[team]  -- speedup acces
		local placesList = side.listOfSafePlaces  -- speedup acces
	    local iterX = floor((mapXdivs-1)/lenghtOfBox)
		local iterZ = floor((mapZdivs-1)/lenghtOfBox)
		
		for i = 0, iterX do
	        for j = 0, iterZ do
			    local localBest = FindOneBest(searchMode,lenghtOfBox,i,j,team)
				-- spEcho("-" .. localBest)
				bestOf[added+1] = localBest
                added = added + 1
			end
		end
		for round = 1, numberOfResults do
		    local safetyMax = 0
			local tileNummo = 1
			local choosenA = 1
		    for a = 0, added do
			    local talkedTile = mapDanger[team][bestOf[a]] or defaultTile
		        if (talkedTile.safetyIndex > safetyMax) then
				    tileNummo = bestOf[a]
					safetyMax = talkedTile.safetyIndex
					choosenA = a
				end	
			end
			placesList[round] = tileNummo
			bestOf[choosenA] = 0
			-- spEcho("best" .. round .. ": " .. tileNummo)
		end
		side.listOfSafePlacesCount = #placesList
		--- only for testing
    	_G.teamInfo  = teamInfo
	end
end

function GetDistance2D(firstX,firstZ,secondX,secondZ)  -- returns 2D distance of two places
    local result = sqrt((firstX-secondX)*(firstX-secondX) + (firstZ-secondZ)*(firstZ-secondZ))
	return result
end

function GetDistance2DSQ(firstX,firstZ,secondX,secondZ)  -- returns 2D distance of two places^2
    return (firstX-secondX)*(firstX-secondX) + (firstZ-secondZ)*(firstZ-secondZ)
end

function GetDistance3D(firstX,firstY,firstZ,secondX,secondZ,secondZ)  -- returns 3D distance of two places
    local result = sqrt((firstX-secondX)*(firstX-secondX) + (firstY-secondY)*(firstY-secondY) + (firstZ-secondZ)*(firstZ-secondZ))
	return result
end

function GetDistance3DSQ(firstX,firstY,firstZ,secondX,secondY,secondZ)  -- returns 3D distance of two places^2
	return (firstX-secondX)*(firstX-secondX) + (firstY-secondY)*(firstY-secondY) + (firstZ-secondZ)*(firstZ-secondZ)
end

function GetAngle(newTargetX,newTargetZ)
    local dist = GetDistance2D(0,0,newTargetX,newTargetZ)
	--if (dist == 0) then spEcho("no distance") end
	local alpha = asin(newTargetX/dist)  --- different representation of X and Z on sreen and in my mind (formation defs).. so not asin(-something)
	local beta  = acos(newTargetZ/dist)
	-- i tried the version with aTan, but it doesnt help much in speed
	local result
	if (alpha > 0) then 
		result = 2*PI - beta 
	else
		result = beta
	end
	-- spEcho(deg(result),deg(alpha),deg(beta))
	return result
end

function GetRotation(thisX,thisZ,targetX,targetZ,rotations)
    if (targetX == nil) then targetX = 1 targetZ = 1 end --- this for avoiding error when leader unit is killed in middle of procedure
    local newTargetX    = targetX - thisX
	local newTargetZ    = -targetZ + thisZ       --- different representation of X and Z on sreen and in my mind (formation defs)
	local movingAngle   = 2*PI/rotations
	local startingAngle = 0 - movingAngle/2
	local angle         = startingAngle + GetAngle(newTargetX,newTargetZ)
	local rot           = floor(angle/movingAngle)
	-- spEcho(deg(angle),rot,(rot%rotations) + 1,thisX,thisZ,targetX,targetZ,newTargetX,newTargetZ)
	return ((rot + rotations/2 + 1) % rotations) + 1 --- 1 for index 0
end

function GetHillyCoeficient(mainX,mainZ)
    local tileID        = GetIDofTile(mainX,mainZ,mapDivision,mapZdivs)
	local maxIndex      = mapXdivs * mapZdivs
	if ((tileID < 1) or (tileID > maxIndex)) then tileID = ceil(maxIndex/2) end   -- if tile is out of the map
	local currentHeight = mapNeutral[tileID].tileHeight
	local coeficient    = 0
	for i=1,8 do
	    local currentIndex = tileID + mapTilesAroundIndex[i]
		local diff = 0
		if ((currentIndex > 0) and (currentIndex <= maxIndex)) then
		    diff = abs(currentHeight - mapNeutral[currentIndex].tileHeight)
		end
		coeficient = coeficient + diff
    end	
	return coeficient/8
end

function GetPositionForAttack(currentPosX,currentPosZ,targetPosX,targetPosZ,distanceFromTarget)
    local xChange = currentPosX - targetPosX
	local zChange = -currentPosZ + targetPosZ
    local angle   = GetAngle(xChange,zChange) + PI/2
	local resultX = targetPosX + cos(angle)*distanceFromTarget -- this need to be completed, not rdy
	local resultZ = targetPosZ + sin(angle)*distanceFromTarget
	local resultY = spGetGroundHeight(resultX,resultZ)
    return abs(resultX),resultY,abs(resultZ)
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

-- commands
function BigMove(groupID,moveX,moveY,moveZ,pathType,formation,waiting,targetX,targetZ)
	--- pathType --- !! change the numbers into strings !!
	-- 0 -- default
	-- 1 -- formation only at the end
	
    --- param preparations ---
	local thisGroup         = groupInfo[groupID]
	local thisFormationDef  = formationDef[formation]
	local membersLimit      = thisGroup.membersListMax
	local whatIsCalledHilly = thisFormationDef.hilly
	local isFirst           = true
	local flatLand          = true
    local rotation
    local thisFormationPos

	local secondaryMoveX, secondaryMoveY, secondaryMoveZ
	--- use parameter setting default formation setting
	if (waiting == nil) then  
	    waiting             = thisFormationDef.constrained
	end
	--- getting position of group
    local unitPosX,unitPosY,unitPosZ = GetPositionOfGroup(groupID,membersLimit)

	--- has this unit rotable formation? ---
	if (thisFormationDef.rotable) then
	
		-- use leaders rotation
	    if (thisGroup.dependant) then
			rotation	= groupInfo[thisGroup.itsLeaderID].rotation
		-- or choose own
		else
			local distance = GetDistance2D(unitPosX,unitPosZ,moveX,moveZ)
			if (targetX == nil) then
				if (distance > thisFormationDef.rotationCheckDistance) then 
					targetX            = moveX - (unitPosX - moveX)
					targetZ            = moveZ - (unitPosZ - moveZ)
					rotation           = GetRotation(moveX,moveZ,targetX,targetZ,thisFormationDef.rotations) 
					thisGroup.rotation = rotation
				else   --- keep old rotation
					rotation = thisGroup.rotation
				end
			else  --- so if target is specified
				rotation = GetRotation(moveX,moveZ,targetX,targetZ,thisFormationDef.rotations) 
				thisGroup.rotation = rotation
			end	
		end
		thisFormationPos = formationsRotated[formation][rotation]
		--spEcho(rotation)
	else
	    thisFormationPos = formations[formation]
	end 
	--- end of param preparations ---
	
	for i=1, membersLimit do
	    --spEcho(i,formation,thisGroup.groupED)
	    unitID = thisGroup.membersList[i]
		-- local scaleX = thisFormationDef.scales[1]  -- scaling in definition now 
		-- local scaleZ = thisFormationDef.scales[2]
		local formationX = thisFormationPos[i][1]  ---- * scaleX
		local formationZ = thisFormationPos[i][2]  ---- * scaleZ          --- scaling added in definition now
		if (thisGroup.membersListAlive[i]) then
		    --spEcho(i,thisGroup.membersListAlive[i])
			if (isFirst) then -- commanding leader of unit
			
			    --- behaviour of waiting for other units, when first run fast... (dependable on formation)
				if (waiting and thisFormationDef.constrained) then 
					if (thisGroup.constrainLevel >= 1 and thisGroup.moveModeChanged) then    --- second unit of group is far a lot and is alive, then
					    spGiveOrderToUnit(unitID, CMD.STOP, {}, {})
						thisGroup.constrainLevel = thisGroup.constrainLevel - 1
					else
						spGiveOrderToUnit(unitID, CMD.MOVE, {moveX + formationX, moveY, moveZ + formationZ}, {})
					end
				else
				    spGiveOrderToUnit(unitID, CMD.MOVE, {moveX + formationX, moveY, moveZ + formationZ}, {})
				end
				isFirst = false

				--- setting behaviour of reamining units depening on height situation around commanding unit
				local coef = GetHillyCoeficient(unitPosX,unitPosZ)
				if (coef >= whatIsCalledHilly) then
					flatLand = false
				else
				    flatLand = true
				end
			else  -- commanding remaining units
			    if (flatLand and (pathType ~= 1)) then -- this means units can use better, relative formation, becouse terrian around is not hilly
					spGiveOrderToUnit(unitID, CMD.MOVE, {unitPosX + formationX, unitPosY, unitPosZ + formationZ}, {})
					thisGroup.moveModeChanged = true
				else
				    spGiveOrderToUnit(unitID, CMD.MOVE, {moveX + formationX, moveY, moveZ + formationZ}, {})
					if (thisFormationDef.constrained) then
						if (thisGroup.constrainLevel <= thisFormationDef.constrainLevel) then
							thisGroup.constrainLevel = thisGroup.constrainLevel + 1
						end
					end
					thisGroup.moveModeChanged = false
				end
			end
		end -- end of unit alive
	end
end
-- end of commands

------CTRL VARIABLES FUNCTIONS ----------------

local function SetSafePlaces(team)
    -- = if number of safe places in listOfSafePlaces is 1 or less, it fill it up
	--old: if (#listOfSafePlaces <= 1) then
	    SearchFirstBestTiles("safePlaces",mapHugeTile,10,team)
	--end
end

local function SetThreat()
-- currentHP/maxHP
-- 
end

local function SetResEnergy(teamNumber)
    local thisTeam = teamInfo[teamNumber]	     
	local levelEnergy,storageEnergy,_,incomeEnergy,expenseEnergy = spGetTeamResources(thisTeam.teamID,"energy")       
	thisTeam.energyLevel   = levelEnergy
	thisTeam.energyStorage = storageEnergy
	thisTeam.energyIncome  = incomeEnergy
	thisTeam.energyExpense = expenseEnergy
end

local function SetResMetal(teamNumber)
    local thisTeam = teamInfo[teamNumber]
    local levelMetal,storageMetal,_,incomeMetal,expenseMetal = spGetTeamResources(thisTeam.teamID,"metal") 
	thisTeam.metalLevel    = levelMetal
	thisTeam.metalStorage  = storageMetal
	thisTeam.metalIncome   = incomeMetal
	thisTeam.metalExpense  = expenseMetal	
end

-- get info functions
-- neutral
local function GiveRandomPlaceInTile(someX,someZ,addRandom,border)
    if (addRandom) then
		someX = someX + math.random(border,mapDivision-border)
		someZ = someZ + math.random(border,mapDivision-border)
	else
	    someX = someX + mapDivision/2
		someZ = someZ + mapDivision/2
	end
	local place = {["x"]=someX,["z"]=someZ,}
	return place
end

-- specific

local function GetOneSafePlace(team,addRandom,border)
    local tileNummo = teamInfo[team].listOfSafePlaces[1]
	-- spEcho(tileNummo)
	-- old code below
	--if (#listOfSafePlaces > 1) then   -- if last position, dont delete it
	    --table.remove(listOfSafePlaces, #listOfSafePlaces)
	--end
	
	--- here can be added function for that - GiveRandomPlaceInTile
	local someX = mapDanger[team][tileNummo].cornerX
	local someZ = mapDanger[team][tileNummo].cornerZ
	-- spEcho(someX) spEcho(someZ)
	local place = GiveRandomPlaceInTile(someX,someZ,addRandom,border)
    return place
end

-- end of get info functions
-- end ai functions
--------------------------------------------------------------------------------------
-- begin MASTERMIND

---- set ctrl variables for next iteration
local function GlobalVarSet()
    --spEcho("Setting global ctrl vars")
	for i=1,numberOfNoeAITeams do
	    local thisTeamID = teamInfo[i].teamID
		---- check count
	    local count      = spGetTeamUnitCount(thisTeamID)
		if (count == 0) then
		    Spring.KillTeam(thisTeamID)
		end
		
		---- set resources
		SetResEnergy(i);
        SetResMetal(i);
	end
    --SetSafePlaces(team)  --- set off becouse speed issues on superbig maps
---- SetThreat();
---- SetAlert();
---- SetCasusBelli();
end

local function CtrlVarSet(army,team)
    spEcho("Setting ctrl vars for army", army)
end

---- -- end of setting ctrl variables
---- -- prepare/execute plan options for all levels plans

local function RunSpirits(part,partcount,mode)
    for i=part+1,#groupInfo,partcount do
		-- if we are commanding this army no. "part", command this unit
		local groupSpiritName	= groupInfo[i].spirit
		local notSleeping		= not(groupInfo[i].sleeping)
		local notSleeper		= groupInfo[i].notSleeper
		local active			= groupInfo[i].active
		local teamNumber		= groupInfo[i].teamNumber
		if ((notSleeping or notSleeper) and active) then
		    --spEcho(i,"begins")
		    spiritDef[groupSpiritName](i,teamNumber,mode)
			--spEcho(i,"ends")
		end
	end
end

local function EventHandler(eventStep)
    for i=1,#events do	
		local unpack = unpack
	    local thisEvent = events[i]
		
		--- if active, look at it :)
		if (thisEvent.active and ((not thisEvent.slow) or ((i%60) == eventStep))) then
		    --- condition check ---
			local listOfConditions   = thisEvent.conditionsNames
			local listOfCondParams   = thisEvent.conditionsParams
			local conditionFulfilled = false
			for j=1,#listOfConditions do
				if (condition[listOfConditions[j]] ~= nil) then 
					conditionFulfilled = condition[listOfConditions[j]](unpack(listOfCondParams[j])) 
					if (not conditionFulfilled) then break end
				else
					Spring.Echo("NOE EVENT HANDLER: Not defined condition is used.")
				end
			end
			if (conditionFulfilled) then
			    --- now do the action dude ---
				local listOfActions   = thisEvent.actionsNames
				local listOfActParams = thisEvent.actionsParams
				for j=1,#listOfActions do
					if (action[listOfActions[j]] ~= nil) then 
						local result = action[listOfActions[j]](unpack(listOfActParams[j]))
						if (not result) then Spring.Echo("something wrong with action") end
					else
						Spring.Echo("NOE EVENT HANDLER: Not defined action is used.")
					end
				end
				
				-- if it was not repeating event, set the event inactive
				if (not thisEvent.repeating) then
					events[i].active = false
				end
			end
		end
		--Spring.Echo("tried event ",i)
	end
end

---- -- end of prepare/execute plan or change plan
---- 
-- end MASTERMIND
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-- subevents
local function NewUnitComming(unitID, unitDefID, unitTeam, builderID)
	local name 			= UnitDefs[unitDefID].name
	local currentTeam 	= "t" .. unitTeam
	local teamNumber 	= reverseAITeamID[currentTeam] or 0
	--spEcho(teamNumber)
	
	if ((teamNumber ~= 0)) then   -- = if (its NOE AI)
	
		-- THE MAIN TASK - ADD THE UNIT TO TABLES --
		TestBeforeAddUnit(unitID,name,teamNumber) -- this do the test and adding at the same time
		
		-- COUNTER UPDATE --
		-- this is done inside the "TestBeforeAddUnit"
    end
	
	--- if enemy valuable, add it into list
	local valuable = valuableUnits[fromIDToNameTable[unitDefID]].valuable
    for i=1,numberOfNoeAITeams do
	    if (i ~= teamNumber) then
		    local notAllied = not(spAreTeamsAllied(unitTeam,teamInfo[i].teamID))
		    if (valuable and notAllied) then 
			    local valuableClass = valuableUnits[fromIDToNameTable[unitDefID]].class
			    AddValuableEnemy(unitID,i,unitTeam,valuableClass)
				--Spring.Echo("Valuable enemy unit added: " .. unitID,i,teamNumber,unitTeam)
			end
		end
	end
	
	if (playMission) then MissionNewUnitComming(unitID, unitDefID, unitTeam) end
	--- ! here add: if it is building, add to buildMap mention, that on this position unit is possible to be build
end

local function UnitLost(unitID, unitDefID, unitTeam)
    local name 			= UnitDefs[unitDefID].name
	local currentTeam 	= "t" .. unitTeam
	local teamNumber 	= reverseAITeamID[currentTeam] or 0
	if (teamNumber ~= 0) then   -- = if (its NOE AI)
		local groupID = reverseUnitsGroupID[unitID]
		if (groupID == nil) then
		    -- Spring.Echo("Killing unit that was not part of any group")
		else
			-- THE MAIN TASK - KILL THE UNIT FROM TABLES --
		    KillUnit(unitID,teamNumber,groupID)
			
			-- COUNTER UPDATE --
		    teamInfo[teamNumber].unitTypeCount[name].count   	= teamInfo[teamNumber].unitTypeCount[name].count - 1
		    teamInfo[teamNumber].unitTypeCount[name].percent 	= teamInfo[teamNumber].unitTypeCount[name].count / teamInfo[teamNumber].unitTypeCount[name].limit
		end
		--KillDef(unitID,unitTeam) -- function for adding spirit back into list is in KillDef()
	end
	
	local valuable = valuableUnits[fromIDToNameTable[unitDefID]].valuable
    
	for i=1,numberOfNoeAITeams do
	    if (i ~= teamNumber) then
		    local notAllied = not(spAreTeamsAllied(unitTeam,teamInfo[i].teamID))
		    if (valuable and notAllied) then 
			    KillValuableEnemy(unitID,i)
				--Spring.Echo("Valuable enemy unit killed: " .. unitID,i,teamNumber,unitTeam)
			end
		end
	end
	
	if (playMission) then MissionUnitLost(unitID, unitDefID, unitTeam) end
	-- ! here should be implemeted buildings death checking for resuing build spots of death buildings
end

function UpdateOrders(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
	local groupID = reverseUnitsGroupID[factID]
	if (groupID == nil) then
		-- Spring.Echo("Killing unit that was not part of any group")
	else
		local thisGroup 	= groupInfo[groupID]
		if (thisGroup.factory) then
			groupInfo[groupID].waitingOrders = groupInfo[groupID].waitingOrders - 1
		end
		if (groupInfo[groupID].waitingOrders == 0) then
			groupInfo[groupID].buildStatus = "idle"
		end
	end
end

function AddOrders()
end
---------------------------
---------------------------
---- maybe i will merge the code of UnitCreated and UnitDestroyed, big parts are similar and may cause bugs
-- events
function gadget:UnitIdle(unitID, unitDefID, unitTeam)
    local name 			= UnitDefs[unitDefID].name
	local currentTeam 	= "t" .. unitTeam
	local teamNumber 	= reverseAITeamID[currentTeam] or 0
	if (teamNumber ~= 0) then   -- = if (its NOE AI)
	    local groupID   = reverseUnitsGroupID[unitID]
		local thisGroup = groupInfo[groupID]
		if (thisGroup ~= nil) then
			thisGroup.status      = "idle"
			thisGroup.buildStatus = "idle"
			thisGroup.fightStatus = "idle"
		end
	end
	if (playMission) then MissionUnitIdle(unitID, unitDefID, unitTeam) end
end

-- created/given/captured
function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    NewUnitComming(unitID, unitDefID, unitTeam, builderID)
	if (playMission) then MissionUnitCreated(unitID, unitDefID, unitTeam, builderID) end
end

function gadget:UnitGiven(unitID, unitDefID, unitTeam)
    NewUnitComming(unitID, unitDefID, unitTeam)
	if (playMission) then MissionUnitGiven(unitID, unitDefID, unitTeam) end
end

function gadget:UnitCaptured(unitID, unitDefID, unitTeam)
    NewUnitComming(unitID, unitDefID, unitTeam)
	if (playMission) then MissionUnitCaptured(unitID, unitDefID, unitTeam) end
end

-- ! from factory and finished?
function gadget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
	UpdateOrders(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
	if (playMission) then MissionUnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders) end
end

-- destroyed/taken
function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	UnitLost(unitID, unitDefID, unitTeam)
	-- unit control:  
	local specialName = unitsUnderGreatEyeIDtoName[unitID]
	if (specialName ~= nil) then
	    unitsUnderGreatEyeNameToID[specialName].isAlive = false
	end
	if (playMission) then MissionUnitDestroyed(unitID, unitDefID, unitTeam) end
end

function gadget:UnitTaken(unitID, unitDefID, unitTeam)
	UnitLost(unitID, unitDefID, unitTeam)
	if (playMission) then MissionUnitTaken(unitID, unitDefID, unitTeam) end
end

function gadget:GameFrame(n)
    --- only time ---
    if ((n % 30) == 0) then
        realGameTime = TimeCounter(n)
		--Spring.Echo(realGameTime[1],realGameTime[2],realGameTime[3])
	end
	
    --- this split the work for AIs of many units to steps depends on executePartLenght number
    local part = n % step
	local mapSplitPart
	
	--- special case (game options)
	if (splitMapping) then
	    mapSplitPart = floor((n % (step * sideIDcount)) / step) + 1
	end
	--- special case end
	
	--- SPEEDABLE NOE STUFF (MAPPING + PLANS RUN) ---
    if     ((part >= stepBeginMapping) and (part <= stepEndMapping)) then  -- mapping from 1 to 8 default
		if (numberOfNoeAITeams > 0) then  -- if there is someone for which we map ;)
			if (splitMapping) then  -- if game options
				Mapping(part,mapSplitPart,splitMapping)
			else
				for team=1,sideIDcount do
					Mapping(part,team,splitMapping)
				end
			end
		end
	elseif (part == stepSetGlobals) then      -- its 9 now default
        GlobalVarSet()
    elseif ((part >= stepExecute) and part < (stepExecute + executePartLenght)) then         -- at 10 starts default
	    --CtrlVarSet(splitter,team)             -- set army ctrl variables
		RunSpirits(part-stepExecute,executePartLenght,"prepare")       -- prepare plans variables
		RunSpirits(part-stepExecute,executePartLenght,"execute")       -- execute chosen plans
	end
	--- END OF SPEEDABLE STUFF ---
	
	------- EVENT HANDLER -------------
	--- mostly only for missions
	
	EventHandler(n % 60)
	
	------- DIRECT ACCESS FOR MISSIONS ---------
	if (playMission) then MissionGameFrame(n) end
end

function gadget:Initialize()
    _G.off               = false
    local options        = spGetModOptions()
	numberOfNoeAITeams   = 0
	numberOfMissionAIs   = 0 
	numberOfOtherAITeams = 0
	local teamID         = 1   --- only FOR TEST
	teamList             = Spring.GetTeamList()
    local missionPath    = "missions/" .. missionName
	--- test settings file present ---
	if (missionName ~= "none") then
	    playMission        = true
		_G.playMission     = playMission
		_G.missionName     = missionName
	    local settingsPath = "missions/" .. missionName .. "/settings.lua"
		include (settingsPath)
		local gadgetsPath  = "missions/" .. missionName .. "/gadgets.lua"
		include (gadgetsPath)
		--- trying mission init ---
        if (playMission) then MissionInitialize() end
		---------------------------
		maximumOfMissionPlayers = missionInfo.maxPlayers
		if (missionInfo.AInames ~= nil) then
		    Spring.Echo("Loading Mission Settings")
		else
		    Spring.Echo("Attempt to play mission, settings file not found.")
		end
	end
	Spring.Echo("-- N.O.E. SETTINGS --")
	
	for i=1,#teamList do
		local id = teamList[i]
		local _,_,_,isAI,side = Spring.GetTeamInfo(id)
        
		-- Spring.Echo("Team" .. teamList[i] .. " is kind of " .. side .. " isAI? " .. tostring(isAI))
		---- adding AI
		if (isAI) then
			local aiInfo = Spring.GetTeamLuaAI(id)
			if (aiInfo == "N.O.E. - Easy") then
				numberOfNoeAITeams = numberOfNoeAITeams + 1
				AITeamID[numberOfNoeAITeams] = id
				aiOptions[numberOfNoeAITeams] = {
					["difficulty"] = "easy",
					["side"]       = side,
				}
			elseif (aiInfo == "N.O.E. - Normal") then
				numberOfNoeAITeams = numberOfNoeAITeams + 1
				AITeamID[numberOfNoeAITeams] = id
				aiOptions[numberOfNoeAITeams] = {
					["difficulty"] = "normal",
					["side"]       = side,
				}
			elseif (aiInfo == "N.O.E. - Hard") then
				numberOfNoeAITeams = numberOfNoeAITeams + 1
				AITeamID[numberOfNoeAITeams] = id
				aiOptions[numberOfNoeAITeams] = {
					["difficulty"] = "hard",
					["side"]       = side,
				}
			elseif (aiInfo == "Mission AI" or aiInfo == "BASE Team 1" or aiInfo == "BASE Team 2" or aiInfo == "WILDERNESS") then			
				numberOfNoeAITeams           = numberOfNoeAITeams + 1
				numberOfMissionAIs           = numberOfMissionAIs + 1
				AITeamID[numberOfNoeAITeams] = id
				local trueSide               = side
                if (missionName ~= "none") then
				    trueSide = missionInfo.AInames[numberOfMissionAIs]
                end
				-- just hot addition for OTE --
				if (missionName == "notAdota") then
				    trueSide = aiInfo
                end
				-- end --
				aiOptions[numberOfNoeAITeams] = {
					["difficulty"] = "special",
					["side"]       = trueSide, 
				}
				--- spawner info ---
			    teamNames[trueSide]        = id
				teamIDtoName[tostring(id)] = trueSide
			else
			    numberOfOtherAITeams = numberOfOtherAITeams + 1
			end
			
			if (aiInfo ~= "Mission AI") then
			    --- spawner info ---
				-- local numberOfNonMissionAITeams = numberOfNoeAITeams - numberOfMissionAIs + numberOfOtherAITeams
				-- local playerName = "ai" .. numberOfNonMissionAITeams
				--------------------------------------------------
				missionPlayersCount = missionPlayersCount + 1
				local playerName = "player" .. missionPlayersCount
			    teamNames[playerName]      = id
				teamIDtoName[tostring(id)] = playerName
			end
		else
		    --- spawner info ---
			if (gaiaID == id) then
			    local playerName = "gaia"
				teamNames[playerName]      = id
				teamIDtoName[tostring(id)] = playerName
			else
				missionPlayersCount = missionPlayersCount + 1
				local playerName = "player" .. missionPlayersCount
				teamNames[playerName]      = id
				teamIDtoName[tostring(id)] = playerName
			end
		end
	end
	_G.numberOfAIs = numberOfNoeAITeams
	
	--- speeds of AI
	splitMapping        = Spring.GetModOptions().noe_many_ais_mapping or true
	mapSmallCycleLength = floor(mapXdivs * (Spring.GetModOptions().noe_mapping or 1))
	executePartLenght   = (Spring.GetModOptions().noe_thinking_split or 8) * numberOfNoeAITeams
	stepEndMapping      = stepBeginMapping + mapSmallCycleLength - 1 
    stepSetGlobals      = stepEndMapping + 1 
    stepExecute         = stepSetGlobals + 1 
	minimalStep         = stepExecute + executePartLenght
	step                = minimalStep + 1  -- pausing now 1 :) 
	timeStep            = 60/step
	mapXdivsStep        = floor(mapXdivs / mapSmallCycleLength)
	Spring.Echo("N.O.E. mapping step: " .. mapSmallCycleLength)
	Spring.Echo("N.O.E. executePartLenght: " .. executePartLenght)
    Spring.Echo("N.O.E. step: " .. step)

	--- framwork ON/OFF with no AI
	frameworkOFFwithoutAI = ToBool(Spring.GetModOptions().noeautooff or frameworkOFFwithoutAI)

	--- put off graphic interface
    if(options.startoptions ~= 'noe') then
        Spring.Echo("N.O.E. graphic debug: OFF")
		_G.off = true
	else
	    Spring.Echo("N.O.E. graphic debug: ON")
	end
	
	--- is AI ON?
	if (frameworkOFFwithoutAI and numberOfNoeAITeams == 0) then
	    Spring.Echo("Removing N.O.E.")
	    _G.off = true
        gadgetHandler:RemoveGadget()
	else
	    
		------- IF NOE IS ON, DO: --------
		include "LuaRules/Configs/noe/noe_side.lua"
		include "LuaRules/Configs/noe/noe_map.lua"
		include "LuaRules/Configs/noe/noe_diff.lua"
	    include "LuaRules/Configs/noe/noe_groups.lua"
		include "LuaRules/Configs/noe/noe_classes.lua"
		include "LuaRules/Configs/noe/noe_formations.lua"
		include "LuaRules/Configs/noe/noe_spirits.lua"
		include "LuaRules/Configs/noe/noe_spawn.lua"
		include "LuaRules/Configs/noe/noe_conditions.lua"
		include "LuaRules/Configs/noe/noe_events.lua"
		include "LuaRules/Configs/noe/noe_actions.lua"
		include "LuaRules/Configs/noe/noe_terraform.lua"
		include "LuaRules/Configs/noe/noe_tasks.lua" 
		include "LuaRules/Configs/noe/noe_module_loader.lua"
		-- other rules --
		include "LuaRules/Configs/noe/noe_rules.lua"
		
		--- IF mission, mission files are loaded ---
		if (playMission) then
		    Spring.Echo("We play mission: " .. missionName)
			
			-- COPY SETTINGS --
			local settingsPath = missionPath .. "/settings.lua"
			include (settingsPath)
			
			-- UPDATE all tables --
			UpdateTables(missionPath)
			-- SPECIAL INIT procedure (every possible editing on updated tables) --
			
			-- map terraformer editing --
			NewTerraformer()
			-- units spawn editing --
		    NewSpawner()   --- in mission file spawn.lua (function that can prepare some data for mission - like own mapping, positions for features etc.)			
		end
		
        --- preparing tables for each noe AI agent
		Spring.Echo("N.O.E. teams:")
		for i=1,numberOfNoeAITeams do
		        local ID         = AITeamID[i]
				local side       = aiOptions[i].side
				local difficulty = aiOptions[i].difficulty
		        -- create team statistics and map
				AddTeam(i,ID,side,difficulty)
				CreateDangerMap(i)
				-- appended only some infos
				local reverse = "t" .. ID
				reverseAITeamID[reverse] = i
				local aiInfo = Spring.GetTeamLuaAI(ID)
				--Spring.Echo("- NoeTeam: " .. teamList[i] .. " is kind of: " .. aiInfo)
				-----------------------------------------------------------------------------------------------------
				-- and reset all the team values depending on type of AI
				local thisTeam            = teamInfo[i]
				local thisSideGroupsList  = sideSettings[side].groups
				local numberOfGroups      = #thisSideGroupsList
				thisTeam.numberOfGroups   = numberOfGroups
				for j=1,numberOfGroups do
				    local groupName       = thisSideGroupsList[j]
				    local thisGroupDef    = groupDef[groupName]
					if (thisGroupDef == nil) then
    					Spring.Echo("!ERROR: This group is not defined correctly: " .. groupName .. " - check noe_side.lua and noe_groups.lua")
						teamInfo[i].numberOfGroups = teamInfo[i].numberOfGroups - 1
					else    
						--- get values from definition or add default values
						local groupSpirit		= thisGroupDef.spirit
						local groupID			= groupCount+1
						local groupUnitName		= thisGroupDef.unit
						local groupSourceName	= thisGroupDef.source
						local groupDependance	= thisGroupDef.dependance or false
						local groupLeaderName	= ""
						local groupDepPos		= thisGroupDef.depPos
						local groupPreference	= thisGroupDef.preference or {0,0,0,0,0,0,1}
						local bufferFactories	= thisGroupDef.factories
						local factory			= false
						local taskName			= thisGroupDef.taskName or "none"
						if (thisGroupDef.source == nil) then factory = true end
						if (groupDependance) then groupLeaderName = thisGroupDef.leader else groupLeaderName = "none" end
						AddDef(groupID,i,AITeamID[i],groupSpirit,groupName,groupDependance,groupLeaderName,factory,bufferFactories,groupDepPos,groupUnitName,groupSourceName,groupPreference,taskName)     --- create group
						thisTeam.listOfGroupsIDs[j]				= groupID		--- fill the spirits list
						thisTeam.listOfGroupsNames[j]			= groupName
						teamInfo[i].groupNameToID[groupName]	= j
						---- one more added...
						groupCount = groupCount + 1
					end
				end
				
				--Spring.Echo(sideSettings.core.groupsNames[1])
				------------------------------------------------------------------------------------------------------
		end
		--- mapHugeTile changer for big maps (bigger then 16x16)
		if ((mapXdivs/2 >= 16) and (mapXdivs == mapZdivs)) then
			mapHugeTile = floor(mapXdivs/4) + floor(mapXdivs/16)
		end
		
		Spring.Echo("Big tile: " .. mapHugeTile .. " (size of tile for searching algoritms)")
		
        --- reset classes values and making name <-> unitDefId tables	
		for i=1,#UnitDefs do
		    local unitName              = UnitDefs[i].name
		    fromIDToNameTable[i]        = unitName
			fromNameToIDTable[unitName] = i
			valuableUnits[unitName]     = {
			    ["valuable"] = false,
				["class"]    = "none",
			}
			-- Spring.Echo(i,UnitDefs[i].name)
		end
		--- LuaRules/Configs/noe/noe_classes.lua ---
		--- making list of valuable targets for checking if unit is/was valuable for enemy
		for	i=1,#classDefLists do
			local thisClass = classDefLists[i].class
			if (thisClass == "valuable") then
				local thisClassList = classDefLists[i].list
			    local thisClassName = classDefLists[i].name
				-- table for checks
				for j=1,#thisClassList do
					local nameInList = thisClassList[j]
					valuableUnits[nameInList] = {
						["valuable"] = true,
						["class"]    = thisClassName,
					}
				end
				-- table for static check
				isStaticTargetClass[thisClassName] = classDefLists[i].static
			end
		end
		--- end of classes
		--- special types list making 
		---- mexes ids list to choose from when building
		for i=1,numberOfNoeAITeams do
		    local thisTeam         = teamInfo[i]
			local thisKeyUnitsList = sideSettings[thisTeam.kind].basicTools
			local thisKeyUnitIDs   = thisTeam.keyUnitIDs
			for j=1,#thisKeyUnitsList do
			    thisKeyUnitIDs[thisKeyUnitsList[j].toolPurpose] = fromNameToIDTable[thisKeyUnitsList[j].unitName]
			end
			-- depreciated code using class defs for the same purpose -- 
			-- for j=1,#classDefLists do
				-- local thisClass = classDefLists[j].class
				-- local thisSide  = classDefLists[j].side
				-- if (thisClass == "mexes" and (thisSide == thisTeam.kind)) then
					-- local thisClassWater = classDefLists[j].water
					-- local thisClassList  = classDefLists[j].list
					-- local idsGroundList  = thisTeam.listOfGroundMexesTypesIDs
					-- local idsWaterList   = thisTeam.listOfWaterMexesTypesIDs
					-- for k=1,#thisClassList do
						-- if (thisClassWater) then
							-- idsWaterList[#idsWaterList + 1]   = fromNameToIDTable[thisClassList[k]]
						-- else
							-- idsGroundList[#idsGroundList + 1] = fromNameToIDTable[thisClassList[k]]
						-- end
						-- spEcho(thisClassList[k],fromNameToIDTable[thisClassList[k]])
					-- end
					-- spEcho("--")
				-- end
			-- end
		end
		--- end of special types list making
		
		--- reset values for all groups
		Spring.Echo("N.O.E. tactical groups (agents): ")
		--- LuaRules/Configs/noe/noe_formations.lua ---
		--- LuaRules/Configs/noe/noe_spirits.lua  ---
		for i=1,groupCount do		    
            local thisGroup          = groupInfo[i]
			local limit              = 0
			local groupLimit         = groupDef[thisGroup.name].size or 1
			thisGroup.transferCount  = groupDef[thisGroup.name].transfer or 1
			thisGroup.formation      = formationBySpirit[thisGroup.spirit] or "hexagon"
			local formationLimit     = formationDef[thisGroup.formation].limit
			---- limits ----
			if (formationLimit >= groupLimit) then      ---- set the limit, formation should be bigger, BUT...
                limit = groupLimit
            else 
			    limit = formationLimit
            end
			
			thisGroup.membersListMax = limit
			if (thisGroup.formation == "noForm") then thisGroup.membersListMax = groupLimit end   -- stay at group limit number

			for j=1,limit do
			    thisGroup.membersListAlive[j] = false
			end
			---- dependance --- (dependant groups gets the info about groupID of their leader)
			if (thisGroup.dependant) then
			    local thisTeamGroupsListNames = teamInfo[thisGroup.teamNumber].listOfGroupsNames
			    for j=1,#thisTeamGroupsListNames do
				    if (thisTeamGroupsListNames[j] == thisGroup.itsLeaderName) then
					    thisGroup.itsLeaderID = teamInfo[thisGroup.teamNumber].listOfGroupsIDs[j]
						break
					end
				end
			end
			--- range --
			local unitName       = fromNameToIDTable[thisGroup.unitName]
			if (unitName ~= nil) then
			    local thisUnitDefWeapons = UnitDefs[unitName].weapons
				local weapon             
				if (thisUnitDefWeapons[1] ~= nil) then
				    weapon = thisUnitDefWeapons[1].weaponDef 
					if (weapon ~= nil) then
						local range     = WeaponDefs[weapon]["range"]
						thisGroup.range = range
				    end
				else
				    if (UnitDefs[unitName].isBuilder) then
						local range     = UnitDefs[unitName].buildDistance
					    thisGroup.range = range
					else
					    -- nothing yet
					end
				end
			end
			--- status ---
			local groupStatus = groupDef[thisGroup.name].status or {0,0,0,1}
			for j=1,#groupStatus do
			    thisGroup.operationalStatusLimits[j] = groupStatus[j]
			end
			--- classes ---
			local thisGroupClasses = groupDef[thisGroup.name].targetClasses or {}
			for j=1,#thisGroupClasses do
			    thisGroup.targetClasses[j] = thisGroupClasses[j]
			end
			--- write info --- 
			Spring.Echo(thisGroup.teamID .. " (".. thisGroup.groupED .. ") " .. thisGroup.name .. " " .. thisGroup.spirit .. " " .. thisGroup.formation .. " " .. thisGroup.membersListMax .. " " .. thisGroup.unitName .. " dependant: " .. tostring(thisGroup.dependant) .. " " .. thisGroup.itsLeaderName .. "(" .. thisGroup.itsLeaderID .. ") " .. thisGroup.taskName)
		end
		--- START OF SPECIAL GROUPS SETTINGS ---
		-- create buildlists data structure and unitTypes --
		for i=1,groupCount do
		    local source      = groupInfo[i].sourceName or "main"
			local unitType    = groupInfo[i].unitName
			local thereSource = false
			local thereUnit   = false
			for j=1,#sourcesList do
			    if (sourcesList[j] == source) then thereSource = true end
			end
			for j=1,#unitTypesList do
			    if (unitTypesList[j] == unitType) then thereUnit = true end
			end
			if (not thereSource) then 
			    sourcesList[#sourcesList+1] = source
			end
			if (not thereUnit) then 
			    unitTypesList[#unitTypesList+1] = unitType
			end
		end
		for i=1,numberOfNoeAITeams do
		    local thisTeam = teamInfo[i]
			for j=1,#sourcesList do
			    local factory     = "buildOrders".. sourcesList[j]
				thisTeam[factory] = {{},{},{},{},{},{},{}}   --- !! only for test, 7 levels now, the lenght automaticly created later
			end
			local thisList = thisTeam.unitTypeCount 
			for j=1,#unitTypesList do
			    thisList[unitTypesList[j]] = {
				    ["name"]    = unitTypesList[j],
					["count"]   = 0,
					["limit"]   = 0,
					["percent"] = 0,
				}
			end
		end
		
		-- buffers + OLD buildilists --
		for i=1,groupCount do
		    local thisGroup  = groupInfo[i]
			local thisSpirit = string.sub(thisGroup.spirit,-6)
		    if (thisSpirit == "Buffer") then
			    local thisBufferList = thisGroup.bufferGroupIDs
			    for j=1,groupCount do
				    local thisSecondGroup = groupInfo[j]
				    local thisTeam        = teamInfo[thisGroup.teamNumber]
					if ((thisSecondGroup.unitName == thisGroup.unitName) and (thisSecondGroup.teamID == thisGroup.teamID) and (thisSecondGroup.groupED ~= thisGroup.groupED)) then
					    thisBufferList[#thisBufferList+1] = thisSecondGroup.groupED
						local factory      = "buildOrders" .. thisSecondGroup.sourceName
						local listOfOrders = thisTeam[factory]
						local counter      = 0
						local thisPrefer   = thisSecondGroup.preference
						-- OLD buildlists creation
						for k=1,#thisPrefer do
						    local thisList = listOfOrders[k]
							local addCount = thisPrefer[k] - counter
							if (addCount > 0) then
								local position = #thisList+1
								thisList[position]    = {}
								thisList[position][1] = thisSecondGroup.unitName
								thisList[position][2] = addCount
								counter = counter + addCount	
							end
                            --Spring.Echo(thisList[position][1],thisList[position][2])							
						end
						--Spring.Echo(thisSecondGroup.name .. " is dependant on buffer " .. thisGroup.name)
					end
				end
			end
			-- OLD building buildlists completition --
		    local thisGroup  = groupInfo[i]
			if (thisGroup.spirit == "factory" or thisGroup.spirit == "building") then
			    local factory = "buildOrders" .. thisGroup.sourceName
				local thisTeam     = teamInfo[thisGroup.teamNumber]
				local listOfOrders = thisTeam[factory]
				local counter      = 0
				local thisPrefer   = thisGroup.preference
				for k=1,#thisPrefer do
					local thisList = listOfOrders[k]
					local addCount = thisPrefer[k] - counter
					if (addCount > 0) then
						local position = #thisList+1
						thisList[position]    = {}
						thisList[position][1] = thisGroup.unitName
						thisList[position][2] = addCount
						counter = counter + addCount	
					end						
				end
			end
		end
		-- unit type count limits --
		for i=1,numberOfNoeAITeams do
		    thisTeam = teamInfo[i]
			for j=1,#sourcesList do
			    local factory      = "buildOrders" .. sourcesList[j]
				local listOfOrders = thisTeam[factory]
			    for k=1,#listOfOrders do
				    local thisList = listOfOrders[k]
				    for l=1,#thisList do
					    local name  = thisList[l][1]
						local count = thisList[l][2]
						thisTeam.unitTypeCount[name]["limit"] = thisTeam.unitTypeCount[name]["limit"] + count
                    end					
				end
			end
		end
		BuffersDebug(false,groupCount,groupInfo,teamInfo,sourcesList,unitTypesList)   --- in noe_groups.lua
		-- buffers end --
		
		-- new factories init--
		initGroup.factoriesGroupsIDs()
		
		--- notSleeping brains and advancedBuffers ---
		initGroup.notSleeper("brain")
		initGroup.notSleeper("advancedBuffer")
		
		--- END OF SPECIAL GROUPS SETTINGS ---
		
		---- formation generation
		Generation() -- generation of all generated formations in noe_formations.lua
		---- formation rotation ----
        Rotation()   -- rotation of all rotating formations in noe_formations.lua
		--- end of preparing rotations ---
		FormationsDebug(false) --- write all formations positions (in noe_formations.lua)
		
		---- METAL MAP ---
		--- LuaRules/Configs/noe/noe_mex_finder.lua ---
		----
		PreparemapMetal()    --- count where all metal spots are
		----
		MetalMapDebug(false) --- write all metal spots positions
		_G.mapMetal = mapMetal
		_G.mapMetalCount = #mapMetal
		---- METAL MAP END ---
		
		---- BUILD MAP ---
		--- LuaRules/Configs/noe/noe_build_space_finder.lua ---
		----
		PreparemapBuildMap()    --- count where all metal spots are
		_G.mapBuild = mapBuild
		_G.mapBuildCount = #mapBuild
		---- BUILD MAP END ---
				
		if (playMission) then
			---- MAP TERRAFORMING ----
			MakeTerraform("public")
			---- MAP TERRAFORMING ENDS ----
		end
		
		
	end
	Spring.Echo("-- N.O.E. SETTINGS END --")
end

function gadget:GamePreload()
	if (string.find(Game.mapName,"notAmap")) then
		PreparemapMetal()
		_G.mapMetal = mapMetal
		_G.mapMetalCount = #mapMetal
		PreparemapBuildMap() 
		_G.mapBuild = mapBuild
		_G.mapBuildCount = #mapBuild
	end
end

function gadget:GameStart()
	if (playMission) then
	    --- spawn units ---
        Spawner(0)
		SetResources()
		MakeTerraform("secret")
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
else

-- END SYNCED
-- BEGIN UNSYNCED
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--[[
-- graphics
local circleDivs                       = 64 --64
local circleList
local glBeginEnd                       = gl.BeginEnd
local glBillboard                      = gl.Billboard
local glCallList                       = gl.CallList
local glColor                          = gl.Color
local glCreateList                     = gl.CreateList
local glDeleteList                     = gl.DeleteList
local glDrawGroundCircle               = gl.DrawGroundCircle
local glDrawGroundQuad                 = gl.DrawGroundQuad
local glLineWidth                      = gl.LineWidth
local glPopMatrix                      = gl.PopMatrix
local glPushMatrix                     = gl.PushMatrix
local glScale                          = gl.Scale
local glTranslate                      = gl.Translate
local glVertex                         = gl.Vertex
local GL_LINE_LOOP                     = GL.LINE_LOOP
local PI                               = math.pi

local mexRadius                        = Game.extractorRadius

teamStatsNumber                        = 1
--- 
local holdPower                        = false   -- is holdPower active
local holdZero                         = false   -- is zeroHold active
local present                          = false   -- is presentView active
local safeIndex                        = false   -- is safeIndexView active
local choosenTile                      = false   -- is choosenTileView active
local height                           = false   -- is heightView active
local mexSpots                         = false   -- is mexSpotsView active
local buildSpots                       = false   -- is buildSpotsView active
--- keyactivation-- 
local lastKey                          
local holdPowerKey                     = 100     -- this is D
local holdZeroKey                      = 101     -- this is E
local presentKey                       = 102     -- this is F
local safeIndexKey                     = 114     -- this is R
local choosenTileKey                   = 113     -- this is Q
local heightKey                        = 119     -- this is H
local mexSpotsKey                      = 109     -- this is M
local buildSpotsKey                    = 97      -- this is A
local rightMod                         = false
local modsKey                          = 308     -- 308 is leftALT, 306 leftctrl, 32 space

local team1Key                         = 257
local team2Key                         = 258
local team3Key                         = 259
local team4Key                         = 260

function drawSquare(x,z,transparency,color,size)
    local r,g,b
	if (color == "red") then
	    r,g,b = 1,0.35,0.35 
	elseif (color == "yellow") then
	    r,g,b = 1,1,0
	elseif (color == "green") then
	    r,g,b = 0,1,0	
	elseif (color == "purple") then
	    r,g,b = 0.75,0,0.75	
	else
	    r,g,b = 1,0.35,0.35
	end
	local side = size or SYNCED.mapDivision
    glColor(r, g, b, transparency)
    glDrawGroundQuad(x, z, x+side, z+side)
	    
	--glLineWidth(25)
    --glDrawGroundCircle(1500, 200, 1500, size, circleDivs)
    --glLineWidth(5)
    --glDrawGroundCircle(1600, 200, 1600, size, circleDivs)
	--glPushMatrix()
    --glBillboard ()
    --gl.Texture("bitmaps/gpl/point2.png")
    --gl.TexRect(-8, -8, 8, 8)
    --glPopMatrix()
end

local function drawPresent()
    local mapXdivs     = SYNCED.mapXdivs
	local mapZdivs     = SYNCED.mapZdivs
    local mapDanger    = SYNCED.mapDanger
	local mapDivision  = SYNCED.mapDivision
    for i=0,mapXdivs do
        for j=0,mapZdivs do
		    local nummo = i*mapZdivs+j+1
	        local color = "yellow"
			local transp
			if (mapDanger[teamStatsNumber][nummo].isHolded) then
				transp = 0.5
			else
				transp = 0
			end
			--- end of preparations, draw now
		    if (transp >= 0.1) then
     			drawSquare(i*mapDivision ,j*mapDivision,transp,color)
			end
		end
	end
end

local function drawHoldPower()
    local mapXdivs     = SYNCED.mapXdivs
	local mapZdivs     = SYNCED.mapZdivs
    local mapDanger    = SYNCED.mapDanger
	local teamInfo     = SYNCED.teamInfo
	local mapDivision  = SYNCED.mapDivision
    for i=0,mapXdivs do
        for j=0,mapZdivs do
		    local nummo = i*mapZdivs+j+1
		    local color = "red"
			local transp = mapDanger[teamStatsNumber][nummo].holdPower / teamInfo[teamStatsNumber].mapMaxHoldedTile
			--- endo of preparations, draw now
		    if (transp >= 0.1) then 
			    drawSquare(i*mapDivision ,j*mapDivision,transp,color)
			end
		end
	end
end

local function drawZeroHoldPower()
    local mapXdivs     = SYNCED.mapXdivs
	local mapZdivs     = SYNCED.mapZdivs
    local mapDanger    = SYNCED.mapDanger
	local teamInfo     = SYNCED.teamInfo
	local mapDivision  = SYNCED.mapDivision
    for i=0,mapXdivs do
        for j=0,mapZdivs do
		    local nummo = i*mapZdivs+j+1
		    local color = "green"
			local transp = mapDanger[teamStatsNumber][nummo].zeroHoldPower / teamInfo[teamStatsNumber].mapMaxZeroHoldTile
			--- endo of preparations, draw now
		    if (transp >= 0.1) then 
				drawSquare(i*mapDivision ,j*mapDivision,transp,color)
			end
		end
	end
end

local function drawSafeIndex()
    local mapXdivs     = SYNCED.mapXdivs
	local mapZdivs     = SYNCED.mapZdivs
    local mapDanger    = SYNCED.mapDanger
	local teamInfo     = SYNCED.teamInfo
	local mapDivision  = SYNCED.mapDivision
    for i=0,mapXdivs do
        for j=0,mapZdivs do
		    local nummo = i*mapZdivs+j+1
		    local color = "green"
			local transp = mapDanger[teamStatsNumber][nummo].safetyIndex / teamInfo[teamStatsNumber].mapMaxSafetyIndexTile
			--- endo of preparations, draw now
		    --if (transp >= 0.1) then 
			    drawSquare(i*mapDivision ,j*mapDivision,transp,color)
			--end
		end
	end
end

local function drawHeight()
    local mapXdivs     = SYNCED.mapXdivs
	local mapZdivs     = SYNCED.mapZdivs
	local neutralMap   = SYNCED.mapNeutral
	local mapDivision  = SYNCED.mapDivision
	local mapMaxHeight = SYNCED.mapMaxHeight
    for i=0,mapXdivs do
        for j=0,mapZdivs do
		    local nummo = i*mapZdivs+j+1
		    local color = "red"
			local transp = neutralMap[nummo].tileHeight / mapMaxHeight
			--- endo of preparations, draw now
		    if (transp >= 0.1) then 
			    drawSquare(i*mapDivision ,j*mapDivision,transp,color)
			end
		end
	end
end

local function drawMexes()
    local mapMetal      = SYNCED.mapMetal
	local mapMetalCount = SYNCED.mapMetalCount
	local mapZdivs      = SYNCED.mapZdivs
    local size          = mexRadius
	local halfSize      = size/2
    for i=1,mapMetalCount do
        local color = "purple"
		--- endo of preparations, draw now
		drawSquare(mapMetal[i].posX - halfSize,mapMetal[i].posZ - halfSize,0.8,color,mexRadius)
	end
end

local function drawBuildSpots()
    local mapBuild      = SYNCED.mapBuild 
	local mapBuildCount = SYNCED.mapBuildCount
	local mapZdivs      = SYNCED.mapZdivs
    local tileSize      = 50         --- ! only local, should tied with global value
    for i=1,mapBuildCount do
	    thisMapBuild = mapBuild[i]
	    if (thisMapBuild.groundBuild) then
		    local color = "purple"
			local limit = 200        --- ! only local, should tied with global value
            if (thisMapBuild.groundRating <= limit) then			
				--- endo of preparations, draw now
				local transp = 1 - (thisMapBuild.groundRating/limit)
				drawSquare(thisMapBuild.posX,thisMapBuild.posZ,transp,color,tileSize)  
			end
		end
		if (thisMapBuild.waterBuild) then
		    local color = "yellow"                    
			--- endo of preparations, draw now
			drawSquare(thisMapBuild.posX,thisMapBuild.posZ,0.8,color,tileSize)  
		end
		if (thisMapBuild.geoBuild) then
		    local color = "green"                    
			--- endo of preparations, draw now
			drawSquare(thisMapBuild.posX,thisMapBuild.posZ,0.8,color,tileSize)  
		end
	end
end

local function drawChoosenTiles()
    local teamInfo  = SYNCED.teamInfo
	local mapDanger = SYNCED.mapDanger
    local transp = 1
    for i = 1, teamInfo[teamStatsNumber].listOfSafePlacesCount do
	    local color = "yellow"
		local tilePrint = mapDanger[teamStatsNumber][teamInfo[teamStatsNumber].listOfSafePlaces[i] ]
		-- endo of preparations, draw now
		drawSquare(tilePrint.cornerX,tilePrint.cornerZ,transp,color)
		transp = transp - (transp/teamInfo[teamStatsNumber].listOfSafePlacesCount)
    end
end

function gadget:KeyPress(key, mods, isRepeat)
    --if (key == holdPowerKey) then
	--end
	if (key == modsKey) then
	    rightMod = true
	end
	--Spring.Echo(key)
end

function gadget:KeyRelease(key)
    if ((key == presentKey) and (rightMod == true)) then 
	    if (present == true) then
		    present = false
		else
		    present = true
		end
		rightMod = false
	elseif ((key == holdPowerKey) and (rightMod == true)) then
	    if (holdPower == true) then
		    holdPower = false
		else
		    holdPower = true
		end
		rightMod = false
	elseif ((key == holdZeroKey) and (rightMod == true)) then
	    if (holdZero == true) then
		    holdZero = false
		else
		    holdZero = true
		end
		rightMod = false
	elseif ((key == safeIndexKey) and (rightMod == true)) then
	    if (safeIndex == true) then
		    safeIndex = false
		else
		    safeIndex = true
		end
		rightMod = false
	elseif ((key == heightKey) and (rightMod == true)) then
	    if (height == true) then
		    height = false
		else
		    height = true
		end
		rightMod = false
	elseif ((key == mexSpotsKey) and (rightMod == true)) then
	    if (mexSpots == true) then
		    mexSpots = false
		else
		    mexSpots = true
		end
		rightMod = false
	elseif ((key == buildSpotsKey) and (rightMod == true)) then
	    if (buildSpots == true) then
		    buildSpots = false
		else
		    buildSpots = true
		end
		rightMod = false		
	elseif ((key == choosenTileKey) and (rightMod == true)) then
	    if (choosenTile == true) then
		    choosenTile = false
		else
		    choosenTile = true
		end
		rightMod = false	
	elseif ((key == team1Key) and (rightMod == true)) then
	    teamStatsNumber = 1
		rightMod = false
	elseif ((key == team2Key) and (rightMod == true)) then
	    teamStatsNumber = 2
		rightMod = false
	elseif ((key == team3Key) and (rightMod == true)) then
	    teamStatsNumber = 3
		rightMod = false
	elseif ((key == team4Key) and (rightMod == true)) then
	    teamStatsNumber = 4
		rightMod = false		
	end
end

function gadget:DrawWorld()
    -- if (groupInfo[1] ~= nil) then
	--    local bx, by, bz  = spGetUnitPosition(groupInfo[1].unitED)
	--	drawSquare(bx,bz,1)	
	-- end
	numberOfAIs = SYNCED.numberOfAIs or 0
	if (teamStatsNumber > numberOfAIs) then
	    return
	end
	
	if (present == true) then
	    drawPresent()                  --- draw isHolded map statistic
	elseif (holdPower == true) then
        drawHoldPower()                --- draw holdPower map statistic
	elseif (holdZero == true) then
	    drawZeroHoldPower()            --- draw zeroHoldPower map statistic 
	elseif (safeIndex == true) then
	    drawSafeIndex()                --- draw drawSafeIndex map statistic ... safe places	
	elseif (height == true) then
	    drawHeight()                   --- draw height of map
	elseif (mexSpots == true) then
	    drawMexes()                    --- draw mex spots map
	elseif (buildSpots == true) then
	    drawBuildSpots()               --- draw build spots map
	elseif (choosenTile == true) then
	    drawChoosenTiles()             --- draw choosen tiles (changable)		
	end
	
	if (SYNCED.playMission) then
		if (MissionStats) then
			MissionStats()
		end
	end
end

function gadget:Initialize()
    if (SYNCED.off) then
	    Spring.Echo("Removing NOE Drawing")
        gadgetHandler:RemoveGadget()
	end
	if (SYNCED.playMission) then
	    local gadgetsPath  = "missions/" .. SYNCED.missionName .. "/gui.lua"
		include(gadgetsPath)
	end
end

]]
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end
-- END UNSYNCED
--------------------------------------------------------------------------------
