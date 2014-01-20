local armorDefs = {
	buglight = {
		"bug1",
	},
	herolight = {
		"doc",
	},
	heromedium = {
		"cam", "bulk",
	},
	heroheavy = {
		"bug", "ball",
	},
	-- TODO: do armro for generated heroes
	-- HERE ADD OTHER ARMOR CLASSES
}

-- just fix to make it work for older engines (before 95) and 95+ newer
local oldStyle = true
if (Game ~= nil and (tonumber(Game.version) >= 95)) then
	oldStyle = false
end

-- this convert subtables from list of strings to hast tables "string" -> 99
local oldArmors = {}
if (oldStyle) then
	for k,v in pairs(armorDefs) do
		oldArmors[k] = {}
		local subtableForConvertion = v
		
		for i=1,#subtableForConvertion do
			local unitName = subtableForConvertion[i]
			oldArmors[k][unitName] = 99
		end
	end
	
	return oldArmors
end
-- end of fix

return armorDefs
