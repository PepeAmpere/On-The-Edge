-------------------------------------------------------------
-------------------- NOE modules loader ---------------------
-------------------------------------------------------------
-- WIKI: http://code.google.com/p/nota/wiki/NOE_module_loader


-- for easier customization and porting NOE framework
-- here just list files you want include in your NOE setup
-- ! WARRNING, overwrite of default content possible!

-- FILES BELOW WILL BE INCLUDED TO NOE --

-- groups --
include "LuaRules/Configs/noe/modules/nota/noe1_groups.lua"
include "LuaRules/Configs/noe/modules/ote/ote_groups.lua"

-- actions --
include "LuaRules/Configs/tsp/tsp_actions.lua"
