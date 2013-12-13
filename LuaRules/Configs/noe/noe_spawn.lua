-------------------------------------
----- NOE spawn groups library ------
-------------------------------------

-- class "single" - one unit, no need for posX,Z
-- only examples now

local spCreateFeature                  = Spring.CreateFeature
local spCreateUnit                     = Spring.CreateUnit
local spGetGroundHeight                = Spring.GetGroundHeight

--------------------------------------------------------------------
-- LIBRARY DEFINED SINGLE UNITS or BUILDINGS or SETS OF BUILDINGS --
--------------------------------------------------------------------

spawnDef = {
    -- single unit --
    ["peewee"] = {unit = "armpw", class = "single"},
	-- buildingsSet with own formation and own names --
	["corDefencePoint"] = {
	    class = "buildingsSet",
		list  = {
		    -- main big gun oh yea!
		    {unit = "cortoast", relX = 0, relZ = 0, class = "single"},
			-- two heavy lasers for killing hard stuff
			{unit = "corvipe", relX = 100, relZ = 40, class = "single"},
			{unit = "corvipe", relX = -100, relZ = 40, class = "single"},
			-- three llts for scums
			{name = "corLltDragged", relX = 240, relZ = 0, class = "buildingsSet"},
			{name = "corLltDragged", relX = -240, relZ = 0, class = "buildingsSet"},
			{name = "corLltDragged", relX = 0, relZ = 200, class = "buildingsSet"},
			-- two expensive and three cheap peaces of AA defence
			{unit = "corrl", relX = 100, relZ = -120, class = "single"},
			{unit = "corrl", relX = -100, relZ = -120, class = "single"},
			{unit = "dca", relX = 160, relZ = 120, class = "single"},
			{unit = "dca", relX = -160, relZ = 120, class = "single"},
			{unit = "dca", relX = -320, relZ = -40, class = "single"},
			{unit = "dca", relX = 320, relZ = -40, class = "single"},
			-- one test wall --
			--{name = "corFullWall-H-200", relX = 0, relZ = 300, class = "buildingsSet"},
		}, 
	},
	["corLltDragged"] = {
	    class = "buildingsSet",
		list  = {
			-- llt + drags around
			{unit = "corllt", relX = 0, relZ = 0, class = "single"},
			{unit = "cordrag", relX = -10, relZ = 30, class = "single"},
			{unit = "cordrag", relX = 10, relZ = 30, class = "single"},
			{unit = "cordrag", relX = -30, relZ = 10, class = "single"},
			{unit = "cordrag", relX = -30, relZ = -10, class = "single"},
			{unit = "cordrag", relX = 30, relZ = 10, class = "single"},
			{unit = "cordrag", relX = 30, relZ = -10, class = "single"},
			{unit = "cordrag", relX = -10, relZ = -30, class = "single"},
			{unit = "cordrag", relX = 10, relZ = -30, class = "single"},
		}, 
	},
	["armLltDragged"] = {
	    class = "buildingsSet",
		list  = {
			-- llt + drags around
			{unit = "armllt", relX = 0, relZ = 0, class = "single"},
			{unit = "armdrag", relX = -10, relZ = 30, class = "single"},
			{unit = "armdrag", relX = 10, relZ = 30, class = "single"},
			{unit = "armdrag", relX = -30, relZ = 10, class = "single"},
			{unit = "armdrag", relX = -30, relZ = -10, class = "single"},
			{unit = "armdrag", relX = 30, relZ = 10, class = "single"},
			{unit = "armdrag", relX = 30, relZ = -10, class = "single"},
			{unit = "armdrag", relX = -10, relZ = -30, class = "single"},
			{unit = "armdrag", relX = 10, relZ = -30, class = "single"},
		}, 
	},
    ["armMGAA3x"] = {
	    class = "buildingsSet",
		list  = {
			-- 3 AA machine guns
			{unit = "armcrach", relX = 0, relZ = 400, class = "single"},
			{unit = "armcrach", relX = -300, relZ = -200, class = "single"},
			{unit = "armcrach", relX = 300, relZ = -200, class = "single"},
		}, 
	},
	["corFullWall-H-200"] = {
	    class = "buildingsSet",
		list  = {
			-- horizontal wall 10 teeth
			{unit = "cordrag", relX = -100, relZ = 0, class = "single"},
			{unit = "cordrag", relX = -80, relZ = 0, class = "single"},
			{unit = "cordrag", relX = -60, relZ = 0, class = "single"},
			{unit = "cordrag", relX = -40, relZ = 0, class = "single"},
			{unit = "cordrag", relX = -20, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 0, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 20, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 40, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 60, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 80, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 100, relZ = 0, class = "single"},
		}, 
	},
	--- one type unit set with formation definined in noe_formations.lua
    ["peeweeGang"] = {
	    class     = "oneTypeSet",
		count     = 20,
		formation = "swarm",
		scale     = 1,
		unit      = "armpw",
	},
	["hammerGang"] = {
	    class     = "oneTypeSet",
		count     = 20,
		formation = "swarm",
		scale     = 1,
		unit      = "armham",
	},
    ["rockoGang"] = {
	    class     = "oneTypeSet",
		count     = 20,
		formation = "swarm",
		scale     = 1,
		unit      = "armrock",
	},
	["bulldogGang"] = {
	    class     = "oneTypeSet",
		count     = 10,
		formation = "swarm",
		scale     = 1,
		unit      = "armbull",
	},
}

