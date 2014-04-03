------------------------------------------------------------------------------
-- NOE MAPPING
-- first noe mapping functions
------------------------------------------------------------------------------

local spAreTeamsAllied                 = Spring.AreTeamsAllied
local spGetModOptions                  = Spring.GetModOptions
local spGetGroundHeight                = Spring.GetGroundHeight
local spGetUnitPosition                = Spring.GetUnitPosition
local spGetUnitsInCylinder             = Spring.GetUnitsInCylinder
local spGetUnitsInRectangle            = Spring.GetUnitsInRectangle
local spGetTeamUnitCount               = Spring.GetTeamUnitCount

local sqrt                             = math.sqrt
local floor                            = math.floor
local ceil                             = math.ceil
local random                           = math.random

function GetIDofTile(posX,posZ,thisDivision,zdivs)
    local ID = 0
	ID = floor(posX/thisDivision)*zdivs + ceil(posZ/thisDivision)
	if (ID == 0) then spEcho("The position is not on map.") end
    return ID
end

function DefaultTileReset() --- making default tile for map border for mapping
        local clev = 0.1
    	mapDefault[1] = {
		-- this part is needed for Mapping/safety
	    ["safetyTransmission"] = {["xDown"]=clev,["xUp"]=clev,["zLeft"]=clev,["zRight"]=clev},
		["safetySecondary"]    = {["xDown"]=clev,["xUp"]=clev,["zLeft"]=clev,["zRight"]=clev},
		["safetyTertiary"]     = {["xDown"]=clev,["xUp"]=clev,["zLeft"]=clev,["zRight"]=clev},
		-- this is of SetSafePositionn
		["safetyIndex"]        = 0, 
	} 
end

function GiveRandomPlaceInTile(someX,someZ,addRandom,border)
    if (addRandom) then
		someX = someX + random(border,mapDivision-border)
		someZ = someZ + random(border,mapDivision-border)
	else
	    someX = someX + mapDivision/2
		someZ = someZ + mapDivision/2
	end
	local place = {["x"]=someX,["z"]=someZ,}
	return place
end

function CreateDangerMap(teamNumber)
    --mapMaxHeight = 0
	mapDanger[teamNumber] = {}
    thisTeam = teamInfo[teamNumber]	
    for i=0,mapXdivs do
        for j=0,mapZdivs do
		    --spEcho("Hey adding", i, j)
			local cornerX = i*mapDivision
			local cornerZ = j*mapDivision
			local height
			    local h1 = spGetGroundHeight(cornerX+mapDivision/4,cornerZ+mapDivision/4)
				local h2 = spGetGroundHeight(cornerX+(mapDivision/4)*3,cornerZ+mapDivision/4)
				local h3 = spGetGroundHeight(cornerX+mapDivision/4,cornerZ+(mapDivision/4)*3)
				local h4 = spGetGroundHeight(cornerX+(mapDivision/4)*3,cornerZ+(mapDivision/4)*3)
			local height = (h1 + h2 + h3 + h4)/4	
			
			local dataIndex = i*mapZdivs+j+1
	        ---- MAP OBJECT ----
			mapDanger[teamNumber][dataIndex]  = {
				["cornerX"]            = cornerX,  -- X axis
				["cornerZ"]            = cornerZ,  -- Z axis
				["centerX"]            = cornerX + mapDivision/2,
				["centerZ"]            = cornerZ + mapDivision/2,
				["holdPower"]          = 0,        -- how many units currently ocupy the tile
				["holdPowerHistory"]   = {},       -- holdPower numbers in history
				["holdPowerRank"]      = 0,        -- holdPower counter number through all iterations
				["antIndex"]           = 0,      -- the same like powerRank, but it lowers down by time
				["isHolded"]           = false,    -- holdPower > 0 or not
				["isHoldedHistory"]    = {},       -- is Holded history
				["zeroHoldPower"]      = 0,        -- how many iterations is holdPower = 0  
				["safetyIndex"]        = 0,        -- index counted through evaluation of map based on zeroHoldPower and holdPower
				["safetyTransmission"] = {["xDown"]=0,["xUp"]=0,["zLeft"]=0,["zRight"]=0}, -- direct way transmission
				["safetySecondary"]    = {["xDown"]=0,["xUp"]=0,["zLeft"]=0,["zRight"]=0}, -- secondary trans
				["safetyTertiary"]     = {["xDown"]=0,["xUp"]=0,["zLeft"]=0,["zRight"]=0}, -- tertiary trans
				["lessSafeTileIndex"]  = 0,        -- index of tile where is the biggest danger
				["tileNotCovered"]     = 0,        -- number of iterations that tile is not covered by radar (basic number for Incertainity)				
			}
			
			mapNeutral[dataIndex] = {
			    ["tileHeight"]         = height, 
			}
			
			if (height > mapMaxHeight) then
			    mapMaxHeight = height
			end
		end	
	end
	--- table for crossing unsafe iterations
	DefaultTileReset() 
	--- only for testing ---
	_G.mapMaxHeight = mapMaxHeight
	_G.mapNeutral = mapNeutral
