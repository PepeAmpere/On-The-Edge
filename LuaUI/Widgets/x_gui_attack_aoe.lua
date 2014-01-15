--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local versionNumber = "v3.1 (OTE)"
-- ported to OTE

function widget:GetInfo()
  return {
    name      = "Attack AoE",
    desc      = versionNumber .. " Cursor indicator for area of effect and scatter when giving attack command.",
    author    = "Evil4Zerggin",
    date      = "26 September 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 1, 
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--config
--------------------------------------------------------------------------------
local numScatterPoints     = 32
local aoeColor             = {1, 0, 0, 1}
local aoeLineWidthMult     = 64
local scatterColor         = {1, 1, 0, 1}
local scatterLineWidthMult = 1024
local circleDivs           = 64
local minSpread            = 8 --weapons with this spread or less are ignored
local numAoECircles        = 9
local pointSizeMult        = 2048

--------------------------------------------------------------------------------
--vars
--------------------------------------------------------------------------------
local aoeDefInfo = {}
local dgunInfo = {}
local hasSelectionCallin = false
local aoeUnitDefID
local dgunUnitDefID
local aoeUnitID
local dgunUnitID
local selUnitID
local circleList
local secondPart = 0
local mouseDistance = 1000
local extraDrawRange

--------------------------------------------------------------------------------
--speedups
--------------------------------------------------------------------------------
local GetActiveCommand       = Spring.GetActiveCommand
local GetCameraPosition      = Spring.GetCameraPosition
local GetFeaturePosition     = Spring.GetFeaturePosition
local GetGroundHeight        = Spring.GetGroundHeight
local GetSmoothMeshHeight    = Spring.GetSmoothMeshHeight
local GetMouseState          = Spring.GetMouseState 
local GetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted
local GetUnitPosition        = Spring.GetUnitPosition
local GetUnitRadius          = Spring.GetUnitRadius
local GetUnitStates          = Spring.GetUnitStates
local TraceScreenRay         = Spring.TraceScreenRay

local CMD_ATTACK             = CMD.ATTACK
local CMD_MANUALFIRE         = CMD.MANUALFIRE
local g                      = Game.gravity
local GAME_SPEED             = 30 -- ..\rts\Sim\Misc\GlobalConstants.h
local SQUARE_SIZE            = 8
local mapW, mapH             = Game.mapSizeX, Game.mapSizeZ


local glBeginEnd             = gl.BeginEnd
local glCallList             = gl.CallList
local glCreateList           = gl.CreateList
local glColor                = gl.Color
local glDeleteList           = gl.DeleteList
local glDepthTest            = gl.DepthTest
local glDrawGroundCircle     = gl.DrawGroundCircle
local glLineWidth            = gl.LineWidth
local glPointSize            = gl.PointSize
local glPopMatrix            = gl.PopMatrix
local glPushMatrix           = gl.PushMatrix
local glRotate               = gl.Rotate
local glScale                = gl.Scale
local glTranslate            = gl.Translate
local glVertex               = gl.Vertex
local GL_LINES               = GL.LINES
local GL_LINE_LOOP           = GL.LINE_LOOP
local GL_POINTS              = GL.POINTS
local PI                     = math.pi
local atan                   = math.atan
local cos                    = math.cos
local sin                    = math.sin
local floor                  = math.floor
local max                    = math.max
local min                    = math.min
local sqrt                   = math.sqrt

--------------------------------------------------------------------------------
--utility functions
--------------------------------------------------------------------------------

local function ToBool(x)
  return x and x ~= 0 and x ~= "false"
end

local function Normalize(x, y, z)
  local mag = sqrt(x*x + y*y + z*z)
  if (mag == 0) 
    then return nil
    else return x/mag, y/mag, z/mag, mag
  end
end

local function VertexList( points )
  for i, point in pairs( points ) do
    glVertex( point )
  end
end

local function GetMouseTargetPosition()
  local mx, my = GetMouseState()
  local mouseTargetType, mouseTarget = TraceScreenRay(mx, my)
  
  if (mouseTargetType == "ground") then
    return mouseTarget[1], mouseTarget[2], mouseTarget[3]
  elseif (mouseTargetType == "unit") then
    return GetUnitPosition(mouseTarget)
  elseif (mouseTargetType == "feature") then
    return GetFeaturePosition(mouseTarget)
  else
    return nil
  end
end

local function GetMouseDistance()
  local cx, cy, cz = GetCameraPosition()
  local mx, my, mz = GetMouseTargetPosition()
  if (not mx) then return nil end
  local dx = cx - mx
  local dy = cy - my
  local dz = cz - mz
  return sqrt(dx*dx + dy*dy + dz*dz)
end

local function UnitCircleVertices()
  for i = 1, circleDivs do
    local theta = 2 * PI * i / circleDivs
    glVertex(cos(theta), 0, sin(theta))
  end
end

local function DrawUnitCircle()
  glBeginEnd(GL_LINE_LOOP, UnitCircleVertices)
end

local function DrawCircle(x, y, z, radius)
  glPushMatrix()
  glTranslate(x, y, z)
  glScale(radius, radius, radius)
  
  glCallList(circleList)
  
  glPopMatrix()
end

local function GetSecondPart(offset)
  local result = secondPart + (offset or 0)
  return result - floor(result)
end

--------------------------------------------------------------------------------
--initialization
--------------------------------------------------------------------------------

local function getWeaponInfo(weaponDef, unitDef)

	local retData

	local weaponType  = weaponDef.type
	local scatter     = weaponDef.accuracy + weaponDef.sprayAngle
	
	if( weaponDef.cylinderTargeting >= 100 ) then
		retData = {
			type = "orbital",
			scatter = scatter }
		
	elseif( weaponType == "Cannon" ) then
		local customParams = weaponDef.customParams
		if( customParams.weaponvelocity ) then
			retData = {
				type = "ballistic",
				scatter = scatter, 
				v = customParams.weaponvelocity,
				range = weaponDef.range,
				mygravity = customParams.mygravity and weaponDef.customParams.mygravity * 800 -- Why 800 ?
								or g }
		else
			retData = {
				type = "ballistic",
				scatter = scatter, 
				v = weaponDef.projectilespeed,
				range = weaponDef.range }
				
			if( weaponDef.myGravity and weaponDef.myGravity > 0 ) then
				retData.mygravity = weaponDef.myGravity
				--Spring.Echo( "1::", retData.scatter, retData.v, retData.mygravity )
			else
				retData.mygravity = g / 200
				--Spring.Echo( "0::", retData.scatter, retData.v, retData.mygravity )
			end
		end
		
		local v, mg = retData.v, retData.mygravity
		retData.maxH = v * v / mg
		retData.v4   = v * v * v * v
		retData.v2mg = 2 * v * v * mg
		retData.mg2  = mg * mg
		retData.quadratic = 0.5 * mg / ( v * v )
			
	elseif( weaponType == "MissileLauncher" ) then
		local turnRate = weaponDef.tracks and weaponDef.turnRate or 0

		if( weaponDef.wobble > turnRate * 1.4 ) then
			if( weaponDef.customParams.weaponvelocity ) then
				scatter =( weaponDef.wobble - weaponDef.turnRate ) * 
							( weaponDef.customParams.weaponvelocity ) * 16
			else
				scatter =( weaponDef.wobble - weaponDef.turnRate ) * 
							( weaponDef.projectilespeed * GAME_SPEED ) * GAME_SPEED
			end
			local rangeScatter = ( 8 * weaponDef.wobble - weaponDef.turnRate )
			retData = {
				type = "wobble",
				scatter = scatter,
				rangeScatter = rangeScatter,
				range = weaponDef.range }
			
		elseif( weaponDef.wobble > turnRate ) then
			if( weaponDef.customParams.weaponvelocity ) then
				scatter = ( weaponDef.wobble - weaponDef.turnRate ) * 
							( weaponDef.customParams.weaponvelocity ) * 16
			else
				scatter = ( weaponDef.wobble - weaponDef.turnRate ) * 
							( weaponDef.projectilespeed * GAME_SPEED ) * 16
			end
			retData = {
				type = "wobble", 
				scatter = scatter }
			
		elseif( weaponDef.tracks ) then
			retData = {
				type = "tracking" }
			
		else
			retData = {
				type = "direct", 
				scatter = scatter, 
				range = weaponDef.range }
			
		end
			
	elseif( weaponType == "AircraftBomb" ) then
		retData = {
			type = "dropped",
			scatter = scatter,
			v = unitDef.speed,
			h = unitDef.wantedHeight,
			salvoSize = weaponDef.salvoSize,
			salvoDelay = weaponDef.salvoDelay }
		
	elseif( weaponType == "StarburstLauncher" ) then
		if( weaponDef.tracks ) then
			retData = { type = "tracking" }
		else
			retData = { type = "cruise" }
		end
		
	elseif( weaponType == "TorpedoLauncher" ) then
		if( weaponDef.tracks ) then
			retData = { type = "tracking" }
		else
			retData = { type = "direct", scatter = scatter, range = weaponDef.range }
		end
		
	elseif( weaponType == "Flame" or weaponDef.noExplode ) then
		retData = {	type = "noexplode", range = weaponDef.range }
	else
		retData = {	type = "direct", scatter = scatter,	range = weaponDef.range }
	end
	
	retData.aoe         = weaponDef.impactOnly and 0 or weaponDef.damageAreaOfEffect
	retData.cost        = unitDef.cost
	retData.mobile      = unitDef.speed > 0
	retData.waterWeapon = weaponDef.waterWeapon
	retData.ee          = weaponDef.edgeEffectiveness
	
	return retData
end

local function SetupUnitDef(unitDefID, unitDef)
	if( not unitDef.weapons ) then 
		return 
	end
  
	local maxSpread = minSpread
	local maxWeaponDef
  
	for num, weapon in ipairs( unitDef.weapons ) do
		if( weapon.weaponDef ) then
			local weaponDef = WeaponDefs[ weapon.weaponDef ]
			if( weaponDef ) then
                local aoe = weaponDef.damageAreaOfEffect
				if( num == 3 and unitDef.canManualFire ) then
					dgunInfo[unitDefID] = getWeaponInfo(weaponDef, unitDef)
				elseif( not weaponDef.isShield 
						and not ToBool( weaponDef.interceptor )
						and ( aoe > maxSpread or weaponDef.range * (weaponDef.accuracy + weaponDef.sprayAngle) > maxSpread )) then
					maxSpread = max( aoe, weaponDef.range * (weaponDef.accuracy + weaponDef.sprayAngle) )
					maxWeaponDef = weaponDef
				end
			end
		end
	end
  
	if (maxWeaponDef) then 
		aoeDefInfo[unitDefID] = getWeaponInfo(maxWeaponDef, unitDef)
	end
end

local function SetupDisplayLists()
  circleList = glCreateList( DrawUnitCircle )
end

local function DeleteDisplayLists()
  glDeleteList( circleList )
end

--------------------------------------------------------------------------------
--updates
--------------------------------------------------------------------------------
local function GetRepUnitID( unitIDs )
  return unitIDs[1]
end

local function UpdateSelection()
  local sel = GetSelectedUnitsSorted()
  
  local maxCost = 0
  dgunUnitDefID = nil
  aoeUnitDefID = nil
  dgunUnitID = nil
  aoeUnitID = nil
  
	for unitDefID, unitIDs in pairs( sel ) do
		if unitDefID == "n" then
			break
		end
		
		if( dgunInfo[unitDefID] ) then 
			dgunUnitDefID = unitDefID
			dgunUnitID = unitIDs[ 1 ]
		end

		if( aoeDefInfo[unitDefID] ) then
			local currCost = UnitDefs[unitDefID].cost * #unitIDs
			if (currCost > maxCost) then
				maxCost = currCost
				aoeUnitDefID = unitDefID
				aoeUnitID = GetRepUnitID(unitIDs)
			end
		end
		
		extraDrawRange = UnitDefs[unitDefID] and UnitDefs[unitDefID].customParams and UnitDefs[unitDefID].customParams.extradrawrange
		if extraDrawRange then
			selUnitID = GetRepUnitID(unitIDs)
		end
	end
end

--------------------------------------------------------------------------------
--aoe
--------------------------------------------------------------------------------

local function DrawAoE(tx, ty, tz, aoe, ee, alphaMult, offset)
  glLineWidth(aoeLineWidthMult * aoe / mouseDistance)
  
  for i=1,numAoECircles do
    local proportion = i / (numAoECircles + 1)
    local radius = aoe * proportion
    local alpha = aoeColor[4] * (1 - proportion) / (1 - proportion * ee) * (1 - GetSecondPart(offset or 0)) * (alphaMult or 1)
    glColor( aoeColor[1], aoeColor[2], aoeColor[3], alpha )
    DrawCircle(tx, ty, tz, radius)
  end

  glColor( 1,1,1,1 )
  glLineWidth( 1 )
end

--------------------------------------------------------------------------------
--dgun/noexplode
--------------------------------------------------------------------------------
local function DrawNoExplode(aoe, fx, fy, fz, tx, ty, tz, range)
  
  local dx = tx - fx
  local dy = ty - fy
  local dz = tz - fz
  
  local bx, by, bz, dist = Normalize(dx, dy, dz)
  
  if (not bx or dist > range) then return end
  
  local br = sqrt(bx*bx + bz*bz)
  
  local wx = -aoe * bz / br
  local wz = aoe * bx / br
  
  local ex = range * bx / br
  local ez = range * bz / br
  
  local vertices = {{fx + wx, fy, fz + wz}, {fx + ex + wx, ty, fz + ez + wz},
                    {fx - wx, fy, fz - wz}, {fx + ex - wx, ty, fz + ez - wz}}
  local alpha = (1 - GetSecondPart()) * aoeColor[4]
  glColor(aoeColor[1], aoeColor[2], aoeColor[3], alpha)
  glLineWidth(scatterLineWidthMult / mouseDistance)
  
  glBeginEnd(GL_LINES, VertexList, vertices)

  glColor(1,1,1,1)
  glLineWidth(1)
end

--------------------------------------------------------------------------------
--ballistics
--------------------------------------------------------------------------------
local function TryTarget(	projectileSpeed, mg, quadratic,
							fromX, fromY, fromZ,
							diffX, diffY, diffZ,
							flatY )
	
	flatLen = sqrt( diffX * diffX + diffZ * diffZ )
	flatX = diffX / flatLen
	flatZ = diffZ / flatLen
	
	local posX, posY, posZ
	
	--local vertices = {}
	for cur = 0, flatLen, SQUARE_SIZE do
		posX, posZ = fromX + flatX * cur, fromZ + flatZ * cur;
		posY = fromY + ( flatY - quadratic * cur ) * cur;

		--if( GetSmoothMeshHeight( posX, posZ ) > posY ) then
		if( GetGroundHeight( posX, posZ ) > posY ) then
			--glBeginEnd( GL.LINE_STRIP, VertexList, vertices )
			return false
		end
		
		--vertices[ #vertices + 1 ] = { posX, posY, posZ }
	end
	--glBeginEnd( GL.LINE_STRIP, VertexList, vertices )
	
	return true
end

local function GetBallisticVector(	v, mg,
									maxH, v4, v2mg, mg2,
									dx, dy, dz, 
									trajectory, 
									range )
	
	local d2d_sq = dx * dx + dz * dz
	local d2d    = sqrt( d2d_sq )
	
	local rangeFactor = ( maxH - dy ) / maxH
	if( d2d > range * rangeFactor ) then
		return nil
	end
  
	local d_sq = d2d_sq + dy * dy
  
	if( d_sq == 0 ) then
		--return 0, v * trajectory, 0
		return nil
	end
  
	local root1 = v4 - v2mg * dy - mg2 * d2d_sq
	if( root1 < 0 ) then
		return nil
	end
  
	local root2 = 2 * d2d_sq * d_sq * ( v * v - mg * dy - trajectory * sqrt( root1 ) )
  
	if( root2 < 0 ) then
		return nil 
	end
  
	local vr = sqrt( root2 )/( 2 * d_sq )

	local bx = dx * vr / d2d
	local bz = dz * vr / d2d
	local by = ( vr == 0 ) and v or vr * dy / d2d + d2d * mg / ( 2 * vr )

	return Normalize( bx, by, bz )
end

local function GetBallisticAreaMap( info, fromX, fromY, fromZ, trajectory )

	local v, mg, range = info.v, info.mygravity, info.range
	local maxH, v4, v2mg, mg2 = info.maxH, info.v4, info.v2mg, info.mg2
	local quadratic = info.quadratic
	
	local r2 = range * range
	
	local step = SQUARE_SIZE * range * 0.004 -- 8 for range 2000
	
	local map = {}
	
	for x = -range, range, step do
		for z = -range, range, step do
			local tx, tz = x + fromX, z + fromZ	
			if( ( x * x + z * z ) < r2 and tx > 0 and tz > 0 and tx < mapW and tz < mapH ) then			
				local ty = GetGroundHeight( tx, tz )
				local dy = ty - fromY
				
				local dx, dz = tx - fromX, tz - fromZ
				local _, by, _ = GetBallisticVector( v, mg, maxH, v4, v2mg, mg2, dx, dy, dz, trajectory, range )
				local canAttack = by and TryTarget( v, mg, quadratic, fromX, fromY, fromZ, dx, dy, dz, by )

				map[ #map + 1 ] = { tx, ty, tz, canAttack }
			end
		end
	end
	
	return map
end

local function GetBallisticImpactPoint( v, mg, fx, fy, fz, bx, by, bz )
  local vx, vy, vz = bx * v, by * v, bz * v
  local px, py, pz = fx, fy, fz
  
  --Spring.Echo( v, mg )
  local ttl = 4 * v / mg
  if( mg == 0 ) then
	return
  end
  
  for i = 1, ttl do
    px, py, pz = px + vx, py + vy, pz + vz
    vy = vy - mg
    
    local gwh = max( GetGroundHeight( px, pz ), 0)
    
    if( py < gwh ) then
      local interpolate = min( ( py - gwh ) / vy, 1 )
      local x = px - interpolate * vx
      local z = pz - interpolate * vz
      return {x, max( GetGroundHeight( x, z ), 0 ), z }
    end
  end
  
  return { px, py, pz }
end

--v: weaponvelocity
--trajectory: +1 for high, -1 for low
local function DrawBallisticScatter(	info, 
										fx, fy, fz, 
										tx, ty, tz, 
										trajectory	)
	
	local scatter, v, mg, range = info.scatter, info.v, info.mygravity, info.range
	if( scatter == 0 ) then
		return 
	end
  
	local dx, dy, dz = tx - fx, ty - fy, tz - fz
	if( dx == 0 and dz == 0 ) then 
		return 
	end

	
	local bx, by, bz = GetBallisticVector( v, mg, 
											info.maxH, info.v4, info.v2mg, info.mg2,
											dx, dy, dz, trajectory, range )
  
	-- don't draw anything if out of range
	if( not bx ) then 
		return 
	end
  
	-- don't draw not accessible target

	if( not TryTarget( v, mg, info.quadratic, fx, fy, fz, dx, dy, dz, by ) ) then
		--Spring.SetMouseCursor( "Stop" )
		return
	end
  
	Spring.SetMouseCursor( "none" )
  
	local br = sqrt( bx * bx + bz * bz )
  
	--bars
	scatter = scatter
	local rx, rz = dx / br, dz / br
	local wx, wz = -scatter * rz, scatter * rx
	local barLength = 0.5 * sqrt( wx * wx + wz * wz ) / br --length of bars
	local barX, barZ = barLength * bx, barLength * bz
	local sx, sz = tx - barX, tz - barZ
	local lx, lz = tx + barX, tz + barZ
	local wsx, wsz = -scatter * ( rz - barZ ), scatter * ( rx - barX )
	local wlx, wlz = -scatter * ( rz + barZ ), scatter * ( rx + barX )
  
	local bars = {
				{ tx + wx,  ty, tz + wz }, { tx - wx,  ty, tz - wz },
				{ sx + wsx, ty, sz + wsz}, { lx + wlx, ty, lz + wlz},
				{ sx - wsx, ty, sz - wsz}, { lx - wlx, ty, lz - wlz} }
  

	--trace impact points
	
	local scatterDiv = scatter / numScatterPoints * 0.5
	local impactPoints = {}
	
	for i = -numScatterPoints, numScatterPoints do
		local currScatter = i * scatterDiv
		local currScatterCos = sqrt( 1 - currScatter * currScatter )
		local rMult = currScatterCos - by * currScatter / br
		local bx_c = bx * rMult
		local by_c = by * currScatterCos + br * currScatter
		local bz_c = bz * rMult

		impactPoints[ i + numScatterPoints + 1 ] = GetBallisticImpactPoint( v, mg, fx, fy, fz, bx_c, by_c, bz_c )
	end
  
	--glLineWidth( scatterLineWidthMult / mouseDistance )

	glColor(scatterColor)
	glDepthTest(false)
	glBeginEnd( GL_LINES, VertexList, bars )
	glBeginEnd( GL_POINTS, VertexList, impactPoints )
	glDepthTest(true)
	glColor(1,1,1,1)

	--glLineWidth( 1 )
end

--------------------------------------------------------------------------------
--wobble
--------------------------------------------------------------------------------
local function DrawWobbleScatter(scatter, fx, fy, fz, tx, ty, tz, rangeScatter, range)
  local dx = tx - fx
  local dy = ty - fy
  local dz = tz - fz
  
  local bx, by, bz, d = Normalize( dx, dy, dz )
  
  glColor(scatterColor)
  glLineWidth(scatterLineWidthMult / mouseDistance)
  if d and range then
    if d <= range then
      DrawCircle(tx, ty, tz, rangeScatter * d + scatter)
    end
  else
    DrawCircle(tx, ty, tz, scatter)
  end
  glColor(1,1,1,1)
  glLineWidth(1)
end

--------------------------------------------------------------------------------
--direct
--------------------------------------------------------------------------------
local function DrawDirectScatter(scatter, fx, fy, fz, tx, ty, tz, range, unitRadius)
  local dx = tx - fx
  local dy = ty - fy
  local dz = tz - fz
  
  local bx, by, bz, d = Normalize(dx, dy, dz)
  
  if (not bx or d == 0 or d > range) then return end
  
  local ux = bx * unitRadius / sqrt(1 - by*by)
  local uz = bz * unitRadius / sqrt(1 - by*by)
  
  local cx = -scatter * uz
  local cz = scatter * ux
  local wx = -scatter * dz / sqrt(1 - by*by)
  local wz = scatter * dx / sqrt(1 - by*by)
  
  local vertices = {{fx + ux + cx, fy, fz + uz + cz}, {tx + wx, ty, tz + wz},
                    {fx + ux - cx, fy, fz + uz - cz}, {tx - wx, ty, tz - wz}}
  
  glColor(scatterColor)
  glLineWidth(scatterLineWidthMult / mouseDistance)
  glBeginEnd(GL_LINES, VertexList, vertices)
  glColor(1,1,1,1)
  glLineWidth(1)
end

--------------------------------------------------------------------------------
--dropped
--------------------------------------------------------------------------------
local function DrawDroppedScatter(aoe, ee, scatter, v, fx, fy, fz, tx, ty, tz, salvoSize, salvoDelay)
  local dx = tx - fx
  local dz = tz - fz
  
  local bx, _, bz = Normalize(dx, 0, dz)
  
  if (not bx) then return end
  
  local vertices = {}
  local currScatter = scatter * v * sqrt(2*fy/g)
  local alphaMult = min(v * salvoDelay / aoe, 1)
  
  for i=1,salvoSize do
    local delay = salvoDelay * (i - (salvoSize + 1) / 2)
    local dist = v * delay
    local px_c = dist * bx + tx
    local pz_c = dist * bz + tz
    local py_c = max(GetGroundHeight(px_c, pz_c), 0)
    
    DrawAoE(px_c, py_c, pz_c, aoe, ee, alphaMult, -delay)
    glColor(scatterColor[1], scatterColor[2], scatterColor[3], scatterColor[4] * alphaMult)
    glLineWidth(scatterLineWidthMult / mouseDistance)
    DrawCircle(px_c, py_c, pz_c, currScatter)
  end
  glColor(1,1,1,1)
  glLineWidth(1)
end

--------------------------------------------------------------------------------
--orbital
--------------------------------------------------------------------------------
local function DrawOrbitalScatter(scatter, tx, ty, tz)
	glColor(scatterColor)
	glLineWidth(scatterLineWidthMult / mouseDistance)
	DrawCircle(tx, ty, tz, scatter)
	glColor(1,1,1,1)
	glLineWidth(1)
end

--------------------------------------------------------------------------------
--callins
--------------------------------------------------------------------------------
function widget:Initialize()
	for unitDefID, unitDef in pairs( UnitDefs ) do
		SetupUnitDef( unitDefID, unitDef )
	end
	SetupDisplayLists()
end

function widget:Shutdown()
	DeleteDisplayLists()
end

local hash = {}
local hashUpdate = 0

function widget:DrawWorld()
	if( not hasSelectionCallin ) then
		UpdateSelection()
	end
  
	mouseDistance = GetMouseDistance() or 1000
  
	local tx, ty, tz = GetMouseTargetPosition()
	if( not tx ) then
		return
	end
	local _, cmd, _ = GetActiveCommand()
  
	if extraDrawRange and selUnitID and cmd == CMD_ATTACK then
		local fx, fy, fz = GetUnitPosition(selUnitID)
		if fx then
			glColor(1, 0.35, 0.35, 0.75)
			glLineWidth(1)
			glDrawGroundCircle(fx, fy, fz, extraDrawRange, 50)
			glColor(1,1,1,1)
		end
	end
  
  	local info, unitID, buildUnitDef
	if( cmd == CMD_ATTACK and aoeUnitDefID ) then 
		info = aoeDefInfo[aoeUnitDefID]
		unitID = aoeUnitID
		
	elseif( cmd == CMD_MANUALFIRE and dgunUnitDefID ) then
		info = dgunInfo[dgunUnitDefID]
		unitID = dgunUnitID
		
	else
		return
	end
	
	local fx, fy, fz
	if( unitID ) then
		fx, fy, fz = GetUnitPosition( unitID )
	else		
		return 
	end
  
	if (not fx) then return end
	if (not info.mobile) then fy = fy + GetUnitRadius(unitID) end
  
	if (not info.waterWeapon) then ty = max(0, ty) end
  
	local weaponType = info.type
  
  if (weaponType == "noexplode") then
    DrawNoExplode(info.aoe, fx, fy, fz, tx, ty, tz, info.range)
	
  elseif( weaponType == "ballistic" ) then
    local trajectory = GetUnitStates( unitID ).trajectory and 1 or -1
	local _, _, _, _, _, _, fx, fy, fz = GetUnitPosition(unitID, true, true)
    DrawAoE( tx, ty, tz, info.aoe, info.ee )
    DrawBallisticScatter( info, fx, fy, fz, tx, ty, tz, trajectory )
	
  elseif (weaponType == "tracking") then
    DrawAoE(tx, ty, tz, info.aoe, info.ee)
	
  elseif (weaponType == "direct") then
    DrawAoE(tx, ty, tz, info.aoe, info.ee)
    DrawDirectScatter(info.scatter, fx, fy, fz, tx, ty, tz, info.range, GetUnitRadius(unitID))
	
  elseif (weaponType == "dropped") then
    DrawDroppedScatter(info.aoe, info.ee, info.scatter, info.v, fx, info.h, fz, tx, ty, tz, info.salvoSize, info.salvoDelay)
	
  elseif (weaponType == "wobble") then
    DrawAoE(tx, ty, tz, info.aoe, info.ee)
    DrawWobbleScatter(info.scatter, fx, fy, fz, tx, ty, tz, info.rangeScatter, info.range)
	
  elseif (weaponType == "orbital") then
    DrawAoE(tx, ty, tz, info.aoe, info.ee)
    DrawOrbitalScatter(info.scatter, tx, ty, tz)
	
  elseif (weaponType == "dontdraw") then
        -- don't draw anything foo
		
  else
    DrawAoE(tx, ty, tz, info.aoe, info.ee)
	
  end
  
  if (cmd == CMD_MANUALFIRE) then
    glColor(1, 0, 0, 0.75)
    glLineWidth(1)
    glDrawGroundCircle(fx, fy, fz, info.range, circleDivs)
    glColor(1,1,1,1)
  end
  
end

function widget:SelectionChanged(sel)
  hasSelectionCallin = true
  UpdateSelection()
end

function widget:Update(dt)
  secondPart = secondPart + dt
  secondPart = secondPart - floor(secondPart)
end
