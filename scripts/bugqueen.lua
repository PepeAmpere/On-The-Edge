local base		= piece 'base'
local turret1	= piece 'turret1'
local turret2	= piece 'turret2'
local rocket	= piece 'rocket'
local radar		= piece 'radar'
local barrel1	= piece 'barrel1'
local barrel2	= piece 'barrel2'
local flare1	= piece 'flare1'
local flare2	= piece 'flare2'
local flare3	= piece 'flare3'
local flare4	= piece 'flare4'
local leg1		= piece 'leg1'
local leg2		= piece 'leg2'
local leg3		= piece 'leg3'
local leg4		= piece 'leg4'
local leg5		= piece 'leg5'
local leg6		= piece 'leg6'  

local moving	= false
local gun1		= base
local gun2		= base

local SIG_Walk	= 1
local SIG_Aim	= 2
local SIG_Aim_2	= 4

function script.Create()
	Hide(flare1)
	Hide(flare2)
	Hide(flare3)
	Hide(flare4)
	moving = false;
	Spin( radar, y_axis, math.rad(100))
    return 0
end

local function Walk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
	while (true) do
	
		if(moving) then
			EmitSfx(leg1, 2052)
			EmitSfx(leg2, 2052)
			EmitSfx(leg3, 2052)
			EmitSfx(leg4, 2052)
			EmitSfx(leg5, 2052)
			EmitSfx(leg6, 2052)
			
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
		
		if(moving) then
		
			EmitSfx(leg1, 2052)
			EmitSfx(leg2, 2052)
			EmitSfx(leg3, 2052)
			EmitSfx(leg4, 2052)
			EmitSfx(leg5, 2052)
			EmitSfx(leg6, 2052)
			
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
		
		if(moving) then
		
			EmitSfx(leg1, 2052)
			EmitSfx(leg2, 2052)
			EmitSfx(leg3, 2052)
			EmitSfx(leg4, 2052)
			EmitSfx(leg5, 2052)
			EmitSfx(leg6, 2052)
			
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
		
		EmitSfx(leg1, 2052)
		EmitSfx(leg2, 2052)
		EmitSfx(leg3, 2052)
		EmitSfx(leg4, 2052)
		EmitSfx(leg5, 2052)
		EmitSfx(leg6, 2052)
		
		Turn( leg1, y-axis, math.rad(43), math.rad(40))
		Turn( leg1, z-axis, math.rad(0), math.rad(40))
		Turn( leg2, y-axis, math.rad(0), math.rad(40))
		Turn( leg2, z-axis, math.rad(0), math.rad(40))
		Turn( leg3, y-axis, math.rad(34), math.rad(40))
		Turn( leg3, z-axis, math.rad(31), math.rad(40))
		Turn( leg4, y-axis, math.rad(-40), math.rad(40))
		Turn( leg4, z-axis, math.rad(-31), math.rad(40))
		Turn( leg5, y-axis, math.rad(-37), math.rad(40))
		Turn( leg5, z-axis, math.rad(0), math.rad(40))
		Turn( leg6, y-axis, math.rad(0), math.rad(40))
		Turn( leg6, z-axis, math.rad(-45), math.rad(40))
		
		Sleep (200)
	end
end

local function StopWalk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
	
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
	Turn( turret1, y_axis, heading, math.rad(90))
	Turn( turret1, x_axis, math.rad(0) - pitch, math.rad(40))
	WaitForTurn( turret1, y_axis)
	WaitForTurn( turret1, x_axis)
	return (1)
end

function script.AimWeapon2(heading, pitch)
	Signal(SIG_Aim_2)
	SetSignalMask(SIG_Aim_2)
	Turn( turret2, y_axis, heading, math.rad(90))
	Turn( rocket, x_axis, heading, math.rad(90))
	return (1)
end

function script.AimWeapon3(heading, pitch)
	Signal(SIG_Aim)
	SetSignalMask(SIG_Aim)
	Turn( turret1, y_axis, heading, math.rad(90))
	Turn( turret1, x_axis, math.rad(0) - pitch, math.rad(60))
	WaitForTurn( turret1, y_axis)
	WaitForTurn( turret1, x_axis)
	return (1)
end

function script.AimWeapon4(heading, pitch)
	Signal(SIG_Aim)
	SetSignalMask(SIG_Aim)
	Turn( turret1, y_axis, heading, math.rad(90))
	Turn( turret1, x_axis, math.rad(0) - pitch, math.rad(60))
	WaitForTurn( turret1, y_axis)
	WaitForTurn( turret1, x_axis)
	return (1)
end

