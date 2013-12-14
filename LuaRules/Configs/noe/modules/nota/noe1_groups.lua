-- GROUPS of NOE 1.0
	
moduleGroupDefs = {	
	--- personality ---
	["cake"]                           = {size = 1, unit = "none", spirit = "brain", transfer = 0, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "None", dependance = false},
    --- commanders ---
	["armCommandTower"]                = {size = 1, unit = "armbase", spirit = "tower", transfer = 1,  status = {0}, preference = {1,1,1,1,1,1,1}, targetClasses = {}, source = "None", dependance = false},
	["armCommander"]                   = {size = 1, unit = "armcom", spirit = "commander", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Gate", dependance = false},
	--- pw groups ---
	["armpwBuffer"]                    = {size = 1000, unit = "armpw", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot1", dependance = false},
	["pwLight-one"]                    = {size = 12, unit = "armpw", spirit = "cleaner", transfer = 4, status = {0,2,5,8}, preference = {4,8,9,10,10,10,10}, targetClasses = {"metal","builders","radarGround"}, source = "Bot1", dependance = false, perimeterIndex = 1},
	["pwLight-two"]                    = {size = 12, unit = "armpw", spirit = "lightDefender", transfer = 6, status = {0,2,5,8}, preference = {0,4,8,9,10,10,10}, targetClasses = {"metal","energy","builders","factories","expTowers"}, source = "Bot1", dependance = false, perimeterIndex = 2},
	["pwLight-three"]                  = {size = 30, unit = "armpw", spirit = "cleaner", transfer = 2, status = {0,6,10,14}, preference = {4,8,9,10,10,10,10}, targetClasses = {"builders","metal","expTowers"}, source = "Bot1", dependance = false},
	["pwLight-four"]                   = {size = 30, unit = "armpw", spirit = "lightAttacker", transfer = 8, status = {0,8,16,22}, preference = {0,4,8,9,10,15,24}, targetClasses = {"metal","builders","expTowers","factories","commandCentre"}, source = "Bot1", dependance = false},
	["pwLight-expansionDef-one"]       = {size = 8, unit = "armpw", spirit = "builderDefender", transfer = 4, status = {0,2,4,6}, preference = {0,0,2,4,6,8,8}, targetClasses = {}, source = "Bot1", dependance = true, leader = "ecoFarkOne", depPos = {0,0}},
	["pwLight-expansionDef-two"]       = {size = 8, unit = "armpw", spirit = "builderDefender", transfer = 4, status = {0,2,4,6}, preference = {0,0,2,4,6,8,8}, targetClasses = {}, source = "Bot1", dependance = true, leader = "ecoFarkTwo", depPos = {0,0}},
	["pwLight-expansionDef-three"]     = {size = 8, unit = "armpw", spirit = "builderDefender", transfer = 4, status = {0,2,4,6}, preference = {0,0,2,4,6,8,8}, targetClasses = {}, source = "Bot1", dependance = true, leader = "ecoFarkThree", depPos = {0,0}},
	["pwLight-attack-one"]             = {size = 12, unit = "armpw", spirit = "raider", transfer = 6, status = {0,2,5,8}, preference = {0,0,4,6,6,6,6}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {200,0}},
	["pwLight-attack-two"]             = {size = 12, unit = "armpw", spirit = "raider", transfer = 6, status = {0,2,5,8}, preference = {0,0,0,0,2,6,6}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {-200,0}},
	["pwLight-remnants-one"]           = {size = 30, unit = "armpw", spirit = "lightAttacker", transfer = 10, status = {0,8,16,22}, preference = {0,0,0,0,0,0,0}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Bot1", dependance = false},
	["pwLight-remnants-two"]           = {size = 30, unit = "armpw", spirit = "lightAttacker", transfer = 10, status = {0,8,16,22}, preference = {0,0,0,0,0,0,0}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Bot1", dependance = false},
	--- hammer ---
	["armhamBuffer"]                   = {size = 1000, unit = "armham", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,82}, targetClasses = {}, source = "Bot1", dependance = false},
	["mainOne-hamAttackForce"]         = {size = 61, unit = "armham", spirit = "standardMainLine", transfer = 8, status = {7,15,23,31}, preference = {8,16,24,32,38,41,41}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Bot1", dependance = false},
	["mainOne-hamAttackForce-support"] = {size = 61, unit = "armham", spirit = "secondaryLine", transfer = 1, status = {0,18,26,34}, preference = {0,0,8,16,24,32,41}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-200}},
	["ham-remnants"]                   = {size = 30, unit = "armham", spirit = "lightAttacker", transfer = 15, status = {0,15,23,25}, preference = {0,0,0,0,0,0,0}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Bot1", dependance = false},
	--- rocko ---
	["armrockBuffer"]                  = {size = 1000, unit = "armrock", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,8}, targetClasses = {}, source = "Bot1", dependance = false},
	["mainOne-rocketShield-one"]       = {size = 61, unit = "armrock", spirit = "heavySupportLine", transfer = 1, status = {0,2,4,6}, preference = {0,6,12,24,32,35,40}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-100}},
	--- sniper ---
	["armsnipeBuffer"]                 = {size = 1000, unit = "armsnipe", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,4}, targetClasses = {}, source = "Bot1", dependance = false},
	["mainOne-snipeSupport"]           = {size = 4, unit = "armsnipe", spirit = "artileryCommander", transfer = 1, status = {0,1,2,3}, preference = {0,0,1,2,3,4,4}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {10,-100}},
	["sniper-raider-one"]              = {size = 3, unit = "armsnipe", spirit = "cloacked-raider", transfer = 1, status = {0,1,2,3}, preference = {0,0,0,1,2,3,3}, targetClasses = {"metal","builders"}, source = "Bot1", dependance = false},
	["sniper-raider-two"]              = {size = 3, unit = "armsnipe", spirit = "cloacked-raider", transfer = 3, status = {0,1,2,3}, preference = {0,0,0,0,1,2,3}, targetClasses = {"metal","builders"}, source = "Bot1", dependance = false},
	--- jethro ---
	["armjethBuffer"]                  = {size = 1000, unit = "armjeth", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,8}, targetClasses = {}, source = "Bot1", dependance = false},
	["mainOne-armjethAA-one"]          = {size = 8, unit = "armjeth", spirit = "supportLine", transfer = 1, status = {0,2,4,6}, preference = {0,2,4,6,8,8,8}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-30}},
	["mainOne-armjethAA-two"]          = {size = 8, unit = "armjeth", spirit = "supportLine", transfer = 2, status = {0,2,4,6}, preference = {0,0,0,0,0,1,2}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-80}},
    ["mainOne-armjethAA-three"]        = {size = 8, unit = "armjeth", spirit = "supportLine", transfer = 3, status = {0,2,4,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-130}},
	--- fark ---
	["armfarkBuffer"]                  = {size = 1000, unit = "armfark", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,11}, targetClasses = {}, source = "Bot1", dependance = false},
	["ecoFarkOne"]                     = {size = 1, unit = "armfark", spirit = "eco", transfer = 1, status = {0,1,1,1}, preference = {1,1,1,1,1,1,1}, targetClasses = {}, source = "Bot1", dependance = false},
	["ecoFarkTwo"]                     = {size = 1, unit = "armfark", spirit = "eco", transfer = 1, status = {0,1,1,1}, preference = {0,1,1,1,1,1,1}, targetClasses = {}, source = "Bot1", dependance = false},
	["ecoFarkThree"]                   = {size = 2, unit = "armfark", spirit = "eco", transfer = 1, status = {0,1,1,2}, preference = {0,0,1,1,1,1,2}, targetClasses = {}, source = "Bot1", dependance = false},
	["ecoFarkFour"]                    = {size = 2, unit = "armfark", spirit = "eco", transfer = 1, status = {0,1,1,2}, preference = {0,0,0,1,1,1,1}, targetClasses = {}, source = "Bot1", dependance = false},
	["tower-farkAssist"]    		   = {size = 3, unit = "armfark", spirit = "supportLine", transfer = 2, status = {0,1,1,1}, preference = {0,0,0,1,1,2,2}, targetClasses = {}, source = "Bot1", dependance = true, leader = "armCommandTower", depPos = {-100,100}},
	["base-farkReclaim"]    	       = {size = 1, unit = "armfark", spirit = "supportLine", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,1,1,1}, targetClasses = {}, source = "Bot1", dependance = true, leader = "pwLight-one", depPos = {-400,400}},
	["mainOne-farkSupport-reclaim"]    = {size = 6, unit = "armfark", spirit = "supportLine", transfer = 2, status = {0,0,1,1}, preference = {0,0,0,1,1,2,3}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {-250,-250}},
	["mainOne-farkSupport-repair"]     = {size = 6, unit = "armfark", spirit = "supportLine", transfer = 2, status = {0,0,0,1}, preference = {0,0,0,0,0,0,1}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {250,-250}},		
	--- fav jeffy ---
	["armfavBuffer"]                   = {size = 1000, unit = "armfav", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,5}, targetClasses = {}, source = "Veh1", dependance = false},
	["scoutJeffOne"]                   = {size = 5, unit = "armfav", spirit = "raider", transfer = 5, status = {0,1,1,1}, preference = {0,5,5,5,5,5,5}, targetClasses = {"metal","builders"}, source = "Veh1", dependance = false},
	--- stumpy ---
	["armstumpBuffer"]                 = {size = 1000, unit = "armstump", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,46}, targetClasses = {}, source = "Veh1", dependance = false},
	["mainOne-stumpyFlank-left"]       = {size = 5, unit = "armstump", spirit = "flanker", transfer = 5, status = {2,3,4,5}, preference = {0,0,0,0,3,4,5}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {800,50}},
	["mainOne-stumpyFlank-right"]      = {size = 5, unit = "armstump", spirit = "flanker", transfer = 5, status = {3,4,4,5}, preference = {0,0,0,0,3,4,5}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {-800,50}},
	["stumpy-raider"]                  = {size = 12, unit = "armstump", spirit = "raider", transfer = 4, status = {0,2,4,6}, preference = {0,1,2,3,3,3,3}, targetClasses = {"builders","metal","expTowers"}, source = "Veh1", dependance = false},
	["mainStumpyTank"]                 = {size = 36, unit = "armstump", spirit = "mainTank", transfer = 4, status = {9,15,21,27}, preference = {2,9,9,18,18,27,36}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Veh1", dependance = false},
	["stumpy-remnants"]                = {size = 36, unit = "armstump", spirit = "mainTank", transfer = 18, status = {0,2,5,22}, preference = {0,0,0,0,0,0,0}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Veh1", dependance = false},
	--- patnher ---
	["armlatnkBuffer"]                 = {size = 1000, unit = "armlatnk", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,8}, targetClasses = {}, source = "Veh1", dependance = false},
	["invisible-raiders"]              = {size = 8, unit = "armlatnk", spirit = "cleaner", transfer = 4, status = {1,3,5,7}, preference = {0,2,4,5,6,7,8}, targetClasses = {"metal","builders"}, source = "Veh1", dependance = false}, 
	--- veh arty ---
	["armmartBuffer"]                  = {size = 1000, unit = "armmart", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,10}, targetClasses = {}, source = "Veh1", dependance = false},
	["mainOne-lightArmArty-one"]       = {size = 18, unit = "armmart", spirit = "artileryCommander", transfer = 1, status = {1,5,10,15}, preference = {0,2,4,8,12,16,18}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-300}}, 
	["mainOne-lightArmArty-two"]       = {size = 18, unit = "armmart", spirit = "artileryCommander", transfer = 4, status = {1,5,10,15}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-450}}, 
	--- veh flak ---
	["armyorkBuffer"]                  = {size = 1000, unit = "armyork", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,10}, targetClasses = {}, source = "Veh1", dependance = false},
	["mainOne-armFlakSquad"]           = {size = 8, unit = "armyork", spirit = "artileryCommander", transfer = 1, status = {1,1,2,2}, preference = {0,2,4,6,8,8,10}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-150}}, 
	["base-armFlakSquad-one"]          = {size = 4, unit = "armyork", spirit = "lightDefender", transfer = 1, status = {1,2,3,4}, preference = {0,1,2,3,4,4,4}, targetClasses = {}, source = "Veh1", dependance = false}, 
	["base-armFlakSquad-two"]          = {size = 6, unit = "armyork", spirit = "lightDefender", transfer = 2, status = {1,2,3,4}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh1", dependance = false}, 
	["base-armFlakSquad-three"]        = {size = 6, unit = "armyork", spirit = "lightDefender", transfer = 3, status = {1,2,3,4}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh1", dependance = false}, 
	--- veh radar ---
	["armseerBuffer"]                  = {size = 1000, unit = "armseer", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh1", dependance = false},
	["mainOne-armRadarUnit"]           = {size = 6, unit = "armseer", spirit = "supportLine", transfer = 1, status = {0,1,1,2}, preference = {0,0,0,1,1,2,3}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-350}}, 
	--- hellfish ---
	["armhellBuffer"]                  = {size = 1000, unit = "armhell", spirit = "airBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,7}, targetClasses = {}, source = "Air1", dependance = false},
	["airHellGroundOne"]               = {size = 7, unit = "armhell", spirit = "antigroundAir", transfer = 1, status = {3,4,5,7}, preference = {1,2,3,4,5,6,7}, targetClasses = {"metal","energy","builders","dangerousGroundUnits","expTowers","factories","defWeapons","radarGround","lessDangerousGroundUnits"}, source = "Air1", dependance = false},   
	["airHellGroundTwo"]               = {size = 7, unit = "armhell", spirit = "antigroundAir", transfer = 3, status = {2,3,5,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {"metal","energy","builders","dangerousGroundUnits","expTowers","factories","defWeapons","radarGround","strategic"}, source = "Air1", dependance = false},   
	["airHellGroundThree"]             = {size = 7, unit = "armhell", spirit = "antigroundAir", transfer = 3, status = {2,3,5,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {"metal","energy","builders","dangerousGroundUnits","expTowers","factories","defWeapons","radarGround","strategic","lessDangerousGroundUnits"}, source = "Air1", dependance = false},   
	["airHellGroundFour"]              = {size = 7, unit = "armhell", spirit = "antigroundAir", transfer = 3, status = {2,3,5,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {"metal","energy","defWeapons","dangerousGroundUnits","lessDangerousGroundUnits","strategic"}, source = "Air1", dependance = false},   
	--- thunder ---
	["armthundBuffer"]                 = {size = 1000, unit = "armthund", spirit = "airBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,5}, targetClasses = {}, source = "Air1", dependance = false},
	["airBombSquad-thunderOne"]        = {size = 6, unit = "armthund", spirit = "antigroundAir", transfer = 2, status = {0,0,0,4}, preference = {0,0,1,2,3,4,6}, targetClasses = {"factories","defWeapons","energy","strategic","jammers"}, source = "Air1", dependance = false},   
	["airBombSquad-thunderTwo"]        = {size = 6, unit = "armthund", spirit = "antigroundAir", transfer = 3, status = {0,0,0,5}, preference = {0,0,0,0,0,0,0}, targetClasses = {"factories","defWeapons","energy","strategic"}, source = "Air1", dependance = false},   
	["airBombSquad-thunderThree"]      = {size = 6, unit = "armthund", spirit = "antigroundAir", transfer = 3, status = {0,0,0,5}, preference = {0,0,0,0,0,0,0}, targetClasses = {"factories","defWeapons","energy","strategic"}, source = "Air1", dependance = false},   
	["airBombSquad-thunderFour"]       = {size = 6, unit = "armthund", spirit = "antigroundAir", transfer = 3, status = {0,0,0,5}, preference = {0,0,0,0,0,0,0}, targetClasses = {"factories","defWeapons","energy","strategic","jammers"}, source = "Air1", dependance = false},   
	["airBombSquad-thunderFive"]       = {size = 6, unit = "armthund", spirit = "antigroundAir", transfer = 3, status = {0,0,0,5}, preference = {0,0,0,0,0,0,0}, targetClasses = {"factories","defWeapons","energy","strategic"}, source = "Air1", dependance = false},   
	--- tECH2 ---
	--- maverick ---
	["armmavBuffer"]                   = {size = 1000, unit = "armmav", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,8}, targetClasses = {}, source = "Bot2", dependance = false},
	["mainOne-armmav-one"]             = {size = 8, unit = "armmav", spirit = "supportLine", transfer = 1, status = {0,2,4,6}, preference = {1,2,3,5,6,7,8}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {20,-60}},
	["mainOne-armmav-two"]             = {size = 8, unit = "armmav", spirit = "supportLine", transfer = 2, status = {0,2,4,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {-20,-180}},
	["mainOne-armmav-three"]           = {size = 8, unit = "armmav", spirit = "supportLine", transfer = 4, status = {0,2,4,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,80}},
	--- raptor ------
	["raptorivBuffer"]                 = {size = 1000, unit = "raptoriv", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot2", dependance = false},
	["raptor-raider-one"]              = {size = 15, unit = "raptoriv", spirit = "lightAttacker", transfer = 3, status = {0,3,7,10}, preference = {1,2,5,8,11,13,15}, targetClasses = {"expTowers","factories","commandCentre"}, source = "Bot2", dependance = false},
	["raptor-raider-two"]              = {size = 15, unit = "raptoriv", spirit = "raider", transfer = 15, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {"expTowers","factories","commandCentre"}, source = "Bot2", dependance = false},
	--- oddity ---
	["armoddBuffer"]                   = {size = 1000, unit = "armodd", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,10}, targetClasses = {}, source = "Bot2", dependance = false},
	["mainOne-armHeavyArty-one"]       = {size = 3, unit = "armodd", spirit = "supportLine", transfer = 1, status = {0,1,2,3}, preference = {1,1,1,2,2,3,3}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-200}}, 
	["mainOne-armHeavyArty-two"]       = {size = 8, unit = "armodd", spirit = "supportLine", transfer = 2, status = {0,1,2,3}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-400}}, 
	--- eraser ---
	["armaserBuffer"]                  = {size = 1000, unit = "armaser", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot2", dependance = false},
	["mainOne-armBotJammerUnit"]       = {size = 2, unit = "armaser", spirit = "supportLine", transfer = 1, status = {0,1,1,2}, preference = {1,1,1,1,1,1,1}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {-50,-50}}, 
	--- penetrator ---
	["armmanniBuffer"]                 = {size = 1000, unit = "armmanni", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh2", dependance = false},
	["mainOne-mobileAnnihilator"]      = {size = 8, unit = "armmanni", spirit = "supportLine", transfer = 1, status = {0,1,4,7}, preference = {1,2,3,4,5,6,7}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-220}}, 
	["mainOne-mobileAnnihilator2"]      = {size = 8, unit = "armmanni", spirit = "supportLine", transfer = 2, status = {0,1,4,7}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,100}}, 
	--- merl ---
	["armmerlBuffer"]                  = {size = 1000, unit = "armmerl", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,10}, targetClasses = {}, source = "Veh2", dependance = false},
	["mainOne-armSuperHeavyArty"]      = {size = 12, unit = "armmerl", spirit = "artileryCommander", transfer = 1, status = {1,2,3,4}, preference = {0,0,1,1,2,2,3}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-500}}, 
	["mainOne-armSuperHeavyArty-two"]  = {size = 12, unit = "armmerl", spirit = "artileryCommander", transfer = 1, status = {1,2,3,4}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-800}}, 
	--- hermes ---
	["aHermesBuffer"]                  = {size = 1000, unit = "ahermes", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,10}, targetClasses = {}, source = "Veh2", dependance = false},
	["mainOne-hermesAA-one"]           = {size = 8, unit = "ahermes", spirit = "supportLine", transfer = 1, status = {1,2,3,4}, preference = {0,0,1,1,2,2,3}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-hamAttackForce", depPos = {0,-100}}, 
	--- hawk ---
	["armhawkBuffer"]                  = {size = 1000, unit = "armhawk", spirit = "airBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Air2", dependance = false},
	["air-armAdvancedAirfight-one"]    = {size = 30, unit = "armhawk", spirit = "airSupreme", transfer = 1, status = {5,10,15,20}, preference = {2,4,6,8,10,12,14}, targetClasses = {}, source = "Air2", dependance = false},   
	["air-armAdvancedAirfight-two"]    = {size = 30, unit = "armhawk", spirit = "airSupreme", transfer = 2, status = {5,10,15,20}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Air2", dependance = false},   
	--- wing ---
	["armwingBuffer"]                  = {size = 1000, unit = "armwing", spirit = "airBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Air2", dependance = false},
	["air-wings-one"]                  = {size = 10, unit = "armwing", spirit = "antigroundAir", transfer = 1, status = {0,0,0,5}, preference = {1,2,3,4,5,6,7}, targetClasses = {"jammers","dangerousGroundUnits","strategic","defWeapons"}, source = "Air2", dependance = false},   
	["air-wings-two"]                  = {size = 10, unit = "armwing", spirit = "antigroundAir", transfer = 2, status = {0,0,0,8}, preference = {0,0,0,0,0,0,0}, targetClasses = {"jammers","dangerousGroundUnits","lessDangerousGroundUnits","strategic","defWeapons"}, source = "Air2", dependance = false},   
	--- destroyer ---
	["armexcalBuffer"]                 = {size = 1000, unit = "armexcal", spirit = "shipBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,3}, targetClasses = {}, source = "Ship", dependance = false},			
	["basicArmNavyForceOne"]           = {size = 3, unit = "armexcal", spirit = "basicAdmiral", transfer = 1, status = {1,1,1,1}, preference = {0,0,0,0,1,2,3}, targetClasses = {}, source = "Ship", dependance = false},
	--- moho ---
	["armckGroup"]                     = {size = 3, unit = "armck", spirit = "mohobuilder", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Tech2", dependance = false},			
	--- BUILDINGS ---
	--- defs ---
	--- nuke ---
	["armNukeSilo-one"]               = {size = 10, unit = "armsilo", spirit = "strategicDefence-nuke", transfer = 1, status = {0,0,0,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Def2", dependance = false},
	--- factories ---
	["armlabGroup"]                    = {size = 10, unit = "armlab", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {1,1,2,2,2,2,3}, targetClasses = {}, source = "Main", dependance = false},
	["armvpGroup"]                     = {size = 10, unit = "armvp", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,1,1,1,2,2,2}, targetClasses = {}, source = "Main", dependance = false},
	["armapGroup"]                     = {size = 10, unit = "armap", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,0,0,1,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
	["armcsyGroup"]                    = {size = 10, unit = "armcsy", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,0,0,0,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
	["armalabGroup"]                   = {size = 10, unit = "armalab", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,0,1,1,2,2,3}, targetClasses = {}, source = "Bot2exp", dependance = false},
	["armavpGroup"]                    = {size = 10, unit = "armavp", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,0,1,1,2,2,3}, targetClasses = {}, source = "Veh2exp", dependance = false},
	["armaapGroup"]                    = {size = 10, unit = "armaap", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,0,1,1,2,2,3}, targetClasses = {}, source = "Air2exp", dependance = false},
	--- other buildings ---
	["armMexes"]                       = {size = 100, unit = "armmex", spirit = "building", transfer = 1, status = {0,1,2,3}, preference = {2,5,7,10,12,13,13}, targetClasses = {}, source = "Main", dependance = false},
	["armMetalMakers"]                 = {size = 200, unit = "armmakr", spirit = "makers", transfer = 1, status = {0,1,2,3}, preference = {0,0,3,6,12,18,30}, targetClasses = {}, source = "Main", dependance = false},
	["armSolarPower"]                  = {size = 200, unit = "armsolar", spirit = "building", transfer = 1, status = {0,1,2,3}, preference = {2,7,15,22,27,32,35}, targetClasses = {}, source = "Main", dependance = false},
	["armWindPower"]                   = {size = 200, unit = "armwin", spirit = "building", transfer = 1, status = {0,1,2,3}, preference = {2,7,15,22,27,32,40}, targetClasses = {}, source = "Main", dependance = false},
	["armFusionPower"]                 = {size = 100, unit = "armfus", spirit = "building", transfer = 1, status = {0,1,2,3}, preference = {0,0,0,0,1,1,2}, targetClasses = {}, source = "Main", dependance = false},
	["armTidalPower"]                  = {size = 200, unit = "armtide", spirit = "building", transfer = 1, status = {0,1,2,3}, preference = {0,4,8,12,18,24,30}, targetClasses = {}, source = "Main", dependance = false},
	--- exp towers ---
	["arm2kbotGroup-one"]              = {size = 1, unit = "arm2kbot", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,1,1,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
	["arm2kbotGroup-two"]              = {size = 1, unit = "arm2kbot", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["arm2kbotGroup-three"]            = {size = 1, unit = "arm2kbot", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["arm2vehGroup-one"]               = {size = 1, unit = "arm2veh", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,1,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
    ["arm2vehGroup-two"]               = {size = 1, unit = "arm2veh", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["arm2vehGroup-three"]             = {size = 1, unit = "arm2veh", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["arm2airGroup-one"]               = {size = 1, unit = "arm2air", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,1,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
    ["arm2airGroup-two"]               = {size = 1, unit = "arm2air", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["arm2airGroup-three"]             = {size = 1, unit = "arm2air", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["arm2defGroup-one"]               = {size = 1, unit = "arm2def", spirit = "expansion2def", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,1,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
    ["arm2defGroup-two"]               = {size = 1, unit = "arm2def", spirit = "expansion2def", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["arm2defGroup-three"]             = {size = 1, unit = "arm2def", spirit = "expansion2def", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
    --- CORE ---
	--- personality ---
	["thor"]                           = {size = 1, unit = "none", spirit = "brain", transfer = 0, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "None", dependance = false},
    --- commanders ---
	["corCommandTower"]                = {size = 1, unit = "corbase", spirit = "tower", transfer = 1, status = {0}, preference = {1,1,1,1,1,1,1}, targetClasses = {}, source = "None", dependance = false},
	["corCommander"]                   = {size = 1, unit = "corcom", spirit = "commander", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Gate", dependance = false},
	--- ak groups ---
	["corakBuffer"]                    = {size = 1000, unit = "corak", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "", dependance = false},
	["akLight-one"]                    = {size = 22, unit = "corak", spirit = "cleaner", transfer = 2, status = {0,2,4,8}, preference = {4,8,12,16,20,21,22}, targetClasses = {"metal","builders"}, source = "Bot1", dependance = false, perimeterIndex = 1},
	["akLight-two"]                    = {size = 10, unit = "corak", spirit = "lightDefender", transfer = 5, status = {0,2,3,5}, preference = {0,4,8,9,10,10,10}, targetClasses = {"metal","energy","builders","expTowers"}, source = "Bot1", dependance = false, perimeterIndex = 2},
	["akLight-three"]                  = {size = 10, unit = "corak", spirit = "cleaner", transfer = 2, status = {0,2,3,4}, preference = {0,0,4,8,9,10,10}, targetClasses = {"metal","builders","expTowers"}, source = "Bot1", dependance = false},
	["akLight-four"]                   = {size = 10, unit = "corak", spirit = "lightAttacker", transfer = 5, status = {0,2,5,8}, preference = {0,0,0,4,8,9,10}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Bot1", dependance = false},
	["akLight-expansionDef-one"]       = {size = 8, unit = "corak", spirit = "builderDefender", transfer = 2, status = {0,2,4,6}, preference = {0,0,2,4,6,8,8}, targetClasses = {}, source = "Bot1", dependance = true, leader = "necroEcoOne", depPos = {0,0}},
	["akLight-expansionDef-two"]       = {size = 8, unit = "corak", spirit = "builderDefender", transfer = 3, status = {0,2,4,6}, preference = {0,0,2,4,6,8,8}, targetClasses = {}, source = "Bot1", dependance = true, leader = "necroEcoTwo", depPos = {0,0}},
	["akLight-expansionDef-three"]     = {size = 8, unit = "corak", spirit = "builderDefender", transfer = 4, status = {0,2,4,6}, preference = {0,0,2,4,6,8,8}, targetClasses = {}, source = "Bot1", dependance = true, leader = "necroEcoThree", depPos = {0,0}},
	["akRaider-one"]                   = {size = 2, unit = "corak", spirit = "cleaner", transfer = 2, status = {0,1,2,2}, preference = {2,2,2,2,2,2,2}, targetClasses = {"builders"}, source = "Bot1", dependance = false},
	["akRaider-two"]                   = {size = 2, unit = "corak", spirit = "cleaner", transfer = 2, status = {0,1,2,2}, preference = {0,0,2,2,2,2,2}, targetClasses = {"metal","builders"}, source = "Bot1", dependance = false},
	["akRaider-three"]                 = {size = 5, unit = "corak", spirit = "cleaner", transfer = 2, status = {0,1,2,2}, preference = {0,0,0,2,2,2,2}, targetClasses = {"builders","metal"}, source = "Bot1", dependance = false},
    ["akRaider-four"]                  = {size = 5, unit = "corak", spirit = "cleaner", transfer = 2, status = {0,1,2,2}, preference = {0,0,0,0,2,2,2}, targetClasses = {"metal","builders"}, source = "Bot1", dependance = false},
	["mainOne-akSupport-one"]          = {size = 16, unit = "corak", spirit = "flanker", transfer = 3, status = {0,2,6,12}, preference = {2,4,6,8,10,12,14}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {200,0}},
	["mainOne-akSupport-two"]          = {size = 16, unit = "corak", spirit = "flanker", transfer = 3, status = {0,2,6,12}, preference = {0,0,0,2,4,6,8}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {-200,0}},
	--- thud ---
	["corthudBuffer"]                  = {size = 1000, unit = "corthud", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot1", dependance = false},
	["mainOne-thudAttackForce"]        = {size = 61, unit = "corthud", spirit = "standardMainLine", transfer = 8, status = {6,12,18,24}, preference = {8,16,24,32,38,41,41}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Bot1", dependance = false},
	["mainOne-thudAttackForce-support"]= {size = 61, unit = "corthud", spirit = "secondaryLine", transfer = 1, status = {0,18,26,34}, preference = {0,0,8,16,24,32,41}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-200}},
	["thud-remnants-one"]              = {size = 30, unit = "corthud", spirit = "lightAttacker", transfer = 15, status = {0,15,23,30}, preference = {0,0,0,0,0,0,0}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Bot1", dependance = false},
	["thud-remnants-two"]              = {size = 30, unit = "corthud", spirit = "lightAttacker", transfer = 15, status = {0,15,23,30}, preference = {0,0,0,0,0,0,0}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Bot1", dependance = false},
	--- storm ---
	["corstormBuffer"]                 = {size = 1000, unit = "corstorm", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,8}, targetClasses = {}, source = "Bot1", dependance = false},
	["mainOne-stormShield-one"]        = {size = 61, unit = "corstorm", spirit = "heavySupportLine", transfer = 1, status = {0,2,4,6}, preference = {0,4,8,12,16,20,24}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-100}},	
	--- morty ---
	["cormortBuffer"]                  = {size = 1000, unit = "cormort", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,4}, targetClasses = {}, source = "Bot1", dependance = false},
	["mainOne-mortySupport"]           = {size = 6, unit = "cormort", spirit = "artileryCommander", transfer = 1, status = {0,1,2,3}, preference = {0,0,1,2,3,4,6}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-100}},
	--- crasher ---
	["corcrashBuffer"]                 = {size = 1000, unit = "corcrash", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,8}, targetClasses = {}, source = "Bot1", dependance = false},
	["mainOne-crasherAA-one"]          = {size = 8, unit = "corcrash", spirit = "supportLine", transfer = 1, status = {0,2,4,6}, preference = {0,2,4,6,8,8,8}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-thudAttackForce",depPos = {0,-30}},
	["mainOne-crasherAA-two"]          = {size = 8, unit = "corcrash", spirit = "supportLine", transfer = 2, status = {0,2,4,6}, preference = {0,0,0,0,0,1,2}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-thudAttackForce",depPos = {0,-80}},
	["mainOne-crasherAA-three"]        = {size = 8, unit = "corcrash", spirit = "supportLine", transfer = 3, status = {0,2,4,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-thudAttackForce",depPos = {0,-130}},
	--- necro ---
	["cornecroBuffer"]                 = {size = 1000, unit = "cornecro", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,11}, targetClasses = {}, source = "Bot1", dependance = false},
	["necroEcoOne"]                    = {size = 1, unit = "cornecro", spirit = "eco", transfer = 1, status = {0,1,1,1}, preference = {1,1,1,1,1,1,1}, targetClasses = {}, source = "Bot1", dependance = false},
	["necroEcoTwo"]                    = {size = 1, unit = "cornecro", spirit = "eco", transfer = 1, status = {0,1,1,1}, preference = {0,1,1,1,1,1,1}, targetClasses = {}, source = "Bot1", dependance = false},
	["necroEcoThree"]                  = {size = 2, unit = "cornecro", spirit = "eco", transfer = 2, status = {0,1,1,1}, preference = {0,0,1,1,1,1,1}, targetClasses = {}, source = "Bot1", dependance = false},
	["necroEcoFour"]                   = {size = 2, unit = "cornecro", spirit = "eco", transfer = 2, status = {0,1,1,1}, preference = {0,0,0,1,1,1,2}, targetClasses = {}, source = "Bot1", dependance = false},
	["tower-necroAssist"]    		   = {size = 4, unit = "cornecro", spirit = "supportLine", transfer = 1, status = {0,1,2,3}, preference = {0,0,0,1,2,3,3}, targetClasses = {}, source = "Bot1", dependance = true, leader = "corCommandTower", depPos = {-100,100}},
	["base-necroReclaim"]    	       = {size = 2, unit = "cornecro", spirit = "supportLine", transfer = 2, status = {0,1,1,1}, preference = {0,0,0,1,1,1,1}, targetClasses = {}, source = "Bot1", dependance = true, leader = "akLight-one", depPos = {-400,400}},
	["mainOne-necroSupport-reclaim"]   = {size = 6, unit = "cornecro", spirit = "supportLine", transfer = 2, status = {0,0,1,1}, preference = {0,0,0,0,1,1,2}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {-250,-250}},
	["mainOne-necroSupport-repair"]    = {size = 6, unit = "cornecro", spirit = "supportLine", transfer = 2, status = {0,0,0,1}, preference = {0,0,0,0,0,0,1}, targetClasses = {}, source = "Bot1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {250,-250}},		
	--- fav ---
	["corfavBuffer"]                   = {size = 1000, unit = "corfav", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,5}, targetClasses = {}, source = "Veh1", dependance = false},
	["favScoutOne"]                    = {size = 5, unit = "corfav", spirit = "cleaner", transfer = 5, status = {0,1,1,1}, preference = {0,5,5,5,5,5,5}, targetClasses = {"metal","builders"}, source = "Veh1", dependance = false},
	--- raider ---
	["corraidBuffer"]                  = {size = 1000, unit = "corraid", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,46}, targetClasses = {}, source = "Veh1", dependance = false},
	["mainOne-raiderFlank-left"]       = {size = 5, unit = "corraid", spirit = "flanker", transfer = 2, status = {2,3,4,5}, preference = {0,0,0,0,3,4,5}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {800,50}},
	["mainOne-raiderFlank-right"]      = {size = 5, unit = "corraid", spirit = "flanker", transfer = 2, status = {2,3,4,5}, preference = {0,0,0,0,3,4,5}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {-800,50}},
	["mainTank"]                       = {size = 36, unit = "corraid", spirit = "mainTank", transfer = 5, status = {9,15,21,27}, preference = {2,9,9,18,18,27,36}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Veh1", dependance = false},
	["raider-remnants"]                = {size = 36, unit = "corraid", spirit = "mainTank", transfer = 18, status = {9,15,21,27}, preference = {0,0,0,0,0,0,0}, targetClasses = {"metal","energy","builders","expTowers","factories","commandCentre"}, source = "Veh1", dependance = false},
	--- leveler ---
	["corlevlrBuffer"]                 = {size = 1000, unit = "corlevlr", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,3}, targetClasses = {}, source = "Veh1", dependance = false},
	["mainOne-levelerArty-one"]        = {size = 9, unit = "corlevlr", spirit = "supportLine", transfer = 1, status = {0,1,2,3}, preference = {0,1,2,3,4,5,6}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {-20,-20}},
	["mainOne-levelerArty-two"]        = {size = 12, unit = "corlevlr", spirit = "artileryCommander", transfer = 1, status = {0,1,2,3}, preference = {2,4,6,8,8,8,8}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {40,-80}},
	--- veh arty ---
	["cormartBuffer"]                  = {size = 1000, unit = "cormart", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,8}, targetClasses = {}, source = "Veh1", dependance = false},
	["mainOne-coreLightArty-one"]      = {size = 14, unit = "cormart", spirit = "artileryCommander", transfer = 1, status = {0,4,8,12}, preference = {0,2,4,8,10,12,14}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-350}}, 
	["mainOne-coreLightArty-two"]      = {size = 16, unit = "cormart", spirit = "artileryCommander", transfer = 8, status = {0,4,8,12}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-500}}, 
	--- veh flak ---
	["corsentBuffer"]                  = {size = 1000, unit = "corsent", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,10}, targetClasses = {}, source = "Veh1", dependance = false},
	["mainOne-coreFlakSquad"]          = {size = 8, unit = "corsent", spirit = "artileryCommander", transfer = 1, status = {1,1,2,2}, preference = {1,1,1,1,2,2,2}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-150}}, 
	["base-coreFlakSquad-one"]         = {size = 8, unit = "corsent", spirit = "lightDefender", transfer = 1, status = {1,2,4,6}, preference = {0,1,2,3,4,5,6}, targetClasses = {}, source = "Veh1", dependance = false}, 
	["base-coreFlakSquad-two"]         = {size = 10, unit = "corsent", spirit = "lightDefender", transfer = 2, status = {1,2,4,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh1", dependance = false}, 
	["base-coreFlakSquad-three"]       = {size = 10, unit = "corsent", spirit = "lightDefender", transfer = 4, status = {1,2,4,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh1", dependance = false}, 
	--- veh radar ---
	["corvradBuffer"]                  = {size = 1000, unit = "corvrad", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh1", dependance = false},
	["mainOne-coreRadarUnit"]          = {size = 6, unit = "corvrad", spirit = "supportLine", transfer = 1, status = {0,1,1,2}, preference = {0,0,0,1,1,2,3}, targetClasses = {}, source = "Veh1", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-350}}, 
	--- vashp ---
	["corevashpBuffer"]                = {size = 1000, unit = "corevashp", spirit = "airBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,5}, targetClasses = {}, source = "Air1", dependance = false},
	["airVaspGroundOne"]               = {size = 7, unit = "corevashp", spirit = "antigroundAir", transfer = 1, status = {1,3,5,7}, preference = {1,2,3,4,5,6,7}, targetClasses = {"metal","energy","builders","expTowers","factories","radarGround"}, source = "Air1", dependance = false},   
	["airVaspGroundTwo"]               = {size = 7, unit = "corevashp", spirit = "antigroundAir", transfer = 7, status = {0,0,6,6}, preference = {1,2,3,4,5,6,7}, targetClasses = {"defWeapons","radarGround","dangerousGroundUnits","lessDangerousGroundUnits","factories","strategic","jammers"}, source = "Air1", dependance = false},
	["airVaspGroundRemnantsOne"]       = {size = 7, unit = "corevashp", spirit = "antigroundAir", transfer = 7, status = {0,0,6,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {"defWeapons","radarGround","dangerousGroundUnits","lessDangerousGroundUnits","factories"}, source = "Air1", dependance = false},
	["airVaspGroundRemnantsTwo"]       = {size = 7, unit = "corevashp", spirit = "antigroundAir", transfer = 4, status = {0,0,6,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {"defWeapons","radarGround","dangerousGroundUnits","lessDangerousGroundUnits","factories","strategic","jammers"}, source = "Air1", dependance = false},
	["airVaspGroundRemnantsThree"]     = {size = 7, unit = "corevashp", spirit = "antigroundAir", transfer = 4, status = {0,0,6,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {"defWeapons","radarGround","dangerousGroundUnits","factories","strategic"}, source = "Air1", dependance = false},
	["airVaspGroundRemnantsFour"]      = {size = 7, unit = "corevashp", spirit = "antigroundAir", transfer = 4, status = {0,0,6,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {"defWeapons","radarGround","dangerousGroundUnits","lessDangerousGroundUnits","factories","strategic"}, source = "Air1", dependance = false},
	--- tECH2 ---
	--- dominator ---
	["corhrkBuffer"]                   = {size = 1000, unit = "corhrk", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,8}, targetClasses = {}, source = "Bot2", dependance = false},
	["mainOne-corhrk-one"]             = {size = 8, unit = "corhrk", spirit = "supportLine", transfer = 1, status = {0,2,4,6}, preference = {1,2,4,6,8,10,12}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {20,-60}},
	["mainOne-corhrk-two"]             = {size = 8, unit = "corhrk", spirit = "supportLine", transfer = 2, status = {0,2,4,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {-20,-180}},
	["mainOne-corhrk-three"]           = {size = 8, unit = "corhrk", spirit = "supportLine", transfer = 4, status = {0,2,4,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,80}},
	--- galacticus ---
	["corgalaBuffer"]                  = {size = 1000, unit = "corgala", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,10}, targetClasses = {}, source = "Bot2", dependance = false},
	["mainOne-coreHeavyArty-one"]      = {size = 8, unit = "corgala", spirit = "supportLine", transfer = 1, status = {0,2,4,6}, preference = {1,2,3,4,5,6,8}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-200}}, 
	["mainOne-coreHeavyArty-two"]      = {size = 8, unit = "corgala", spirit = "supportLine", transfer = 2, status = {0,2,4,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-300}}, 
	["mainOne-coreHeavyArty-three"]    = {size = 8, unit = "corgala", spirit = "supportLine", transfer = 4, status = {0,2,4,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-400}}, 
	--- spectre ---
	["corspecBuffer"]                  = {size = 1000, unit = "corspec", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Bot2", dependance = false},
	["mainOne-coreBotJammerUnit"]      = {size = 2, unit = "corspec", spirit = "supportLine", transfer = 1, status = {0,1,1,2}, preference = {1,1,1,1,1,1,1}, targetClasses = {}, source = "Bot2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {-50,-50}}, 
	--- goliath ---
	["corgolBuffer"]                   = {size = 1000, unit = "corgol", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh2", dependance = false},
	["mainOne-coreMeatShield-one"]     = {size = 9, unit = "corgol", spirit = "supportLine", transfer = 1, status = {0,1,3,6}, preference = {1,2,3,4,5,6,7}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,100}}, 
	["mainOne-coreMeatShield-two"]     = {size = 9, unit = "corgol", spirit = "supportLine", transfer = 2, status = {0,1,3,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,250}}, 
	["mainOne-coreMeatShield-three"]   = {size = 9, unit = "corgol", spirit = "supportLine", transfer = 4, status = {0,1,3,6}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,450}}, 
	--- diplomat ---
	["corvrocBuffer"]                  = {size = 1000, unit = "corvroc", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,10}, targetClasses = {}, source = "Veh2", dependance = false},
	["mainOne-coreSuperHeavyArty-one"] = {size = 12, unit = "corvroc", spirit = "artileryCommander", transfer = 1, status = {1,3,7,10}, preference = {1,1,2,2,3,4,5}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-500}}, 
	["mainOne-coreSuperHeavyArty-two"] = {size = 12, unit = "corvroc", spirit = "artileryCommander", transfer = 2, status = {1,3,7,10}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,350}}, 
	--- horgue ---
	["corhorgBuffer"]                  = {size = 1000, unit = "corhorg", spirit = "vehBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,10}, targetClasses = {}, source = "Veh2", dependance = false},
	["mainOne-horgueAA-one"]           = {size = 8, unit = "corhorg", spirit = "supportLine", transfer = 1, status = {1,2,3,4}, preference = {0,0,1,1,2,2,3}, targetClasses = {}, source = "Veh2", dependance = true, leader = "mainOne-thudAttackForce", depPos = {0,-100}}, 
	--- vamp ---
	["corvampBuffer"]                  = {size = 1000, unit = "corvamp", spirit = "airBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Air2", dependance = false},
	["air-coreAdvancedAirfight-one"]   = {size = 30, unit = "corvamp", spirit = "airSupreme", transfer = 1, status = {5,10,15,20}, preference = {2,4,6,8,10,12,14}, targetClasses = {}, source = "Air2", dependance = false},   
	["air-coreAdvancedAirfight-two"]   = {size = 30, unit = "corvamp", spirit = "airSupreme", transfer = 2, status = {5,10,15,20}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Air2", dependance = false},   
	--- napalm ---
	["corerbBuffer"]                   = {size = 1000, unit = "corerb", spirit = "airBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Air2", dependance = false},
	["air-napalm-one"]                 = {size = 10, unit = "corerb", spirit = "antigroundAir", transfer = 1, status = {0,0,0,8}, preference = {1,2,3,4,5,6,7}, targetClasses = {"jammers","dangerousGroundUnits","strategic","defWeapons"}, source = "Air2", dependance = false},   
	["air-napalm-two"]                 = {size = 10, unit = "corerb", spirit = "antigroundAir", transfer = 2, status = {0,0,0,8}, preference = {1,2,3,4,5,5,5}, targetClasses = {"jammers","dangerousGroundUnits","strategic","defWeapons"}, source = "Air2", dependance = false}, 
	--- destroyer ---
	["cordestBuffer"]                  = {size = 1000, unit = "cordest", spirit = "shipBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,3}, targetClasses = {}, source = "Ship", dependance = false},			
	["basicCoreNavyForceOne"]          = {size = 3, unit = "cordest", spirit = "basicAdmiral", transfer = 1, status = {1,1,1,1}, preference = {0,0,0,0,1,2,3}, targetClasses = {}, source = "Ship", dependance = false},
    --- moho ---
	["corackGroup"]                    = {size = 3, unit = "corack", spirit = "mohobuilder", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Tech2", dependance = false},			
	----- BUILDINGS ----
	--- defs ---
	--- nuke ---
	["coreNukeSilo-one"]               = {size = 10, unit = "corsilo", spirit = "strategicDefence-nuke", transfer = 1, status = {0,0,0,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Def2", dependance = false},
	--- factories ---
	["corlabGroup"]                    = {size = 10, unit = "corlab", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {1,1,2,2,2,2,3}, targetClasses = {}, source = "Main", dependance = false},
	["corvpGroup"]                     = {size = 10, unit = "corvp", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,1,1,1,2,2,2}, targetClasses = {}, source = "Main", dependance = false},
	["corapGroup"]                     = {size = 10, unit = "corap", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,0,0,1,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
	["corcsyGroup"]                    = {size = 10, unit = "corcsy", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,0,0,0,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
	["coralabGroup"]                   = {size = 10, unit = "coralab", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,0,1,1,2,2,3}, targetClasses = {}, source = "Bot2exp", dependance = false},
	["coravpGroup"]                    = {size = 10, unit = "coravp", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,0,1,1,2,2,3}, targetClasses = {}, source = "Veh2exp", dependance = false},
	["coraapGroup"]                    = {size = 10, unit = "coraap", spirit = "factory", transfer = 1, status = {0,1,2,3}, preference = {0,0,1,1,2,2,3}, targetClasses = {}, source = "Air2exp", dependance = false},
	--- buildings ---
	["coreMexes"]                      = {size = 100, unit = "cormex", spirit = "building", transfer = 1, status = {0,1,2,3}, preference = {2,5,7,10,12,13,13}, targetClasses = {}, source = "Main", dependance = false},
	["coreMetalMakers"]                = {size = 200, unit = "cormakr", spirit = "makers", transfer = 1, status = {0,1,2,3}, preference = {0,0,3,6,12,18,30}, targetClasses = {}, source = "Main", dependance = false},
	["coreSolarPower"]                 = {size = 200, unit = "corsolar", spirit = "building", transfer = 1, status = {0,1,2,3}, preference = {2,7,15,22,27,32,35}, targetClasses = {}, source = "Main", dependance = false},
	["coreWindPower"]                  = {size = 200, unit = "corwin", spirit = "building", transfer = 1, status = {0,1,2,3}, preference = {2,7,15,22,27,32,40}, targetClasses = {}, source = "Main", dependance = false},
	["coreFusionPower"]                = {size = 100, unit = "corfus", spirit = "building", transfer = 1, status = {0,1,2,3}, preference = {0,0,0,0,1,1,2}, targetClasses = {}, source = "Main", dependance = false},
	["coreTidalPower"]                 = {size = 200, unit = "cortide", spirit = "building", transfer = 1, status = {0,1,2,3}, preference = {0,4,8,12,18,24,30}, targetClasses = {}, source = "Main", dependance = false},
	--- exp towers ---
	["cor2kbotGroup-one"]              = {size = 1, unit = "cor2kbot", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,1,1,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
	["cor2kbotGroup-two"]              = {size = 1, unit = "cor2kbot", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["cor2kbotGroup-three"]            = {size = 1, unit = "cor2kbot", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["cor2vehGroup-one"]               = {size = 1, unit = "cor2veh", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,1,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
	["cor2vehGroup-two"]               = {size = 1, unit = "cor2veh", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["cor2vehGroup-three"]             = {size = 1, unit = "cor2veh", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["cor2airGroup-one"]               = {size = 1, unit = "cor2air", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,1,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
	["cor2airGroup-two"]               = {size = 1, unit = "cor2air", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["cor2airGroup-three"]             = {size = 1, unit = "cor2air", spirit = "expansion2", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["cor2defGroup-one"]               = {size = 1, unit = "cor2def", spirit = "expansion2def", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,1,1,1,1}, targetClasses = {}, source = "Main", dependance = false},
	["cor2defGroup-two"]               = {size = 1, unit = "cor2def", spirit = "expansion2def", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	["cor2defGroup-three"]             = {size = 1, unit = "cor2def", spirit = "expansion2def", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Main", dependance = false},
	
	--- BUG ---
	--- alpha
	["alphaBuffer"]                    = {size = 1000, unit = "bug1", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,10}, targetClasses = {}, source = "Hive", dependance = false},
	["aphaAttacker-one"]               = {size = 10, unit = "bug1", spirit = "lightAttacker", transfer = 1, status = {0,2,5,8}, preference = {2,5,8,10,10,10,10}, targetClasses = {"metal","energy","builders","factories","defWeapons","radarGround"}, source = "Hive", dependance = false},
	
	--- PIRATES ---
	--- heroes
	["herofatboy"]                    	= {size = 1, unit = "herfatboy", spirit = "lightAttacker", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,1}, targetClasses = {"metal","energy","builders","factories","defWeapons","radarGround"}, source = "None", dependance = false},

	--- REP ---
	--- mum ---
	["asistdronehealing"]              = {size = 1, unit = "dronehealing", spirit = "superunit", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,1}, targetClasses = {"metal","energy","builders","expTowers","factories","defWeapons","radarGround"}, source = "None", dependance = false},
	--- drone ---
	["repdroneBuffer"]                 = {size = 1000, unit = "repdrone", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,8}, targetClasses = {}, source = "None", dependance = false},
	["droneAttacker"]                  = {size = 8, unit = "repdrone", spirit = "lightAttacker", transfer = 4, status = {0,2,4,6}, preference = {2,4,6,8,8,8,8}, targetClasses = {"metal","energy","builders","expTowers","factories","defWeapons","radarGround"}, source = "None", dependance = false},
}

---- update groups table ----
if (groupDefs == nil) then groupDefs = {} end
for k,v in pairs(moduleGroupDefs) do
	groupDefs[k] = v 
end