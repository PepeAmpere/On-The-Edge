----- mission formations settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newFormationBySpirit = {
	["defaultSpirit"]           = "pentagram",
}

newFormationNames = {"pentagram"}

newFormationDef = {
    ["pentagram"] = {name = "pentagram", limit = 5, scales = {20,20}, gen = true, hilly = 60, constrained = true, variant = false, rotable = true, rotations = 16, rotationCheckDistance = 2000},
}

newFormations = {
    ["pentagram"] = { 
	    [1]  = {0,3},
		[2]  = {2,1}, 
		[3]  = {-2,1}, 
		[4]  = {1,-2},
		[5]  = {-1,-2},
	},
}

newFormationsGeneration = {
	["pentagram"] = function(limit) 
	    OnlyScaling("pentagram",limit)
	end,
}