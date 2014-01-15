------------------------------------------------------------------------------
-- OTE HEROES WEAPONS
-- weapons for heroes
------------------------------------------------------------------------------

local heroWeaponsIndex = {	
	["ball"] 		= 1,
	["bug"] 		= 2,
	["bulk"] 		= 3,
	["cam"] 		= 4,
	["doc"] 		= 5,
}

local heroWeaponsDefs = {	 --	ball, bug, bulk, cam, doc 
	name 				= { "long_beam", "big_bite", "heavy_mg", "paralyzer", "auto_pistol" },
	weapontype 			= { "BeamLaser", "Melee", "BeamLaser", "BeamLaser", "Cannon" },
	accuracy 			= { 10, 20, 10, 10, 10 },
	areaofeffect 		= { 100, 16, 100, 100, 100 },
	avoidfeature 		= { false, false, false, false, false },
	avoidfriendly 		= { true, true, true, true, true },
	canattackground 	= { true, true, true, true, true },
	collidefriendly 	= { true, true, true, true, true },
	collisionsize 		= { 8, 8, 8, 8, 8 },
	commandfire 		= { false, false, false, false, false },
	craterboost 		= { 0, 0, 0, 0, 0 },
	cratermult 			= { 0, 0, 0, 0, 0 },
	edgeeffectiveness 	= { 0.1, 0.1 ,0.1 ,0.1 ,0.1 },
	explosionspeed 		= { 128, 128, 128, 128, 128 },
	firestarter			= { 100, 100, 100, 100, 100 },
	gravityaffected 	= { true, true, true, true, true },
	impulseboost 		= { 0, 0, 0, 0, 0 },
	impulsefactor 		= { 0, 0, 0, 0, 0 },
	intensity 			= { 1, 1, 1, 1, 1 },
	noselfdamage 		= { true,true,true,true,true },
	size 				= { 4, 2, 4, 4, 4 },
	soundstart 			= { "orangeblob_explo", "orangeblob_explo", "orangeblob_explo", "orangeblob_explo", "orangeblob_explo" },
	soundhit 			= { "orangeblob_explo", "orangeblob_explo", "orangeblob_explo", "orangeblob_explo", "orangeblob_explo" },

	rgbcolor 			= { "1.0 1.0 1.0", "1.0 1.0 0.0", "1.0 1.0 1.0", "1.0 1.0 1.0", "0.1 0.6 1.0" },
	rgbcolor2 			= { "1.0 1.0 1.0", "1.0 0.6 0.0", "1.0 1.0 1.0", "1.0 1.0 1.0", "0.1 0.6 1.0" },
	turret 				= { true, true, true, true, true },
	texture1 			= { "flame", "flame", "flame", "flame", "flame" },
	weaponvelocity 		= { 800, 1000, 800, 800, 800 },
	explosiongenerator 	= { "custom:TANKGUN_FX", "custom:TANKGUN_FX", "custom:TANKGUN_FX", "custom:TANKGUN_FX", "custom:TANKGUN_FX" },

	range 				= { 400, 600, 400, 400, 400 },
	reloadtime 			= { 1.5, 0.08, 1.5, 1.5, 1.5 },
	damage 				= { {default = 55}, {default = 4}, {default = 55}, {default = 55}, {default = 55} },
}

-- final
heroWeapons = {}

for name,index in pairs(heroWeaponsIndex) do
	local newPrimaryWeapon = {}
	
	-- copy all values for given primary weapon
	for weaponAtribute,values in pairs(heroWeaponsDefs) do
		newPrimaryWeapon[weaponAtribute] = values[index]
	end
	
	-- export to main data structure
	heroWeapons[name] = newPrimaryWeapon
end