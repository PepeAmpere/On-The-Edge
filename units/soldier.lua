local defName  		= "soldier"

local unitDef = {
--Internal settings
    BuildPic 		= "filename.bmp",
    Category 		= "BUILDING TOWER NOTAIR NOTSUB",
    ObjectName 		= "soldier.s3o",
    name 			= "Basic soldier",
    Side 			= "REP",
    TEDClass 		= "TANK",
    UnitName 		= defName,
    script 			= "soldier.lua",
    
--Unit limitations and properties
    BuildTime 		= 1000,
    Description 	= "Basic warrior",
    MaxDamage 		= 400,
    RadarDistance 	= 0,
    SightDistance 	= 400,
    SoundCategory 	= "TANK",
    Upright 		= 0,
    
--Energy and metal related
    BuildCostEnergy = 100,
    BuildCostMetal 	= 0,
   
--Pathfinding and related
    Acceleration 	= 0.15,
    BrakeRate 		= 0.1,
    FootprintX 		= 2,
    FootprintZ 		= 2,
    MaxSlope 		= 15,
    MaxVelocity 	= 2.0,
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
			def                	= "riotgun",
			BadTargetCategory 	= "NOTAIR",
			ExplodeAs 			= "TANKDEATH",
			NoChaseCategory 	= "AIR",
		},
	},
	weaponDefs = {
		riotgun = {
			name = "Plasma Shotgun",
			weapontype = "Cannon",
			accuracy = 10,
			areaofeffect = 1,
			avoidfeature = false,
			avoidfriendly = false,
			beamtime = 0.15,
			burst = 4,
			burstRate = 0.12, 
			canattackground = true,
			collidefriendly = false,
			collisionsize = 1,
			commandfire = false,
			craterboost = 0,
			cratermult = 0,
			edgeeffectiveness = 0.1,
			explosionspeed = 128,
			firestarter = 100,
			gravityaffected = true,
			impulseboost = 0.0,
			impulsefactor = 0.0,
			laserflaresize = 20,
			intensity = 0.5,
			impactonly = 1,
			noselfdamage = true,
			size = 2,
			soundstart = "smg",
			soundhit = "",
			range = 240,
			reloadtime = 0.7,
			rgbcolor = "1.0 0.6 0.6",
			turret = true,
			texture1 = "flame",
			thickness = 2.5,
			weaponvelocity = 500,
			explosiongenerator = "",
			damage = {
				default = 2,
				-- TODO: make it by generator
			},
		},
	}
}

return lowerkeys({ [defName]  =  unitDef })
