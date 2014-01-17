------------------------------------------------------------------------------
-- TSP actions definition file
-- more about actions on WIKI: http://code.google.com/p/nota/wiki/NOE_actions
-- more about TSP specific stuff: !TODO add
------------------------------------------------------------------------------

local spCreateUnit			= Spring.CreateUnit
local spGetUnitPosition		= Spring.GetUnitPosition
local spGetUnitsInArea 		= Spring.GetUnitsInArea
local spGetUnitsInSphere 	= Spring.GetUnitsInSphere
local spGiveOrderToUnit 	= Spring.GiveOrderToUnit
local spTransferUnit 		= Spring.TransferUnit

local tspAction = {
	-- AKCE PRO REPAIR DRONE
	["SpawnAssistDrone"] = function(unitID, teamID, actionLevel)
		local heroPosX, heroPosY, heroPosZ 	= spGetUnitPosition(unitID)
		-- spawn of assist drone
		local unitDef = "dronehealing" .. actionLevel
		local droneID = spCreateUnit(unitDef, heroPosX, heroPosY + 50, heroPosZ, "s", teamID)
		-- set drone to repair hero unit
		spGiveOrderToUnit(droneID, CMD.GUARD, {unitID}, {})
		-- TODO: drone gets own spirit, which will check its fuel and destroy it when fuel is out
		return true
	end,
	-- AKCE PRO SPUSTENI HACKER DEVICE
	-- TODO(pripadne dodat podminku aby se nepouzila akce bez jednotek) -> do conditions
	["HackerDevice"] = function(centerX, centerZ, radius, teamID)
		-- get units in given area
		local unitsInArea = spGetUnitsInArea(centerX, 0, centerZ, radius)
		-- for all units change team to teamID, if possible
		for i=1, #unitsInArea do
			if(true) then --TODO podminka 
				spTransferUnit(unitsInArea[i], teamID)
			end
		end
		return true
	end,
	-- AKCE PRO TELEPORTOVANI JEDNOTKY
	["TeleportUnit"] = function()
		--TODO: doplnit
	end,
	-- AKCE PRO JUMPJET
	["Jumpjet"] = function()
		--TODO: doplnit
	end,
	-- AIRSTRIKE AKCE
	["Airstrike"] = function(unitDefID, centerX, centerZ, teamBaseID)
		-- spawn airplane unit
		local planeID = spCreateUnit(unitDefID, 0, 300, 0, "s", teamBaseID)
		-- attack order to plane to given position
		spGiveOrderToUnit(planeID, CMD.ATTACK, {centerX, 300, centerZ}, {"shift"})
		-- plane flies away and destroy itself :D :D
		-- TODO somehow destroy the plane
		spGiveOrderToUnit(planeID, CMD.MOVE, {20, 300, 20}, {"shift"})
		
	end,
	-- VYSPAWNOVANI MIN
	["Minefield"] = function(centerX, centerZ, teamID, mineDefID, count, formationName, formationScale)
		-- TODO spawn mines in area of center and radius with defined count and formation
		-- using PlantMine for each mine
		for i=1, count do
			local relX, relZ = formations[formationName][i][1], formations[formationName][i][2]
			action.PlantMine(centerX + relX*formationScale, centerZ + relZ*formationScale, teamID, mineDefID)
		end
	end,
	["PlantMine"] = function(posX, posZ, teamID, mineDefID)
	-- SPAWNS MINE: can by used for spawning Minefield or EMPMine etc.
		-- spawn GivenMine in given spot
		spCreateUnit(mineDefID, posX, 0, posZ, "s", teamID)
	end,
	["ScoutArea"] = function(basePosX, basePosZ, teamBaseID, targetX, targetY, unitDefID)
	-- SPAWN AIRPLANE THAT SCOUTS GIVEN AREA
		-- TODO spawn airplane
		-- TODO fly airplane to given possition
		-- TODO fly airplane out of map and destroy unit
	end,
	["FlyingEye"] = function(unitID, eyeDefID, teamID)
	-- SPAWN FLYING EYE CONTROLED BY PLAYER
		-- TODO spawn unit
	end,
	["StaticEye"] = function(posX, posY, eyeDefID, teamBaseID)
	-- SPAWN STATIC EYE
		-- TODO spawn unit and change count of this units
	end,
	["BolidImpact"] = function()
		-- TODO spawn unit that makes this happen
	end,
	["MeteorRain"] = function()
		-- TODO spawn unit that makes this happen
	end,
	["NanobotsAttack"] = function(unitID, targetID, duration)
	-- ATTACK OF NANOBOTS
		-- TODO add ChangeNanobotsLevel for given unit in global data structure - not true/false but duration 
		local startTime = realGameTime
		events[#events+1] = {
			repeating           = true,
			active              = true,
			slow    			= true,
            conditionsNames     = {"UnitIsAlive", "ChangeNanobotsLevel"},
			conditionsParams    = {{tagetID},{targetID,duration}},
			actionsNames    	= {"NanobotsPower"}, -- at the end decrease NanobotsActive by 1 and if 0 deactivate event
			actionsParams   	= {{targetID}}, 
        }
	end,
	["AcidBomb"] = function(posX, posZ, radius, duration)
	-- ACID BOMB TO GIVEN AREA
		-- TODO add ChangeAcidLevel for all given units in global data structure, same as Nanobots
		local startTime = realGameTime
		local affectedUnits = spGetUnitsInSphere(posX, 0, posZ, radius)
		
		for i=1, #affectedUnits do
		local thisUnit = affectedUnits[i]
			events[#events+1] = {
				repeating           = true,
				active              = true,
				slow    			= true,
				conditionsNames     = {"UnitIsAlive", "ChangeAcidLevel"},
				conditionsParams    = {{thisUnit},{thisUnit}},
				actionsNames    	= {"NanobotsPower"},
				actionsParams   	= {{thisUnit}},
			}
		end
	end,
	["BugsWard"] = function(unitID, teamBaseID, unitsSet, formationName)
	-- SPAWNS BUGWARD FOR HERO
		--GET HERO POSSITION, AND SPAWN BUGS OF GIVEN TYPE IN GIVEN FORMATION
		local heroPosX, heroPosY, heroPosZ 	= spGetUnitPosition(unitID)
		local thisFormation 				= formations[formationName]
		
		if(#unitsSet <= #thisFormation) then
			for i=1, #unitsSet do
				spCreateUnit(unitsSet[i], heroPosX + thisFormation[i][1], heroPosY, heroPosZ + thisFormation[i][2], "s", teamBaseID)
			end
			return true
		else
			return false
		end
		
		--TODO AI stuff
	end,
	["DustStorm"] = function()
	-- STARTS A DUSTSTORM
		-- TODO spawn existing duststorm
	end,
}

------------------------------------------------------------------------------
----------------------- END OF MODULE DEFINITIONS ----------------------------

---- update actions table ----
if (action == nil) then action = {} end
for k,v in pairs(tspAction) do
	action[k] = v 
end
