local version = "1.0 (OTE)"
-- ported for OTE

function widget:GetInfo()
	return {
		name 	= "Armor Display",
		desc 	= version .. " Display armor over hero",
		author 	= "PepeAmpere",  -- inspired by S44 armor widget mady by Evil4Zerggin
		date 	= "19 September 2013",
		license = "notAlicense",
		layer 	= 2,
		enabled = true,
	}
end

-- configs
local distance 				= 64
local fontSize 				= 8
local lineWidth 			= 1
local blue					= 0.3

-- constants and math
local close 				= distance - fontSize
local far 					= distance + fontSize
local SQRT2 				= math.sqrt(2)
local PI					= math.pi
local PI2					= PI*2

local acos					= math.acos
local abs					= math.abs
local floor					= math.floor

-- speed-ups
local spGetMouseState 		= Spring.GetMouseState
local spGetUnitDefID 		= Spring.GetUnitDefID
local spGetUnitDirection 	= Spring.GetUnitDirection
local spGetUnitFlanking 	= Spring.GetUnitFlanking
local spGetUnitPosition 	= Spring.GetUnitPosition
local spGetUnitVectors 		= Spring.GetUnitVectors
local spGetSelectedUnits 	= Spring.GetSelectedUnits
local spIsUnitIcon 			= Spring.IsUnitIcon
local spTraceScreenRay 		= Spring.TraceScreenRay

local glBillboard 			= gl.Billboard
local glColor 				= gl.Color
local glLineWidth 			= gl.LineWidth
local glPopMatrix 			= gl.PopMatrix
local glPushMatrix 			= gl.PushMatrix
local glShape 				= gl.Shape
local glText 				= gl.Text
local glTranslate 			= gl.Translate
local glLines 				= GL.LINES

-- math&locals

local function GetArmorColor(armor)
	local red = 1 
	local green = 1
	if (armor < 1) then
		red = 1 - 1.5*(1 - armor)
	elseif (armor > 1) then
		green = 1 - 1.5*(armor - 1)
	end
	
	return {red, green, blue}
end

local fakeArmors = {
}

-- calls

function widget:DrawWorld()
	local mouseX, mouseZ 			  = spGetMouseState()
	local mouseTargetType,mouseTarget = spTraceScreenRay(mouseX, mouseZ)

	if mouseTargetType == "unit" then
		local unitDefID 	= spGetUnitDefID(mouseTarget)
		if (not unitDefID) then return end  -- unknown unit
		local unitDef 		= UnitDefs[unitDefID]
		local flanking 		= unitDef.flankingBonusMode
		local name	 		= unitDef.name

		if (flanking == 3 and fakeArmors[name] == nil)	then
			local x,y,z 					= spGetUnitPosition(mouseTarget)
			local front, up, right 			= spGetUnitVectors(mouseTarget)
			local _,_,minValue				= spGetUnitFlanking(mouseTarget)
			local hackReverseValue			= false
			if (not front) then return end  					-- radar dot
			if (minValue ~= nil and minValue>1) then hackReverseValue = true end 	-- reverse hack - this won't work if front armor weak and rear armor strong (can be enhanced, but.. :)
			
			-- armor vectors
			local frontMult 	= unitDef.flankingBonusDirX
			local topMult 		= unitDef.flankingBonusDirY
			local backMult 		= unitDef.flankingBonusDirZ
			
			-- prerequisities:
			-- frontMult ~ 0 and backMult ~ 1
			-- !not mathematicly correct in all vectors setup, but for expected setups its correct
			local armorFront 	= (1 - frontMult) * unitDef.flankingBonusMin
			local armorRear 	= (0 + backMult) * unitDef.flankingBonusMax
			local armorSide 	= (armorFront + armorRear) / 2
			local armorTop 		= armorRear 
			
			-- finish reverse hack
			if (hackReverseValue) then
				local helpValue = armorFront
				armorFront 		= armorRear
				armorRear 		= helpValue				
			end
			
			local armorFrontDescription 	= (tostring(floor(armorFront * 100)) .. "%")
			local armorSideDescription 		= (tostring(floor(armorSide * 100)) .. "%")
			local armorRearDescription 		= (tostring(floor(armorRear * 100)) .. "%")
			local armorTopDescription 		= (tostring(floor(armorTop * 100)) .. "%")
			
			-- Spring.Echo(armorFrontDescription,armorSideDescription,armorRearDescription,armorTopDescription)
			
			local diagonal1 = {
				(front[1] + right[1]) / SQRT2,
				(front[2] + right[2]) / SQRT2,
				(front[3] + right[3]) / SQRT2,
			}

			local diagonal2 = {
				(front[1] - right[1]) / SQRT2,
				(front[2] - right[2]) / SQRT2,
				(front[3] - right[3]) / SQRT2,
			}

			local vertices = {
				{v = {diagonal1[1] * close, diagonal1[2] * close, diagonal1[3] * close}},
				{v = {diagonal1[1] * far, diagonal1[2] * far, diagonal1[3] * far}},
				{v = {diagonal2[1] * close, diagonal2[2] * close, diagonal2[3] * close}},
				{v = {diagonal2[1] * far, diagonal2[2] * far, diagonal2[3] * far}},
				{v = {-diagonal1[1] * close, -diagonal1[2] * close, -diagonal1[3] * close}},
				{v = {-diagonal1[1] * far, -diagonal1[2] * far, -diagonal1[3] * far}},
				{v = {-diagonal2[1] * close, -diagonal2[2] * close, -diagonal2[3] * close}},
				{v = {-diagonal2[1] * far, -diagonal2[2] * far, -diagonal2[3] * far}},
			}

			glLineWidth(lineWidth)
			
			glPushMatrix()
			
				glTranslate(x,y,z)
				glColor(1,1,1)
				glShape(glLines, vertices)

				glColor(GetArmorColor(armorFront))
				glPushMatrix()
					glTranslate(front[1] * distance, front[2] * distance, front[3] * distance)
					glBillboard()
					glText(armorFrontDescription, 0, -fontSize / 2, fontSize, "nc")
				glPopMatrix()

				glColor(GetArmorColor(armorSide))
				glPushMatrix()
					glTranslate(right[1] * distance, right[2] * distance, right[3] * distance)
					glBillboard()
					glText(armorSideDescription, 0, -fontSize / 2, fontSize, "nc")
				glPopMatrix()

				glPushMatrix()
					glTranslate(-right[1] * distance, -right[2] * distance, -right[3] * distance)
					glBillboard()
					glText(armorSideDescription, 0, -fontSize / 2, fontSize, "nc")
				glPopMatrix()

				glColor(GetArmorColor(armorRear))
				glPushMatrix()
					glTranslate(-front[1] * distance, -front[2] * distance, -front[3] * distance)
					glBillboard()
					glText(armorRearDescription, 0, -fontSize / 2, fontSize, "nc")
				glPopMatrix()

				glColor(GetArmorColor(armorTop))
				glPushMatrix()
					glTranslate(up[1] * distance / 2, up[2] * distance / 2, up[3] * distance / 2)
					glBillboard()
					glText(armorTopDescription, 0, -fontSize / 2, fontSize, "nc")
				glPopMatrix()

			glPopMatrix()
				
			glLineWidth(lineWidth)
		end
	end
end