end

function Mapping(part,teamNumber,splitMapping)
    local thisTeam = teamInfo[teamNumber]
    --- this is only speedup part
	if (part == stepBeginMapping) then  
		thisTeam.mapMaxHoldedTileCycle      = 0
		thisTeam.mapMaxAntIndexCycle        = 0
		thisTeam.mapMaxZeroHoldTileCycle    = 0
		thisTeam.mapMaxSafetyIndexTileCycle = 0
		thisTeam.mapMinSafetyIndexTileCycle = fullSafe
	end
	--- end of speedup part
	-- spEcho(iStartPoint,iEndPoint)
	
    for i = part+1,mapCount,mapSmallCycleLength do   ---- normaly from 0 to mapXdivs-1, now speeded
	    local j           = (i % mapZdivs)+1
		local thisIndex   = i
		local dngr        = mapDanger[teamNumber][thisIndex] -- only speedup for acces to table
		local startPointX = dngr.cornerX 
		local startPointZ = dngr.cornerZ
		local allUnits    = spGetUnitsInRectangle(startPointX,startPointZ,(startPointX + mapDivision),(startPointZ + mapDivision)) 
		local power       = #allUnits
		
		for a = 1, #teamList do   -- how many units/tile
			local allied = (spAreTeamsAllied(teamList[a],AITeamID[teamNumber]))
			if (allied) then
				local units = spGetUnitsInRectangle(startPointX,startPointZ,(startPointX + mapDivision),(startPointZ + mapDivision),teamList[a])  
				power       = power - #units
			end	
		end			
		
		dngr.holdPower     = power                                           -- change up holdPower of tile
		dngr.holdPowerRank = dngr.holdPowerRank + power                      -- grow up holdPowerRank of tile
		---- safety part
		local dngrUp   = mapDanger[teamNumber][thisIndex-1]  --or mapDefault[1]    -- only speedup for acces to table
		local dngrDown = mapDanger[teamNumber][thisIndex+1] --or mapDefault[1]     -- only speedup for acces to table
		if (j == 1) then                                                     -- fix against top/down safety transition
			dngrUp = mapDefault[1]
		end
		if (j == mapZdivs) then 			
			dngrDown = mapDefault[1]
		end
		local dngrLeft  = mapDanger[teamNumber][thisIndex-mapZdivs] --or mapDefault[1]    -- only speedup for acces to table
		local dngrRight = mapDanger[teamNumber][thisIndex+mapZdivs] --or mapDefault[1]    -- only speedup for acces to table
		if (i <= mapZdivs) then                                                            -- fix for left/right safety border
			dngrLeft = mapDefault[1]
		end
		if (i >= mapCount - mapZdivs) then 			
			dngrRight = mapDefault[1]
		end
		-- spEcho(teamNumber .. " " .. i*mapZdivs+j+1 .. " ")
		local somePower = dngr.holdPower * unitDangerMultiplier
		local up, down, right, left
		down  = dngrUp.safetyTransmission.xDown + (dngrUp.safetySecondary.xDown + dngrUp.safetyTertiary.xDown)/2
		up    = dngrDown.safetyTransmission.xUp + (dngrDown.safetySecondary.xUp + dngrDown.safetyTertiary.xUp)/2
		right = dngrLeft.safetyTransmission.zRight + (dngrLeft.safetySecondary.zRight + dngrLeft.safetyTertiary.zRight)/2
		left  = dngrRight.safetyTransmission.zLeft + (dngrRight.safetySecondary.zLeft + dngrRight.safetyTertiary.zLeft)/2
		dngr.safetyIndex = fullSafe - down
									- up
									- right
									- left
									- somePower  		                             -- prepare safeindex for tile
		dngr.safetyTransmission.xDown  = (dngrUp.safetyTransmission.xDown    + somePower) / divConst
		dngr.safetyTransmission.xUp    = (dngrDown.safetyTransmission.xUp    + somePower) / divConst
		dngr.safetyTransmission.zRight = (dngrLeft.safetyTransmission.zRight + somePower) / divConst
		dngr.safetyTransmission.zLeft  = (dngrRight.safetyTransmission.zLeft + somePower) / divConst			
		
		dngrUp.safetyTertiary.zRight   = (dngrLeft.safetyTertiary.zRight     + somePower) / divConst2 + up / divConst3
		dngrUp.safetyTertiary.zLeft    = (dngrRight.safetyTertiary.zLeft     + somePower) / divConst2 + up / divConst3
		dngrDown.safetySecondary.zRight = (dngrLeft.safetySecondary.zRight   + somePower) / divConst2 + down / divConst3
		dngrDown.safetySecondary.zLeft  = (dngrRight.safetySecondary.zLeft   + somePower) / divConst2 + down / divConst3
		dngrLeft.safetyTertiary.xUp    = (dngrDown.safetySecondary.xUp       + somePower) / divConst2 + left / divConst3
		dngrLeft.safetyTertiary.xDown  = (dngrUp.safetyTertiary.xDown        + somePower) / divConst2 + left / divConst3
		dngrRight.safetySecondary.xUp  = (dngrDown.safetySecondary.xUp       + somePower) / divConst2 + right / divConst3
		dngrRight.safetySecondary.xDown = (dngrUp.safetySecondary.xDown      + somePower) / divConst2 + right / divConst3

		if (dngr.safetyIndex >= (fullSafe - 0.1)) then dngr.safetyIndex = fullSafe end
		
		---- ANTS ---
		dngr.antIndex = (dngr.antIndex + (dngr.holdPower*antValue))
        local decrease = antCounter % antDecreaseTimes
		if (decrease == 0) then
			dngr.antIndex = dngr.antIndex * antDecreaseValue
		end
		---- endANTS ---
		--- end safety part
		--------------- maxconditions
		--- isHolded condition and notHolded
		if (power >= 1) then  
			dngr.isHolded = true                            -- tile is holded by some unit
			--- maxHold condition
			if (dngr.holdPower > thisTeam.mapMaxHoldedTile) then
				thisTeam.mapMaxHoldedTile = dngr.holdPower
			end
			if (dngr.holdPower > thisTeam.mapMaxHoldedTileCycle) then 
				thisTeam.mapMaxHoldedTileCycle = dngr.holdPower
			end
			--- end of maxHold condition
		else                   
			dngr.isHolded = false                           -- tile is not holded by unit
			dngr.zeroHoldPower = dngr.zeroHoldPower + 1     -- tile is not holded for another turn
			--- maxZeroHold condition
			if (dngr.zeroHoldPower > thisTeam.mapMaxZeroHoldTile) then
				thisTeam.mapMaxZeroHoldTile = dngr.zeroHoldPower
			end
			if (dngr.zeroHoldPower > thisTeam.mapMaxZeroHoldTileCycle) then 
				thisTeam.mapMaxZeroHoldTileCycle = dngr.zeroHoldPower
			end
			--- end of maxZeroHold condition
		end
		--- maxSafetyIndex condition
		if (dngr.safetyIndex > thisTeam.mapMaxSafetyIndexTileCycle) then 
			thisTeam.mapMaxSafetyIndexTileCycle = dngr.safetyIndex
		end
		--- end of maxconditions
		--- minSafetyIndex conditon
		if (dngr.safetyIndex < thisTeam.mapMinSafetyIndexTileCycle) then 
			thisTeam.mapMinSafetyIndexTileCycle      = dngr.safetyIndex
			thisTeam.mapMinSafetyIndexTileIndexCycle = thisIndex
		end
		--- end of minSafetyIndex
		--- mapMaxHoldPowerRank ---
		if (dngr.holdPowerRank > thisTeam.mapMaxHoldPowerRank) then
		    thisTeam.mapMaxHoldPowerRank      = dngr.holdPowerRank
			thisTeam.mapMaxHoldPowerRankIndex = thisIndex
		end
		--- end of mapMaxHoldPowerRank
		--- maxANT ---
		if (dngr.antIndex > thisTeam.mapMaxAntIndexCycle) then
		    thisTeam.mapMaxAntIndexCycle = dngr.antIndex
		end
		--- end of maxANT --
		DefaultTileReset() 
	end
	-- when last mapping part, grow cycle counter and send it to graphic part
	if (part == stepEndMapping) then
	    --mapSmallCycles = mapSmallCycles + mapTileUnitConstant   -- color of tile depends on this line
		--- decrease the mapMaxHoldedTile when the most occupied tile constant is not occupied
		if (thisTeam.mapMaxHoldedTile > thisTeam.mapMaxHoldedTileCycle) then
     		thisTeam.mapMaxHoldedTile = thisTeam.mapMaxHoldedTileCycle
		end
		--- the same with min/max index
		thisTeam.mapMaxAntIndex             = thisTeam.mapMaxAntIndexCycle
		thisTeam.mapMaxSafetyIndexTile      = thisTeam.mapMaxSafetyIndexTileCycle
     	thisTeam.mapMinSafetyIndexTile      = thisTeam.mapMinSafetyIndexTileCycle
		thisTeam.mapMinSafetyIndexTileIndex = thisTeam.mapMinSafetyIndexTileIndexCycle
        ----- send to globals - for testing only
	    _G.mapDa = mapDanger
        _G.teamInfo = teamInfo
		----- clearing values
	end
    antCounter    = antCounter + 1
