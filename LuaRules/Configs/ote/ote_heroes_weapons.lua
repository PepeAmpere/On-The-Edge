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
	weapontype 			= { "BeamLaser", "Melee", "LaserCannon", "BeamLaser", "Cannon" },
	accuracy 			= { 10, 10, 20, 10000, 50 },
	areaofeffect 		= { 20, 40, 2, 20, 2 },
	avoidfeature 		= { false, false, false, false, false },
	avoidfriendly 		= { false, false, false, false, false },
	burst				= { 1, 1, 1, 1, 3 },
	burstRate			= { 0.1, 0.1, 0.1, 0.1, 0.18 },
	canattackground 	= { true, true, true, true, true },
	collidefriendly 	= { false, false, false, false, false },
	collisionsize 		= { 8, 8, 8, 8, 2 },
	commandfire 		= { false, false, false, false, false },
	craterboost 		= { 0, 0, 0, 0, 0 },
	cratermult 			= { 0, 0, 0, 0, 0 },
	edgeeffectiveness 	= { 0.1, 0.1 ,0.1 ,0.1 ,0.1 },
	explosionspeed 		= { 128, 128, 128, 128, 256 },
	firestarter			= { 80, 0, 40, 0, 20 },
	gravityaffected 	= { true, true, true, true, true },
	impulseboost 		= { 0, 0, 0, 0, 0 },
	impulsefactor 		= { 0, 0, 0, 0, 0 },
	intensity 			= { 1, 1, 0.8, 1, 1 },
	noselfdamage 		= { true,true,true,true,true },
	size 				= { 4, 4, 2, 5, 4 },
	soundstart 			= { "bfglaser", "bite2", "bulk_mg_short", "laser2", "heavy_shot" },
	soundhit 			= { "", "", "", "", "" },

	rgbcolor 			= { "1.0 1.0 1.0", "1.0 1.0 0.0", "1.0 1.0 1.0", "1.0 1.0 1.0", "0.3 0.9 1.0" },
	rgbcolor2 			= { "1.0 1.0 1.0", "1.0 1.0 0.0", "1.0 0.6 0.0", "1.0 1.0 1.0", "1.0 1.0 1.0" },
	thickness 			= { 2, 2, 0.75, 2, 4 },
	turret 				= { true, true, true, true, true },
	texture1 			= { "flame", "flame", "flame", "flame", "flame" },
	weaponvelocity 		= { 800, 800, 1000, 800, 600 },
	explosiongenerator 	= { "custom:TANKGUN_FX", "custom:TANKGUN_FX", "", "custom:TANKGUN_FX", "" },

	range 				= { 400, 250, 650, 400, 400 },
	reloadtime 			= { 1.5, 1.5, 0.04, 1.5, 1.0 },
	damage 				= { {default = 35}, {default = 220}, {default = 6}, {default = 55}, {default = 20} },
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