local defName  		= "towersmall"

local unitDef = {
--Internal settings
    BuildPic 		= "filename.bmp",
    Category 		= "BUG BUILDING",
    ObjectName 		= "towersmall.s3o",
    name 			= "Laser defence tower",
    Side 			= "REP",
    TEDClass 		= "TANK",
    UnitName 		= defName,
    script 			= "towersmall.lua",
    
--Unit limitations and properties
    BuildTime 		= 1000,
    Description 	= "Secondary defence",
    MaxDamage 		= 800,
    RadarDistance 	= 150,
    SightDistance 	= 400,
    SoundCategory 	= "TANK",
    Upright 		= 0,
    
--Energy and metal related
    BuildCostEnergy = 100,
    BuildCostMetal 	= 0,
    
--Abilities
    Builder 		= 0,
    CanAttack 		= 1,
    CanGuard 		= 0,
    CanMove 		= 0,
    CanPatrol 		= 0,
    CanStop 		= 1,
    LeaveTracks 	= 0,
    Reclaimable 	= 0,
    
--Hitbox
--    collisionVolumeOffsets    =  "0 0 0",
--    collisionVolumeScales     =  "20 20 20",
--    collisionVolumeTest       =  1,
--    collisionVolumeType       =  "box",
    
--Weapons and related
	weapons = {
		[1] = {
			def                	= "orangeblob",
			BadTargetCategory 	= "NOTAIR",
			ExplodeAs 			= "TANKDEATH",
			NoChaseCategory 	= "AIR",
		},
	},
	weaponDefs = {
		orangeblob = {
			name = "Orange Plasma Cannon",
			weapontype = "Cannon",
			accuracy = 10,
			areaofeffect = 100,
			avoidfeature = false,
			avoidfriendly = true,
			canattackground = true,
			collidefriendly = true,
			collisionsize = 8,
			commandfire = false,
			craterboost = 0,
			cratermult = 0,
			edgeeffectiveness = 0.1,
			explosionspeed = 128,
			firestarter = 100,
			gravityaffected = true,
			impulseboost = 0,
			impulsefactor = 0,
			intensity = 1,
			noselfdamage = true,
			size = 4,
			soundstart = "orangeblob_explo",
			soundhit = "orangeblob_explo",
			range = 250,
			reloadtime = 1.5,
			rgbcolor = "1.0 1.0 1.0",
			turret = true,
			texture1 = "flame",
			weaponvelocity = 400,
			explosiongenerator = "custom:TANKGUN_FX",
			damage = {
				default = 55,
			},
		},
	}
}

return lowerkeys({ [defName]  =  unitDef })
