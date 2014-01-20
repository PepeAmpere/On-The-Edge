local defName  		= "ranger"

local unitDef = {
--Internal settings
    BuildPic 		= "filename.bmp",
    Category 		= "GROUND ARMY",
    ObjectName 		= "ranger.s3o",
    name 			= "Ranged recruit",
    Side 			= "REP",
    TEDClass 		= "TANK",
    UnitName 		= defName,
    script 			= "ranger.lua",
    
--Unit limitations and properties
    BuildTime 		= 1000,
    Description 	= "Ranged soldier",
    MaxDamage 		= 800,
    RadarDistance 	= 0,
    SightDistance 	= 500,
    SoundCategory 	= "TANK",
    Upright 		= 0,
    
--Energy and metal related
    BuildCostEnergy = 100,
    BuildCostMetal 	= 0,
    
--Pathfinding and related
	MaxVelocity		= 2.5,
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
   collisionVolumeOffsets    =  "0 0 0",
   collisionVolumeScales     =  "35 50 35",
   collisionVolumeTest       =  1,
   collisionVolumeType       =  "cylY",
    
--Weapons and related
	weapons = {
		[1] = {
			def                	= "rangermissile",
			BadTargetCategory 	= "NOTAIR",
			ExplodeAs 			= "TANKDEATH",
			NoChaseCategory 	= "",
		},
	},
	weaponDefs = {
		rangermissile = {
			name = "Rangers Missile",
			weapontype = "Cannon",
			accuracy = 10,
			areaofeffect = 10,
			avoidfeature = false,
			avoidfriendly = false,
			canattackground = true,
			collidefriendly = false,
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
			soundstart = "rocketlaunch2",
			soundhit = "orangeblob_explo",
			range = 450,
			reloadtime = 1.5,
			rgbcolor = "1.0 1.0 1.0",
			turret = true,
			texture1 = "flame",
			weaponvelocity = 400,
			explosiongenerator = "custom:TANKGUN_FX",
			-- smokeTrail = 1,
			-- tracks = 1,
			-- startVelocity = 0,
			-- acceleration = 0.5,
			-- turnRate = 35000,
			damage = {
				default = 35,
				herolight = 25,
				heromedium = 20,
				heroheavy = 15,
				-- TODO: make it by generator
			},
		},
	}
}

return lowerkeys({ [defName]  =  unitDef })
