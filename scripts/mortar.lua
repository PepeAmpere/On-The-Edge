local base				= piece 'base'
local gun				= piece 'gun'

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
	Turn(base, y_axis, math.rad(0), math.rad(90))
	WaitForTurn(base, y_axis)
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
	
	StartThread( RestoreAfterDelay )
	return true
end

function script.QueryWeapon()
	return gun
end

function script.FireWeapon1()
	gunSelect = not gunSelect
end

function script.AimFromWeapon1()
	return base
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth*100
	return (3)
end