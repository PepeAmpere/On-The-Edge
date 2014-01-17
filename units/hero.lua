-- ubergenerator :) 
VFS.Include("LuaRules/Configs/ote/ote_heroes.lua")
VFS.Include("LuaRules/Configs/ote/ote_rules.lua")
VFS.Include("LuaRules/Configs/ote/ote_items.lua")
-- + dependant
VFS.Include("LuaRules/Configs/ote/ote_items_combinator.lua")
VFS.Include("LuaRules/Configs/ote/ote_heroes_weapons.lua")
-- + gameSettings
VFS.Include("LuaRules/Configs/ote/ote_heroes_presetup.lua")
-- + utility
VFS.Include("LuaRules/Gadgets/Includes/utilities.lua")

local allHeroesDefs 	= {}

local maxLevels 		= 6
local triangelCorrect	= 2
local heroDefsCounter 	= 0

local function GetNeeded()
	-- local list = {
		-- bug_h0_w0_b0_b0_1 = true,
		-- ball_h0_w0_b0_b0_1 = true,
		-- bulk_h0_w0_b0_b0_1 = true,
		-- cam_h0_w0_b0_b0_1 = true,
		-- doc_h0_w0_b0_b0_1 = true,		
	-- }
	return neededCombos			-- from LuaRules/Configs/ote/ote_heroes_presetup.lua
end
local listOfneeded		= GetNeeded()

local function CreatHeroDefName(classPlusItems,level,a,b,c)
	return (classPlusItems .. "_" .. tostring(level) .. "_" .. a .. "_" .. b .. "_" .. c)
end

local function CreateBaseDef(className, heroPlusItemsCode, finalName, itemList)
	
	local newDef = {
		-- head
		buildPic 		= heroClass[className].bigImage,
		category 		= "HERO GROUND NOTAIR",
		objectName 		= heroClass[className].model,
		name 			= className,
		side 			= className,
		unitName 		= finalName .. "_0_0_0",
		script 			= heroClass[className].script,
		description 	= heroClass[className].description,
		
		-- healt + LOS
		maxDamage 		= oteRule.health[heroClass[className].statsClass[2]],
		radarDistance 	= 0,
		sightDistance 	= oteRule.los[heroClass[className].statsClass[8]],
		mass 			= 1500,
		iconType		= "hero",		
		
		soundCategory 	= "",
		upright 		= 0,
		buildCostEnergy = 0,
		buildCostMetal 	= 0,
		
		-- move
		maxVelocity		= oteRule.speed[heroClass[className].statsClass[1]],
		acceleration 	= 0.2,
		brakeRate 		= 0.2,
		turnRate		= 1000,
		maxWaterDepth 	= 20,
		movementClass 	= heroClass[className].movement,
		footprintX		= heroClass[className].footprint,
		footprintZ		= heroClass[className].footprint,
		
		-- ability
		builder 		= 0,
		canAttack 		= 1,
		canGuard 		= 1,
		canMove 		= 1,
		canPatrol 		= 1,
		canStop 		= 1,
		leaveTracks 	= 0,
		reclaimable 	= 0,
		capturable		= 0,
		
		-- TODO: add spheres for each bot in heroClass[className]
	   -- collisionVolumeOffsets    =  "0 0 0",
	   -- collisionVolumeScales     =  "70 100 70",
	   -- collisionVolumeTest       =  1,
	   -- collisionVolumeType       =  "cylY",
		
		weapons = {
			[1] = {
				def                	= heroWeapons[className].name,
				-- ExplodeAs 			= heroWeapons[className].name,
				NoChaseCategory 	= "AIR",
			},
		},
		weaponDefs = {
			[heroWeapons[className].name] = heroWeapons[className], 			-- directly done via LuaRules/Configs/ote/ote_heroes_weapons.lua
		},
		customParams = {
			energyStorage	= oteRule.energy[heroClass[className].statsClass[3]],
			spawnTime		= 5 + 0 + oteRule.heroSpawn[heroClass[className].statsClass[9]],
			tsps			= {},
			nextLevelExp	= oteRule.experienceLevelFirst,
			isHero			= true,
			level			= 0,
		},
	}
	
	-- OTE RULES EDITS
	newDef["energyMake"] 	= oteRule.reactorMove[heroClass[className].statsClass[1]] -- !currently based on speed instead own move produce value
	newDef["autoHeal"] 		= 0
	-- ? weapons settings are directly done via LuaRules/Configs/ote/ote_heroes_weapons.lua
	-- tsps
	local newTSPsNames 	= heroClass[className].tsps
	local newTSPs		= {}
	local tspUpdates	= {{1,0,0}, {0,1,0},{0,0,1}}
	for i=1, #newTSPsNames do							-- mostly 3
		newTSPs[i] = {
			name 				= newTSPsNames[i],
			level 				= 0,
			nextLevelName		= CreatHeroDefName(heroPlusItemsCode,1,tspUpdates[i][1],tspUpdates[i][2],tspUpdates[i][3]),
			nextLevelAllowed	= true,
		}
	end
	-- TODO: fix this shit
	-- newDef.customParams["tsps"] = Deepcopy(newTSPs)
	
	newDef.customParams["tsps_size"] 				= #newTSPsNames	
	newDef.customParams["tsp1_name"] 				= newTSPs[1].name
	newDef.customParams["tsp1_level"] 				= newTSPs[1].level
	newDef.customParams["tsp1_nextLevelName"] 		= newTSPs[1].nextLevelName
	newDef.customParams["tsp1_nextLevelAllowed"] 	= newTSPs[1].nextLevelAllowed
	newDef.customParams["tsp2_name"] 				= newTSPs[2].name
	newDef.customParams["tsp2_level"] 				= newTSPs[2].level
	newDef.customParams["tsp2_nextLevelName"] 		= newTSPs[2].nextLevelName
	newDef.customParams["tsp2_nextLevelAllowed"] 	= newTSPs[2].nextLevelAllowed
	newDef.customParams["tsp3_name"] 				= newTSPs[3].name
	newDef.customParams["tsp3_level"] 				= newTSPs[3].level
	newDef.customParams["tsp3_nextLevelName"] 		= newTSPs[3].nextLevelName
	newDef.customParams["tsp3_nextLevelAllowed"] 	= newTSPs[3].nextLevelAllowed
	
	-- ITEMS EDITS
	for itemClass,itemName in pairs(itemList) do
		if (itemClass == "head") then
			newDef = oteItem[itemName].upgrade(newDef)
		end
		if (itemClass == "weapon") then
			-- ! later may be special
			newDef.weaponDefs[heroWeapons[className].name] = oteItem[itemName].upgrade(newDef.weaponDefs[heroWeapons[className].name])
		end
		if (itemClass == "reactor") then
			-- ! later may be special
			newDef["energyMake"] 	= (newDef["energyMake"] or 0) + oteRule.reactorPlus[itemName]
			newDef["autoHeal"] 		= (newDef["autoHeal"] or 0) + oteRule.autorepair[itemName]
		end
		if (itemClass == "body1" or itemClass == "body2") then
			-- ! later may be special
			newDef = oteItem[itemName].upgrade(newDef)
		end
	end
	
	return newDef, newTSPs
