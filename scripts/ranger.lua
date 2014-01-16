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
local left_gun			= piece 'left_bottom_tube'
local right_gun			= piece 'right_bottom_tube'

local moving = false
local gunSelect = false		

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

function script.StartMoving()
	moving = true
	StartThread( Walk )
end

function script.StopMoving()
	moving = false
	StartThread( StopWalk )
end

function script.AimWeapon1()
	Signal(SIG_Aim)
	SetSignalMask(SIG_Aim)
end

function script.FireWeapon1()
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
	Explode( left_top_tube, SFX.FIRE)
	Explode( right_top_tube, SFX.FIRE)
	Explode( body, SFX.SHATTER)
	Explode( right_leg_top, SFX.SHATTER)
	Explode( right_leg_middle, SFX.FALL)
	Explode( right_leg_feet, SFX.FALL)
	Explode( left_leg_top, SFX.FALL)
	Explode( left_leg_middle, SFX.FALL)
	Explode( left_leg_feet, SFX.FALL)
	return (3)
end