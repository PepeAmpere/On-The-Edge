-----------------------------------------
-- pepes metal extractor spots finder ---
-- for NOE ------------------------------
-----------------------------------------

metalMapDivision   = 10                       -- size of tiles
local mapX         = Game.mapSizeX
local mapZ         = Game.mapSizeZ
local mapXdivs     = math.floor(mapX / metalMapDivision)
local mapZdivs     = math.floor(mapZ / metalMapDivision)
local mexRadius    = Game.extractorRadius

local spGetGroundInfo   = Spring.GetGroundInfo
local spGetGroundHeight = Spring.GetGroundHeight

local mAbs         = math.abs

--- metal map data structure ---
local mapMetalRaw  = {}

local function FirstScan()
    for i=1,mapXdivs do
	    for j=1,mapZdivs do
		    local posX          = metalMapDivision*i
			local posZ          = metalMapDivision*j
		    local _,metalAmount = spGetGroundInfo(posX,posZ)
			local height        = spGetGroundHeight(posX,posZ)
			local waterOne      = false
			if (height <= 0) then waterOne = true end
			if (metalAmount > 10) then
				mapMetalRaw[#mapMetalRaw + 1] = {
					["posX"]      = posX,
					["posZ"]      = posZ,
					["centerX"]   = posX + metalMapDivision/2,
					["centerZ"]   = posZ + metalMapDivision/2,
					["height"]    = height,
					["amount"]    = metalAmount,
					["water"]     = waterOne,
					--- technical --- 
					["used"]   = false,
					["hisGuys"]= {},
				}
			end
		end
    end
end

local function PreMergeMarking()
    for i=1,#mapMetalRaw do
	    if (not(mapMetalRaw[i].used))then
		    local listOfGuys = mapMetalRaw[i].hisGuys
			listOfGuys[1]    = i
			for j=i+1,#mapMetalRaw do
			    if (not(mapMetalRaw[j].used)) then
					local distance = GetDistance2D(mapMetalRaw[i].posX,mapMetalRaw[i].posZ,mapMetalRaw[j].posX,mapMetalRaw[j].posZ)
					if (distance < 2*mexRadius) then
						listOfGuys[#listOfGuys + 1] = j
						mapMetalRaw[j].used         = true
					end
				end
			end
			mapMetalRaw[i].used = true
		end
	end
end

local function Merging()
    for i=1,#mapMetalRaw do
	    local listOfGuys = mapMetalRaw[i].hisGuys
	    local listLength = #listOfGuys
		if (listLength > 0) then
		    local averageX   = mapMetalRaw[listOfGuys[1]].posX
		    local averageZ   = mapMetalRaw[listOfGuys[1]].posZ
			local averageY   = mapMetalRaw[listOfGuys[1]].height
			local averageMet = mapMetalRaw[listOfGuys[1]].amount
			local waterOne   = false
		    for j=2,listLength do
			    averageX   = averageX + mapMetalRaw[listOfGuys[j]].posX
				averageZ   = averageZ + mapMetalRaw[listOfGuys[j]].posZ
				averageY   = averageY + mapMetalRaw[listOfGuys[j]].height
				averageMet = averageMet + mapMetalRaw[listOfGuys[j]].amount
			end
			averageX   = averageX / listLength
			averageZ   = averageZ / listLength
			averageY   = averageY / listLength
			averageMet = averageMet / listLength
			if (averageY <= 0) then waterOne = true end
			if (listLength >= 2) then
				mapMetal[#mapMetal + 1] = {
					["posX"]   = averageX,
					["posZ"]   = averageZ,
					["height"] = averageY,
					["amount"] = averageMet,
					["water"]  = waterOne,
				}
			end
		end
	end
end

local function Replacing(first,second)
    local thisFirst,thisSecond = {},{}
    thisFirst        = mapMetal[first]
	thisSecond       = mapMetal[second]
	mapMetal[second] = thisFirst
	mapMetal[first]  = thisSecond
end

-- local function CloseMetalSpotsReSort() 
	-- for i=1,20 do
        -- for j=1,#mapMetal-2 do
	        -- local iksDistanceOne = mAbs(mapMetal[j].posX - mapMetal[j+1].posX)
			-- local iksDistanceTwo = mAbs(mapMetal[j].posX - mapMetal[j+2].posX)
			-- local zetDistanceOne = mAbs(mapMetal[j].posZ - mapMetal[j+1].posZ)
			-- local zetDistanceTwo = mAbs(mapMetal[j].posZ - mapMetal[j+2].posZ)
			-- if ((zetDistanceOne > zetDistanceTwo) and (zetDistanceOne > iksDistanceOne*2)) then
			    -- Replacing(j+1,j+2)
			-- end
	    -- end
	-- end
-- end

function PreparemapMetal()
	mapMetalRaw  = {}
    FirstScan()
	PreMergeMarking()
	Merging()
end 

function MetalMapDebug(doit)
    if (doit) then
	    for i=1,#mapMetal do
		    Spring.Echo(mapMetal[i].posX,mapMetal[i].posZ,mapMetal[i].height,mapMetal[i].amount,tostring(mapMetal[i].water))
		end
	else
	    Spring.Echo("MetalMap debug not requested")
	    return
	end    
end