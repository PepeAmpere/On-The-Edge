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

local moving = false

local SIG_Aim	= 2
local SIG_Move	= 1

function script.Create()
	moving = false
    return 0
end

local function Walk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
	while (true) do
	end
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
end

function script.FireWeapon1()
end

function script.AimFromWeapon1()
end

function script.Killed(recentDamage, maxHealth)
	return 0
end