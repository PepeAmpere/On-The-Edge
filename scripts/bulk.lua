-- defs including heirarchy --
local base = piece 'base'
	local torso = piece 'torso'
		local chest = piece 'chest'
			local arm_left = piece 'arm_left'
				local mg_left = piece 'mg_left'
			local arm_right = piece 'arm_right'
				local mg_right = piece 'mg_right'
		local backpack = piece 'backpack'
	local leg_left_top = piece 'leg_left_top'
		local leg_left_bottom = piece 'leg_left_bottom'
			local leg_left_foot = piece 'leg_left_foot'
	local leg_right_top = piece 'leg_right_top'
		local leg_right_bottom = piece 'leg_right_bottom'
			local leg_right_foot = piece 'leg_right_foot'
				
-- waiting times
local restoring = 1350
local mgStep = 10

-- rotations
local plusQuarter 	= math.rad(90)
local plusHalf 		= math.rad(180)
local plus3Quarter 	= math.rad(270)


-- signals				
local SIG_Walk = 1
local SIG_Aim = 2	

local gunSelect = false			

-----------------------------------------------
	
-- init
function script.Create()
	-- close shield generator
	Move(backpack, z_axis, 8)
end


-- move
local function Walk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
end

local function StopWalk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
end

function script.StartMoving()
	StartThread(Walk)
end

function script.StopMoving()
	StartThread(StopWalk)
end  

function script.Activate()
	-- here shield
end

function script.Deactivate()
end 

local function RestoreAfterDelay()
	Sleep(restoring)
	
	-- turn back to basic position
	Turn(chest, y_axis, 0, plusQuarter)
	WaitForTurn(chest, y_axis)
	Turn(arm_left, x_axis, 0, plusQuarter)
	Turn(arm_right, x_axis, 0, plusQuarter)
end

-- weapons
function script.QueryWeapon(num)
	if gunSelect then 
		return mg_left
	else 
		return mg_right 
	end
end

function script.AimFromWeapon(num) return torso end

function script.AimWeapon(num, heading, pitch)
	Signal(SIG_Aim)
	SetSignalMask(SIG_Aim)
	
	local newPitch = -pitch 
	if (pitch <= 0) then
		newPitch = newPitch * 1.5
	end
	
	-- aiming
	Turn(chest, y_axis, heading, plusHalf) 			-- left-right
	Turn(arm_left, x_axis, newPitch, plus3Quarter) 	-- up-down left arm
	Turn(arm_right, x_axis, newPitch, plus3Quarter) -- up-down right arm
	WaitForTurn(chest, y_axis)
	WaitForTurn(arm_left, x_axis)
	WaitForTurn(arm_right, x_axis)
	
	StartThread(RestoreAfterDelay)
	return true
end

local function rotator()
	if gunSelect then
		Spin(mg_left, z_axis, 14)
		Sleep(mgStep)
		StopSpin(mg_left, z_axis, 1)
	else
		Spin(mg_right, z_axis, 14)
		Sleep(mgStep)
		StopSpin(mg_right, z_axis, 1)
	end
end

function script.FireWeapon(num)
	-- switch guns each shot
	gunSelect = not gunSelect
	StartThread(rotator)
end

-- killed
function script.Killed(recentDamage, maxHealth)
end 