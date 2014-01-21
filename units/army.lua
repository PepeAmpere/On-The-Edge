local allArmyUnits 	= {}

local names			= {
	"mortar",
}

for i=1,#names do
	local unitDefName 	= names[i]
	local unitDef = {
	--Internal settings
		BuildPic 		= "filename.bmp",
		Category 		= "BUILDING TOWER NOTAIR NOTSUB",
		ObjectName 		= unitDefName .. ".s3o",
		name 			= "Base stuff",
		Side 			= "REP",
		TEDClass 		= "TANK",
		UnitName 		= unitDefName,
		script 			= "mortar.lua",   

		maxDamage		= 800,
		SightDistance 	= 450,

		Acceleration 	= 0.15,
		BrakeRate 		= 0.1,
		FootprintX 		= 2,
		FootprintZ 		= 2,
		MaxSlope 		= 15,
		MaxVelocity 	= 2.0,
		MaxWaterDepth 	= 20,
		MovementClass 	= "Default2x2",
		TurnRate		= 400,
		
		Builder 		= 0,
		CanAttack 		= 1,
		CanGuard 		= 1,
		CanMove 		= 1,
		CanPatrol 		= 1,
		CanStop 		= 1,
		LeaveTracks 	= 0,
		Reclaimable 	= 0,
		
		mass			= 2000,
		
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
				size = 10,
				soundstart = "mortar2",
				soundhit = "mortarhit",
				range = 600,
				reloadtime = 3.0,
				rgbcolor = "1.0 0.8 0.8",
				turret = true,
				texture1 = "flame",
				weaponvelocity = 400,
				explosiongenerator = "custom:TANKGUN_FX",
				damage = {
					default = 100,
					herolight = 80,
					heromedium = 70,
					heroheavy = 60,
					-- TODO: make it by generator
				},
			},
		}
	}
	
	allArmyUnits[unitDefName] = unitDef
end

return lowerkeys(allArmyUnits)