spawnThis = {
    -- how it should look like: {name = "peewee", posX = 0, posZ = 0, facing = "n", teamName = "defaultMissionAI"},
}

------------------------------------------
-- LIBRARY WITH STANDARD EDIT FUNCTIONS --
------------------------------------------

spawnEdit = {
	["isUsedMapTheSameAsSpecifiedOne"] = function()
	    if (missionInfo.specMapName == Game.mapName) then
		    return true
		else
		    Spring.Echo("N.O.E. mission spawner ERROR: This mission needs different map for playing (" .. missionInfo.specMapName .. ")")
		    return false
		end
	end,
    ["spawnLessPlayersTransfer"] = function()
	    -- this one shares stuff (units, buildings) for players, that are not playing the mission (if prepared for more)
	    if (missionPlayersCount < maximumOfMissionPlayers) then
			Spring.Echo("N.O.E. mission spawner: giving all units from not used players slots to other players")
			for i=1,#spawnThis do
				local thisMember   = spawnThis[i]
				local thisTeamName = thisMember.teamName
				local sixLetters   = string.sub(thisTeamName,1,6)
				if (sixLetters == "player") then
					local teamNumber      = tonumber(string.sub(thisTeamName,7))
					local newNumber       = teamNumber % missionPlayersCount + 1
					spawnThis[i].teamName = "player" .. newNumber   
				end
			end
	    end
	end,
    ["spawLessPlayersDontSpawn"] = function()
	    -- this one shares stuff (units, buildings) for players, that are not playing the mission (if prepared for more)
	    if (missionPlayersCount < maximumOfMissionPlayers) then
			Spring.Echo("N.O.E. mission spawner: not spawning all units from not used players slots")
			for i=1,#spawnThis do
				local thisMember   = spawnThis[i]
				local thisTeamName = thisMember.teamName
				local sixLetters   = string.sub(thisTeamName,1,6)
				if (sixLetters == "player") then
					local teamNumber      = tonumber(string.sub(thisTeamName,7))
					if (teamNumber > missionPlayersCount) then
						spawnThis[i].gameTime = -1
					end
				end
			end
	    end
	end,	
	["specificMapCheck"] = function()
	    if (missionInfo.specificMapNeeded) then
            return spawnEdit["isUsedMapTheSameAsSpecifiedOne"]()
		else
		    return true
		end
	end,
}

----------------------------------
-- THREE MAIN SPAWNER FUNCTIONS --
----------------------------------

function OneTypeSetSpawner(unitType,posX,posZ,facing,team,specialName,formation,scale,count)
    if (team ~= nil) then
		local thisFormation = formations[formation]
		local thisFormDef   = formationDef[formation]
		if (count <= thisFormDef.limit) then
			for i=1,count do			
				SingleSpawner(unitType,posX + thisFormation[i][1]*scale,posZ + thisFormation[i][2]*scale,facing,team,specialName)
			end
			return true
		else
		    Spring.Echo("NOE - OneTypeSetSpawner: More units then is possible in chosen formation.")
			return false
		end
	else
	    Spring.Echo("NOE - OneTypeSetSpawner: Bad (team) definition of mission spawn.")
	    return false
	end
