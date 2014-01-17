---------------------------------------
--- DIRECT ACCESS TO GADGET CALLINS ---
---------------------------------------

heroesTeamToUnitID 		= {}
heroesTeamToUnitDefID 	= {}
heroesUnitIDToTeam 		= {}

--- NOE CALLINs ---
function MissionNewUnitComming(unitID, unitDefID, unitTeam)
end

function MissionUnitLost(unitID, unitDefID, unitTeam)
end

--- SPRING GADGETS CALLINs ---
function MissionUnitIdle(unitID, unitDefID, unitTeam)
end

function MissionUnitCreated(unitID, unitDefID, unitTeam, builderID)
end

function MissionUnitGiven(unitID, unitDefID, unitTeam)
end

function MissionUnitCaptured(unitID, unitDefID, unitTeam)
end

function MissionUnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
end

function MissionUnitDestroyed(unitID, unitDefID, unitTeam)
	local thisUnit  = UnitDefs[unitDefID]
	local isHero	= thisUnit.customParams.ishero
	if (isHero) then
		heroesTeamToUnitID[tostring(unitTeam)] 		= unitID
		heroesTeamToUnitDefID[tostring(unitTeam)] 	= unitDefID
		heroesUnitIDToTeam[tostring(unitID)]		= unitTeam
		
		events[#events+1] = {	
			repeating			= false,				active			= true,					slow	= true,
			conditionsNames		= {"timeMore"},													actionsNames	= {"SpawnThisHero"},
			conditionsParams	= {{{realGameTime[1],realGameTime[2]+1,realGameTime[3]}}},		actionsParams	= {{unitID,unitDefID,unitTeam}},
		}
	end
end

function MissionUnitTaken(unitID, unitDefID, unitTeam)
end

function MissionGameFrame(n)
end

function MissionInitialize()
end