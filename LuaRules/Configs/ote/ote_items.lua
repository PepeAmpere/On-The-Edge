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
	["noHelmet"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "helm.png",
		shortName		= "No helmet",
		description		= "This slot is not used",
		position		= "head",
		code			= "h0",
		goodHeroes		= {},
		badHeroes		= {"bug"},
		upgrade 		= function(defTable) 
			return defTable
		end,
		upgInterpret	= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	
	-- weaponUps
	["noWeapon"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "weapon0.png",
		shortName		= "No weapon",
		description		= "This slot is not used",
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
		description		= "Anti-armor shells - weaker a bit but same amount of dmg to armored enemies",
		position		= "weapon",
		code			= "wa",
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
		description		= "Upgrade which allows you to fire two times faster with worse aim",
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
		upgInterpret	= {0, -priceClass.cheap, priceClass.expensive, 0, 0, 0, 0, 0, 0, 0},
	},
	
	-- body
	["nobody"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "nobody.png",
		shortName		= "No body",
		description		= "This slot is not used",
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
		description		= "Panzer which increase armor of hero for direct attacks but decrease his speed a bit in exchange",
		position		= "body",
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
		upgInterpret	= {0, 0, 0, 0, 0, priceClass.moderate, 0, 0, 0, 0},
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

