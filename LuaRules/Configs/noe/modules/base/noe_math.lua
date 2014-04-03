------------------------------------------------------------------------------
-- NOE MATH
-- math functions
------------------------------------------------------------------------------

local floor                            = math.floor
local ceil                             = math.ceil
local deg                              = math.deg
local sin                              = math.sin
local cos                              = math.cos
local asin                             = math.asin
local acos                             = math.acos
local atan                             = math.atan
local abs                              = math.abs
local sqrt                             = math.sqrt
local random                           = math.random
local PI                               = math.pi

--? work with global pseudoRandom
function OwnRandom(minimal,maximal)
    pseudoRandom = pseudoRandom + 1
    local result = 0
	for i=1,(pseudoRandom % 7) + 2 do
	    result = math.random(minimal,maximal)
	end
	return result
end

function ToBool(something)
	if (something == 0 or something == "false" or something == "0" or something == false or something == nil) then
		return false
	else
		return true
	end
end

function TimeCounter(n)
    local frameTime = n/30
	
    local hours	    = floor(frameTime/3600)
	if (hours > 0) then
		frameTime = frameTime - hours*3600 
	end
	
	local minutes  = floor(frameTime/60)
	if (minutes > 0) then
		frameTime = frameTime - minutes*60
	end

	local seconds  = floor(frameTime)
	
    local countedTime = {0,0,0}
	countedTime[1] = hours
	countedTime[2] = minutes
	countedTime[3] = seconds
    return countedTime
end

function GetDistance2D(firstX,firstZ,secondX,secondZ)  -- returns 2D distance of two places
    local result = sqrt((firstX-secondX)*(firstX-secondX) + (firstZ-secondZ)*(firstZ-secondZ))
	return result
end

function GetDistance2DSQ(firstX,firstZ,secondX,secondZ)  -- returns 2D distance of two places^2
    return (firstX-secondX)*(firstX-secondX) + (firstZ-secondZ)*(firstZ-secondZ)
end

function GetDistance3D(firstX,firstY,firstZ,secondX,secondZ,secondZ)  -- returns 3D distance of two places
    local result = sqrt((firstX-secondX)*(firstX-secondX) + (firstY-secondY)*(firstY-secondY) + (firstZ-secondZ)*(firstZ-secondZ))
	return result
end

function GetDistance3DSQ(firstX,firstY,firstZ,secondX,secondY,secondZ)  -- returns 3D distance of two places^2
	return (firstX-secondX)*(firstX-secondX) + (firstY-secondY)*(firstY-secondY) + (firstZ-secondZ)*(firstZ-secondZ)
end

function GetAngle(newTargetX,newTargetZ)
    local dist = GetDistance2D(0,0,newTargetX,newTargetZ)
	--if (dist == 0) then spEcho("no distance") end
	local alpha = asin(newTargetX/dist)  --- different representation of X and Z on sreen and in my mind (formation defs).. so not asin(-something)
	local beta  = acos(newTargetZ/dist)
	-- i tried the version with aTan, but it doesnt help much in speed
	local result
	if (alpha > 0) then 
		result = 2*PI - beta 
	else
		result = beta
	end
	-- spEcho(deg(result),deg(alpha),deg(beta))
	return result
end

function GetRotation(thisX,thisZ,targetX,targetZ,rotations)
    if (targetX == nil) then targetX = 1 targetZ = 1 end --- this for avoiding error when leader unit is killed in middle of procedure
    local newTargetX    = targetX - thisX
	local newTargetZ    = -targetZ + thisZ       --- different representation of X and Z on sreen and in my mind (formation defs)
	local movingAngle   = 2*PI/rotations
	local startingAngle = 0 - movingAngle/2
	local angle         = startingAngle + GetAngle(newTargetX,newTargetZ)
	local rot           = floor(angle/movingAngle)
	-- spEcho(deg(angle),rot,(rot%rotations) + 1,thisX,thisZ,targetX,targetZ,newTargetX,newTargetZ)
	return ((rot + rotations/2 + 1) % rotations) + 1 --- 1 for index 0
end

function GetHillyCoeficient(mainX,mainZ)
    local tileID        = GetIDofTile(mainX,mainZ,mapDivision,mapZdivs)
	local maxIndex      = mapXdivs * mapZdivs
	if ((tileID < 1) or (tileID > maxIndex)) then tileID = ceil(maxIndex/2) end   -- if tile is out of the map
	local currentHeight = mapNeutral[tileID].tileHeight
	local coeficient    = 0
	for i=1,8 do
	    local currentIndex = tileID + mapTilesAroundIndex[i]
		local diff = 0
		if ((currentIndex > 0) and (currentIndex <= maxIndex)) then
		    diff = abs(currentHeight - mapNeutral[currentIndex].tileHeight)
		end
		coeficient = coeficient + diff
    end	
	return coeficient/8
end

function GetPositionForAttack(currentPosX,currentPosZ,targetPosX,targetPosZ,distanceFromTarget)
    local xChange = currentPosX - targetPosX
	local zChange = -currentPosZ + targetPosZ
    local angle   = GetAngle(xChange,zChange) + PI/2
	local resultX = targetPosX + cos(angle)*distanceFromTarget -- this need to be completed, not rdy
	local resultZ = targetPosZ + sin(angle)*distanceFromTarget
	local resultY = spGetGroundHeight(resultX,resultZ)
    return abs(resultX),resultY,abs(resultZ)
end

function IsFarFromEdge(posX,posZ,dist)   --- controls if place is far (far = dist) from border of map
    --- start of settings
	local distance = dist or edgeDistance
    --- end of settings
	if  ((posX >= distance) and (posX <= (mapX - distance)) and (posZ >= distance) and posZ <= (mapZ-distance)) then
	    return true
	else
	    return false
	end
end

function GetRandomPlaceAround(placeX,placeZ,distanceMin,distanceMax)
    local diff    = distanceMax - distanceMin
    local randX   = OwnRandom(-diff,diff)
	local randZ   = OwnRandom(-diff,diff)
	--spEcho(placeX,placeZ,randX,randZ)
	if (randX >= 0) then randX = randX + distanceMin else randX = randX - distanceMin end
	if (randZ >= 0) then randZ = randZ + distanceMin else randZ = randZ - distanceMin end
	randX = randX + placeX
	randZ = randZ + placeZ
	if ((randZ <= 0) or (randZ > mapZ) or (randX <= 0) or (randX > mapX)) then 
		randX,randZ = GetRandomPlaceAround(placeX,placeZ,distanceMin,distanceMax)
	end
	return randX, randZ
end

function GetRandomPlaceOnTheMap()
    -- ? can be added some parameters like: water, hill, or something
	local randX = OwnRandom(1,mapX)
	local randZ = OwnRandom(1,mapZ)
	return randX, randZ
end