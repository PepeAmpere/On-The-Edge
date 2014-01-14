local base		= piece 'base'
local turret	= piece 'turret'
local jawleft	= piece	'jawleft'
local jawright	= piece 'jawright'
local head		= piece 'head'
local tooth		= piece 'tooth'
local leg1		= piece 'leg1'
local leg2		= piece 'leg2'
local leg3		= piece 'leg3'
local leg4		= piece 'leg4'
local leg5		= piece 'leg5'
local leg6		= piece 'leg6'

local moving	= false
local SIG_Aim	= 2
local SIG_Aim_2	= 4
local SIG_Move	= 1

function script.Create()
	moving = false
    return 0
end

local function Walk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
	while( true ) do
	
		if( moving ) then
			Turn( leg1, y_axis, math.rad(43), math.rad(40))
			Turn( leg1, y_axis, math.rad(0), math.rad(40))
			Turn( leg1, z_axis, math.rad(0), math.rad(40))
			Turn( leg1, z_axis, math.rad(0), math.rad(40))
			Turn( leg2, z_axis, math.rad(0), math.rad(40))
			Turn( leg2, z_axis, math.rad(31), math.rad(40))
			Turn( leg3, y_axis, math.rad(34), math.rad(40))
			Turn( leg3, y_axis, math.rad(34), math.rad(40))
			Turn( leg3, z_axis, math.rad(31), math.rad(40))
			Turn( leg3, z_axis, math.rad(0), math.rad(40))
			Turn( leg4, y_axis, math.rad(-40), math.rad(40))
			Turn( leg4, y_axis, math.rad(-40), math.rad(40))
			Turn( leg4, z_axis, math.rad(-31), math.rad(40))
			Turn( leg4, z_axis, math.rad(0), math.rad(40))
			Turn( leg5, y_axis, math.rad(-37), math.rad(40))
			Turn( leg5, y_axis, math.rad(0), math.rad(40))
			Turn( leg5, z_axis, math.rad(0), math.rad(40))
			Turn( leg5, z_axis, math.rad(0), math.rad(40))
			Turn( leg6, y_axis, math.rad(0), math.rad(40))
			Turn( leg6, y_axis, math.rad(-30), math.rad(40))
			Turn( leg6, z_axis, math.rad(-45), math.rad(40))
			
			Sleep (200)
		end
		
		if( moving ) then
			Turn( leg1, z_axis, math.rad(31), math.rad(40))
			Turn( leg2, y_axis, math.rad(34), math.rad(40))
			Turn( leg2, z_axis, math.rad(31), math.rad(40))
			Turn( leg3, y_axis, math.rad(0), math.rad(40))
			Turn( leg3, z_axis, math.rad(0), math.rad(40))
			Turn( leg4, y_axis, math.rad(0), math.rad(40))
			Turn( leg5, z_axis, math.rad(-31), math.rad(40))
			Turn( leg6, z_axis, math.rad(2), math.rad(40))
			
			Sleep (200)
		end
		
		if( moving ) then
			Turn( leg1, y_axis, math.rad(55), math.rad(40))
			Turn( leg1, z_axis, math.rad(31), math.rad(40))
			Turn( leg2, y_axis, math.rad(34), math.rad(40))
			Turn( leg2, z_axis, math.rad(0), math.rad(40))
			Turn( leg3, z_axis, math.rad(31), math.rad(40))
			Turn( leg4, y_axis, math.rad(0), math.rad(40))
			Turn( leg4, z_axis, math.rad(-31), math.rad(40))
			Turn( leg5, y_axis, math.rad(-31), math.rad(40))
			Turn( leg5, z_axis, math.rad(-31), math.rad(40))
			Turn( leg6, y_axis, math.rad(3), math.rad(40))
			
			Sleep (200)
		end
		
		Turn( leg1, y_axis, math.rad(43), math.rad(40))
		Turn( leg1, z_axis, math.rad(0), math.rad(40))
		Turn( leg2, y_axis, math.rad(0), math.rad(40))
		Turn( leg2, z_axis, math.rad(0), math.rad(40))
		Turn( leg3, y_axis, math.rad(34), math.rad(40))
		Turn( leg3, z_axis, math.rad(31), math.rad(40))
		Turn( leg4, y_axis, math.rad(-40), math.rad(40))
		Turn( leg4, z_axis, math.rad(-31), math.rad(40))
		Turn( leg5, y_axis, math.rad(-37), math.rad(40))
		Turn( leg5, z_axis, math.rad(0), math.rad(40))
		Turn( leg6, y_axis, math.rad(0), math.rad(40))
		Turn( leg6, z_axis, math.rad(-45), math.rad(40))
		
		Sleep (200)
	end
