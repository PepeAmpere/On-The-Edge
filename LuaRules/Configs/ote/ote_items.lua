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

local damageLaserUpgradePerPrice = {
	free 		= 0,
	cheap 		= 2,
	moderate	= 5,
	expensive	= 8,
	ultimate	= 11,
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
	["laserRifle"] = {
		price 			= priceClass.free,
		icon			= itemIconsPath .. "laser1.png",
		position		= "weapon",
		upgrade 		= {},
	},
	["laserCutter"] = {
		price 			= priceClass.moderate,
		icon			= itemIconsPath .. "laser2.png",
		position		= "weapon",
		upgrade 		= {
			damage = damageLaserUpgradePerPrice.moderate,
		},
	},
	["laserGrinder"] = {
		price 			= priceClass.expensive,
		icon			= itemIconsPath .. "laser3.png",
		position		= "weapon",
		upgrade 		= {
			damage 	= -damageLaserUpgradePerPrice.cheap,
			reload	= 0.5,
		},
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
	},
}