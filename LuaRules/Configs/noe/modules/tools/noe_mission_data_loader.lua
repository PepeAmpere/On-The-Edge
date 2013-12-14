-------------------------------
--- peps mission data loader --
--- for NOE -------------------
-------------------------------

-- = look into mission folder and append all tables content from given files on tables of unit_noe.lua
-- ! duplicity is not solved, so i think new table rewrites old values

local function UpdateSide()
    if (newSideSettings == nil) then
	    return false
	else
		-- local oldCount = #sideSettings
		-- local newCount = #newSideSettings
		for k,v in pairs(newSideSettings) do
			sideSettings[k] = v 
		end
		return true
	end
end

local function UpdateGroups()
    if (newGroupDef == nil) then
	    return false
	else
		-- local oldCount = #groupDef
		-- local newCount = #newGroupDef
		for k,v in pairs(newGroupDef) do
			groupDef[k] = v 
		end
		return true
	end
end

local function UpdateSpirits()
    if (newSpiritDef == nil) then
	    return false
	else
		-- local oldCount = #spiritDef
		-- local newCount = #newSpiritDef
		for k,v in pairs(newSpiritDef) do
			spiritDef[k] = v 
		end
		
		-- local oldCount = #plan
		-- local newCount = #newPlan
		for k,v in pairs(newPlan) do
			plan[k] = v 
		end
		return true
	end
end

local function UpdateFormations()
    if (formationBySpirit == nil) then
	    return false
	else
		-- local oldCount = #formationBySpirit
		-- local newCount = #newFormationBySpirit
		for k,v in pairs(newFormationBySpirit) do
			formationBySpirit[k] = v 
		end
		
		local oldCount = #formationNames
		local newCount = #newFormationNames
		for i=1,newCount do
		    formationNames[oldCount + i] = newFormationNames[i]
		end
		
	    -- local oldCount = #formationDef
		-- local newCount = #newFormationDef
		for k,v in pairs(newFormationDef) do
			formationDef[k] = v 
		end
		
		-- local oldCount = #formations
		-- local newCount = #newFormations
		for k,v in pairs(newFormations) do
			formations[k] = v 
		end
		
		-- local oldCount = #formationsGeneration
		-- local newCount = #newFormationsGeneration
		for k,v in pairs(newFormationsGeneration) do
			formationsGeneration[k] = v 
		end
		return true
	end
end

local function UpdateClasses()
    if (newClassDefLists == nil) then
	    return false
	else
		-- local oldCount = #classDefLists
		-- local newCount = #newClassDefLists
		for k,v in pairs(newClassDefLists) do
			classDefLists[k] = v 
		end
		return true
	end
end

local function UpdateSpawn()
    if (newSpawnDef == nil) then
	    return false
	else
		-- local oldCount = #spawnDef
		-- local newCount = #newSpawnDef
		for k,v in pairs(newSpawnDef) do
			spawnDef[k] = v 
		end
		
		-- local oldCount = #spawnThis
		-- local newCount = #newSpawnThis
		for k,v in pairs(newSpawnThis) do
			spawnThis[k] = v 
		end
		
		-- special additon for generated spawners (features)
		if (newSpawnFeatureDef ~= nil and newFeaturesSpawn ~= nil) then
			for k,v in pairs(newSpawnFeatureDef) do
				spawnDef[k] = v 
			end
			
			for k,v in pairs(newFeaturesSpawn) do
				spawnThis[#spawnThis + 1] = v 
			end
		end
		
		return true
	end
end

local function UpdateConditions()
    if (newCondition == nil) then
	    return false
	else
	    -- local oldCount = #condition
		-- local newCount = #newCondition
		for k,v in pairs(newCondition) do
			condition[k] = v 
		end
		return true
	end
end

local function UpdateEvents()
    if (newEvents == nil) then
	    return false
	else
	    local oldCount = #events
		local newCount = #newEvents
		for i=1,newCount do
		    events[oldCount + i] = newEvents[i]
		end
		return true
	end
end

local function UpdateActions()
    if (newAction == nil) then
	    return false
	else
        -- local oldCount = #action
		-- local newCount = #newAction
		for k,v in pairs(newAction) do
			action[k] = v 
		end
		return true
	end
end

local function UpdateTerraformer()
    if (newTerraform == nil) then
	    return false
	else
		-- local oldCount = #terraform
		-- local newCount = #newTerraform
		for k,v in pairs(newTerraform) do
			terraform[k] = v 
		end
		
	    local oldCount = #terraformPlan
		local newCount = #newTerraformPlan
		for i=1,newCount do
		    terraformPlan[oldCount + i] = newTerraformPlan[i]
		end
		return true
	end
end

local function UpdateMaps()
    if (newMap == nil) then
	    return false
	else
		-- local oldCount = #map
		-- local newCount = #newMap
		for k,v in pairs(newMap) do
			map[k] = v 
		end
		return true
	end
end

local function UpdateTasks()
    if (newTask == nil) then
	    return false
	else
		-- local oldCount = #task
		-- local newCount = #newTask
		for k,v in pairs(newTask) do
			task[k] = v 
		end
		return true
	end
end

function UpdateTables(missionPath)
    local ok = false
	
	-- UPDATE SIDE --
	local currentPath = missionPath .. "/AIdefs/side.lua"
	include (currentPath)
    ok = UpdateSide()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
	-- UPDATE GROUPS --
	local currentPath = missionPath .. "/AIdefs/groups.lua"
	include (currentPath)
    ok = UpdateGroups()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
	-- UPDATE SPIRITS --
	local currentPath = missionPath .. "/AIdefs/spirits.lua"
	include (currentPath)
    ok = UpdateSpirits()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
	-- UPDATE FORMATIONS --
	local currentPath = missionPath .. "/AIdefs/formations.lua"
	include (currentPath)
    ok = UpdateFormations()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
	-- UPDATE CLASSES --
	local currentPath = missionPath .. "/AIdefs/classes.lua"
	include (currentPath)
    ok = UpdateClasses()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
	-- UPDATE SPAWN --
	local currentPath = missionPath .. "/AIdefs/spawn.lua"
	include (currentPath)
    ok = UpdateSpawn()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
	-- UPDATE CONDITIONS --
	local currentPath = missionPath .. "/AIdefs/conditions.lua"
	include (currentPath)
    ok = UpdateConditions()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
    -- UPDATE EVENTS --
	local currentPath = missionPath .. "/AIdefs/events.lua"
	include (currentPath)
    ok = UpdateEvents()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
	-- UPDATE ACTIONS --
	local currentPath = missionPath .. "/AIdefs/actions.lua"
	include (currentPath)
    ok = UpdateActions()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
    -- UPDATE TERRAFORMER --
	local currentPath = missionPath .. "/AIdefs/terraform.lua"
	include (currentPath)
    ok = UpdateTerraformer()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
	-- UPDATE MAPS --
	local currentPath = missionPath .. "/AIdefs/map.lua"
	include (currentPath)
    ok = UpdateMaps()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
	-- UPDATE TASKS --
	local currentPath = missionPath .. "/AIdefs/tasks.lua"
	include (currentPath)
    ok = UpdateTasks()
	if (ok) then Spring.Echo(currentPath .. " successfully loaded") else Spring.Echo("ERROR: " .. currentPath .. " not loaded") end
	
end