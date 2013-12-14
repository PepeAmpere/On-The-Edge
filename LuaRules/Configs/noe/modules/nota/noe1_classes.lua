------------------------------------------------------------------------------
-- CLASSES of NOE 1.0
-- more about groups on WIKI: http://code.google.com/p/nota/wiki/NOE_classes
------------------------------------------------------------------------------

local moduleClassDefLists = {
    ---- valuable classes ----
    {
	    ["class"]  = "valuable", 
	    ["name"]   = "metal",
		["static"] = true,
		["list"]   = {
		    "armmex",
			"armfmex",
			--"armuwmex",
			"armmoho",
			"armmmkr",
			"cormex",
			"corfmex",
			--"coruwmex",
			"cormoho",
			"cormmkr",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "energy",
		["static"] = true,
		["list"]   = {
		    "armfus",
			"armmfus",
			"corfus",
			"cormfus",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "builders",
		["static"] = false,
		["list"]   = {
		    "armfark",
			"armck",
			"armcv",
			--"armca",
			--"armacsub",
			"cornecro",
			"corack",
			"corcv",
			--"corca",
			--"coracsub",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "expTowers",
		["static"] = true,
		["list"]   = {
		    "arm2veh",
			"arm2air",
			"arm2def",
			"arm2kbot",
			"armlvl2",
			"armnanotc",
			"cor2air",
			"cor2def",
			"cor2kbot",
			"cor2veh",
			"corlvl2",
			"corntow",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "factories",
		["static"] = true,
		["list"]   = {
		    -- ARM --
		    "armaap",
			"armalab",
			"armap",
			"armavp",
			"armcsy",
			"armhklab",
			"armhp",
			"armlab",
			"armshltx",
			"armvp",
			"armplab",
			"armplat",			
		    -- CORE --						
	        "coraap",
			"coralab",
			"corap",
			"coravp",
			"corvp",
			"corcsy",
			"corgant",
			"corhp",
			"corlab",
			"corplat",
			"corslab",
			"corvalkfac",
			"corplab",
			"armfff",
		},
	},
    {
	    ["class"]  = "valuable",
	    ["name"]   = "defWeapons",
		["static"] = true,
		["list"]   = {
		    "armanni",
			"armlaunch",
			"armguard",
			"armamb",
			"canon3g",
			"armbrtha",
			"armvulc",
			"armbox",
			"armemp",
			"armsilo",
			"armtabi",
			"armamd",
			"armmllt",
			--- CORE ---
		    "cordoom",
			"corpun",
			"cortoast",
			"omega",
			"corint",
			"corbuzz",
			"corsupergun",
			"splinter",
			"cortron",
			"corsilo",
			"corflu",
			"corfmd",
            "corfury2",			
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "radarGround",
		["static"] = false,
		["list"]   = {
		    "armmark",
			"armseer",
			"armrad",
			"corvoyr",
			"corvrad",
			"corrad",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "radarAir",
		["static"] = false,
		["list"] = {
			--"armhawk",
			--"armsehak",
			--"corawac",
			--"corhunt",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "sonar",
		["static"] = true,
		["list"]   = {
			--"armsonar",
			--"corsonar",	
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "jammers",
		["static"] = false,
		["list"]   = {
			"armaser",
			"armjam",
			"corspec",
			"coreter",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "dangerousGroundUnits",
		["static"] = false,
		["list"] = {
		    "armodd",
			"armpod",
			"armcom",
			"armcom2",
			"avtr",
			"armmanni",
			"armmerl",
			"armscab",
			--- CORE ---
			"corgala",
			"cortraq",
			"corkrog",
			"corcom",
			"cordemo",
			"corvroc",
			"corhorg",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "lessDangerousGroundUnits",
		["static"] = false,
		["list"]   = {
		    "armbull",
			--- CORE ---
			"corsumo",
			"corcrabe",
			"correap",
			"corgol",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "dangerousNavyUnits",
		["static"] = false,
		["list"]   = {
			"armthovr",
			"armmcrus",
			"armbcrus",
			"armewar",
			"armcarry",
			"aseadragon",
			"armtib",
			--- CORE ---
			"corthovr",
			"coraat",
			"corsub",
			"corhmcrus",
			"corcarry",
			"corewar",
			"corbcrus",
			"corblackhy",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "dangerousAirUnits",
		["static"] = false,
		["list"]   = {
			"armpnix",
			"blade",
			"corbtrans",
			--- CORE ---
			"corhurc",
			"corerb",
			"corsbomb",
			"corvalk",
			"corvalkii",
			"corff",
		},
	},
	{
	    ["class"]  = "valuable",
	    ["name"]   = "strategic",
		["static"] = true,
		["list"]   = {
			"armamd",
			"armsilo",
			--- CORE ---
			"corfmd",
			"corsilo",
		},
	},
	---- leaders ----
	{
	    ["class"]  = "leaders",
	    ["name"]   = "commandCentre",
		["static"] = false,
		["list"]   = {
		    "armbase",
			"armcom",
			"armcom2",
			"corbase",
			"corcom",
			"corcom2",
		},
	},
	--- other classes ---
	{
	    ["class"]  = "mexes",
	    ["name"]   = "groundMexesOfArm",
		["side"]   = "arm",
		["static"] = true,
		["water"]  = false,
		["list"]   = {
		    "armmex",
			"armmoho",
		},
	},
	{
	    ["class"]  = "mexes",
	    ["name"]   = "groundMexesOfCore",
		["side"]   = "core",
		["static"] = true,
		["water"]  = false,
		["list"]   = {
			"cormex",
			"cormoho",
		},
	},
	{
	    ["class"]  = "mexes",
	    ["name"]   = "waterMexesOfArm",
		["side"]   = "arm",
		["static"] = true,
		["water"]  = true,
		["list"]   = {
			"armfmex",
			"armuwmex",
		},
	},
	{
	    ["class"]  = "mexes",
	    ["name"]   = "waterMexesOfCore",
		["side"]   = "core",
		["static"] = true,
		["water"]  = true,
		["list"]   = {
			"corfmex",
			"coruwmex",
		},
	},
}


------------------------------------------------------------------------------
----------------------- END OF MODULE DEFINITIONS ----------------------------

-- update global tables 
if (classDefLists == nil) then classDefLists = {} end
for k,v in pairs(moduleClassDefLists) do
	classDefLists[k] = v 
end