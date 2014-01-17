------------------------------------------------------------------------------
-- OTE MUSIC
-- play music
------------------------------------------------------------------------------

function widget:GetInfo()
	return {
	name      = "OTE music",
	desc      = "Plays ote music",
	author    = "PepeAmpere, music Pepe Pelant",
	date      = "Jan 17, 2014",
	license   = "OTE license",
	layer     = 0,
	enabled   = true  --  loaded by default?
	}
end

local currentlyPlaying	= math.random(1,4)
local tracks = {
	[1] = {
		path 	= "sounds/notsorted/ontheedge1_1",
		lenght 	= {0,1,0},
	},
	[2] = {
		path 	= "sounds/notsorted/ontheedge1.mp3",
		lenght 	= {0,1,0},
	},
	[3] = {
		path 	= "sounds/notsorted/ontheedge1_1",
		lenght 	= {0,1,0},
	},
	[4] = {
		path 	= "sounds/notsorted/ontheedge1_1",
		lenght 	= {0,1,0},
	},
}