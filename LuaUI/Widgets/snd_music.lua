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

local currentlyPlaying	= 1
local tracks = {
	[1] = {
		path 	= "sounds/notsorted/ontheedge1_1.ogg",
		lenght 	= {0,2,26},
	},
	[2] = {
		path 	= "sounds/notsorted/ontheedge2_2.ogg",
		lenght 	= {0,7,58},
	},
}