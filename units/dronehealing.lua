local defName		= "dronehealing"

local unitDef = {
--Internal settings
    BuildPic 		= "filename.bmp",
    Category 		= "NOTHERO NOTTOWER AIR CREEP",
    ObjectName 		= "tank3.s3o",
    name 			= "Healing drone",
    UnitName 		= defName,
    script 			= "drone.lua",

--Unit limitations and properties
    BuildTime 		= 0,
    Description 	= "Healing drone for hero.",
    MaxDamage 		= 200,
    RadarDistance 	= 0,
    SightDistance 	= 200,
    Upright 		= 0,

--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal 	= 0,

--Airflying
	MaxVelocity		= 5.2,
	BrakeRate		= 4,
	Acceleration	= 0.2,
	TurnRate		= 800,
	SteeringMode	= 1,
	ShootMe			= 1,
	CruiseAlt		= 100,
	Scale			= 1,
	BankScale		= 1,
    
--Abilities
    Builder 		= 1,
    CanAttack 		= 0,
	CanRepair		= 1,
    CanGuard 		= 1,
    CanMove 		= 1,
    CanPatrol 		= 0,
    CanStop 		= 1,
    LeaveTracks 	= 0,
    Reclaimable 	= 1,
	CanFly			= 1,
    
	WorkerTime		= 1, 
--Hitbox
--    collisionVolumeOffsets    =  "0 0 0",
--    collisionVolumeScales     =  "20 20 20",
--    collisionVolumeTest       =  1,
--    collisionVolumeType       =  "box",
    
--Weapons and related
}

return lowerkeys({ [defName]  =  unitDef })