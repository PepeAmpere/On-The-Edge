-- SIDE of NOE 1.0
-- more about side on WIKI: http://code.google.com/p/nota/wiki/NOE_side

local moduleSideSettings = {   
	["arm"] = {
        ["groups"] = {
		    --- brain ---
			"cake",
		    --- commander ---
			"armCommandTower",
			"armCommander",    
		    --- pw groups ---
		    "armpwBuffer",
			"pwLight-one",
			"pwLight-two",
			"pwLight-three",
			"pwLight-four",
			"pwLight-expansionDef-one",
			"pwLight-expansionDef-two",
			"pwLight-expansionDef-three",
			"pwLight-attack-one",
			"pwLight-attack-two",
			"pwLight-remnants-one",
			"pwLight-remnants-two",
            --- hammer ---
			"armhamBuffer",
			"mainOne-hamAttackForce",
			"mainOne-hamAttackForce-support",
			"ham-remnants",
			--- rocko ---
	        "armrockBuffer",
			"mainOne-rocketShield-one",
			--- sniper ---
			"armsnipeBuffer",
			"mainOne-snipeSupport",
			"sniper-raider-one",
			"sniper-raider-two",
			--- jethro ---
			"armjethBuffer",
			"mainOne-armjethAA-one",
			"mainOne-armjethAA-two",
			"mainOne-armjethAA-three",
			--- fark ---
			"armfarkBuffer",
			"ecoFarkOne",
			"ecoFarkTwo",
			"ecoFarkThree",
			"ecoFarkFour",
			"tower-farkAssist",
			"base-farkReclaim",
 			"mainOne-farkSupport-reclaim",
            "mainOne-farkSupport-repair",  			
			--- fav jeffy ---
			"armfavBuffer",
			"scoutJeffOne",
			--- stumpy ---
			"armstumpBuffer",
			"mainOne-stumpyFlank-left",
			"mainOne-stumpyFlank-right",
			"stumpy-raider",
			"mainStumpyTank",
			"stumpy-remnants",
			--- patnher ---
			"armlatnkBuffer",
			"invisible-raiders",
			--- veh arty ---
			"armmartBuffer",
		    "mainOne-lightArmArty-one",
			"mainOne-lightArmArty-two",
			--- veh flak ---
			"armyorkBuffer",
			"mainOne-armFlakSquad",
			"base-armFlakSquad-one",
			"base-armFlakSquad-two",
			"base-armFlakSquad-three",
            --- veh radar ---
	        "armseerBuffer",
            "mainOne-armRadarUnit",		
			--- hellfish ---
			"armhellBuffer",
			"airHellGroundOne",
			"airHellGroundTwo",
			"airHellGroundThree",
			"airHellGroundFour",
            --- thunder ---
            "armthundBuffer",
            "airBombSquad-thunderOne",
			"airBombSquad-thunderTwo",
			"airBombSquad-thunderThree",
			"airBombSquad-thunderFour",
			"airBombSquad-thunderFive",
			--- tECH2 ---
			--- maverick ---
			"armmavBuffer",
			"mainOne-armmav-one",
			"mainOne-armmav-two",
			"mainOne-armmav-three",
			--- raptor ---
			"raptorivBuffer",
			"raptor-raider-one",
			"raptor-raider-two",
			--- oddity ---
			"armoddBuffer",
			"mainOne-armHeavyArty-one", 
			"mainOne-armHeavyArty-two",
			--- eraser ---
			"armaserBuffer",
			"mainOne-armBotJammerUnit", 
			--- penetrator ---
			"armmanniBuffer",
			"mainOne-mobileAnnihilator", 
			"mainOne-mobileAnnihilator2",
			--- merl ---
			"armmerlBuffer",
			"mainOne-armSuperHeavyArty", 	
            --- hermes ---
            "aHermesBuffer",
            "mainOne-hermesAA-one",	
            --- hawk ---
            "armhawkBuffer",
            "air-armAdvancedAirfight-one",
            "air-armAdvancedAirfight-two",
			--- wing ---
            "armwingBuffer",
            "air-wings-one",
            "air-wings-two",
			--- destroyer ---
            "armexcalBuffer",			
			"basicArmNavyForceOne",
			--- moho ---
			"armckGroup",
			--- defs ---
			"armNukeSilo-one",
            --- factories ---
            "armlabGroup",	
            "armvpGroup",
            "armapGroup",
            "armcsyGroup",
			"armalabGroup",
			"armavpGroup",
			"armaapGroup",
            --- buildings ---
            "armMexes",
			"armMetalMakers",
			"armSolarPower",
			"armWindPower",
			"armFusionPower",
			"armTidalPower",
            --- expansion towers groups ---  
		    "arm2kbotGroup-one",
			"arm2kbotGroup-two",
			"arm2kbotGroup-three",
			"arm2vehGroup-one",	
            "arm2vehGroup-two",
			"arm2vehGroup-three",
			"arm2airGroup-one",	
            "arm2airGroup-two",
			"arm2airGroup-three",
			"arm2defGroup-one",	
            "arm2defGroup-two",
			"arm2defGroup-three",
        },
		["basicTools"] = {
		    -- mexes --
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
			{toolPurpose = "advancedGroundMex", unitName = "armmoho"},
			{toolPurpose = "floatingMex", unitName = "armfmex"},
			{toolPurpose = "underwaterMex", unitName = "armuwmex"},
			-- energy resources --
			{toolPurpose = "basicStableGroundEnergyResource", unitName = "armsolar"},
			{toolPurpose = "basicUnStableGroundEnergyResource", unitName = "armwin"},
			{toolPurpose = "advancedStableGroundEnergyResource", unitName = "armfus"},
			{toolPurpose = "geothermalPlant", unitName = "armgeo"},
			{toolPurpose = "basicWaterStableEnergyResource", unitName = "armtide"},
			-- storages --
			{toolPurpose = "basicMetalStorage", unitName = "armmstor"},
			{toolPurpose = "basicEnergyStorage", unitName = "armestor"},
			-- metalmaker --
			{toolPurpose = "basicMetalMaker", unitName = "armmakr"},
			-- units, builders --
			{toolPurpose = "basicBotBuilder", unitName = "armfark"},
			{toolPurpose = "mohoBuilder", unitName = "armck"},
			{toolPurpose = "basicVehicleBuilder", unitName = "armcv"},
			{toolPurpose = "basicHoverBuilder", unitName = "armch"},
			{toolPurpose = "basicUnderwaterBuilder", unitName = "armacsub"},
			-- basic factories --
			{toolPurpose = "botLabTech1", unitName = "armlab"},
			{toolPurpose = "vehLabTech1", unitName = "armvp"},
			{toolPurpose = "airLabTech1", unitName = "armap"},
			{toolPurpose = "shipyard", unitName = "armcsy"},
			{toolPurpose = "hoversPlatform", unitName = "armplat"},
			-- expansions --
			{toolPurpose = "botTech2", unitName = "arm2kbot"},
			{toolPurpose = "vehTech2", unitName = "arm2veh"},
			{toolPurpose = "airTech2", unitName = "arm2air"},
			{toolPurpose = "defTech2", unitName = "arm2def"},
			-- adv. factories --
			{toolPurpose = "botLabTech2", unitName = "armalab"},
			{toolPurpose = "vehLabTech2", unitName = "armavp"},
			{toolPurpose = "airLabTech2", unitName = "armaap"},
			-- mohominer --
			{toolPurpose = "mohoMiner", unitName = "armck"},
			-- radar --
			{toolPurpose = "groundRadar", unitName = "armrad"},
			-- airpads --
			{toolPurpose = "staticAirpad", unitName = "armasp"},
			-- defences --
			{toolPurpose = "llt", unitName = "armllt"},
			{toolPurpose = "plasmaBattery", unitName = "armguard"},
			{toolPurpose = "staticFlak", unitName = "armflak"},
			{toolPurpose = "nukeSilo", unitName = "armsilo"},
			{toolPurpose = "lrpc", unitName = "armbrtha"},
			{toolPurpose = "anniLaser", unitName = "armanni"},
		},
	},
	["core"] = {
        ["groups"] = {
		    --- brain ---
			"thor",
		    --- commander ---
			"corCommandTower",
			"corCommander",
		    --- ak groups ---
		    "corakBuffer",
			"akLight-one",
			"akLight-two",
			"akLight-three",
			"akLight-four",
			"akLight-expansionDef-one",
			"akLight-expansionDef-two",
			"akLight-expansionDef-three",
			"akRaider-one",
			"akRaider-two",
			"akRaider-three",
			"akRaider-four",
			"mainOne-akSupport-one",
			"mainOne-akSupport-two",
            --- thud ---
			"corthudBuffer",
			"mainOne-thudAttackForce",
			"mainOne-thudAttackForce-support",
			"thud-remnants-one",
			"thud-remnants-two",
			--- storm ---
			"corstormBuffer",
			"mainOne-stormShield-one",
			--- morty ---
			"cormortBuffer",
			"mainOne-mortySupport",
			--- crasher ---
			"corcrashBuffer",
			"mainOne-crasherAA-one",
			"mainOne-crasherAA-two",
			"mainOne-crasherAA-three",
			--- necro ---
			"cornecroBuffer",
			"necroEcoOne",
			"necroEcoTwo",
			"necroEcoThree",
			"necroEcoFour",
			"tower-necroAssist",
			"base-necroReclaim",
 			"mainOne-necroSupport-reclaim",
            "mainOne-necroSupport-repair",  			
			--- fav ---
			"corfavBuffer",
			"favScoutOne",
			--- raider ---
			"corraidBuffer",
			"mainOne-raiderFlank-left",
			"mainOne-raiderFlank-right",
			"mainTank",
			"raider-remnants",
			--- leveler ---
			"corlevlrBuffer",
			"mainOne-levelerArty-one",
			"mainOne-levelerArty-two",
			--- veh arty ---
			"cormartBuffer",
		    "mainOne-coreLightArty-one",
			"mainOne-coreLightArty-two",
			--- veh flak ---
			"corsentBuffer",
			"mainOne-coreFlakSquad",
			"base-coreFlakSquad-one",
			"base-coreFlakSquad-two",
			"base-coreFlakSquad-three",
            --- veh radar ---
	        "corvradBuffer",
            "mainOne-coreRadarUnit",
			--- vashp ---
			"corevashpBuffer",
			"airVaspGroundOne",
            "airVaspGroundTwo",
			"airVaspGroundRemnantsOne",
			"airVaspGroundRemnantsTwo",
			"airVaspGroundRemnantsThree",
			"airVaspGroundRemnantsFour",
			--- tECH2 ---
			--- dominator ---
			"corhrkBuffer",
			"mainOne-corhrk-one",
			"mainOne-corhrk-two",
			"mainOne-corhrk-three",
			--- galacticus ---
			"corgalaBuffer",
			"mainOne-coreHeavyArty-one", 
			"mainOne-coreHeavyArty-two", 
			"mainOne-coreHeavyArty-three", 
			--- spectre ---
			"corspecBuffer",
			"mainOne-coreBotJammerUnit", 
			--- goliath ---
			"corgolBuffer",
			"mainOne-coreMeatShield-one", 
			"mainOne-coreMeatShield-two", 
			"mainOne-coreMeatShield-three", 
			--- diplomat ---
			"corvrocBuffer",
			"mainOne-coreSuperHeavyArty-one", 
			"mainOne-coreSuperHeavyArty-two", 
            --- horgue ---
            "corhorgBuffer",
            "mainOne-horgueAA-one",	
            --- vamp ---
            "corvampBuffer",
            "air-coreAdvancedAirfight-one",
            "air-coreAdvancedAirfight-two",			
			--- napalm ---
			"corerbBuffer",
			"air-napalm-one",
			"air-napalm-two",
			--- destroyer ---
            "cordestBuffer",			
			"basicCoreNavyForceOne",
			--- moho ---
			"corackGroup",
			--- defs ---
			"coreNukeSilo-one",
            --- factories ---
            "corlabGroup",	
            "corvpGroup",
            "corapGroup",
            "corcsyGroup",
			"coralabGroup",
			"coravpGroup",
			"coraapGroup",
            --- buildings ---
            "coreMexes",
			"coreMetalMakers",
			"coreSolarPower",
			"coreWindPower",
			"coreFusionPower",
			"coreTidalPower",
            --- expansion towers groups ---	
			"cor2kbotGroup-one",
			"cor2kbotGroup-two",
			"cor2kbotGroup-three",
			"cor2vehGroup-one",	
            "cor2vehGroup-two",
			"cor2vehGroup-three",
			"cor2airGroup-one",	
            "cor2airGroup-two",
			"cor2airGroup-three",
			"cor2defGroup-one",	
            "cor2defGroup-two",
			"cor2defGroup-three",
        },	
        ["basicTools"] = {
		    -- mexes --
		    {toolPurpose = "basicGroundMex", unitName = "cormex"},
			{toolPurpose = "advancedGroundMex", unitName = "cormoho"},
			{toolPurpose = "floatingMex", unitName = "corfmex"},
			{toolPurpose = "underwaterMex", unitName = "coruwmex"},
			-- energy resources --
			{toolPurpose = "basicStableGroundEnergyResource", unitName = "corsolar"},
			{toolPurpose = "basicUnStableGroundEnergyResource", unitName = "corwin"},
			{toolPurpose = "advancedStableGroundEnergyResource", unitName = "corfus"},
			{toolPurpose = "geothermalPlant", unitName = "corgeo"},
			{toolPurpose = "basicWaterStableEnergyResource", unitName = "cortide"},
			-- storages --
			{toolPurpose = "basicMetalStorage", unitName = "cormstor"},
			{toolPurpose = "basicEnergyStorage", unitName = "corestor"},
			-- metalmaker --
			{toolPurpose = "basicMetalMaker", unitName = "cormakr"},
			-- units, builders --
			{toolPurpose = "basicBotBuilder", unitName = "cornecro"},
			{toolPurpose = "mohoBuilder", unitName = "corck"},
			{toolPurpose = "basicVehicleBuilder", unitName = "corcv"},
			{toolPurpose = "basicHoverBuilder", unitName = "corch"},
			{toolPurpose = "basicUnderwaterBuilder", unitName = "coracsub"},
			-- basic factories --
			{toolPurpose = "botLabTech1", unitName = "corlab"},
			{toolPurpose = "vehLabTech1", unitName = "corvp"},
			{toolPurpose = "airLabTech1", unitName = "corap"},
			{toolPurpose = "shipyard", unitName = "corcsy"},
			{toolPurpose = "hoversPlatform", unitName = "corplat"},
			-- expansions --
			{toolPurpose = "botTech2", unitName = "cor2kbot"},
			{toolPurpose = "vehTech2", unitName = "cor2veh"},
			{toolPurpose = "airTech2", unitName = "cor2air"},
			{toolPurpose = "defTech2", unitName = "cor2def"},
			-- adv. factories --
			{toolPurpose = "botLabTech2", unitName = "coralab"},
			{toolPurpose = "vehLabTech2", unitName = "coravp"},
			{toolPurpose = "airLabTech2", unitName = "coraap"},
			-- mohominer --
			{toolPurpose = "mohoMiner", unitName = "corack"},
			-- radar --
			{toolPurpose = "groundRadar", unitName = "corrad"},
			-- airpads --
			{toolPurpose = "staticAirpad", unitName = "corasp"},
			-- defences --
			{toolPurpose = "llt", unitName = "corllt"},
			{toolPurpose = "plasmaBattery", unitName = "corpun"},
			{toolPurpose = "staticFlak", unitName = "corflak"},
			{toolPurpose = "nukeSilo", unitName = "corsilo"},
			{toolPurpose = "lrpc", unitName = "corint"},
			{toolPurpose = "anniLaser", unitName = "cordoom"},
		},		
	},
	["bug"] = {
	    ["groups"] = {
		    "alphaBuffer",
			"aphaAttacker-one",
		},
	},
	["pir"] = {
	    ["groups"] = {
		    "herofatboy",
		},
	},
	["rep"] = {
	    ["groups"] = {
		    "repmum",
			"repdroneBuffer",
			"droneAttacker",
		},
	},
}


------------------------------------------------------------------------------
----------------------- END OF MODULE DEFINITIONS ----------------------------

---- update global tables ----
if (sideSettings == nil) then sideSettings = {} end
for k,v in pairs(moduleSideSettings) do
	sideSettings[k] = v 
end