------------------------
--- MISSION SETTINGS ---
------------------------

----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

missionInfo = {
    name         		= "notAdota",
	victoryCount 		= 2,
	defeatCount  		= 1,
	maxPlayers			= 16,
	playersMetal		= 0,
	playersEnergy		= 0,
	AIcount      		= 3,
	AInames      = {
	    "BASE Team 1",
		"BASE Team 2",
		"WILDERNESS",
	},
	victoryCount		= 1,
	defeatCount			= 1,
	victory	= {
		{	-- prefered victory			
			description = "Win 100.",
			message		= "Great job, we won!",
		},
	},
	defeat	= {
		{	-- loose
			description = "Loose",	
			message		= "Bad day",
		},
	},
	notStartUnit		= true,
	specificMapNeeded	= false,
	specMapName			= "notAdotaMap",
	
}
