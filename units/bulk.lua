local defName  		=  "Bulk"

local unitDef  =  {
--Internal settings
    BuildPic 		= "filename.bmp",
    Category 		= "TANK SMALL NOTAIR NOTSUB",
    ObjectName 		= "bulk.S3O",
    name 			= "Bulk",
    Side 			= "REP",
    TEDClass 		= "TANK",
    UnitName 		= defName,
    script 			= "bulk.lua",
    
--Unit limitations and properties
    BuildTime 		= 1000,
    Description 	= "Defender",
    MaxDamage 		= 800,
    RadarDistance 	= 0,
    SightDistance 	= 400,
    SoundCategory 	= "",
    Upright 		= 0,
    
--Energy and metal related
    BuildCostEnergy = 100,
    BuildCostMetal 	= 0,
    
--Pathfinding and related
    Acceleration 	= 0.15,
    BrakeRate 		= 0.1,
    FootprintX 		= 4,
    FootprintZ 		= 4,
    MaxSlope 		= 15,
    MaxVelocity 	= 2.0,
    MaxWaterDepth 	= 20,
    MovementClass 	= "HeroNormal",
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
			def                	= "bulk_mg",
			BadTargetCategory 	= "NOTAIR",
			ExplodeAs 			= "TANKDEATH",
			NoChaseCategory 	= "AIR",
		},
	},
	weaponDefs = {
		bulk_mg = {
			name = "Bulk machine gun",
			weapontype = "Cannon",
			accuracy = 20,
			areaofeffect = 16,
			avoidfeature = false,
			avoidfriendly = true,
			beamweapon = 1,
			canattackground = true,
			collidefriendly = true,
			collisionsize = 4,
			commandfire = false,
			craterboost = 0,
			cratermult = 0,
			-- cylindertargeting = 0.2,
			edgeeffectiveness = 0.1,
			explosionspeed = 128,
			firestarter = 100,
			gravityaffected = true,
			impulseboost = 0,
			impulsefactor = 0,
			intensity = 0.8,
			noselfdamage = true,
			size = 2,
			soundstart = "orangeblob_explo",
			soundhit = "orangeblob_explo",
			range = 600,
			reloadtime = 0.08,
			rgbcolor = "1.0 1.0 0.0",
			rgbcolor2 = "1.0 0.6 0.0",
			sprayangle = 512,
			-- thickness = 0.50,
			turret = true,
			tolerance = 800,
			texture1 = "flame",
			weaponvelocity = 1000,
			-- explosiongenerator = "custom:TANKGUN_FX",
			damage = {
				default = 4,
			},
		},
	}
}

return lowerkeys({ [defName]  =  unitDef })