end

function FindOneBest(searchMode,lenghtOfBox,startX,startZ,team)
    local defaultTile = mapDefault[1]
	local chosenTile
	-- spEcho(startX .. " " .. startZ)	
	if (searchMode == "safePlaces") then
	    local safety = 0
		for k = 0 + mapHugeTileEdge, lenghtOfBox - 1 - mapHugeTileEdge do
			for l = 0 + mapHugeTileEdge, lenghtOfBox - 1 - mapHugeTileEdge do
			    local tileNumber = startX*(mapZdivs*lenghtOfBox)+k*mapZdivs+startZ*lenghtOfBox+l+1
				-- spEcho(tileNumber)
				local tile = mapDanger[team][tileNumber] or defaultTile
				if (tile.safetyIndex > safety) then
				    chosenTile = tileNumber
					safety = tile.safetyIndex
				end
				-- spEcho(tile.safetyIndex)
				--- here is bug, NOTcomming more then mapXdivs
				if (tileNumber % mapZdivs == 0) then  -- bugfix
				    break
				end
			end
		end
		return chosenTile
    end	
end

function SearchFirstBestTiles(searchMode,lenghtOfBox,numberOfResults,team)
    if (searchMode == "safePlaces") then
	    local defaultTile = mapDefault[1]
	    local bestOf = {}  -- unsorted list of best results
		local added = 0    -- how many places i have added		
		local side = teamInfo[team]  -- speedup acces
		local placesList = side.listOfSafePlaces  -- speedup acces
	    local iterX = floor((mapXdivs-1)/lenghtOfBox)
		local iterZ = floor((mapZdivs-1)/lenghtOfBox)
		
		for i = 0, iterX do
	        for j = 0, iterZ do
			    local localBest = FindOneBest(searchMode,lenghtOfBox,i,j,team)
				-- spEcho("-" .. localBest)
				bestOf[added+1] = localBest
                added = added + 1
			end
		end
		for round = 1, numberOfResults do
		    local safetyMax = 0
			local tileNummo = 1
			local choosenA = 1
		    for a = 0, added do
			    local talkedTile = mapDanger[team][bestOf[a]] or defaultTile
		        if (talkedTile.safetyIndex > safetyMax) then
				    tileNummo = bestOf[a]
					safetyMax = talkedTile.safetyIndex
					choosenA = a
				end	
			end
			placesList[round] = tileNummo
			bestOf[choosenA] = 0
			-- spEcho("best" .. round .. ": " .. tileNummo)
		end
		side.listOfSafePlacesCount = #placesList
		--- only for testing
    	_G.teamInfo  = teamInfo
	end
end

function GetOneSafePlace(team,addRandom,border)
    local tileNummo = teamInfo[team].listOfSafePlaces[1]
	-- spEcho(tileNummo)
	-- old code below
	--if (#listOfSafePlaces > 1) then   -- if last position, dont delete it
	    --table.remove(listOfSafePlaces, #listOfSafePlaces)
	--end
	
	--- here can be added function for that - GiveRandomPlaceInTile
	local someX = mapDanger[team][tileNummo].cornerX
	local someZ = mapDanger[team][tileNummo].cornerZ
	-- spEcho(someX) spEcho(someZ)
	local place = GiveRandomPlaceInTile(someX,someZ,addRandom,border)
    return place
end