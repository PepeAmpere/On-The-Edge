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
		
	},
	["bulk"] = {
		statsClass 	= heroStats["bug"],
		bigImage	= heroUIimage["bug"],
		
	},
	["bulk"] = {
		statsClass 	= heroStats["bulk"],
		bigImage	= heroUIimage["bulk"],
		
	},
	["cam"] = {
		statsClass 	= heroStats["cam"],
		bigImage	= heroUIimage["cam"],
		
	},
	["doc"] = {
		statsClass 	= heroStats["doc"],
		bigImage	= heroUIimage["doc"],
		
	},
}