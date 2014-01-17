------------------------------------------------------------------------------
-- TSP definitions
-- more about actions on WIKI: http://code.google.com/p/nota/wiki/TSP_defs
-- more about TSP specific stuff: !TODO add
------------------------------------------------------------------------------

tspDef = {
	["example"] = {
		-- head
		description = "Some example power", 			-- description - not much long
		level		= 1,
		levelCap	= 1,
		
		-- GUI
		icon 		= "LuaUI/Images/something.png",  	-- path to icon
		
		-- cost
		cost		= {									-- resources cost of use TSP
			metal 			= 0,
			energy 			= 0,
			hydrocarbons 	= 0,
		},
		
		-- conditions and actions
		conditionsNames 			= {},				-- ?! only special addition conditions, reload/times of ability or stun of hero checked by executor
		conditionsParams 			= {}
		actionsNames 				= {},
		actionsParams 				= {},
		
		-- first use
		firstUseBlock				= false,			-- are there any conditions for approving first use of TSP
		firstUseConditionsNames		= {},
		firstUseConditionsParams	= {},
		firstAmount					= 1,				-- how power-uses possible on one reload (classic hero power = 1)
		
		-- reuse
		reloadable 					= false,  			-- if power can be reused = used more times then once
		reloadTime 					= {0,0,1},  		-- time for reload in h:m:s
		reloadCycles 				= -1,  				-- number of reloads (if -1, then infinite)
		-- reloadConditionsNames		= {},				-- ? (not needed now i think)
		-- reloadConditionsParams		= {},				-- ?		
		
		-- effects in time
		effectInTime				= false,			-- shall I generate events for effects active in time?
		effectStepTime				= {0,0,1},
		effectRepeatAmount			= 1,
		effectConditionsNames		= {},				-- ?! general condition, which you don't need to add here, is information about effect "isActive" checked by executor
		effectConditionsParams		= {},
		effectActionsNames 			= {},
		effectActionsParams 		= {},
		
	},
}



