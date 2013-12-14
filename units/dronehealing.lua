local defName		= "dronehealing"

local unitDef = {
--Internal settings
    BuildPic 		= "filename.bmp",
    Category 		= "NOTHERO NOTTOWER AIR CREEP",
    ObjectName 		= "tank3.s3o",
    name 			= "Healing drone",
    UnitName 		= defName,
    script 			= "dronehealingscript.lua",

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
    
--Pathfinding and related
    MovementClass 	= "Default2x2",
    
--Abilities
    Builder 		= 0,
    CanAttack 		= 0,
	CanRepair		= 1,
    CanGuard 		= 1,
    CanMove 		= 1,
    CanPatrol 		= 0,
    CanStop 		= 1,
    LeaveTracks 	= 0,
    Reclaimable 	= 1,
	CanFly			= 1,
    
--Hitbox
--    collisionVolumeOffsets    =  "0 0 0",
--    collisionVolumeScales     =  "20 20 20",
--    collisionVolumeTest       =  1,
--    collisionVolumeType       =  "box",
    
--Weapons and related
}

return lowerkeys({ [defName]  =  unitDef })