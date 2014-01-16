------------------------------------------------------------------------------
-- OTE game info
-- keep all info about levels, experience, etc
------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name 	= "ote_game_info",
		desc 	= "Gadget keeping all important statistics",
		author 	= "PepeAmpere",
		date 	= "2014-01-16",
		license = "ote",
		layer 	= -255,
		enabled = true,
	}
end

-- TODO:
-- get msg, increase exp, cash, level counters
-- send message it was done, release action
-- function RecvLuaMsg(msg)
	-- Spring.Echo(Hello!)
-- end