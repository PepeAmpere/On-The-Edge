local butt				= piece 'butt'
local left_leg_top		= piece 'left_leg_top'
local left_leg_middle	= piece 'left_leg_middle'
local left_leg_feet		= piece 'left_leg_feet'
local right_leg_top		= piece 'right_leg_top'
local right_leg_middle	= piece 'right_leg_middle'
local right_leg_feet	= piece 'right_leg_feet'
local body				= piece 'body'
local left_shield		= piece 'left_shield'
local right_shield		= piece 'right_shield'
local left_gun			= piece 'left_gun'
local right_gun			= piece 'right_gun'

local moving 	= false
local gunSelect	= false

local SIG_Aim	= 2
local SIG_Move	= 1

function script.Create()
	moving = false
    return 0
end

local function Walk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
	-- while (true) do
	-- end
end

local function StopWalk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
end

local function RestoreAfterDelay()
	Sleep(1000)
	
	Turn(body, y_axis, math.rad(0), math.rad(90))
	WaitForTurn(body, y_axis)
	Turn(left_gun, x_axis, math.rad(0), math.rad(90))
	Turn(right_gun, x_axis, math.rad(0), math.rad(90))
end

function script.StartMoving()
	moving = true
	StartThread( Walk )
end

function script.StopMoving()
	moving = false
	StartThread( StopWalk )
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_Aim)
	SetSignalMask(SIG_Aim)
	
	local newPitch = -pitch 
	if (pitch <= 0) then
		newPitch = newPitch * 1.5
	end
	
	Turn(body, y_axis, heading, math.rad(180)) 			-- left-right
	Turn(left_gun, x_axis, newPitch, math.rad(300)) 	-- up-down left arm
	Turn(right_gun, x_axis, newPitch, math.rad(300)) 	-- up-down right arm
	WaitForTurn(body, y_axis)
	WaitForTurn(left_gun, x_axis)
	WaitForTurn(right_gun, x_axis)
	
	StartThread( RestoreAfterDelay )
	return true
end

function script.QueryWeapon()
	if gunSelect then 
		return left_gun
	else 
		return right_gun 
	end
end

function script.FireWeapon1()
	gunSelect = not gunSelect
end

function script.AimFromWeapon1()
	return body
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth*100
	if( severity <= 25 ) then
		Explode( left_shield, SFX.SHATTER)
		Explode( right_shield, SFX.SHATTER)
		Explode( body, SFX.SHATTER)
		Explode( left_leg_middle, SFX.FALL)
		Explode( left_leg_feet, SFX.FALL)
		Explode( right_leg_middle, SFX.FALL)
		return (1)
	end
	if( severity <= 50 ) then
		Explode( left_shield, SFX.SHATTER)
		Explode( right_shield, SFX.SHATTER)
		Explode( body, SFX.SHATTER)
		Explode( right_leg_top, SFX.FALL)
		Explode( right_leg_middle, SFX.FALL)
		Explode( right_leg_feet, SFX.FALL)
		Explode( left_leg_top, SFX.FALL)
		Explode( left_leg_middle, SFX.FALL)
		Explode( left_leg_feet, SFX.FALL)
		return (2)
	end
	if( severity <= 99 ) then
		Explode( left_shield, SFX.SHATTER)
		Explode( right_shield, SFX.SHATTER)
		Explode( body, SFX.SHATTER)
		Explode( right_leg_top, SFX.FALL)
		Explode( right_leg_middle, SFX.FALL)
		Explode( right_leg_feet, SFX.SHATTER)
		Explode( left_leg_top, SFX.FALL)
		Explode( left_leg_middle, SFX.FALL)
		Explode( left_leg_feet, SFX.FALL)
		return (3)
	end
	Explode( left_shield, SFX.FALL)
	Explode( right_shield, SFX.FALL)
	Explode( left_gun, SFX.FIRE)
	Explode( right_gun, SFX.FIRE)
	Explode( body, SFX.SHATTER)
	Explode( right_leg_top, SFX.SHATTER)
	Explode( right_leg_middle, SFX.FALL)
	Explode( right_leg_feet, SFX.FALL)
	Explode( left_leg_top, SFX.FALL)
	Explode( left_leg_middle, SFX.FALL)
	Explode( left_leg_feet, SFX.FALL)
	return (3)
end