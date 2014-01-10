------------------------------------------------------------------------------
-- OTE HEROES
-- more about global settings on project site wiki https://github.com/OTE-AM/On-The-Edge/blob/master/wiki/design_detail.md
------------------------------------------------------------------------------

-- bigger value => better
local heroStats = {	-- speed, health, energy, armor, dmg, reload, range, spawn
	["ball"] 		= {2, 5, 4, 4, 2, 4, 2, 4},
	["bug"] 		= {4, 4, 2, 4, 4, 3, 1, 2},
	["bulk"] 		= {3, 3, 2, 3, 1, 5, 3, 3},
	["cam"] 		= {3, 3, 3, 2, 3, 3, 3, 2},
	["doc"] 		= {5, 2, 3, 3, 3, 2, 2, 3},
}

local heroModel		= {
	["ball"] 		= "ball.s3o",
	["bug"] 		= "bug.s3o",
	["bulk"] 		= "bulk.s3o",
	["cam"] 		= "cam.s3o",
	["doc"] 		= "doc.s3o",
}

local heroUIpath 	= "LuaUI/oteUI/heroes256x256/"
local heroUIimage	= {
	["ball"] 		= "ball.png",
	["bug"] 		= "bug.png",
	["bulk"] 		= "bulk.png",
	["cam"] 		= "cam.png",
	["doc"] 		= "doc.png",
}

heroClass = {
	["ball"] = {
		statsClass 	= heroStats["ball"],
		bigImage	= heroUIpath .. heroUIimage["ball"],
		model		= heroModel["ball"],
		
	},
	["bug"] = {
		statsClass 	= heroStats["bug"],
		bigImage	= heroUIpath .. heroUIimage["bug"],
		model		= heroModel["bug"],
		
	},
	["bulk"] = {
		statsClass 	= heroStats["bulk"],
		bigImage	= heroUIpath .. heroUIimage["bulk"],
		model		= heroModel["bulk"],
		
	},
	["cam"] = {
		statsClass 	= heroStats["cam"],
		bigImage	= heroUIpath .. heroUIimage["cam"],
		model		= heroModel["cam"],
		
	},
	["doc"] = {
		statsClass 	= heroStats["doc"],
		bigImage	= heroUIpath .. heroUIimage["doc"],
		model		= heroModel["doc"]
		
	},
}