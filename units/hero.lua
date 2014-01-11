-- ubergenerator :) 
VFS.Include("LuaRules/Configs/ote/ote_heroes.lua")
VFS.Include("LuaRules/Configs/ote/ote_rules.lua")
VFS.Include("LuaRules/Configs/ote/ote_items.lua")
-- + dependant
VFS.Include("LuaRules/Configs/ote/ote_items_combinator.lua")
VFS.Include("LuaRules/Configs/ote/ote_heroes_weapons.lua")

local allHeroesDefs 	= {}

local defName  			=  "dude"

local function CreateBaseDef(className, finalName, itemList)
	
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
		mass 			= 1000,
		
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
		movementClass 	= "HeroNormal",
		
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
		--    collisionVolumeOffsets    =  "0 0 0",
		--    collisionVolumeScales     =  "20 20 20",
		--    collisionVolumeTest       =  1,
		--    collisionVolumeType       =  "box",
		
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
		},
	}
	
	-- OTE RULES EDITS
	newDef["energyMake"] 	= oteRule.reactorMove[heroClass[className].statsClass[1]] -- !currently based on speed instead own move produce value
	-- ? weapons settings are directly done via LuaRules/Configs/ote/ote_heroes_weapons.lua
	-- tsps
	local newTSPsNames 	= heroClass[className].tsps
	local newTSPs		= {}
	for i=1, #newTSPsNames do							-- mostly 3
		newTSPs[i] = {
			name 	= newTSPsNames[i],
			level 	= 0,
		}
	end
	newDef.customParams.tsps = newTSPs
	
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
		if (itemClass == "chest1" or itemClass == "chest2") then
			-- ! later may be special
			newDef = oteItem[itemName].upgrade(newDef)
		end
	end
	
	return newDef
end

for className,thisClass in pairs(heroClass) do

	-- to every class of heroes add all combinations of items
	for i=1,itemComboCounter do
		local heroPlusItemsCode	= className .. "_" .. itemCombo[i].comboString
		
		-- for each class
		-- level 0
		local level 		= 0
		local finalName 	= heroPlusItemsCode .. "_" .. level
		local skills		= {0,0,0}								-- ?! max level for each skill is 5 now
		
		local newBaseDef 	= CreateBaseDef(className, finalName, itemCombo[i].itemList)
		-- local GenerateNextLevel()
		allHeroesDefs[newBaseDef.unitName] = newBaseDef
		
		-- BFS
		-- for i=1,15 do
			-- finalName = heroPlusItemsCode .. "_" .. i
		-- end
			-- dostanu meno a vsechny vlastnosti, ktere se nemeni s levelem
			-- mam vsechny kombinace jmen (+ table = uroven + schopnosti + predchudce + naslednici)
			-- pak jedu, a davam vlasnosti, ktere se nemeni s levelem + pridam efekt predmetu
			-- protoze znam level, tak ty, ktere se meni pravidelne s levelem + efekt predmetu
			-- pak pridam tabulku se schopnostmi, predchudci a nasledniky + existuje/neexistuje
	end
end
		
-- final table completing
-- for k,v in pairs(newSpiritDef) do
	-- spiritDef[k] = v 
-- end

return lowerkeys(allHeroesDefs)