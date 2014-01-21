local allBaseDefs 	= {}

local names			= {
	"base_barracks",
	"base_barracks45",
	"base_bunker",
	"base_bunker22",
	"base_bunker45",
	"base_bunker_device",
	"base_bunker_device22",
	"base_bunker_device45",
	"base_main",
	"base_main45",
	"base_pipe",
	"base_pipe45",
	"base_repair_pad",
	"base_repair_pad45",
	"base_turbine",
	"base_turbine45",
	"wall_corner_inner",
	"wall_corner_inner_nest",
	"wall_corner_inner_nest45",
	"wall_corner_inner45",
	"wall_corner_outer",
	"wall_corner_outer_nest",
	"wall_corner_outer_nest45",
	"wall_corner_outer45",
	"wall_straight",
	"wall_straight_nest",
	"wall_straight_nest45",
	"wall_straight45",	
}

for i=1,#names do
	local unitDefName 	= names[i]
	local scriptName	= "template.lua"
	if (unitDefName == "base_turbine" or unitDefName == "base_turbine45") then scriptName = "base/turbine.lua" end
	local unitDef = {
	--Internal settings
		BuildPic 		= "filename.bmp",
		Category 		= "BUILDING TOWER NOTAIR NOTSUB",
		ObjectName 		= "base/" .. unitDefName .. ".s3o",
		name 			= "Base stuff",
		Side 			= "REP",
		TEDClass 		= "TANK",
		UnitName 		= unitDefName,
		script 			= scriptName,   

		maxDamage		= 4000,
		SightDistance 	= 500,
	}
	
	allBaseDefs[unitDefName] = unitDef
end

return lowerkeys(allBaseDefs)
