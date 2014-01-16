------------------------------------------------------------------------------
-- OTE HEROES
-- more about global settings on project site wiki https://github.com/OTE-AM/On-The-Edge/blob/master/wiki/design_detail.md
------------------------------------------------------------------------------

-- bigger value => better
local heroStats = {	-- speed, health, energy, armor, dmg, reload, range, los, spawn
	["ball"] 		= {1, 5, 4, 4, 2, 4, 2, 3, 4},
	["bug"] 		= {5, 4, 1, 4, 4, 3, 1, 5, 2},
	["bulk"] 		= {2, 3, 2, 3, 1, 5, 3, 2, 3},
	["cam"] 		= {3, 2, 3, 2, 3, 3, 3, 4, 2},
	["doc"] 		= {4, 1, 3, 3, 3, 2, 2, 2, 3},
}

local heroesTSPnames = {
	["ball"] 		= {"none1", "none2", "none3"},
	["bug"] 		= {"none1", "none2", "none3"},
	["bulk"] 		= {"none1", "none2", "none3"},
	["cam"] 		= {"none1", "none2", "none3"},
	["doc"] 		= {"none1", "none2", "none3"},
}

local heroUIpath 	= "LuaUI/oteUI/heroes256x256/"

heroClass = {
	["ball"] = {
		statsClass 	= heroStats["ball"],
		bigImage	= heroUIpath .. "ball.png",
		model		= "ball.s3o",
		script		= "ball.lua",
		description	= "Dumball",
		tsps		= heroesTSPnames["ball"],
		
		movement	= "HeroFat",
		footprint	= 5,
		
	},
	["bug"] = {
		statsClass 	= heroStats["bug"],
		bigImage	= heroUIpath .. "bug.png",
		model		= "bug3r.s3o",
		script		= "bug.lua",
		description	= "Angry bug",
		tsps		= heroesTSPnames["bug"],
		
		movement	= "HeroNormal",
		footprint	= 4,
		
	},
	["bulk"] = {
		statsClass 	= heroStats["bulk"],
		bigImage	= heroUIpath .. "bulk.png",
		model		= "bulk.s3o",
		script		= "bulk.lua",
		description	= "Mr. Bulk",
		tsps		= heroesTSPnames["bulk"],
		
		movement	= "HeroNormal",
		footprint	= 4,
		
	},
	["cam"] = {
		statsClass 	= heroStats["cam"],
		bigImage	= heroUIpath .. "cam.png",
		model		= "cam.s3o",
		script		= "cam.lua",
		description	= "Angry webcamera",
		tsps		= heroesTSPnames["cam"],
		
		movement	= "HeroNormal",
		footprint	= 4,
		
	},
	["doc"] = {
		statsClass 	= heroStats["doc"],
		bigImage	= heroUIpath .. "doc.png",
		model		= "doc.s3o",
		script		= "doc.lua",
		description	= "Crazy runner",
		tsps		= heroesTSPnames["doc"],
		
		movement	= "HeroSlim",
		footprint	= 3,
		
	},
}