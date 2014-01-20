local defName  		= "towermain"

local unitDef = {
--Internal settings
    BuildPic 		= "filename.bmp",
    Category 		= "BUILDING TOWER NOTAIR NOTSUB",
    ObjectName 		= "towermain.s3o",
    name 			= "Main defence tower",
    Side 			= "REP",
    TEDClass 		= "TANK",
    UnitName 		= defName,
    script 			= "towermain.lua",
    
--Unit limitations and properties
    BuildTime 		= 1000,
    Description 	= "Defence tower with strong guided mortar weapon",
    MaxDamage 		= 6000,
    RadarDistance 	= 0,
    SightDistance 	= 650,
    SoundCategory 	= "TANK",
    Upright 		= 0,
	iconType		= "tower",
    
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
   collisionVolumeOffsets    =  "20 0 -20",
   collisionVolumeScales     =  "130 300 130",
   collisionVolumeTest       =  1,
   collisionVolumeType       =  "cylY",
    
--Weapons and related
	weapons = {
		[1] = {
			def                	= "mortar",
			BadTargetCategory 	= "NOTAIR",
			ExplodeAs 			= "TANKDEATH",
			NoChaseCategory 	= "AIR",
		},
	},
	weaponDefs = {
		mortar = {
			name = "Mortar tower weapon",
			weapontype = "Cannon",
			accuracy = 10,
			areaofeffect = 200,
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
			size = 10,
			soundstart = "grenade_launch",
			soundhit = "mortarhit",
			range = 750,
			reloadtime = 3.5,
			rgbcolor = "1.0 1.0 1.0",
			turret = true,
			texture1 = "flame",
			weaponvelocity = 400,
			explosiongenerator = "custom:TANKGUN_FX",
			damage = {
				default = 360,
			},
		},
	}
}

return lowerkeys({ [defName]  =  unitDef })
