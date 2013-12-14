-- GROUPS of OTE

moduleGroupDefs = {
	-- empty now
}

---- update groups table ----
if (groupDefs == nil) then groupDefs = {} end
for k,v in pairs(moduleGroupDefs) do
	groupDefs[k] = v 
end