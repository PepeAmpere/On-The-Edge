local defName  				= "minebasic"

local unitDef = {
--Internal settings
    BuildPic 				= "filename.bmp",
    Category 				= "MINE NOTAIR NOTMOVE",
    ObjectName 				= "tank3.s3o",
    name 					= "Generic mine",
    UnitName 				= defName,
    script 					= "minebasicscript.lua",
    
--Unit limitations and properties
    BuildTime 				= 0,
    Description 			= "A generic mine for minefield ability",
    MaxDamage 				= 32,
    RadarDistance 			= 0,
    SightDistance 			= 55,
    Upright 				= 0,
    
--Energy and metal related
    BuildCostEnergy 		= 0,
    BuildCostMetal 			= 0,
    
--Pathfinding and related
    FootprintX 				= 1,
    FootprintZ 				= 1,
    
--Abilities
    Builder 				= 0,
    CanAttack 				= 0,
    CanGuard 				= 0,
    CanMove 				= 0,
    CanPatrol 				= 0,
    CanStop 				= 0,
    LeaveTracks 			= 0,
    Reclaimable 			= 0,
	
--Special mine ability
	kamikaze 				= 1,
	kamikazeDistance		= 40,
	selfDestructCountdown 	= 1,
	initCloaked				= 1,
	cloakCost				= 0,
	minCloakDistance		= 10,
	stealth					= 0,
	idleTime				= 100,
	idleAutoHeal			= 0.5,
	selfDestructAs			= "selfexplosion",
    
--Hitbox
--    collisionVolumeOffsets    =  "0 0 0",
--    collisionVolumeScales     =  "20 20 20",
--    collisionVolumeTest       =  1,
--    collisionVolumeType       =  "box",
    
--Weapons and related
	weapons = {
		[1] = {
			def                	= "selfexplosion",
			BadTargetCategory 	= "NOTAIR",
			ExplodeAs 			= "TANKDEATH",
			NoChaseCategory 	= "AIR",
		},
	},
	weaponDefs = {
		selfexplosion = {
			name = "Mine self explosion",
			weapontype = "Cannon",
			accuracy = 0,
			areaofeffect = 130,
			avoidfeature = false,
			avoidfriendly = false,
			canattackground = true,
			collidefriendly = true,
			collisionsize = 8,
			commandfire = false,
			craterboost = 0.1,
			cratermult = 0.1,
			impulseFactor = 0.5,
			edgeeffectiveness = 0.1,
			firestarter = 50,
			intensity = 1,
			noselfdamage = false,
			size = 5,
			soundstart = "orangeblob_explo",
			soundhit = "orangeblob_explo",
			range = 480,
			reloadtime = 3.6,
			rgbcolor = "1.0 1.0 1.0",
			texture1 = "flame",
			explosiongenerator = "custom:TANKGUN_FX",
			damage = {
				default = 800,
			},
		},
	}
}

return lowerkeys({ [defName]  =  unitDef })