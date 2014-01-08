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
	-- weaponUps
	["basicWeapon"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "laser1.png",
		position		= "weapon",
		upgrade 		= {},
		goodHeroes		= {},
		badHeroes		= {},
	},
	["duranthiumAmmo"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "laser2.png",
		position		= "weapon",
		upgrade 		= {
			damage = 1+damageWeaponUpgradePerPrice.moderate,
		},
		goodHeroes		= {},
		badHeroes		= {"bug"},
	},
	["dualReloader"] = {
		price 			= priceClass.expensive,
		icon			= itemIconsPath .. "laser3.png",
		position		= "weapon",
		upgrade 		= {
			damage 	= 1-damageWeaponUpgradePerPrice.cheap,
			reload	= 0.5,
		},
		goodHeroes		= {},
		badHeroes		= {"bug"},
	},
	
	-- armorUps
	["panzerFront"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "panzerFront.png",
		position		= "chest",
		upgrade 		= {
			speed				= panzerLightSpeedDecrease,
			flankingBonusMode	= 3,
			flankingBonusDir	= {0.0, 0.0, 1.0},
			flankingBonusMax 	= 1.0,
			flankingBonusMin  	= panzerLightEffect,
		},
		goodHeroes		= {},
		badHeroes		= {"cam"},
	},
	["panzerRear"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "panzerRear.png",
		position		= "chest",
		upgrade 		= {
			speed				= panzerLightSpeedDecrease,
			flankingBonusMode	= 3,
			flankingBonusDir	= {0.0, 0.0, -1.0},
			flankingBonusMax 	= 1.0,
			flankingBonusMin  	= panzerLightEffect,
		},
		goodHeroes		= {},
		badHeroes		= {},
	},
	["panzerRight"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "panzerRight.png",
		position		= "chest",
		upgrade 		= {
			speed				= panzerLightSpeedDecrease,
			flankingBonusMode	= 3,
			flankingBonusDir	= {-1.0, 0.0, 0.0},
			flankingBonusMax 	= 1.0,
			flankingBonusMin  	= panzerLightEffect,
		},
		goodHeroes		= {},
		badHeroes		= {},
	},
	["panzerLeft"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "panzerLeft.png",
		position		= "chest",
		upgrade 		= {
			speed				= panzerLightSpeedDecrease,
			flankingBonusMode	= 3,
			flankingBonusDir	= {1.0, 0.0, 0.0},
			flankingBonusMax 	= 1.0,
			flankingBonusMin  	= panzerLightEffect,
		},
		goodHeroes		= {},
		badHeroes		= {},
	},
	["panzerUltimate"] = {
		price 			= priceClass.ultimate,
		icon			= itemIconsPath .. "panzerUltimate.png",
		position		= "chest",
		upgrade 		= {
			speed				= panzerHeavySpeedDecrease,
			flankingBonusMode	= 3,
			flankingBonusDir	= {0.0, 0.0, 1.0},
			flankingBonusMax 	= 1.0,
			flankingBonusMin  	= panzerHeavyEffect,
		},
		goodHeroes		= {},
		badHeroes		= {"cam"},
	},
}