------------------------------------------------------------------------------
-- pepes NOE buildspace finder
-- for NOE
-- more info about on WIKI: http://code.google.com/p/nota/wiki/NOE_build_space_finder
------------------------------------------------------------------------------

--- derived from noe_mex_finder.lua and heightMap creation
--- its used for avoiding stupid positions when building
--- !! have to be used after mex finder - its using data from metalMap for avoid building on metal spots

buildMapDivision    = 50                          -- size of tiles
local smallStep     = 10
local treeBurden    = 100
local smallBurden   = 25
local mapX          = Game.mapSizeX
local mapZ          = Game.mapSizeZ
buildMapXdivs       = math.floor(mapX / buildMapDivision)
buildMapZdivs       = math.floor(mapZ / buildMapDivision)
local mexRadius     = 150
local partRadius    = mexRadius/2

local mAbs          = math.abs

local mapBuildTilesAroundIndex              = {  --- index map for looking on neigbours of one tile
	[1]  = -1,                   -- up
	[2]  = buildMapZdivs - 1,    -- uppright
	[3]  = buildMapZdivs,        -- right
	[4]  = buildMapZdivs + 1,    -- downright
	[5]  = 1,                    -- down
	[6]  = -buildMapZdivs + 1,   -- downleft
	[7]  = -buildMapZdivs,       -- left
	[8]  = -buildMapZdivs - 1,   -- upleft
}

local spGetGroundInfo    = Spring.GetGroundInfo
local spGetGroundHeight  = Spring.GetGroundHeight
local spGetGroundBlocked = Spring.GetGroundBlocked
local spTestBuildOrder   = Spring.TestBuildOrder

local buildMapRaw = {}

local function FirstScan()
    for i=0,buildMapXdivs do
	    for j=0,buildMapZdivs do
		    local dataIndex         = i*buildMapZdivs+j+1
		    local posX              = buildMapDivision*i
			local posZ              = buildMapDivision*j
			local heightMiddle      = spGetGroundHeight(posX+buildMapDivision/2,posZ+buildMapDivision/2)
			local height
			    local h1 = spGetGroundHeight(posX+buildMapDivision/4,     posZ+buildMapDivision/4)
				local h2 = spGetGroundHeight(posX+(buildMapDivision/4)*3, posZ+buildMapDivision/4)
				local h3 = spGetGroundHeight(posX+buildMapDivision/4,     posZ+(buildMapDivision/4)*3)
				local h4 = spGetGroundHeight(posX+(buildMapDivision/4)*3, posZ+(buildMapDivision/4)*3)
			local height = (h1 + h2 + h3 + h4)/4	
			local groundOK, waterOK
			if ((h1 <=0) or (h2 <= 0) or (h3 <= 0) or (h4 <= 0)) then
			    groundOK = false
				waterOK  = true
				-- !! add function recalulation waterRating 
			else
			    groundOK = true
				waterOK  = false
			end
			buildMapRaw[dataIndex] = {
			    ["posX"]         = posX,
				["posZ"]         = posZ,
				["height"]       = height,
				["heightMiddle"] = heightMiddle,
				["groundBuild"]  = groundOK,
			    ["groundRating"] = 0,
				["waterBuild"]   = waterOK,
				["waterRating"]  = 0,
				["geoBuild"]     = false,
				["used"]         = false,
			}
		end
	end
end

local function SetHeightStability()
    for i=1,#buildMapRaw do
		local thisTile     = buildMapRaw[i]
		local startPosX    = thisTile.posX
		local startPosZ    = thisTile.posZ
		local thisHeight   = thisTile.height
		local heightChange = 0
		for k=0,buildMapDivision,smallStep do
			for l=0,buildMapDivision,smallStep do
			    local change = mAbs(spGetGroundHeight(startPosX + k,startPosZ + l) - thisHeight)
				heightChange = heightChange + change
				--Spring.Echo(startPosX + k,startPosZ + l,change)
			end
		end
		thisTile.groundRating = 1 + heightChange
		--Spring.Echo(i,thisTile.posX,thisTile.posZ,tostring(thisTile.groundBuild),thisTile.groundRating,tostring(thisTile.waterBuild))
	end
end

local function HandicapTilesWithFeatures()
    local buildTileHalfSize = buildMapDivision/2
    for i=1,#buildMapRaw do
	    local thisTile = buildMapRaw[i]
		if (thisTile.groundBuild) then
			local blocking,feature = spTestBuildOrder(fromNameToIDTable["cormex"],thisTile.posX +buildTileHalfSize ,0,thisTile.posZ +buildTileHalfSize,1)
			if (blocking == 2 and feature ~= nil) then
				--Spring.Echo(i,feature)
				thisTile.groundRating = thisTile.groundRating + treeBurden
				-- adding burden to surrounding tiles
				for j=1,8 do
				    local secondaryIndex = i + mapBuildTilesAroundIndex[j]
					if (buildMapRaw[secondaryIndex] ~= nil) then
						buildMapRaw[secondaryIndex].groundRating = buildMapRaw[secondaryIndex].groundRating + smallBurden
					end
				end
			end
		end
	end
end

local function KillTilesWithMexSpots()
    for i=1,#mapMetal do
	    local thisMetalSpot = mapMetal[i]
		local startX        = thisMetalSpot.posX - partRadius
		local startZ        = thisMetalSpot.posZ - partRadius
		--Spring.Echo(i,thisMetalSpot.posX,thisMetalSpot.posZ,mexRadius,buildMapDivision)
        for k=0,mexRadius+1,buildMapDivision do
			for l=0,mexRadius+1,buildMapDivision do
			    local thisIndex = GetIDofTile(startX + k,startZ + l,buildMapDivision,buildMapZdivs)
				--Spring.Echo(thisIndex,startX + k,startZ + l)
				if (buildMapRaw[thisIndex] ~= nil) then
				    buildMapRaw[thisIndex].groundBuild = false
					buildMapRaw[thisIndex].waterBuild  = false
				end
            end
        end		
        --Spring.Echo("--")		
	end
end

function PreparemapBuildMap()
    FirstScan()
	SetHeightStability()
	HandicapTilesWithFeatures()
	KillTilesWithMexSpots()
	mapBuild = buildMapRaw
end 