end

function ListSpawner(list,posX,posZ,facing,team,specialName)
    if (team ~= nil) then
		for i=1,#list do
		    local thisMember = list[i]
			if     (thisMember.class == "single") then
			    SingleSpawner(thisMember.unit,posX + thisMember.relX,posZ + thisMember.relZ,facing,team,specialName)
			elseif (thisMember.class == "buildingsSet") then
			    local thisSpawnDef = spawnDef[thisMember.name]
				if (thisSpawnDef ~= nil) then
					ListSpawner(thisSpawnDef.list,posX + thisMember.relX,posZ + thisMember.relZ,facing,team,specialName)
				else
				    Spring.Echo("SpawnDefinition not found (" .. thisMember.name .. ")")
				end
			elseif (thisMember.class == "oneTypeSet") then
				OneTypeSetSpawner(thisMember.unit,thisMember.posX,thisMember.posZ,thisMember.facing,teamNames[thisMember.teamName],specialName,thisMember.formation,thisMember.scale,thisMember.count)
		    end
		end
		return true
	else
	    Spring.Echo("NOE - ListSpawner: Bad (team) definition of mission spawn.")
	    return false
	end
end

function SingleSpawner(unit,posX,posZ,facing,team,specialName,featMark)
	if (team ~= nil) then
	    local posY  = spGetGroundHeight(posX,posZ)
		local newID
		if (featMark == "feature") then
			newID = spCreateFeature(unit,posX,posY,posZ,facing,team)
		else -- if nill or "unit"
			newID = spCreateUnit(unit,posX,posY,posZ,facing,team)
		end
		if (specialName ~= "none") then
		    unitsUnderGreatEyeNameToID[specialName] = {
			    id      = newID,
				isAlive = true,
			}
			unitsUnderGreatEyeIDtoName[newID] = specialName
	    end
		return true
	else
	    Spring.Echo("NOE - SingleSpawner: Bad (team) definition of mission spawn (unit: " .. unit .. ")")
		return false
	end
end

--------------------
-- SPAWNER ITSELF --
--------------------

function Spawner(gameTime)
    local haveIspawn = false
    ---- prespawn  ----
	local isSpawnCorrect = false
	isSpawnCorrect       = spawnEdit["specificMapCheck"]()
    ---- the spawn ----
	if (isSpawnCorrect) then
		for i=1,#spawnThis do
			local thisMember   = spawnThis[i]
			local thisSpawnDef = spawnDef[thisMember.name]
			--- specialName check
			local specialName  = "none"
			if (thisMember.checkType == "single") then
			    specialName = thisMember.checkName
			end
			---
			if (thisMember.gameTime == gameTime) then
				if (thisSpawnDef ~= nil) then
					if     (thisSpawnDef.class == "single") then
						SingleSpawner(thisSpawnDef.unit,thisMember.posX,thisMember.posZ,thisMember.facing,teamNames[thisMember.teamName],specialName,"unit")
					elseif  (thisSpawnDef.class == "feature") then
						SingleSpawner(thisSpawnDef.unit,thisMember.posX,thisMember.posZ,thisMember.facing,teamNames[thisMember.teamName],specialName,"feature")
					elseif (thisSpawnDef.class == "buildingsSet") then
						ListSpawner(thisSpawnDef.list,thisMember.posX,thisMember.posZ,thisMember.facing,teamNames[thisMember.teamName],specialName)
					elseif (thisSpawnDef.class == "oneTypeSet") then
						OneTypeSetSpawner(thisSpawnDef.unit,thisMember.posX,thisMember.posZ,thisMember.facing,teamNames[thisMember.teamName],specialName,thisSpawnDef.formation,thisSpawnDef.scale,thisSpawnDef.count)
					end
					haveIspawn = true
				else
					Spring.Echo("NOE - Spawner: SpawnDefinition not found (" .. thisMember.name .. ")")
				end
			end
		end
	end
	---- postspawn ----
    return haveIspawn
end