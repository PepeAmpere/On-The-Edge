------------------------------------------------------------------------------
-- TSP conditions
-- more about conditions on WIKI: http://code.google.com/p/nota/wiki/NOE_conditions
------------------------------------------------------------------------------

local tspCondtion = {
	
}

------------------------------------------------------------------------------
----------------------- END OF MODULE DEFINITIONS ----------------------------

-- update global tables 
if (condition == nil) then condition = {} end
for k,v in pairs(tspCondtion) do
	condition[k] = v 
end