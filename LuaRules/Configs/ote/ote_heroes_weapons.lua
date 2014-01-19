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
	accuracy 			= { 10, 10, 20, 10, 10 },
	areaofeffect 		= { 100, 100, 16, 100, 20 },
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
	intensity 			= { 1, 1, 0.4, 1, 1 },
	noselfdamage 		= { true,true,true,true,true },
	size 				= { 4, 4, 2, 5, 8 },
	soundstart 			= { "bfglaser", "bite2", "heavy_shot", "laser2", "heavy_shot" },
	--soundhit 			= { "orangeblob_explo", "orangeblob_explo", "orangeblob_explo", "orangeblob_explo", "orangeblob_explo" },

	rgbcolor 			= { "1.0 1.0 1.0", "1.0 1.0 0.0", "1.0 1.0 1.0", "1.0 1.0 1.0", "0.1 0.8 0.6" },
	rgbcolor2 			= { "1.0 1.0 1.0", "1.0 1.0 0.0", "1.0 0.6 0.0", "1.0 1.0 1.0", "0.1 0.8 0.6" },
	turret 				= { true, true, true, true, true },
	texture1 			= { "flame", "flame", "flame", "flame", "flame" },
	weaponvelocity 		= { 800, 800, 1000, 800, 800 },
	explosiongenerator 	= { "custom:TANKGUN_FX", "custom:TANKGUN_FX", "custom:TANKGUN_FX", "custom:TANKGUN_FX", "custom:TANKGUN_FX" },

	range 				= { 400, 150, 700, 400, 500 },
	reloadtime 			= { 1.5, 1.5, 0.04, 1.5, 0.5 },
	damage 				= { {default = 55}, {default = 55}, {default = 8}, {default = 55}, {default = 25} },
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