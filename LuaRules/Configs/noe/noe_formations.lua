------------------------------
----- NOE formations ---------
------------------------------

--- (*) ADDING NEW FORMATION - what you should do:
--- every formation needs:
--- name = string
--- limit = number
--- scales = table with two numbers - x scale and z scale
--- if it has generation function - gen = bool 
--- how big hilly coeficient is needed to dont use formation - hilly = number (from 5 to 80)
--- if formation likes to be constrained, keeping formation in cost of time - constrained = bool
--- if yes, set constainLevel = number (1-8) (how many iterations maximaly will game wait to get formation back)
--- if formation has variant - variant = bool
--- if yes, the name of formation - nextVariant = string (with name of other difined formation)
--- if it can be rotated - rotable = bool
--- if yes, then number of rotations (not identical variants) of formation - rotations = number
--- if rotable - rotationCheckDistance set how far from target formation can be changed
--- THEN
--- you have to add yourFormationName into list of formations (formationNames)
--- you have to add definition of formation to formationDef table
--- you have to make formations table in table formations (there have to be defined that ["yourFormationName"] = {}, at least, if you plan to generate formation
--- if you plan to generate formation, you have to define your generation function in formationsGeneration
--- AND
--- you need some spirit, that uses your formation

formationBySpirit = {
	["raider"]             = "arrow",
	["cloacked-raider"]    = "arrow",
	["flanker"]            = "swarm",
	["lightDefender"]      = "swarm",
	["builderDefender"]    = "circle",
	["lightAttacker"]      = "swarm",
	["cleaner"]            = "swarm",
	["standardMainLine"]   = "standardLine",
	["secondaryLine"]      = "standardLine2nd",
	["heavySupportLine"]   = "standardLine",
	["supportLine"]        = "smallLine",
	["eco"]                = "swarm",
	["mainTank"]           = "wedge",
	["artileryCommander"]  = "artyLine",
	["antigroundAir"]      = "doubleColumn",
	["basicAdmiral"]       = "seaUnit",
	["superunit"]          = "noForm",
	["airSupreme"]         = "noForm",
	["mohobuilder"]        = "noForm",
	---- buffers ----
	["botBuffer"]          = "hexagon",
	["vehBuffer"]          = "box",
    ["airBuffer"]          = "box",          --- ! this shoud be changed later, too small for air
	["shipBuffer"]         = "box",          --- ! this shoud be changed later, too small for ships
	---- passive ---
	["noSpirit"]           = "noForm",
	["brain"]              = "noForm",
    ["tower"]              = "noForm",
	["commander"]          = "noForm",
	["factory"]            = "noForm",
	["building"]           = "noForm",
	["makers"]             = "noForm",
	["expansion2"]         = "noForm",
	["expansion2def"]      = "noForm",
	["strategicDefence-nuke"] = "noForm",
}

--- these one thing is strange, created becouse cannot be used formationDef[i].name   - why? i dont know
formationNames = {"noForm","hexagon","box","arrow","swarm","standardLine","standardLineZig","standardLine2nd","smallLine","doubleColumn","seaUnit","artyLine","wedge","circle"}

formationDef = {
    ["noForm"]             = {name = "noForm",		limit = 1, 		scales = {1,1}, 	gen = false, hilly = 0, constrained = false, variant = false,                                                  rotable = false},
	["hexagon"]            = {name = "hexagon",		limit = 100, 	scales = {7,0}, 	gen = true,  hilly = 0, constrained = false, variant = false,                                                  rotable = false},
	["box"]                = {name = "box", 		limit = 100, 	scales = {25,25}, 	gen = true,  hilly = 0, constrained = false, variant = false,                                                  rotable = true, rotations = 8, rotationCheckDistance = 2000},
	["arrow"]              = {name = "arrow",		limit = 5, 		scales = {10,10}, 	gen = true,  hilly = 0, constrained = false, variant = false,                                                  rotable = true, rotations = 16, rotationCheckDistance = 2000},
	["swarm"]              = {name = "swarm", 		limit = 30, 	scales = {10,10}, 	gen = true,  hilly = 30, constrained = true,  constrainLevel = 2, variant = false,                             rotable = false},
	["standardLine"]       = {name = "standardLine", limit = 61, 	scales = {30,20}, 	gen = true,  hilly = 60, constrained = true,  constrainLevel = 8, variant = true, nextVariant = "standardLineZig", rotable = true, rotations = 16, rotationCheckDistance = 2000},
	["standardLineZig"]    = {name = "standardLineZig", limit = 61, scales = {30,20}, 	gen = true,  hilly = 60, constrained = true,  constrainLevel = 8, variant = true, nextVariant = "standardLine", rotable = true, rotations = 16, rotationCheckDistance = 2000},
	["standardLine2nd"]    = {name = "standardLine2nd", limit = 61, scales = {30,20}, 	gen = true,  hilly = 60, constrained = true,  constrainLevel = 8, variant = false,                             rotable = true, rotations = 16, rotationCheckDistance = 2000},
	["smallLine"]          = {name = "smallLine", 	limit = 9, 		scales = {180,5}, 	gen = true,  hilly = 0, constrained = false, variant = false,                                                  rotable = true, rotations = 16, rotationCheckDistance = 2000},
	["doubleColumn"]       = {name = "doubleColumn", limit = 12, 	scales = {80,80}, 	gen = true,  hilly = 0, constrained = false, variant = false,                                                  rotable = true, rotations = 16, rotationCheckDistance = 2000},
	["seaUnit"]            = {name = "seaUnit", 	limit = 3, 		scales = {50,50}, 	gen = true,  hilly = 0, constrained = false, variant = false,                                                  rotable = true, rotations = 16, rotationCheckDistance = 2000},
	["artyLine"]           = {name = "artyLine", 	limit = 12, 	scales = {70,30}, 	gen = true,  hilly = 0, constrained = false, variant = false,                                                  rotable = true, rotations = 16, rotationCheckDistance = 800},
	["wedge"]              = {name = "wedge", 		limit = 36, 	scales = {60,80}, 	gen = true,  hilly = 20, constrained = true, constrainLevel = 8, variant = false,                              rotable = true, rotations = 16, rotationCheckDistance = 2000},
	["circle"]             = {name = "circle", 		limit = 8, 	    scales = {40,40},   gen = true,  hilly = 20, constrained = true, constrainLevel = 2, variant = false,                              rotable = false},
}
--- formation limit should be allways bigger than limit of group 

formations = {
    ["noForm"] = { 
	    [1]  = {0,0},
	},
    ["swarm"] = {
	    [1]  = {0,0},		[2]  = {9,-1},		[3]  = {2,-8},		[4]  = {-5,-7},		[5]  = {-10,4},
		[6]  = {1,10},		[7]  = {12,9},		[8]  = {16,-2},		[9]  = {12,-11},	[10] = {1,-17},
		[11] = {-8,-16},	[12] = {-15,-3},	[13] = {-15,10},	[14] = {-5,18},		[15] = {8,19},
		[16] = {21,13},		[17] = {25,2},		[18] = {21,-10},	[19] = {6,-20},		[20] = {-4,-22},
		[21] = {-17,-7},	[22] = {-22,2},		[23] = {-15,20},	[24] = {3,26},		[25] = {18,23},
		[26] = {29,10},		[27] = {28,-7},		[28] = {21,-20},	[29] = {5,-27},		[30] = {-13,-24},
	},
	["arrow"] = {
	    [1]  = {0,4},
		[2]  = {-3,0},
		[3]  = {3,0},
		[4]  = {-6,-4},
		[5]  = {6,-4},
	},
	["wedge"] = {
	    [1]  = {0,0},
		[2]  = {-1,2},		[3]  = {0,2},		[4]  = {1,2},
		[5]  = {-2,1},		[6]  = {-1,1},		[7]  = {0,1,},		[8]  = {1,1},		[9]  = {2,1},
		[10]  = {-3,0},		[11]  = {-2,0},		[12]  = {-1,0},		[13]  = {0,3},		[14]  = {1,0},		[15]  = {2,0},		[16]  = {3,0},
		[17]  = {-4,-1},	[18]  = {-3,-1},	[19]  = {-2,-1},    [20]  = {-1,-1},	[21]  = {0,-1},		[22]  = {1,-1},		[23]  = {2,-1},		[24]  = {3,-1},		[25]  = {4,-1},
		[26]  = {-5,-2},	[27]  = {-4,-2},    [28]  = {-3,-2},	[29]  = {-2,-2},    [30]  = {-1,-2},	[31]  = {0,-2},		[32]  = {1,-2},		[33]  = {2,-2},		[34]  = {3,-2},		[35]  = {4,-2},		[36]  = {5,-2},
	},
	["standardLine"] = {
		[1]  = {0,1},		[2]  = {0,6},		[3]  = {2,6},		[4]  = {-2,6},		[5]  = {4,6},		
		[6]  = {-4,6},		[7]  = {1,4},		[8]  = {-1,4},		[9]  = {3,4},		[10]  = {-3,4},
	},
	["standardLineZig"] = {
		[1]  = {0,-3},		[2]  = {0,-1},		[3]  = {2,-1},		[4]  = {-2,-1},		[5]  = {4,-1},		
		[6]  = {-4,-1},		[7]  = {1,1},		[8]  = {-1,1},		[9]  = {3,1},		[10]  = {-3,1},
	},
	["standardLine2nd"] = {
	    [1]  = {0,-9},		[2]  = {0,-7},		[3]  = {2,-7},		[4]  = {-2,-7},		[5]  = {4,-7},		
		[6]  = {-4,-7},     [7]  = {1,-5},		[8]  = {-1,-5},		[9]  = {3,-5},		[10]  = {-3,-5},
	},
	["smallLine"] = {
	    [1]  = {0,-1},		[2]  = {1,-1},		[3]  = {-1,-1},		[4]  = {2,-1},		[5]  = {-2,-1},
		[6]  = {3,-1},		[7]  = {-3,-1},		[8]  = {4,-1},	    [9]  = {-4,-1},
	},
	["circle"] = {
	    [1]  = {4,0},		[2]  = {-4,4},		[3]  = {-8,0},		[4]  = {-4,-4},		[5]  = {-1,3},
		[6]  = {-1,-3},		[7]  = {-7,3},		[8]  = {-7,-3},
	},
    ["doubleColumn"] = {
	    [1]  = {-1,4},		[2]  = {1,4},		[3]  = {-1,2},		[4]  = {1,2},		[5]  = {-1,0},
		[6]  = {1,0},		[7]  = {-1,-2},		[8]  = {1,-2},		[9]  = {-1,-4},		[10] = {1,-4},
		[11] = {-1,-6},		[12] = {1,-6},
	},
	["seaUnit"] = {
	    [1]  = {0,2},
		[2]  = {-2,1},
		[3]  = {2,1},
		[4]  = {-4,0},
		[5]  = {4,0},
	},
	["artyLine"] = {
	    [1]  = {0,1},		[2]  = {2,1},		[3]  = {-2,1},		[4]  = {4,1},		[5]  = {-4,1},
		[6]  = {1,-1},		[7]  = {-1,-1},		[8]  = {3,-1},		[9]  = {-3,-1},		[10] = {6,1},
		[11] = {-6,1},		[12] = {5,-1},      [13] = {-5,-1},     [14] = {8,1},       [15] = {-8,1},
		[16] = {7,-1},      [17] = {-7,-1},     [18] = {10,1},
	},
	["box"] = {
	    [1]  = {0,0},		[2]  = {1,0},		[3]  = {1,-1},		[4]  = {0,-1},		[5]  = {-1,-1},
		[6]  = {-1,0},		[7]  = {-1,1},		[8]  = {0,1},		[9]  = {1,1},		[10] = {2,1},
		[11] = {2,0},		[12] = {2,-1},		[13] = {2,-2},		[14] = {1,-2},		[15] = {0,-2},
		[16] = {-1,-2},		[17] = {-2,2},		[18] = {-2,-1},		[19] = {-2,-0},		[20] = {-2,1},
		[21] = {-2,2},		[22] = {-1,2},		[23] = {-0,2},		[24] = {1,2},		[25] = {2,2},
		[26] = {3,2},		[27] = {3,1},		[28] = {3,0},		[29] = {3,-1},		[30] = {3,-2},
		[31] = {3,-3},		[32]  = {2,-3},		[33] = {1,-3},		[34] = {0,-3},		[35] = {-1,-3},
		[36] = {-2,-3},		[37] = {-3,-3},		[38] = {-3,-2},		[39] = {-3,-1},		[40] = {-3,0},
		[41] = {-3,1},		[42] = {-3,2},		[43] = {-3,3},		[44] = {-2,3},		[45] = {-1,3},
		[46] = {0,3},		[47] = {1,3},		[48] = {2,3},		[49] = {3,3},		[50] = {4,3},
		[51] = {4,2},		[52] = {4,1},		[53] = {4,0},		[54] = {4,-1},		[55] = {4,-2},
		[56] = {4,-3},		[57] = {4,-4},		[58] = {3,-4},		[59] = {2,-4},		[60] = {1,-4},
		[61] = {0,-4},		[62] = {-1,-4},		[63] = {-2,-4},		[64] = {-3,-4},		[65] = {-4,-4},
		[66] = {-4,-3},		[67] = {-4,-2},		[68] = {-4,-1},		[69] = {-4,0},		[70] = {-4,1},
		[71] = {-4,2},		[72] = {-4,3},		[73] = {-4,4},		[74] = {-3,4},		[75] = {-2,4},
		[76] = {-1,4},		[77] = {0,4},		[78] = {1,4},		[79] = {2,4},		[80] = {3,4},
		[81] = {4,4},		[82] = {5,4},		[83] = {5,3},		[84] = {5,2},		[85] = {5,1},
		[86] = {5,0},		[87] = {5,-1},		[88] = {5,-2},		[89] = {5,-3},		[90] = {5,-4},
		[91] = {5,-5},		[92] = {4,-5},		[93] = {3,-5},		[94] = {2,-5},		[95] = {1,-5},
		[96] = {0,-5},		[97] = {-1,-5},		[98] = {-2,-5},		[99] = {-3,-5},		[100] = {-4,-5},
	},
   ["hexagon"] = {
	    [1]  = {0,0},
		[2]  = {3,6*math.sin(30)},
		[3]  = {6,0},
		[4]  = {3,-6*math.sin(30)},
		[5]  = {-3,-6*math.sin(30)},
		[6]  = {-6,0},
		[7]  = {-3,6*math.sin(30)}, 
		--- and so on
		--- will be easy to generate it? yep
	},
}

formationsRotated = {}

function FormationsDebug(makeIt)
    if (makeIt) then
		for a=1,#formationNames do
		    local formationName = formationNames[a]
		    Spring.Echo(formationName)
			if (formationDef[formationName].rotable) then
				for i=1,formationDef[formationName].rotations do
					for j=1,formationDef[formationName].limit do
						Spring.Echo(formationsRotated[formationName][i][j][1] .. " " .. formationsRotated[formationNames[a]][i][j][2])
					end		
					Spring.Echo("end of Rotation .." .. i)					
				end				
			else
				for j=1,formationDef[formationName].limit do
					Spring.Echo(formations[formationNames[a]][j][1] .. " " .. formations[formationNames[a]][j][2])
				end
			end
		end
	else
	    Spring.Echo("Formations debug not requested")
	end
end

function Rotate(posX,posZ,alpha)
    local newPosX, newPosZ
	newPosX = posX*math.cos(alpha) - posZ*math.sin(alpha)
	newPosZ = posX*math.sin(alpha) + posZ*math.cos(alpha)
	local newCouple = {newPosX, newPosZ}
	return newCouple
end

function Rotation ()
	for i=1,#formationNames do
		local thisFormation = formationDef[formationNames[i]]
		local formationName = thisFormation.name
		formationsRotated[formationName] = {}
		local rotations = 0
		local positions = thisFormation.limit
		if (thisFormation.rotable) then
			rotations = thisFormation.rotations
			local theseRotations = formationsRotated[formationName]
			for j=1,rotations do
				theseRotations[j] = {}
				local thisRotation = theseRotations[j]
				local alpha = -(j-1)*math.rad(360/rotations)   --- = reverse clocks
				for k=1,positions do
					local posX = formations[formationName][k][1]
					local posZ = formations[formationName][k][2]
					thisRotation[k] = Rotate(posX,posZ,alpha)
				end
			end
		end
	end
end

function Generation()
    for i = 1, #formationNames do
	    thisFormationName = formationNames[i]
	    thisLimit         = formationDef[thisFormationName].limit
        if (formationDef[thisFormationName].gen) then           --- if formation needs generation
		    formationsGeneration[thisFormationName](thisLimit)  --- generation formation until limit reached
		end
	end
end

function OnlyScaling(formationName,limit)
    local thisFormationPositions = formations[formationName]
	local scaleX = formationDef[formationName].scales[1]
    local scaleZ = formationDef[formationName].scales[2]
	for i=1,limit do
	    thisFormationPositions[i][1] = thisFormationPositions[i][1] * scaleX
		thisFormationPositions[i][2] = thisFormationPositions[i][2] * scaleZ
	end
end

function StandardLineGeneration(formationName,limit)
    local position = 10
	local thisFormation = formations[formationName]
	local scaleX = formationDef[formationName].scales[1]
	local scaleZ = formationDef[formationName].scales[2]
	local generationMove = {
		[1]  = {2,0},
		[2]  = {-2,0},
		[3]  = {2,0},
		[4]  = {-2,0},
	}
	local generationPos = {
		[1]  = {}, ---- tile 5
		[2]  = {}, ---- tile 6
		[3]  = {}, ---- tile 9
		[4]  = {}, ---- tile 10
	}
	local part = 1    --- definition in declaration wasnt working, maybe there was used only pointer on specified position
	generationPos[1][1] = thisFormation[5][1]
	generationPos[1][2] = thisFormation[5][2]
	generationPos[2][1] = thisFormation[6][1]
	generationPos[2][2] = thisFormation[6][2]
	generationPos[3][1] = thisFormation[9][1]
	generationPos[3][2] = thisFormation[9][2]
	generationPos[4][1] = thisFormation[10][1]
	generationPos[4][2] = thisFormation[10][2]
	for i=position,limit do
	    thisFormation[i] = {}
		thisFormation[i][1] = generationPos[part][1] + (scaleX * generationMove[part][1])
		thisFormation[i][2] = generationPos[part][2] + (scaleZ * generationMove[part][2])
		generationPos[part][1] = thisFormation[i][1]
		generationPos[part][2] = thisFormation[i][2]
		if (part == 4) then
			part = 1
		else
			part = part + 1
		end
	end
end



formationsGeneration = {
	["swarm"] = function(limit) 
	    OnlyScaling("swarm",limit)
	end,
	["arrow"] = function(limit) 
	    OnlyScaling("arrow",limit)
	end,
	["wedge"] = function(limit) 
	    OnlyScaling("wedge",limit)
	end,
	["standardLine"] = function(limit) 
	    --- till 9th position its done, defined in table
		OnlyScaling("standardLine",10)
	    --- so only rescaling for 1 to 10
		StandardLineGeneration("standardLine",limit)
	end,
	["standardLineZig"] = function(limit) 
	    --- till 9th position its done, defined in table
		OnlyScaling("standardLineZig",10)
	    --- so only rescaling for 1 to 10
		StandardLineGeneration("standardLineZig",limit)
	end,
	["standardLine2nd"] = function(limit) 
	    --- till 9th position its done
		OnlyScaling("standardLine2nd",10)
		--- so only rescaling for 1 to 10
		StandardLineGeneration("standardLine2nd",limit)
	end,
	["smallLine"] = function(limit) 
		OnlyScaling("smallLine",limit)
	end,
	["doubleColumn"] = function(limit) 
		OnlyScaling("doubleColumn",limit)
	end,
	["seaUnit"] = function(limit) 
		OnlyScaling("seaUnit",limit)
	end,
	["artyLine"] = function(limit) 
		OnlyScaling("artyLine",limit)
	end,
	["box"] = function(limit) 
		OnlyScaling("box",limit)
	end,
	["circle"] = function(limit) 
		OnlyScaling("circle",limit)
	end,
    ["hexagon"] = function(limit)   ---- generate formation positions for hexagon formation
		local thisFormation = formations["hexagon"]
		local scale = formationDef["hexagon"].scales[1]    ---- hexagon is using only one number for scaling
		thisFormation[1] = {0,0}
		local position = 2
		local side = 1
		local inside = 0
        local smallSizeOfHex = 3 * scale
        local bigSizeOfHex = 2 * smallSizeOfHex	
		local step = 6
		--- reset generationMoveTab
		local hexGenerationMove = {
			[1]  = {smallSizeOfHex,-bigSizeOfHex*math.sin(30)},
			[2]  = {-smallSizeOfHex,-bigSizeOfHex*math.sin(30)},
			[3]  = {-bigSizeOfHex,0},
			[4]  = {-smallSizeOfHex,bigSizeOfHex*math.sin(30)},
			[5]  = {smallSizeOfHex,bigSizeOfHex*math.sin(30)},
			[6]  = {bigSizeOfHex,0},
		}
		---
		for i=1,30 do
			local counter = 0
			local startPoint = {[1]  = {},[2]  = {},[3]  = {},[4]  = {},[5]  = {},[6]  = {}}
			for k=1,6 do
				if (k == 1) then
					local point = {side*smallSizeOfHex,side*bigSizeOfHex*math.sin(30)}
					thisFormation[position] = point
					startPoint[k] = point
				elseif (k == 2) then
					local point = {side*bigSizeOfHex,0}
					thisFormation[position] = point
					startPoint[k] = point
				elseif (k == 3) then
					local point = {side*smallSizeOfHex,-side*bigSizeOfHex*math.sin(30)}
					thisFormation[position] = point
					startPoint[k] = point
				elseif (k == 4) then
					local point = {-side*smallSizeOfHex,-side*bigSizeOfHex*math.sin(30)}
					thisFormation[position] = point
					startPoint[k] = point
				elseif (k == 5) then
					local point = {-side*bigSizeOfHex,0}
					thisFormation[position] = point
					startPoint[k] = point
				elseif (k == 6) then
					local point = {-side*smallSizeOfHex,side*bigSizeOfHex*math.sin(30)}
					thisFormation[position] = point
					startPoint[k] = point
				end
				--Spring.Echo(position)
				position = position + 1
				counter = counter + 1		
			end
			for a=1,inside do
				for b=1,6 do
					thisFormation[position] = {}
					thisFormation[position][1] = startPoint[b][1] + a * hexGenerationMove[b][1]
					thisFormation[position][2] = startPoint[b][2] + a * hexGenerationMove[b][2]
					position = position + 1
					counter = counter + 1
				end
			end
			step = step + 6
			side = side + 1
			inside = inside + 1
			if (position >= limit) then 
			    return
			end
		end
	end,

}

------------------------------------------------------------------------------
-------------------------- OLD CODE FOR TESTING PURPOSES ---------------------

-- function RoundingTwoNumbers(x)
    -- local firstRound = math.floor(x)
	-- return x
	-- if (firstRound == x) then
	    -- return x
	-- end
    -- local newNumber = x*100
	-- local secondRound = math.floor(newNumber)
	-- local secondNumber = newNumber - secondRound
	-- if (secondNumber >= 0.5) then
		-- return math.floor(newNumber)/100
	-- else
	    -- return math.ceil(newNumber)/100
	-- end
-- end

-- testing of formations rotations
 --[[       for i=1,16 do
		    local a,b
		    if (i == 1) then
			    a = 0
				b = 3
			elseif (i == 2) then
			    a = 2
				b = 3
			elseif (i == 3) then
			    a = 3
				b = 3
			elseif (i == 4) then
			    a = 3
				b = 2			
			elseif (i == 5) then
			    a = 3
				b = 0
			elseif (i == 6) then
			    a = 3
				b = -2
			elseif (i == 7) then
			    a = 3
				b = -3
			elseif (i == 8) then
			    a = 2
				b = -3
			elseif (i == 9) then
			    a = 0
				b = -3
			elseif (i == 10) then
			    a = -2
				b = -3
			elseif (i == 11) then
			    a = -3
				b = -3
			elseif (i == 12) then
			    a = -3
				b = -2
			elseif (i == 13) then
			    a = -3
				b = 0
			elseif (i == 14) then
			    a = -3
				b = 2
			elseif (i == 15) then
			    a = -3
				b = 3
			elseif (i == 16) then
			    a = -2
				b = 3
			end
			local result = GetRotation(0,0,a,b,16)
			Spring.Echo(result)
		end
		Spring.Echo("..")]]--