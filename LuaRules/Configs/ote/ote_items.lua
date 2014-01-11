------------------------------------------------------------------------------
-- OTE ITEMS
-- more about global settings on project site wiki https://github.com/OTE-AM/On-The-Edge/blob/master/wiki/design_detail.md
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
	moderate	= 2,
	expensive	= 3,
	ultimate	= 5,	
}
local panzerLightSpeedDecrease 	= -0.4
local panzerHeavySpeedDecrease 	= -1.0
local panzerLightEffect 		= 0.8
local panzerHeavyEffect			= 0.6

oteItem = {
	-- head sensors
	["simpleHelmet"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "helm.png",
		position		= "head",
		code			= "h0",
		goodHeroes		= {},
		badHeroes		= {"bug"},
		upgrade 		= function(defTable) 
			return defTable
		end,
	},
	
	-- weaponUps
	["basicWeapon"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "weapon0.png",
		position		= "weapon",
		code			= "w0",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			return defTable
		end,
	},
	["duranthiumAmmo"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "weaponAmmo.png",
		position		= "weapon",
		code			= "wa",
		goodHeroes		= {},
		badHeroes		= {"bug"},
		upgrade 		= function(defTable)
			local newDefaultDmg	= defTable.damage.default * (1 + damageWeaponUpgradePerPrice.moderate)
			defTable.damage = {
				default =  newDefaultDmg,
			}
			return defTable
		end,
	},
	["dualReloader"] = {
		price 			= priceClass.expensive,
		icon			= itemIconsPath .. "weaponReload.png",
		position		= "weapon",
		code			= "wl",
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
	},
	
	-- chest
	["noChest"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "noChest.png",
		position		= "chest",
		code			= "ch0",
		goodHeroes		= {},
		badHeroes		= {},
		upgrade 		= function(defTable) 
			return defTable
		end,
	},
	["panzerFront"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "panzerFront.png",
		position		= "chest",
		code			= "pf",
		goodHeroes		= {},
		badHeroes		= {"cam"},
		upgrade 		= function(defTable) 
			local newSpeed = defTable.maxVelocity + panzerLightSpeedDecrease
			defTable.maxVelocity 		= newSpeed
			defTable.flankingBonusMode	= 3
			defTable.flankingBonusDir	= {0.0, 0.0, 1.0}
			defTable.flankingBonusMax 	= 1.0
			defTable.flankingBonusMin 	= panzerLightEffect
			return defTable
		end,
	},
	-- ["panzerRight"] = {
		-- price 			= priceClass.moderate,
		-- icon			= itemIconsPath .. "panzerRight.png",
		-- position		= "chest",
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
	-- },
	-- ["panzerUltimate"] = {
		-- price 			= priceClass.ultimate,
		-- icon			= itemIconsPath .. "panzerUltimate.png",
		-- position		= "chest",
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
	-- },
}

