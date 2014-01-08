local defName  		= "bug3"

local unitDef = {
--Internal settings
    BuildPic 		= "filename.bmp",
    Category 		= "BUG",
    ObjectName 		= "bug3.s3o",
    name 			= "bug",
    Side 			= "REP",
    TEDClass 		= "TANK",
    UnitName 		= defName,
    script 			= "bug3.lua",
    
--Unit limitations and properties
    BuildTime 		= 1000,
    Description 	= "Mighty warrior",
    MaxDamage 		= 800,
    RadarDistance 	= 0,
    SightDistance 	= 400,
    SoundCategory 	= "TANK",
    Upright 		= 0,
    
--Energy and metal related
    BuildCostEnergy = 100,
    BuildCostMetal 	= 0,
   
--Pathfinding and related
	MaxVelocity		= 4,
	BrakeRate		= 0.4,
	Acceleration	= 0.5,
    FootprintX 		= 2,
    FootprintZ 		= 2,
    MaxSlope 		= 30,
    MaxWaterDepth 	= 20,
    MovementClass 	= "Default2x2",
    TurnRate		= 900,
    
--Abilities
    Builder 		= 0,
    CanAttack 		= 1,
    CanGuard 		= 1,
    CanMove 		= 1,
    CanPatrol 		= 1,
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
