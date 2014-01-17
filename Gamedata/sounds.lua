local Sounds = {
	SoundItems = {
		--- RESERVED FOR SPRING, DON'T REMOVE
		IncomingChat = {
			file = "sounds/incoming_chat.wav",
			 rolloff = 0.1, 
			maxdist = 10000,
			priority = 100, --- higher numbers = less chance of cutoff
			maxconcurrent = 1, ---how many maximum can we hear?
		},
		MultiSelect = {
			file = "sounds/multiselect.wav",
			 rolloff = 0.1, 
			maxdist = 10000,
			priority = 100, --- higher numbers = less chance of cutoff
			maxconcurrent = 1, ---how many maximum can we hear?
		},
		MapPoint = {
			file = "sounds/mappoint.wav",
			rolloff = 0.1,
			maxdist = 10000,
			priority = 100, --- higher numbers = less chance of cutoff
			maxconcurrent = 1, ---how many maximum can we hear?
		},
		--- END RESERVED

		--WEAPONS

		orangeblob_explo = { 
            file = "sounds/Explosi3.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 6000,


			priority = 10, --- higher numbers = less chance of cutoff
			maxconcurrent = 4, ---how many maximum can we hear?
		},
		mortar1 = { 
            file = "sounds/mortar1.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10, 
			maxconcurrent = 4, 
		},
		mortar2 = { 
            file = "sounds/mortar2.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4, 
		},
		mortarhit = { 
            file = "sounds/mortar_hit.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		
		--- unsorted ---
		bfglaser = { 
            file = "sounds/notsorted/bfglaser.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		bite1 = { 
            file = "sounds/notsorted/Bite1.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		bite2 = { 
            file = "sounds/notsorted/Bite2.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		bite3 = { 
            file = "sounds/notsorted/Bite3.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		bite4 = { 
            file = "sounds/notsorted/Bite4.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		bug_smash = { 
            file = "sounds/notsorted/bug_smash.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		bug_smash2 = { 
            file = "sounds/notsorted/bug_smash2.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		bugyes = { 
            file = "sounds/notsorted/bugyes.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		bugyes2 = { 
            file = "sounds/notsorted/bugyes2.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		crash1 = { 
            file = "sounds/notsorted/Crash1.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		exploze1 = { 
            file = "sounds/notsorted/Exploze1.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		exploze2 = { 
            file = "sounds/notsorted/Exploze2.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		exploze3 = { 
            file = "sounds/notsorted/Exploze3.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},		
		exploze4 = { 
            file = "sounds/notsorted/Exploze4.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		flamethrower = { 
            file = "sounds/notsorted/flamethrower.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		grenade_launch = { 
            file = "sounds/notsorted/grenade_launch.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		heavy_shot = { 
            file = "sounds/notsorted/heavy_shot.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		laser = { 
            file = "sounds/notsorted/laser.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		laser1 = { 
            file = "sounds/notsorted/laser1.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		laser2 = { 
            file = "sounds/notsorted/laser2.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		ontheedge1 = { 
            file = "sounds/notsorted/ontheedge1.mp3", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		ontheedge1_1 = { 
            file = "sounds/notsorted/ontheedge1_1.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		ontheedge2 = { 
            file = "sounds/notsorted/ontheedge2_2.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		ontheedge3 = { 
            file = "sounds/notsorted/ontheedge3.mp3", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		robotselect1 = { 
            file = "sounds/notsorted/robotselect1.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		robotselect2 = { 
            file = "sounds/notsorted/robotselect2.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		robotselect3 = { 
            file = "sounds/notsorted/robotselect3.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		robotyes1 = { 
            file = "sounds/notsorted/robotyes1.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		robotyes2 = { 
            file = "sounds/notsorted/robotyes2.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		robotyes3 = { 
            file = "sounds/notsorted/robotyes3.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		rocketlaunch2 = { 
            file = "sounds/notsorted/rocketlaunch2.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		shot_hit_metal1 = { 
            file = "sounds/notsorted/shot_hit_metal1.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		slime_splash = { 
            file = "sounds/notsorted/Slime_Splash.ogg", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},		
		sniper = { 
            file = "sounds/notsorted/sniper.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 5000,
			priority = 10,
			maxconcurrent = 4,
		},
		submachine_gun_oneshot = { 
            file = "sounds/notsorted/submachine_gun_oneshot.wav", 
			rolloff=3, dopplerscale = 0, maxdist = 1000,
			priority = 10,
			maxconcurrent = 4,
		},
		
		--[[DefaultsForSounds = { -- this are default settings
			file = "ThisEntryMustBePresent.wav",
			gain = 1.0,
			pitch = 1.0,
			priority = 0,
			maxconcurrent = 16, --- some reasonable limits
			--maxdist = FLT_MAX, --- no cutoff at all
		},
		--- EXAMPLE ONLY!
		MyAwesomeSound = {			
			file = "sounds/booooom.wav",
			preload, -- put in memory!
			loop,  -- loop me!
			looptime=1000, --- milliseconds!
			gain = 2.0, --- for uber-loudness
			pitch = 0.2, --- bass-test
			priority = 15, --- very high
			maxconcurrent = 1, ---only once
			--maxdist = 500, --- only when near
		},]]
	},
}




return Sounds