function script.FireWeapon1()

	if(gun1 == 0) then
		Show(flare1)
		Move( barrel1, z_axis, math.rad(-3.2), math.rad(500))
		Sleep(150)
		Hide(flare1)
		WaitForMove( barrel1, z_axis)
		Move( barrel1, z_axis, math.rad(0), math.rad(3.2))
	end
	
	if( gun1 == 1 ) then
		Show(flare2)
		Move( barrel2, z_axis, math.rad(-3.2), math.rad(500))
		Sleep(150)
		Hide(flare2)
		WaitForMove( barrel2, z_axis)
		Move( barrel2, z_axis, math.rad(0), math.rad(3.2))
	end
	
	gun1 = 1-gun1
end

function script.FireWeapon2()

	if( gun2 == 0 ) then
		Show(flare3)
		Sleep(100)
		Hide(flare3)
		gun2 = turret1
		return (0)
	end
	
	if( gun2 == 1 ) then
		Show(flare4)
		Sleep(100)
		Hide(flare4)
		gun2 = base
		return (0)
	end
end

function script.FireWeapon3()
end

function script.FireWeapon4()
end

function script.AimFromWeapon1()
	return turret1
end

function script.AimFromWeapon2()
	return turret2
end

function script.AimFromWeapon3()
	return 1
end

function script.AimFromWeapon4()
	return 1
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth*100
	
	Hide(flare1)
	Hide(flare2)
	Hide(flare3)
	Hide(flare4)
	
	if( severity <= 25 ) then
		Explode( barrel1, SFX.FALL)
		Explode( barrel2, SFX.FALL)
		Explode( base, SFX.FALL)
		Explode( flare1, SFX.FALL)
		Explode( flare2, SFX.FALL)
		Explode( flare3, SFX.FALL)
		Explode( flare4, SFX.FALL)
		Explode( leg1, SFX.FALL)
		Explode( leg2, SFX.FALL)
		Explode( leg3, SFX.FALL)
		Explode( leg4, SFX.FALL)
		Explode( leg5, SFX.FALL)
		Explode( leg6, SFX.FALL)
		Explode( turret1, SFX.FALL)
		Explode( turret2, SFX.FALL)
		Explode( radar, SFX.FALL)
		Explode( rocket, SFX.FALL)
		return 1
	end
	
	if( severity <= 50 ) then
		Explode( barrel1, SFX.FALL)
		Explode( barrel2, SFX.FALL)
		Explode( base, SFX.FALL)
		Explode( flare1, SFX.FALL)
		Explode( flare2, SFX.FALL)
		Explode( flare3, SFX.FALL)
		Explode( flare4, SFX.FALL)
		Explode( leg1, SFX.FALL)
		Explode( leg2, SFX.FALL)
		Explode( leg3, SFX.FALL)
		Explode( leg4, SFX.FALL)
		Explode( leg5, SFX.FALL)
		Explode( leg6, SFX.FALL)
		Explode( turret1, SFX.SHATTER)
		Explode( turret2, SFX.SHATTER)
		Explode( radar, SFX.SHATTER)
		Explode( rocket, SFX.SHATTER)
		return 2
	end
	
	if( severity <= 99 ) then
		Explode( barrel1, SFX.FIRE)
		Explode( barrel2, SFX.FIRE)
		Explode( base, SFX.FIRE)
		Explode( flare1, SFX.FIRE)
		Explode( flare2, SFX.FIRE)
		Explode( flare3, SFX.FIRE)
		Explode( flare4, SFX.FIRE)
		Explode( leg1, SFX.FIRE)
		Explode( leg2, SFX.FIRE)
		Explode( leg3, SFX.FIRE)
		Explode( leg4, SFX.FIRE)
		Explode( leg5, SFX.FIRE)
		Explode( leg6, SFX.FIRE)
		Explode( turret1, SFX.FIRE)
		Explode( turret2, SFX.FIRE)
		Explode( radar, SFX.FIRE)
		Explode( rocket, SFX.FIRE)
		return 3
	end
	
		Explode( barrel1, SFX.FIRE)
		Explode( barrel2, SFX.FIRE)
		Explode( base, SFX.FIRE)
		Explode( flare1, SFX.FIRE)
		Explode( flare2, SFX.FIRE)
		Explode( flare3, SFX.FIRE)
		Explode( flare4, SFX.FIRE)
		Explode( leg1, SFX.FIRE)
		Explode( leg2, SFX.FIRE)
		Explode( leg3, SFX.FIRE)
		Explode( leg4, SFX.FIRE)
		Explode( leg5, SFX.FIRE)
		Explode( leg6, SFX.FIRE)
		Explode( turret1, SFX.FIRE)
		Explode( turret2, SFX.FIRE)
		Explode( radar, SFX.FIRE)
		Explode( rocket, SFX.FIRE)
	
	return 3
end