local base = piece 'base'
local box = piece 'box'
local head = piece 'head'
local container = piece 'container'
local barrel = piece 'barrel'

function script.Create()
    return 0
end

function script.Killed(recentDamage, maxHealth)
	return 0
end

function script.AimFromWeapon(num) return barrel end

local function RestoreAfterDelay()
	Sleep(3000)
	Turn( head , y_axis, 0, math.rad(90) )
	WaitForTurn( head, y_axis)
	Turn( container, x_axis, 0, math.rad(90) )
end


function script.AimWeapon(num, heading, pitch )
	Signal( SIG_Aim )
	SetSignalMask( SIG_Aim )
	Turn( head, y_axis, heading + math.rad(45), math.rad(-90) ) 	-- left-right
	Turn( container, x_axis, -pitch, math.rad(270) ) 	
	WaitForTurn(head, y_axis)
	WaitForTurn(container, x_axis)
	StartThread(RestoreAfterDelay)

	return true
end

local function recoil()
	-- Move(barrel, x_axis, 6)
	-- Move(barrel, z_axis, 2)

	-- Move(barrel, x_axis, 0, 3)
	-- Move(barrel, z_axis, 0, 1)
end

function script.FireWeapon(num)
	StartThread(recoil)
end
function script.QueryWeapon(num)
	return barrel
end