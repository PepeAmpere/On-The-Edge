local butt				= piece 'butt'
local left_leg_top		= piece 'left_leg_top'
local left_leg_middle	= piece 'left_leg_middle'
local left_leg_feet		= piece 'left_lef_feet'
local right_leg_top		= piece 'right_leg_top'
local right_leg_middle	= piece 'right_leg_middle'
local right_leg_feet	= piece 'right_leg_feet'
local body				= piece 'body'
local container			= piece 'container' 
local left_top_tube		= piece 'left_top_tube'
local right_top_tube	= piece 'right_top_tube'
local left_bottom_tube	= piece 'left_bottom_tube'
local right_bottom_tube	= piece 'right_bottom_tube'

local moving = false
local gunSelect = 1		

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
	Turn(container, x_axis, math.rad(0), math.rad(90))
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
	Turn(container, x_axis, newPitch, math.rad(300)) 	-- up-down left arm
	WaitForTurn(body, y_axis)
	WaitForTurn(container, x_axis)
	
	StartThread( RestoreAfterDelay )
	return true
end

function script.QueryWeapon()
	local switch = {
		[1] = left_top_tube,
		[2] = left_bottom_tube,
		[3] = right_top_tube,
		[4] = right_bottom_tube,
	}

	return switch[gunSelect]
end

function script.FireWeapon1()
	gunSelect = ((gunSelect + 1)%4) + 1	
end

function script.AimFromWeapon1()
	return body
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth*100
	if( severity <= 25 ) then
		Explode( left_top_tube, SFX.SHATTER)
		Explode( right_top_tube, SFX.SHATTER)
		Explode( body, SFX.SHATTER)
		Explode( left_leg_middle, SFX.FALL)
		Explode( left_leg_feet, SFX.FALL)
		Explode( right_leg_middle, SFX.FALL)
		return (1)
	end
	if( severity <= 50 ) then
		Explode( left_top_tube, SFX.SHATTER)
		Explode( right_top_tube, SFX.SHATTER)
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
		Explode( left_top_tube, SFX.SHATTER)
		Explode( right_top_tube, SFX.SHATTER)
		Explode( body, SFX.SHATTER)
		Explode( right_leg_top, SFX.FALL)
		Explode( right_leg_middle, SFX.FALL)
		Explode( right_leg_feet, SFX.SHATTER)
		Explode( left_leg_top, SFX.FALL)
		Explode( left_leg_middle, SFX.FALL)
		Explode( left_leg_feet, SFX.FALL)
		return (3)
	end
	Explode( left_top_tube, SFX.FALL)
	Explode( right_top_tube, SFX.FALL)
	Explode( left_bottom_tube, SFX.FIRE)
	Explode( right_bottom_tube, SFX.FIRE)
	Explode( body, SFX.SHATTER)
	Explode( right_leg_top, SFX.SHATTER)
	Explode( right_leg_middle, SFX.FALL)
	Explode( right_leg_feet, SFX.FALL)
	Explode( left_leg_top, SFX.FALL)
	Explode( left_leg_middle, SFX.FALL)
	Explode( left_leg_feet, SFX.FALL)
	return (3)
end