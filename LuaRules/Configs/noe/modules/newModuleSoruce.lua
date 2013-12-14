------------------------------------------------------------------------------
-- moduleName
-- more about groups on WIKI: the link
------------------------------------------------------------------------------

local moduleTable {
	
}

------------------------------------------------------------------------------
----------------------- END OF MODULE DEFINITIONS ----------------------------

-- update global tables 
-- ? replace _globalTable with given table
if (_globalTable == nil) then _globalTable = {} end
for k,v in pairs(moduleTable) do
	_globalTable[k] = v 
end