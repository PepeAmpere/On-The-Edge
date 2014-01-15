function widget:GetInfo()
	return {
		name      = "MAP - radar view",
		desc      = "Set radar view as defualt view at start of the game",
		author    = "PepeAmpere",
		date      = "11th November, 2012",
		license   = "BY-NC-SA",
		layer     = 0,
		enabled   = true --  loaded by default?
	}
end

function widget:GameStart()
	local _,_,spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
    if (not(spec)) then
		Spring.SendCommands('togglelos')
		Spring.SendCommands('toggleradarandjammer')
	else
	    Spring.Echo("AUTO-LOS: Removing AUTO-LOS (player is spectator)")
	    widgetHandler:RemoveWidget()
	end
end