------------------------------------------------------------------------------
-- OTE conditions
-- more about conditions on WIKI: http://code.google.com/p/nota/wiki/NOE_conditions
-- place here anything that links to some content unique stuff (like unit, sound, table, ...)
------------------------------------------------------------------------------

local moduleCondtion {
	
}

------------------------------------------------------------------------------
----------------------- END OF MODULE DEFINITIONS ----------------------------

-- update global tables 
if (condition == nil) then condition = {} end
for k,v in pairs(moduleCondtion) do
	condition[k] = v 
end