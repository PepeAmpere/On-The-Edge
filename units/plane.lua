local defName  		= "plane"

local unitDef = {
--Internal settings
    BuildPic 		= "filename.bmp",
    Category 		= "AIR",
    ObjectName 		= "tank3.s3o",
    name 			= "Plane",
    UnitName 		= defName,
    script 			= "planescript.lua",
    
--Unit limitations and properties
    BuildTime 		= 0,
    Description 	= "Plane, used by airstrike ande scout abilites",
    MaxDamage 		= 10000,
    RadarDistance 	= 0,
    SightDistance 	= 400,
    Upright 		= 1,
    
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal 	= 0,
    
--Airflying
	MaxVelocity		= 10.5,
	BrakeRate		= 4,
	Acceleration	= 0.5,
	TurnRate		= 800,
	SteeringMode	= 1,
	ShootMe			= 1,
	CruiseAlt		= 300,
	Scale			= 1,
	BankScale		= 1,
    
--Abilities
    Builder 		= 0,
    CanAttack 		= 1,
    CanGuard 		= 0,
    CanMove 		= 1,
    CanPatrol 		= 1,
    CanStop 		= 1,
    LeaveTracks 	= 0,
    Reclaimable 	= 0,
	CanFly			= 1,
    
--Hitbox
--    collisionVolumeOffsets    =  "0 0 0",
--    collisionVolumeScales     =  "20 20 20",
--    collisionVolumeTest       =  1,
--    collisionVolumeType       =  "box",
    
--Weapons and related
	weapons = {
		[1] = {
			def                	= "airstrike",
			NoChaseCategory 	= "AIR",
		},
	},
	weaponDefs = {
		airstrike = {
			name = "airstrike",
			weapontype = "AircraftBomb",
			accuracy = 0.0,
			areaofeffect = 400,
			avoidfeature = false,
			avoidfriendly = false,
			canattackground = true,
			collidefriendly = true,
			collisionsize = 0.05,
			commandfire = true,
			craterboost = 0.0,
			cratermult = 0.1,
			edgeeffectiveness = 0.8,
			firestarter = 100,
			gravityaffected = false,
			impulseboost = 0,
			impulsefactor = 0,
			intensity = 1,
			noselfdamage = true,
			size = 15,
			soundstart = "orangeblob_explo",
			soundhit = "orangeblob_explo",
			range = 1000,
			reloadtime = 1.6,
			rgbcolor = "1.0 1.0 1.0",
			turret = true,
			texture1 = "flame",
			weaponvelocity = 400,
			explosiongenerator = "custom:TANKGUN_FX",
			damage = {
				default = 200,
			},
		},
	}
}

return lowerkeys({ [defName]  =  unitDef })