end

local function StopWalk()
	Signal(SIG_Walk)
	SetSignalMask( SIG_Walk )
	
	Sleep (100)
	Turn( leg1, y_axis, math.rad(0), math.rad(100))
	Turn( leg1, z_axis, math.rad(0), math.rad(100))
	Turn( leg2, y_axis, math.rad(0), math.rad(100))
	Turn( leg2, z_axis, math.rad(0), math.rad(100))
	Turn( leg3, y_axis, math.rad(0), math.rad(100))
	Turn( leg3, z_axis, math.rad(0), math.rad(100))
	Turn( leg4, y_axis, math.rad(0), math.rad(100))
	Turn( leg4, z_axis, math.rad(0), math.rad(100))
	Turn( leg5, y_axis, math.rad(0), math.rad(100))
	Turn( leg5, z_axis, math.rad(0), math.rad(100))
	Turn( leg6, y_axis, math.rad(0), math.rad(100))
	Turn( leg6, z_axis, math.rad(0), math.rad(100))
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
	Turn( base, y_axis, heading, math.rad(30))
	Turn( head, y_axis, heading, math.rad(200))
	Turn( head, x_axis, math.rad(0) - pitch - math.rad(24), math.rad(120))
	WaitForTurn( head, y_axis)
	WaitForTurn( head, x_axis)
	return 1
end

function script.AimWeapon2(heading, pitch)
	Signal(SIG_Aim_2)
	SetSignalMask(SIG_Aim_2)
	Turn( head, y_axis, heading, math.rad(200))
	Turn( head, x_axis, math.rad(0) - pitch - math.rad(24), math.rad(120))
	WaitForTurn( head, y_axis)
	WaitForTurn( head, x_axis)
	return 1
end

function script.FireWeapon1()
	Move( base, z_axis, math.rad(6.4), math.rad(40))
	Move( base, y_axis, math.rad(3.2), math.rad(20))
	Sleep (100)
	Turn( jawright, y_axis, math.rad(60), math.rad(500))
	Turn( jawleft, y_axis, math.rad(-60), math.rad(500))
	Sleep (200)
	Move( base, z_axis, math.rad(0), math.rad(32))
	Move( base, y_axis, math.rad(0), math.rad(16))
	Turn( jawright, y_axis, math.rad(0), math.rad(300))
	Turn( jawleft, y_axis, math.rad(0), math.rad(300))
end

function script.FireWeapon2()
end

function script.AimFromWeapon1()
	return head
end

function script.AimFromWeapon2()
	return head
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth*100
	if( severity <= 25 ) then
		Explode( base, SFX.SHATTER)
		Explode( leg1, SFX.SHATTER)
		Explode( leg2, SFX.SHATTER)
		Explode( leg3, SFX.SHATTER)
		Explode( leg4, SFX.SHATTER)
		Explode( leg5, SFX.SHATTER)
		Explode( leg6, SFX.SHATTER)
		Explode( turret, SFX.SHATTER)
		return (1)
	end
	
	if( severity <= 50 ) then
		Explode( base, SFX.SHATTER)
		Explode( leg1, SFX.FALL)
		Explode( leg2, SFX.FALL)
		Explode( leg3, SFX.FALL)
		Explode( leg4, SFX.FALL)
		Explode( leg5, SFX.FALL)
		Explode( leg6, SFX.FALL)
		Explode( turret, SFX.SHATTER)
		return (2)
	end
	
	if( severity <= 99 ) then
		Explode( base, SFX.SHATTER)
		Explode( leg1, SFX.FALL)
		Explode( leg2, SFX.FALL)
		Explode( leg3, SFX.FALL)
		Explode( leg4, SFX.FALL)
		Explode( leg5, SFX.FALL)
		Explode( leg6, SFX.FALL)
		Explode( turret, SFX.SHATTER)
		return (3)
	end
	
	Explode( base, SFX.SHATTER)
	Explode( leg1, SFX.FALL)
	Explode( leg2, SFX.FALL)
	Explode( leg3, SFX.FALL)
	Explode( leg4, SFX.FALL)
	Explode( leg5, SFX.FALL)
	Explode( leg6, SFX.FALL)
	Explode( turret, SFX.SHATTER)
	return (3)
end