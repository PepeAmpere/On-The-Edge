----- mission events settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newEvents = {
	-- spawn all armies every minute
    {	repeating			= true,					active			= true,								slow	= true,
		conditionsNames		= {"SecondInMinute"},	actionsNames	= {"SpawnAll"},
		conditionsParams	= {{0}},				actionsParams	= {{}},
	}, 
	
	-- if any of main barracks killed, stop produce units there
	{	repeating			= true,					active			= true,								slow	= true,
		conditionsNames		= {"timeMore"},			actionsNames	= {"CheckBarracksAlive"},
		conditionsParams	= {{{0,0,1}}},			actionsParams	= {{}},
	}, 
	
	-- endgame 
	{	repeating			= true,					active			= true,								slow	= true,
		conditionsNames		= {"GameUndecided"},	actionsNames	= {"CheckEndGame"},
		conditionsParams	= {{}},					actionsParams	= {{}},
	},
}
