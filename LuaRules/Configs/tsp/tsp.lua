--------------------------------------------------------------------------------
-- TSP definition file - Temporary Strategic Powers ----------------------------
--------------------------------------------------------------------------------
local spGetUnitsInArea 	= Spring.GetUnitsInArea
local spTransferUnit 	= Spring.TransferUnit

tsp = {
	-- AKCE PRO REPAIR DRONE
	["SpawnDrone"] = function(unitID, unitDefID, teamBaseID)
		-- TODO spawnovat drona pro leceni
		-- TODO nastavit aby branil jednotku
		return true
	end,
	-- AKCE PRO SPUSTENI HACKER DEVICE
	-- TODO(pripadne dodat podminku aby se nepouzila akce bez jednotek) -> do conditions
	["HackerDevice"] = function(centerX, centerZ, radius, teamID)
		--rict si o jednotky v oblasti
		local unitsInArea = spGetUnitsInArea(centerX, 0, centerZ, radius)
		--u tech u kterych je to povolene zmenit tym na teamNumber
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
		-- TODO spawn jednotky letadla
		-- TODO attack order letadlu na pozici
		-- TODO dostat letadlo pryc a zrusit ho
	end
	-- VYSPAWNOVANI MIN
	["Minefield"] = function(centerX, centerZ, teamID, mineDefID, count, formationName)
		-- TODO spawn mines in area of center and radius with defined count and formation
		-- using PlantMine for each mine
	end,
	["PlantMine"] = function(posX, posZ, teamID, mineDefID)
	-- SPAWNS EMP MINE
		-- TODO spawn GivenMine in given spot
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
		-- TODO add NanobotsActive for given unit in global data structure - not true/false but duration 
		local startTime = realGameTime
		events[#events+1] = {
			repeating           = true,
			active              = true,
			slow    			= true,
            conditionsNames     = {"UnitIsAlive", "NanobotsActive"},
			conditionsParams    = {{tagetID},{targetID}},
			actionsNames    	= {"NanobotsPower"}, -- at the end decrease NanobotsActive by 1 and if 0 deactivate event
			actionsParams   	= {{targetID}}, 
        }
	end,
	["AcidBomb"] = function(posX, posZ, radius, duration)
	-- ACID BOMB TO GIVEN AREA
		-- TODO add AcidActive for all given units in global data structure, same as Nanobots
		local startTime = realGameTime
		local affectedUnits = Spring.GetUnitsInSphere(posX, 0, posZ, radius)
		
		for i=1, #affectedUnits do
		local thisUnit = affectedUnits[i]
			events[#events+1] = {
				repeating           = true,
				active              = true,
				slow    			= true,
				conditionsNames     = {"UnitIsAlive", "AcidActive"},
				conditionsParams    = {{thisUnit},{thisUnit}},
				actionsNames    	= {"NanobotsPower"},
				actionsParams   	= {{thisUnit}},
			}
		end
	end,
	["BugsWard"] = function(unitID, teamBaseID, unitsSet, formationName)
	-- SPAWNS BUGWARD FOR HERO
		--GET HERO POSSITION, AND SPAWN BUGS OF GIVEN TYPE IN GIVEN FORMATION
		local heroPosX, heroPosY, heroPosZ 	= Spring.GetUnitPosition(unitID)
		local thisFormation 				= formations[formationName]
		
		if(#unitsSet <= #thisFormation) then
			for i=1, #unitsSet do
				Spring.CreateUnit(unitsSet[i], heroPosX + thisFormation[i][1], heroPosY, heroPosZ + thisFormation[i][2], teamBaseID)
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
	["PlusOneUnit"] = function()
	-- BASE SPAWNES MORE UNITS
		--TODO change global attribut by one
	end,
	["Giants"]
	--BASE CAN SPANWN GIANT
		--TODO change global attribut by one
}