end

function Deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Deepcopy(orig_key)] = Deepcopy(orig_value)
        end
        setmetatable(copy, Deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

Spring.Echo("----------- START OF OTE HERO DEFS CREATOR -----------")
Spring.Echo("... listing wanted hero + items combos: ")

for heroPlusItemsCode,_ in pairs(listOfneeded) do
	local setup		= split(heroPlusItemsCode, "_")
	local className = setup[1]
	local itemList	= {
		head	= itemCodeToName[setup[2]],	-- from itemCodeToName[] - LuaRules/Configs/ote/ote_heroes_presetup.lua
		weapon	= itemCodeToName[setup[3]],
		body1	= itemCodeToName[setup[4]],
		body2	= itemCodeToName[setup[5]],
		reactor	= reactorSettings[setup[6]],
	}
	
	-- for each class
	-- level 0
	local level 				= 0
	local finalName 			= heroPlusItemsCode .. "_" .. level
	local skills				= {0,0,0}								-- ?! max level for each skill is 5 now
	
	local newBaseDef,newTsps	= CreateBaseDef(className, heroPlusItemsCode, finalName, itemList)
	allHeroesDefs[newBaseDef.unitName] = newBaseDef
	
	-- if we need this to generate
	Spring.Echo(heroPlusItemsCode .. "  ... generating defs")
	
	-- help structure
	local allDefsCombinations = {}	
	-- init base
	allDefsCombinations[newBaseDef.unitName] = {
		level 	= 0,
		tsps	= newTsps,
	}
	
	-- ?! no BFS, just silly thing now
	-- TODO: one day do it more clear
	for a=0,maxLevels do
		for b=0,maxLevels do
			for c=0,maxLevels do
				if (a + b + c == 0) then -- skip and?
				else
					local newLevel			= a + b + c
					local anotherNewName 	= CreatHeroDefName(heroPlusItemsCode,newLevel,a,b,c)
					local newTSPsNames 		= heroClass[className].tsps
					local newTSPs			= {}
					local tspLevels			= {a, b, c}
					local tspUpdates		= {{1,0,0}, {0,1,0},{0,0,1}}
					
					local allow				= true
					if (level >= maxLevels*3) then
						allow = false
					end
					for i=1, #newTSPsNames do							-- mostly 3
						newTSPs[i] = {
							name 				= newTSPsNames[i],
							level 				= tspLevels[i],
							nextLevelName		= CreatHeroDefName(heroPlusItemsCode,newLevel+1,a + tspUpdates[i][1],b + tspUpdates[i][2],c + tspUpdates[i][3]),
							nextLevelAllowed	= allow,
						}
					end
					allDefsCombinations[anotherNewName] = {
						level 	= newLevel,
						tsps	= newTSPs,
					}
					-- Spring.Echo(anotherNewName)
				end
			end
		end
	end
	-- ! END OF DUMMY GENERATOR ;)
	
	-- MARK BAD DEVELOPMENT
	for newDefName,subDefs in pairs(allDefsCombinations) do
		local a,b,c				= subDefs.tsps[1].level, subDefs.tsps[2].level, subDefs.tsps[3].level
		local tspUpdates		= {{-1,0,0}, {0,-1,0},{0,0,-1}}
		
		-- just triangular equations or max
		if ((a+b+triangelCorrect < c) or (a+c+triangelCorrect < b) or (c+b+triangelCorrect < a) or (a==maxLevels) or (b==maxLevels) or (c==maxLevels)) then
			-- look back and select where impossible updates
			for i=1,3 do
				if ((a + tspUpdates[i][1] >= 0) and (b + tspUpdates[i][2] >=0) and (c + tspUpdates[i][3] >= 0)) then
					local newName = CreatHeroDefName(heroPlusItemsCode,subDefs.level-1,a + tspUpdates[i][1],b + tspUpdates[i][2],c + tspUpdates[i][3])
					allDefsCombinations[newName].tsps[i].nextLevelAllowed = false
				end
			end
		end
	end
	
	for newDefName,subDefs in pairs(allDefsCombinations) do	
		local a,b,c				= subDefs.tsps[1].level, subDefs.tsps[2].level, subDefs.tsps[3].level
		local newLevel			= subDefs.level
		local newDef			= Deepcopy(newBaseDef)
		
		-- !add powers, only 3 now!	
		-- TODO: make again better !!!!! bug stupid bug
		-- newDef.customParams.tsps = Deepcopy(subDefs.tsps)
		
		-- imcrease healh/energy/speed/repair/charge
		-- !! TODO: make and connect with ote rules multipliers
		local testMultiplier = 1.04
		local expMultiplier = 1.1
		newDef.unitName						= newDefName
		newDef.maxDamage 					= math.floor(newBaseDef.maxDamage * testMultiplier^newLevel)
		newDef.customParams.energyStorage 	= math.floor(newBaseDef.customParams.energyStorage * testMultiplier^newLevel)
		newDef.maxVelocity 					= newBaseDef.maxVelocity * testMultiplier^newLevel
		newDef.energyMake 					= newBaseDef.energyMake * testMultiplier^newLevel
		newDef.autoHeal 					= newBaseDef.autoHeal * testMultiplier^newLevel
		
		newDef.customParams.spawnTime 		= newBaseDef.customParams.spawnTime + 2*newLevel
		newDef.customParams.nextLevelExp 	= math.floor(newBaseDef.customParams.nextLevelExp * expMultiplier^newLevel)
		newDef.customParams.level			= newLevel
		
		newDef.customParams["tsps_size"] 				= 3
		newDef.customParams["tsp1_name"] 				= subDefs.tsps[1].name
		newDef.customParams["tsp1_level"] 				= subDefs.tsps[1].level
		newDef.customParams["tsp1_nextLevelName"] 		= subDefs.tsps[1].nextLevelName
		newDef.customParams["tsp1_nextLevelAllowed"] 	= subDefs.tsps[1].nextLevelAllowed
		newDef.customParams["tsp2_name"] 				= subDefs.tsps[2].name
		newDef.customParams["tsp2_level"] 				= subDefs.tsps[2].level
		newDef.customParams["tsp2_nextLevelName"] 		= subDefs.tsps[2].nextLevelName
		newDef.customParams["tsp2_nextLevelAllowed"] 	= subDefs.tsps[2].nextLevelAllowed
		newDef.customParams["tsp3_name"] 				= subDefs.tsps[3].name
		newDef.customParams["tsp3_level"] 				= subDefs.tsps[3].level
		newDef.customParams["tsp3_nextLevelName"] 		= subDefs.tsps[3].nextLevelName
		newDef.customParams["tsp3_nextLevelAllowed"] 	= subDefs.tsps[3].nextLevelAllowed

		-- kill bad levels combinations
		-- just triangular equations 
		if ((a+b+triangelCorrect < c) or (a+c+triangelCorrect < b) or (c+b+triangelCorrect < a) or (a==maxLevels) or (b==maxLevels) or (c==maxLevels)) then
			-- No spring echo pls, its thousands of variations without line 150
			-- Spring.Echo("bad one: ", newDefName) 
			newDef.customParams["tsp1_nextLevelAllowed"] = false
			newDef.customParams["tsp2_nextLevelAllowed"] = false
			newDef.customParams["tsp3_nextLevelAllowed"] = false
		end
		
		allHeroesDefs[newDefName] 		= newDef
		heroDefsCounter					= heroDefsCounter + 1
		--Spring.Echo(newDefName) 
		--Spring.Echo(newDef.customParams.level,subDefs.tsps[1].nextLevelAllowed,subDefs.tsps[2].nextLevelAllowed,subDefs.tsps[3].nextLevelAllowed)
	end
end

Spring.Echo("OTE hero defs creator: " .. heroDefsCounter .. " definitions made!")
Spring.Echo("----------- END OF OTE HERO DEFS CREATOR -----------")
		
-- final table completing
-- for k,v in pairs(allHeroesDefs) do
	-- spiritDef[k] = v 
-- end

return lowerkeys(allHeroesDefs)