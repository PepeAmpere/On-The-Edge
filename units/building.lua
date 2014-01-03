local defName  		= "building"

local unitDef = {
--Internal settings
    BuildPic 		= "filename.bmp",
    Category 		= "BUILDING TOWER NOTAIR NOTSUB",
    ObjectName 		= "building_dummy.dae",
    name 			= "Basic building",
    Side 			= "REP",
    TEDClass 		= "TANK",
    UnitName 		= defName,
    script 			= "building.lua",
    
--Unit limitations and properties
    BuildTime 		= 1000,
    Description 	= "Some basic base stuff",
    MaxDamage 		= 800,
    RadarDistance 	= 0,
    SightDistance 	= 400,
    SoundCategory 	= "TANK",
    Upright 		= 0,
    
--Energy and metal related
    BuildCostEnergy = 100,
    BuildCostMetal 	= 0,
   
--Abilities
    Builder 		= 0,
    CanAttack 		= 1,
    CanGuard 		= 1,
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
}

return lowerkeys({ [defName]  =  unitDef })
