local defName		= "dronehealing"

local allBaseDefs 	= {}

local names			= {}
for i=1,5 do
	names[i] = defName .. i
end

for i=1,#names do
	local unitDefName 	= names[i]
	local unitDef = {
	--Internal settings
		UnitName 		= unitDefName, 

		maxDamage		= i*200,
		SightDistance 	= 500,
		BuildPic 		= "filename.bmp",
		Category 		= "NOTHERO NOTTOWER AIR CREEP",
		ObjectName 		= "tank3.s3o",
		name 			= "Healing drone",
		script 			= "dronehealing.lua",

	--Unit limitations and properties
		BuildTime 		= 0,
		Description 	= "Healing drone for hero.",
		RadarDistance 	= 0,
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
		CruiseAlt		= 250,
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
		
		WorkerTime		= i*0.4, 
	--Hitbox
	--    collisionVolumeOffsets    =  "0 0 0",
	--    collisionVolumeScales     =  "20 20 20",
	--    collisionVolumeTest       =  1,
	--    collisionVolumeType       =  "box",
		
	--Weapons and related
	}
	
	allBaseDefs[unitDefName] = unitDef
end

return lowerkeys(allBaseDefs)