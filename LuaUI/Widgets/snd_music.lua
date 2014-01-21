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
		lenghtS	= 146,
	},
	[2] = {
		path 	= "sounds/notsorted/ontheedge2_2.ogg",
		lenght 	= {0,7,58},
		lenghtS	= 478,
	},
}

function widget:Initialize()
	Spring.StopSoundStream()
	Spring.PlaySoundStream(tracks[math.random(1,2)].path, 0.25)
end

function widget:GameFrame(n)
	if (n == tracks[1].lenghtS*30) then
		Spring.StopSoundStream()
		Spring.PlaySoundStream(tracks[2].path, 0.3)
	end
	if (n == tracks[1].lenghtS*30 + tracks[2].lenghtS*30) then
		Spring.StopSoundStream()
		Spring.PlaySoundStream(tracks[1].path, 0.3)
	end
	if (n == tracks[1].lenghtS*30 + 2*tracks[2].lenghtS*30) then
		Spring.StopSoundStream()
		Spring.PlaySoundStream(tracks[1].path, 0.3)
	end
	if (n == 2*tracks[1].lenghtS*30 + 2*tracks[2].lenghtS*30) then
		Spring.StopSoundStream()
		Spring.PlaySoundStream(tracks[1].path, 0.3)
	end
	if (n == 2*tracks[1].lenghtS*30 + 3*tracks[2].lenghtS*30) then
		Spring.StopSoundStream()
		Spring.PlaySoundStream(tracks[1].path, 0.3)
	end
	if (n == 3*tracks[1].lenghtS*30 + 3*tracks[2].lenghtS*30) then
		Spring.StopSoundStream()
		Spring.PlaySoundStream(tracks[1].path, 0.3)
	end
end