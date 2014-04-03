------------------------------------------------------------------------------
-- NOE COMMANDS
-- head functions for execution commands
------------------------------------------------------------------------------

local spGiveOrderToUnit                = Spring.GiveOrderToUnit

function BigMove(groupID,moveX,moveY,moveZ,pathType,formation,waiting,targetX,targetZ)
	--- pathType --- !! change the numbers into strings !!
	-- 0 -- default
	-- 1 -- formation only at the end
	
    --- param preparations ---
	local thisGroup         = groupInfo[groupID]
	local thisFormationDef  = formationDef[formation]
	local membersLimit      = thisGroup.membersListMax
	local whatIsCalledHilly = thisFormationDef.hilly
	local isFirst           = true
	local flatLand          = true
    local rotation
    local thisFormationPos

	local secondaryMoveX, secondaryMoveY, secondaryMoveZ
	--- use parameter setting default formation setting
	if (waiting == nil) then  
	    waiting             = thisFormationDef.constrained
	end
	--- getting position of group
    local unitPosX,unitPosY,unitPosZ = GetPositionOfGroup(groupID,membersLimit)

	--- has this unit rotable formation? ---
	if (thisFormationDef.rotable) then
	
		-- use leaders rotation
	    if (thisGroup.dependant) then
			rotation	= groupInfo[thisGroup.itsLeaderID].rotation
		-- or choose own
		else
			local distance = GetDistance2D(unitPosX,unitPosZ,moveX,moveZ)
			if (targetX == nil) then
				if (distance > thisFormationDef.rotationCheckDistance) then 
					targetX            = moveX - (unitPosX - moveX)
					targetZ            = moveZ - (unitPosZ - moveZ)
					rotation           = GetRotation(moveX,moveZ,targetX,targetZ,thisFormationDef.rotations) 
					thisGroup.rotation = rotation
				else   --- keep old rotation
					rotation = thisGroup.rotation
				end
			else  --- so if target is specified
				rotation = GetRotation(moveX,moveZ,targetX,targetZ,thisFormationDef.rotations) 
				thisGroup.rotation = rotation
			end	
		end
		thisFormationPos = formationsRotated[formation][rotation]
		--spEcho(rotation)
	else
	    thisFormationPos = formations[formation]
	end 
	--- end of param preparations ---
	
	for i=1, membersLimit do
	    --spEcho(i,formation,thisGroup.groupED)
	    unitID = thisGroup.membersList[i]
		-- local scaleX = thisFormationDef.scales[1]  -- scaling in definition now 
		-- local scaleZ = thisFormationDef.scales[2]
		local formationX = thisFormationPos[i][1]  ---- * scaleX
		local formationZ = thisFormationPos[i][2]  ---- * scaleZ          --- scaling added in definition now
		if (thisGroup.membersListAlive[i]) then
		    --spEcho(i,thisGroup.membersListAlive[i])
			if (isFirst) then -- commanding leader of unit
			
			    --- behaviour of waiting for other units, when first run fast... (dependable on formation)
				if (waiting and thisFormationDef.constrained) then 
					if (thisGroup.constrainLevel >= 1 and thisGroup.moveModeChanged) then    --- second unit of group is far a lot and is alive, then
					    spGiveOrderToUnit(unitID, CMD.STOP, {}, {})
						thisGroup.constrainLevel = thisGroup.constrainLevel - 1
					else
						spGiveOrderToUnit(unitID, CMD.MOVE, {moveX + formationX, moveY, moveZ + formationZ}, {})
					end
				else
				    spGiveOrderToUnit(unitID, CMD.MOVE, {moveX + formationX, moveY, moveZ + formationZ}, {})
				end
				isFirst = false

				--- setting behaviour of reamining units depening on height situation around commanding unit
				local coef = GetHillyCoeficient(unitPosX,unitPosZ)
				if (coef >= whatIsCalledHilly) then
					flatLand = false
				else
				    flatLand = true
				end
			else  -- commanding remaining units
			    if (flatLand and (pathType ~= 1)) then -- this means units can use better, relative formation, becouse terrian around is not hilly
					spGiveOrderToUnit(unitID, CMD.MOVE, {unitPosX + formationX, unitPosY, unitPosZ + formationZ}, {})
					thisGroup.moveModeChanged = true
				else
				    spGiveOrderToUnit(unitID, CMD.MOVE, {moveX + formationX, moveY, moveZ + formationZ}, {})
					if (thisFormationDef.constrained) then
						if (thisGroup.constrainLevel <= thisFormationDef.constrainLevel) then
							thisGroup.constrainLevel = thisGroup.constrainLevel + 1
						end
					end
					thisGroup.moveModeChanged = false
				end
			end
		end -- end of unit alive
	end
end