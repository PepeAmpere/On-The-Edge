------------------------------------------------------------------------------
-- OTE ITEMS
-- more about global settings on project site wiki https://github.com/OTE-AM/On-The-Edge/blob/master/wiki/design_detail.md
-- !in this file use def values atributes without lowercasing
------------------------------------------------------------------------------

-- bonus item types
------------------------
-- basic
-- sensorUp
-- weaponUp
-- healthUp
-- energyUp
-- armorUp
-- speedUp
-- shieldUp

local itemIconsPath = "LuaUI/Images/ote/items/" 

local damageWeaponUpgradePerPrice = {
	free 		= 0,
	cheap 		= 0.02,
	moderate	= 0.05,
	expensive	= 0.08,
	ultimate	= 0.11,
}
local priceClass	= {
	free 		= 0,
	cheap 		= 1,
	moderate	= 3,
	expensive	= 5,
	ultimate	= 7,	
}
local panzerLightSpeedDecrease 	= -0.4
local panzerHeavySpeedDecrease 	= -1.0
local panzerLightEffect 		= 0.8
local panzerHeavyEffect			= 0.6

oteItem = {
	-- head sensors
	["noHelmet"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "head0.png",
		shortName		= "No helmet",
		description		= "This slot is not used.",
		position		= "head",
		code			= "h0",
		goodHeroes		= {},
		badHeroes		= {"bug"},
		upgrade 		= function(defTable) 
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	["singleScope"] = {
		price 			= priceClass.cheap,
		icon			= itemIconsPath .. "headScope.png",
		shortName		= "Single Scope",
		description		= "Slightly increase Line Of Sight (LOS) of Hero.",
		position		= "head",
		code			= "hlls",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			local newLOS 			= defTable.sightDistance + 100
			defTable.sightDistance 	= newLOS
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, priceClass.cheap, 0, 0, 0, 0, 0},
	},
	["googolGlass"] = {
		price 			= priceClass.ultimate,
		icon			= itemIconsPath .. "headSuperScope.png",
		shortName		= "Googol Glass",
		description		= "Superexpensive long range scope which allows you to see tiny bunny in mouth of angry Spacebug for 50 miles.",
		position		= "head",
		code			= "hgls",
		goodHeroes		= {},
		badHeroes		= {"doc"},
		upgrade 		= function(defTable) 
			local newLOS 			= defTable.sightDistance + 400
			defTable.sightDistance 	= newLOS
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, priceClass.ultimate, 0, 0, 0, 0, 0},
	},
	["tinyRadarEmitor"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "headRadar.png",
		shortName		= "Tiny Radar Emitor",
		description		= "RADAR! Small distance radar emitor in nice metal helm. Nothing more, nothing less.",
		position		= "head",
		code			= "hetr",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			local radarDistance 		= 200
			defTable.radarDistance 		= radarDistance
			defTable.onoffable 			= 1
			defTable.activateWhenBuilt 	= 1				
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	["backupUnit"] = {
		price 			= priceClass.expensive,
		icon			= itemIconsPath .. "headBackUp.png",
		shortName		= "Back-up Unit",
		description		= "Memory cloud decrease spawn time of Hero.",
		position		= "head",
		code			= "hspw",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			local newSpawnTime 					= math.floor(defTable.customParams.spawnTime * 0.5)
			defTable.customParams.spawnTime 	= newSpawnTime	
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	
	-- weaponUps
	["noWeapon"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "weapon0.png",
		shortName		= "No weapon",
		description		= "This slot is not used.",
		position		= "weapon",
		code			= "w0",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	["duranthiumAmmo"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "weaponAmmo.png",
		shortName		= "Duranthium Ammo",
		description		= "Anti-armor shells - weaker a bit but same amount of dmg to armored enemies.",
		position		= "weapon",
		code			= "wdam",
		goodHeroes		= {},
		badHeroes		= {"bug"},
		upgrade 		= function(defTable)
			local newDefaultDmg	= defTable.damage.default * 0.8
			defTable.damage = {
				default =  newDefaultDmg,
				-- TODO: add all other classes the same dmg
			}
			return defTable
		end,
		upgInterpret	= {0, -priceClass.cheap, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	["dualReloader"] = {
		price 			= priceClass.expensive,
		icon			= itemIconsPath .. "weaponReload.png",
		shortName		= "Dual realoder",
		description		= "Upgrade which allows you to fire two times faster with worse aim.",
		position		= "weapon",
		code			= "wdrl",
		goodHeroes		= {},
		badHeroes		= {"bug"},		
		upgrade 		= function(defTable) 
			local newDefaultDmg	= defTable.damage.default * 0.6
			local newReload		= defTable.reloadtime * 0.5
			defTable.damage = {	
				default = newDefaultDmg,
			}
			defTable.reloadtime = newReload
			return defTable
		end,
		upgInterpret	= {0, -priceClass.cheap, priceClass.expensive, 0, 0, 0, 0, 0, 0, 0},
	},
	["gravitonShells"] = {
		price 			= priceClass.ultimate,
		icon			= itemIconsPath .. "weaponShells.png",
		shortName		= "Graviton Shells",
		description		= "Hit by shell add motion to target. Need some energy upkeep.",
		position		= "weapon",
		code			= "wgsh",
		goodHeroes		= {"bulk"},
		badHeroes		= {},		
		upgrade 		= function(defTable) 
			-- TODO: do effect
			-- add push
			-- decrease energy prod.
			return defTable
		end,
		upgInterpret	= {0, 0, priceClass.ultimate, 0, 0, 0, 0, 0, 0, -priceClass.cheap},
	},
	
	-- body
	["nobody"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "nobody.png",
		shortName		= "No body",
		description		= "This slot is not used.",
		position		= "body",
		code			= "b0",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	["panzerFront"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "panzerFront.png",
		shortName		= "Light front panzer",
		description		= "Panzer which increase armor of hero for direct attacks but decrease his speed a bit in exchange.",
		position		= "body",
		code			= "bfpz",
		goodHeroes		= {},
		badHeroes		= {"cam"},
		upgrade 		= function(defTable) 
			local newSpeed 	= defTable.maxVelocity + panzerLightSpeedDecrease
			local newHealth = defTable.maxDamage + 25
			defTable.maxVelocity 		= newSpeed
			defTable.flankingBonusMode	= 3
			defTable.flankingBonusDir	= {0.0, 0.0, 1.0}
			defTable.flankingBonusMax 	= 1.0
			defTable.flankingBonusMin 	= panzerLightEffect
			defTable.maxDamage			= newHealth
			return defTable
		end,
		upgInterpret	= {-priceClass.cheap, 0, 0, 0, 0, priceClass.moderate, 0, 0, 0, 0},
	},
	["standardRadarEmitor"] = {
		price 			= priceClass.expensive,
		icon			= itemIconsPath .. "bodyRadar.png",
		shortName		= "Standard Radar Emitor",
		description		= "RADAR! Powerfull scan device you!",
		position		= "body",
		code			= "bemr",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			local radarDistance 		= 900
			defTable.radarDistance 		= radarDistance		
			defTable.onoffable 			= 1
			defTable.activateWhenBuilt 	= 1	
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	["smallEnergyStorage"] = {
		price 			= priceClass.cheap,
		icon			= itemIconsPath .. "bodySmallEnergyStorage.png",
		shortName		= "Small Energy Storage",
		description		= "Additional auto-battery. Enough for recharging you cell phone.",
		position		= "body",
		code			= "bsme",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			local newEnergyStorage					= defTable.customParams.energyStorage + 100
			defTable.customParams.energyStorage 	= newEnergyStorage	
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, priceClass.cheap, 0, 0},
	},
	["bigEnergyStorage"] = {
		price 			= priceClass.expensive,
		icon			= itemIconsPath .. "bodyBigEnergyStorage.png",
		shortName		= "Big Energy Storage",
		description		= "Where others stop, we start. Bentoi battery for profi users.",
		position		= "body",
		code			= "bbge",
		goodHeroes		= {},
		badHeroes		= {"bug"},
		upgrade 		= function(defTable) 
			local newEnergyStorage					= defTable.customParams.energyStorage + 250
			defTable.customParams.energyStorage 	= newEnergyStorage	
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, priceClass.expensive, 0, 0},
	},
	["plasmaShieldEmitor"] = {
		price 			= priceClass.ultimate,
		icon			= itemIconsPath .. "bodyPlasmaShield.png",
		shortName		= "Plasma Shield Emitor",
		description		= "Ultimate solution for annonying plasma around your head.",
		position		= "body",
		code			= "bpsh",
		goodHeroes		= {},
		badHeroes		= {"bulk", "bug"},
		upgrade 		= function(defTable) 
			-- TODO: add plasma shield
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	["cloakEmitor"] = {
		price 			= priceClass.expensive,
		icon			= itemIconsPath .. "bodyCloakEmitor.png",
		shortName		= "Cloak Emitor",
		description		= "PREADOTOR mode! Mu ha ha ha ha!!!",
		position		= "body",
		code			= "becl",
		goodHeroes		= {},
		badHeroes		= {"bulk"},
		upgrade 		= function(defTable) 
			-- TODO: add shield
			-- energy consumption!
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, -priceClass.expensive},
	},
	["pathingUnit"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "bodySpeed.png",
		shortName		= "Pathing Unit",
		description		= "Generaly improve speed, especially in steep places.",
		position		= "body",
		code			= "bspd",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			local newSpeed 			= defTable.maxVelocity + panzerLightSpeedDecrease
			defTable.maxVelocity 	= newSpeed
			-- TODO: 
			-- ? add bonus in steep terrian? not now, maybe later
			return defTable
		end,
		upgInterpret	= {priceClass.cheap, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	["jammerEmitor"] = {
		price 			= priceClass.ultimate,
		icon			= itemIconsPath .. "bodyJammer.png",
		shortName		= "Jammer Emitor",
		description		= "Hide hero and all around him aside hungry enemy radar eyes. Cost huge amount of energy.",
		position		= "body",
		code			= "bejm",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			local newRadarDistanceJam 	= 50
			defTable.radarDistanceJam 	= newRadarDistanceJam	
			defTable.onoffable 			= 1
			defTable.activateWhenBuilt 	= 1				
			-- TODO: add jammer
			-- decrease energy production a lot
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, -priceClass.ultimate},
	},
	-- ["panzerRight"] = {
		-- price 			= priceClass.moderate,
		-- icon			= itemIconsPath .. "panzerRight.png",
		-- shortName		= "No helmet",
		-- description		= "No helmet",
		-- position		= "body",
		-- code			= "pr",
		-- goodHeroes		= {},
		-- badHeroes		= {},
		-- upgrade 		= function(defTable) 
			-- local newSpeed = defTable.maxVelocity + panzerLightSpeedDecrease
			-- defTable.maxVelocity 		= newSpeed
			-- defTable.flankingBonusMode	= 3,
			-- defTable.flankingBonusDir	= {-1.0, 0.0, 0.0},
			-- defTable.flankingBonusMax 	= 1.0,
			-- defTable.flankingBonusMin 	= panzerLightEffect,
			-- return defTable
		-- end,
		-- upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	-- },
	-- ["panzerUltimate"] = {
		-- price 			= priceClass.ultimate,
		-- icon			= itemIconsPath .. "panzerUltimate.png",
		-- shortName		= "No helmet",
		-- description		= "No helmet",
		-- position		= "body",
		-- code			= "pu",
		-- goodHeroes		= {},
		-- badHeroes		= {"cam"},
		-- upgrade 		= function(defTable) 
			-- local newSpeed = defTable.maxVelocity + panzerHeavySpeedDecrease
			-- defTable.maxVelocity 		= newSpeed
			-- defTable.flankingBonusMode	= 3,
			-- defTable.flankingBonusDir	= {0.0, 0.0, 1.0},
			-- defTable.flankingBonusMax 	= 1.0,
			-- defTable.flankingBonusMin 	= panzerHeavyEffect,
			-- return defTable
		-- end,
		-- upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	-- },
}

