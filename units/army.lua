local allArmyUnits 	= {}

local names			= {
	"mortar",
}

for i=1,#names do
	local unitDefName 	= names[i]
	local unitDef = {
	--Internal settings
		BuildPic 		= "filename.bmp",
		Category 		= "BUILDING TOWER NOTAIR NOTSUB",
		ObjectName 		= unitDefName .. ".s3o",
		name 			= "Base stuff",
		Side 			= "REP",
		TEDClass 		= "TANK",
		UnitName 		= unitDefName,
		script 			= "template.lua",   

		maxDamage		= 1000,
		SightDistance 	= 500,
		canMove			= true,
	}
	
	allArmyUnits[unitDefName] = unitDef
end

return lowerkeys(allArmyUnits)