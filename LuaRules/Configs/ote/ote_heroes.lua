------------------------------------------------------------------------------
-- OTE HEROES
-- more about global settings on project site wiki https://github.com/OTE-AM/On-The-Edge/blob/master/wiki/design_detail.md
------------------------------------------------------------------------------

-- bigger value => better
local heroStats = {	-- speed, health, energy, armor, dmg, reload, range, spawn
	["ball"] 		= {2, 5, 4, 4, 2, 4, 2, 4},
	["bulk"] 		= {3, 3, 2, 3, 1, 5, 3, 3},
	["cam"] 		= {3, 3, 3, 2, 3, 3, 3, 2},
	["other"] 		= {},
}

heroClass = {
	["ball"] = {
		statsClass 	= heroStats["ball"],
		
	},
	["bulk"] = {
		statsClass 	= heroStats["bulk"],
		badItemsList 	= {
			"laserRifle",
			"laserCutter",
			"laserGrinder",
		},
		
	},
	["cam"] = {
		statsClass 		= heroStats["cam"],
		badItemsList 	= {
			"laserRifle",
			"laserCutter",
			"laserGrinder",
			"panzerFront",
			"panzerUltimate",
		},
	},
	["other"] = {
		statsClass 	= heroStats["other"],
		
	},
}