----------------------------------------------------------
-- NOE modules loader
-- WIKI: http://code.google.com/p/nota/wiki/NOE_module_loader
----------------------------------------------------------

-- for easier customization and porting NOE framework
-- here just list files you want include in your NOE setup
-- ! WARRNING, overwrite of default content possible!

-- FILES BELOW WILL BE INCLUDED INTO NOE --

-----------------------------------------------------------
-- VITAL MANDATORY MODULES - general tools
	include "LuaRules/Configs/noe/modules/tools/noe_mex_finder.lua"
	include "LuaRules/Configs/noe/modules/tools/noe_build_space_finder.lua"
	include "LuaRules/Configs/noe/modules/tools/noe_mission_data_loader.lua"

-----------------------------------------------------------
-- OPTIONAL STUFF

-- actions --
	include "LuaRules/Configs/tsp/tsp_actions.lua"	
	
-- classes ---
	include "LuaRules/Configs/noe/modules/nota/noe1_classes.lua"
	
-- groups --
	include "LuaRules/Configs/noe/modules/nota/noe1_groups.lua"
	include "LuaRules/Configs/noe/modules/ote/ote_groups.lua"

-- side ---
	include "LuaRules/Configs/noe/modules/nota/noe1_side.lua"
	
-- spawn ---
	include "LuaRules/Configs/noe/modules/nota/noe1_spawn.lua"
