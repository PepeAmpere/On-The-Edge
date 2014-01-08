---------------------------------------
--- DIRECT ACCESS TO GADGET CALLINS ---
---------------------------------------

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
end

function MissionUnitTaken(unitID, unitDefID, unitTeam)
end

function MissionGameFrame(n)
end

function MissionInitialize()
end