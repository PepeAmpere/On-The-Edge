------------------------------------------------------------------------------
-- SPAWN NOE 1.0
-- more about groups on WIKI: http://code.google.com/p/nota/wiki/NOE_spawn
------------------------------------------------------------------------------

local moduleSpawnDef = {
    -- single unit --
    ["peewee"] = {unit = "armpw", class = "single"},
	-- buildingsSet with own formation and own names --
	["corDefencePoint"] = {
	    class = "buildingsSet",
		list  = {
		    -- main big gun oh yea!
		    {unit = "cortoast", relX = 0, relZ = 0, class = "single"},
			-- two heavy lasers for killing hard stuff
			{unit = "corvipe", relX = 100, relZ = 40, class = "single"},
			{unit = "corvipe", relX = -100, relZ = 40, class = "single"},
			-- three llts for scums
			{name = "corLltDragged", relX = 240, relZ = 0, class = "buildingsSet"},
			{name = "corLltDragged", relX = -240, relZ = 0, class = "buildingsSet"},
			{name = "corLltDragged", relX = 0, relZ = 200, class = "buildingsSet"},
			-- two expensive and three cheap peaces of AA defence
			{unit = "corrl", relX = 100, relZ = -120, class = "single"},
			{unit = "corrl", relX = -100, relZ = -120, class = "single"},
			{unit = "dca", relX = 160, relZ = 120, class = "single"},
			{unit = "dca", relX = -160, relZ = 120, class = "single"},
			{unit = "dca", relX = -320, relZ = -40, class = "single"},
			{unit = "dca", relX = 320, relZ = -40, class = "single"},
			-- one test wall --
			--{name = "corFullWall-H-200", relX = 0, relZ = 300, class = "buildingsSet"},
		}, 
	},
	["corLltDragged"] = {
	    class = "buildingsSet",
		list  = {
			-- llt + drags around
			{unit = "corllt", relX = 0, relZ = 0, class = "single"},
			{unit = "cordrag", relX = -10, relZ = 30, class = "single"},
			{unit = "cordrag", relX = 10, relZ = 30, class = "single"},
			{unit = "cordrag", relX = -30, relZ = 10, class = "single"},
			{unit = "cordrag", relX = -30, relZ = -10, class = "single"},
			{unit = "cordrag", relX = 30, relZ = 10, class = "single"},
			{unit = "cordrag", relX = 30, relZ = -10, class = "single"},
			{unit = "cordrag", relX = -10, relZ = -30, class = "single"},
			{unit = "cordrag", relX = 10, relZ = -30, class = "single"},
		}, 
	},
	["armLltDragged"] = {
	    class = "buildingsSet",
		list  = {
			-- llt + drags around
			{unit = "armllt", relX = 0, relZ = 0, class = "single"},
			{unit = "armdrag", relX = -10, relZ = 30, class = "single"},
			{unit = "armdrag", relX = 10, relZ = 30, class = "single"},
			{unit = "armdrag", relX = -30, relZ = 10, class = "single"},
			{unit = "armdrag", relX = -30, relZ = -10, class = "single"},
			{unit = "armdrag", relX = 30, relZ = 10, class = "single"},
			{unit = "armdrag", relX = 30, relZ = -10, class = "single"},
			{unit = "armdrag", relX = -10, relZ = -30, class = "single"},
			{unit = "armdrag", relX = 10, relZ = -30, class = "single"},
		}, 
	},
    ["armMGAA3x"] = {
	    class = "buildingsSet",
		list  = {
			-- 3 AA machine guns
			{unit = "armcrach", relX = 0, relZ = 400, class = "single"},
			{unit = "armcrach", relX = -300, relZ = -200, class = "single"},
			{unit = "armcrach", relX = 300, relZ = -200, class = "single"},
		}, 
	},
	["corFullWall-H-200"] = {
	    class = "buildingsSet",
		list  = {
			-- horizontal wall 10 teeth
			{unit = "cordrag", relX = -100, relZ = 0, class = "single"},
			{unit = "cordrag", relX = -80, relZ = 0, class = "single"},
			{unit = "cordrag", relX = -60, relZ = 0, class = "single"},
			{unit = "cordrag", relX = -40, relZ = 0, class = "single"},
			{unit = "cordrag", relX = -20, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 0, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 20, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 40, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 60, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 80, relZ = 0, class = "single"},
			{unit = "cordrag", relX = 100, relZ = 0, class = "single"},
		}, 
	},
	--- one type unit set with formation definined in noe_formations.lua
    ["peeweeGang"] = {
	    class     = "oneTypeSet",
		count     = 20,
		formation = "swarm",
		scale     = 1,
		unit      = "armpw",
	},
	["hammerGang"] = {
	    class     = "oneTypeSet",
		count     = 20,
		formation = "swarm",
		scale     = 1,
		unit      = "armham",
	},
    ["rockoGang"] = {
	    class     = "oneTypeSet",
		count     = 20,
		formation = "swarm",
		scale     = 1,
		unit      = "armrock",
	},
	["bulldogGang"] = {
	    class     = "oneTypeSet",
		count     = 10,
		formation = "swarm",
		scale     = 1,
		unit      = "armbull",
	},
}

------------------------------------------------------------------------------
----------------------- END OF MODULE DEFINITIONS ----------------------------

-- update global tables 
if (spawnDef == nil) then spawnDef = {} end
for k,v in pairs(moduleSpawnDef) do
	spawnDef[k] = v 
end

