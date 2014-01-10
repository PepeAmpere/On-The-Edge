------------------------------------------------------------------------------
-- OTE RULES
-- more about global settings on project site wiki https://github.com/OTE-AM/On-The-Edge/blob/master/wiki/design_detail.md
-- TODO: connect with rest of game 
------------------------------------------------------------------------------

oteRule = {
	experienceRadius	= 1000,
	experienceLevelMult	= 1.5,
	experience	= {
		soldier 	= 4,
		ranger		= 4,
		hero		= 50,
		towerMain	= 200,
		towerSmall	= 5,
		bug1		= 1,
		bug2		= 4,
		bug3		= 8,
		bug5		= 200,
		bugqueen	= 1000,
		bugtower	= 20,
		bughive		= 40,
	},

	-- HERO GENERATION CLASSES --
	speed 		= {2.5, 3.5, 4, 4.5, 5.5},
	
	health 		= {400, 600, 700, 800, 1000},
	autorepair	= {0.5, 1.5, 2, 2.5, 3.5},												-- hitpoints healed based on unit starting unit setup
	reactorPlus = {0.5, 1.5, 2, 2.5, 3.5},												-- additional energy income based on unit starting unit setup
	reactorMove = {1,2,2.5,3,4},														-- this energy income is used when unit moves (so when idle, its energy income)
	energy 		= {150, 250, 300, 350, 450},											-- size of energy storage
	armor		= {"none","heroLight","heroMedium","heroHeavy","heroInvulnerable"},							
	
	dmgBase		= {400, 600, 40, 800, 1000},
	reload		= {7, 5, 4, 3, 1},
	range		= {150, 450, 600, 750, 1050},
	
	heroSpawn	= {7, 5, 4, 3, 1},
	
	-- ARMY CLASSES (non-hero) --
	armyArmor			= {"none","light","medium","heavy","invulnerable"},
	
	soldierOneHealth 	= {200, 250, 300, 500},
	soldierTwoHealth 	= {150, 175, 200, 300},
	soldierThreeHealth 	= {500, 650, 800, 1200},
	
	soldierOneDamage	= {12, 14, 16, 22},
	soldierTwoDamage 	= {25, 30, 35, 50},
	soldierThreeDamage	= {50, 60, 70, 100},
	
	soldierOneRange 	= {80, 80, 80, 100},
	soldierTwoRange 	= {400, 400, 400, 500},
	soldierThreeRange	= {400, 400, 400, 500},
	
	soldierOneReload 	= {1, 0.95, 0.9, 0.8},
	soldierTwoReload 	= {2, 1.9, 1.8, 1.6},
	soldierThreeReload	= {2.5, 2.4, 2.3, 2.2},
	
	soldierOneSpeed		= {2, 2, 2, 2.5},
	soldierTwoSpeed 	= {2, 2, 2, 2.5},
	soldierThreeSpeed	= {2, 2, 2, 2.5},
	
	-- ARMY spawn
	spawnTime					= {0,1,0},
	
	spawnSoldierOneSize 		= 5,
	spawnSoldierTwoSize			= 2,
	spawnSoldierThreeSize 		= 1,
	
	spawnSoldeirOneFrequency 	= 1,
	spawnSoldeirTwoFrequency 	= 1,
	spawnSoldeirTheeFrequency 	= 3,
	
	topPathName					= "",
	middlePathName				= "",
	bottomPathName				= "",
	
	-- BASE CLASSES --
	baseArmor  	= {
		"buildingNone",
		"buildingLight",
		"buildingMedium",
		"buildingHeavy",
		"buildingInvulnerable"
	},
	
	-- GUI --
	guiUpdate = 10,
}