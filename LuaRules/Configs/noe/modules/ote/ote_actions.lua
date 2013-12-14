------------------------------------------------------------------------------
-- OTE actions
-- more about actions on WIKI: http://code.google.com/p/nota/wiki/NOE_actions
-- place here anything that links to some content unique stuff (like unit, sound, table, ...)
------------------------------------------------------------------------------

local moduleAction {
	
}

------------------------------------------------------------------------------
----------------------- END OF MODULE DEFINITIONS ----------------------------

-- update global tables 
if (action == nil) then action = {} end
for k,v in pairs(moduleAction) do
	action[k] = v 
end