-- ubergenerator :) 
VFS.Include("LuaRules/Configs/ote/ote_heroes.lua")
VFS.Include("LuaRules/Configs/ote/ote_rules.lua")
VFS.Include("LuaRules/Configs/ote/ote_items.lua")
-- + dependant
VFS.Include("LuaRules/Configs/ote/ote_items_combinator.lua")
VFS.Include("LuaRules/Configs/ote/ote_heroes_weapons.lua")

local allHeroesDefs 	= {}

local maxLevels 		= 5
local triangelCorrect	= 2
local heroDefsCounter 	= 0

-- !! shortcut testing
-- TODO: iclude file which take from options setups we need to generate
local function SomeFunction()
	local list = {
		bug_h0_w0_ch0_ch0_1 = true,
		ball_h0_w0_ch0_ch0_1 = true,
		bulk_h0_w0_ch0_ch0_1 = true,
		cam_h0_w0_ch0_ch0_1 = true,
		doc_h0_w0_ch0_ch0_1 = true,		
	}
	return list
end
local listOfneeded		= SomeFunction()

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
			isHero			= true,
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
		if (itemClass == "body1" or itemClass == "body2") then
			-- ! later may be special
			newDef = oteItem[itemName].upgrade(newDef)
		end
	end
	
	return newDef
end

Spring.Echo("----------- START OF OTE HERO DEFS CREATOR -----------")
Spring.Echo("... listing wanted hero + items combos: ")

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
		
		-- if we need this to generate
		if (listOfneeded[heroPlusItemsCode]) then
			Spring.Echo(heroPlusItemsCode .. "  ... generating defs")
		
			-- ?! no BFS, just silly thing now
			-- TODO: one day do it more clear
			for a=0,maxLevels do
				for b=0,maxLevels do
					for c=0,maxLevels do
						if (a + b + c == 0) then -- skip and?
						else
							local newLevel			= a + b + c
							local anotherNewName 	= heroPlusItemsCode .. "_" .. tostring(newLevel) .. "_" .. a .. "_" .. b .. "_" .. c
							local newDef			= {}
							for k,v in pairs(newBaseDef) do
								newDef[k] = v 
							end
							
							-- !add powers, only 3 now!
							local newTSPsNames 		= heroClass[className].tsps
							local newTSPs			= {}
							local tspLevels			= {a, b, c}
							for i=1, #newTSPsNames do							-- mostly 3
								newTSPs[i] = {
									name 	= newTSPsNames[i],
									level 	= tspLevels[i],
								}
							end
							newDef.customParams.tsps = newTSPs		
							
							-- imcrease healh/energy/speed/repair/charge
							-- !! TODO: make and connect with ote rules multipliers
							local testMultiplier = 1.02
							local expMultiplier = 2
							newDef.unitName						= anotherNewName
							newDef.maxDamage 					= newBaseDef.maxDamage * testMultiplier^newLevel
							newDef.customParams.energyStorage 	= newBaseDef.customParams.energyStorage * testMultiplier^newLevel
							newDef.maxVelocity 					= newBaseDef.maxVelocity * testMultiplier^newLevel
							newDef.energyMake 					= newBaseDef.energyMake * testMultiplier^newLevel
							newDef.autoHeal 					= newBaseDef.autoHeal * testMultiplier^newLevel
							
							newDef.customParams.spawnTime 		= newBaseDef.customParams.spawnTime + newLevel
							newDef.customParams.nextLevelExp 	= newBaseDef.customParams.nextLevelExp * expMultiplier^newLevel

							-- kill bad levels combinations
							-- just triangular equations 
							if ((a+b+triangelCorrect < c) or (a+c+triangelCorrect < b) or (c+b+triangelCorrect < a)) then
								--No spring echo pls, its thousands of variations without line 150
								--Spring.Echo("bad one: ", anotherNewName) 
							else
								allHeroesDefs[anotherNewName] 	= newDef
								heroDefsCounter					= heroDefsCounter + 1
								--Spring.Echo(anotherNewName) 
							end
						end
					end
				end
			end
		-- ! END OF DUMMY GENERATOR ;)
		end
	end
end

Spring.Echo("OTE hero defs creator: " .. heroDefsCounter .. " definitions made!")
Spring.Echo("----------- END OF OTE HERO DEFS CREATOR -----------")
		
-- final table completing
-- for k,v in pairs(newSpiritDef) do
	-- spiritDef[k] = v 
-- end

return lowerkeys(allHeroesDefs)