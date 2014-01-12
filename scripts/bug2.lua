local base = piece 'base'
local leg1 = piece 'leg1'
local leg2 = piece 'leg2'
local leg3 = piece 'leg3'
local leg4 = piece 'leg4'
local leg5 = piece 'leg5'
local leg6 = piece 'leg6'
local cro1 = piece 'cro1'
local cro2 = piece 'cro2'
local flare1 = piece 'flare1'
local flare2 = piece 'flare2'
local mouthspit = piece 'mouthspit'

local SIG_Walk 	= 1
local SIG_Aim 	= 2
local moving 	= false

local now 		= nil
local walkSleep = 200
local croMoveSp	= math.rad(50)
local rad5		= math.rad(5.000000)
local radMinus5 = math.rad(-5.000000)
local rad0		= math.rad(0)
local rad100	= math.rad(100)
local rad200	= math.rad(200)


function script.Create()
	Hide( flare1)
	Hide( flare2)
	Move( base, y_axis, math.rad(-20), now)
	Move( base, y_axis, math.rad(0), math.rad(40))
	moving = false
    return 0
end

local function CroMove1()
	Turn( cro1, z_axis, rad5, croMoveSp)
	Turn( cro1, y_axis, rad5, croMoveSp)
	Turn( cro1, x_axis, rad5, croMoveSp)
	Turn( cro2, z_axis, radMinus5, croMoveSp)
	Turn( cro2, y_axis, radMinus5, croMoveSp)
	Turn( cro2, x_axis, radMinus5, croMoveSp)
end

local function CroMove2()
	Turn( cro1, z_axis, radMinus5, croMoveSp)
	Turn( cro1, y_axis, radMinus5, croMoveSp)
	Turn( cro1, x_axis, radMinus5, croMoveSp)
	Turn( cro2, z_axis, rad5, croMoveSp)
	Turn( cro2, y_axis, rad5, croMoveSp)
	Turn( cro2, x_axis, rad5, croMoveSp)
end

local function Walk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
	while ( true ) do
	
		if (moving) then
			Turn( leg1, y_axis, math.rad(43.005495), now)
			Turn( leg1, y_axis, math.rad(0.000000), math.rad(148))
			Turn( leg1, z_axis, math.rad(0.000000), now)
			Turn( leg1, z_axis, math.rad(0.000000), math.rad(3))	
			
			Turn( leg2, z_axis, math.rad(0.000000), now)
			Turn( leg2, z_axis, math.rad(31.005495), math.rad(155))
			
			Turn( leg3, y_axis, math.rad(34.005495), now)
			Turn( leg3, y_axis, math.rad(34.005495), math.rad(3))
			Turn( leg3, z_axis, math.rad(31.005495), now)
			Turn( leg3, z_axis, math.rad(0.000000), math.rad(155))
			
			Turn( leg4, y_axis, math.rad(-40.005495), now)
			Turn( leg4, y_axis, math.rad(-40.005495), math.rad(0))
			Turn( leg4, z_axis, math.rad(-31.005495), now)
			Turn( leg4, z_axis, math.rad(0.000000), math.rad(152))
			
			Turn( leg5, y_axis, math.rad(-37.005495), now)
			Turn( leg5, y_axis, math.rad(0.000000), math.rad(185))
			Turn( leg5, z_axis, math.rad(0.000000), now)
			Turn( leg5, z_axis, math.rad(0.000000), math.rad(0))
			
			Turn( leg6, y_axis, math.rad(0.000000), now)
			Turn( leg6, y_axis, math.rad(-30.005495), math.rad(152))
			Turn( leg6, z_axis, math.rad(-45.005495), now)	
			
			CroMove1()		
			Sleep(walkSleep)		
		end
		
		if (moving) then
			Turn( leg1, z_axis, math.rad(31.005495), math.rad(158))
			Turn( leg2, y_axis, math.rad(34.005495), math.rad(163))
			Turn( leg2, z_axis, math.rad(31.005495), math.rad(1))		
			Turn( leg3, y_axis, math.rad(0.000000), math.rad(160))
			Turn( leg3, z_axis, math.rad(0.000000), math.rad(3))
			Turn( leg4, y_axis, math.rad(0.000000), math.rad(200))
			Turn( leg5, z_axis, math.rad(-31.005495), math.rad(155))			
			Turn( leg6, z_axis, math.rad(2.000000), math.rad(237))	

			CroMove2()
			Sleep(walkSleep)
		end
		
		if (moving) then
			Turn( leg1, y_axis, math.rad(55.005495), math.rad(269))
			Turn( leg1, z_axis, math.rad(31.005495), math.rad(3))	
			Turn( leg2, y_axis, math.rad(34.005495), math.rad(0))
			Turn( leg2, z_axis, math.rad(0.000000), math.rad(152))	
			Turn( leg3, z_axis, math.rad(31.005495), math.rad(158))	
			Turn( leg4, y_axis, math.rad(0.000000), math.rad(3))
			Turn( leg4, z_axis, math.rad(-31.005495), math.rad(152))
			Turn( leg5, y_axis, math.rad(-31.005495), math.rad(158))
			Turn( leg5, z_axis, math.rad(-31.005495), math.rad(0))	
			Turn( leg6, y_axis, math.rad(3.000000), math.rad(167))

			CroMove1()
			Sleep(walkSleep)
		end

		Turn( leg1, y_axis, math.rad(43.005495), math.rad(80))
		Turn( leg1, z_axis, math.rad(0.000000), math.rad(162))
		Turn( leg2, y_axis, math.rad(0.000000), math.rad(163))
		Turn( leg2, z_axis, math.rad(0.000000), math.rad(163))
		Turn( leg3, y_axis, math.rad(34.005495), math.rad(163))
		Turn( leg3, z_axis, math.rad(31.005495), math.rad(0))	
		Turn( leg4, y_axis, math.rad(-40.005495), math.rad(197))
		Turn( leg4, z_axis, math.rad(-31.005495), math.rad(0))
		Turn( leg5, y_axis, math.rad(-37.005495), math.rad(27))
		Turn( leg5, z_axis, math.rad(0.000000), math.rad(155))
		Turn( leg6, y_axis, math.rad(0.000000), math.rad(15))
		Turn( leg6, z_axis, math.rad(-45.005495), math.rad(137))	
		
		CroMove2()
		Sleep(walkSleep)
   
	end
end

local function StopWalk()
	Signal(SIG_Walk)
	SetSignalMask( SIG_Walk )
	
	Sleep(100)
	Turn( leg1, y_axis, rad0, rad100)
	Turn( leg1, z_axis, rad0, rad100)
	Turn( leg2, y_axis, rad0, rad100)
	Turn( leg2, z_axis, rad0, rad100)
	Turn( leg3, y_axis, rad0, rad100)
	Turn( leg3, z_axis, rad0, rad100)
	Turn( leg4, y_axis, rad0, rad100)
	Turn( leg4, z_axis, rad0, rad100)
	Turn( leg5, y_axis, rad0, rad100)
	Turn( leg5, z_axis, rad0, rad100)
	Turn( leg6, y_axis, rad0, rad100)
	Turn( leg6, z_axis, rad0, rad100)
	Turn( cro1, z_axis, rad0, rad200)
	Turn( cro1, y_axis, rad0, rad200)
	Turn( cro1, x_axis, rad0, rad200)
	Turn( cro2, z_axis, rad0, rad200)
	Turn( cro2, y_axis, rad0, rad200)
	Turn( cro2, x_axis, rad0, rad200)
end

function script.StartMoving()
	moving = true
    StartThread( Walk )
end

function script.StopMoving()
	moving = false
    StartThread( StopWalk )
end   

function script.Killed(recentDamage, maxHealth)
	return 0
end

function script.AimWeapon1(heading, pitch)
	Signal(SIG_Aim)
	SetSignalMask(SIG_Aim)
	Turn( base, y_axis, heading, math.rad(360))
	WaitForTurn(base, y_axis)
	return 1
end

function script.FireWeapon1()
	Move( base, z_axis, math.rad(10), math.rad(50))
	Move( base, y_axis, math.rad(3), math.rad(30))
	Move( flare1, z_axis, math.rad(-20), math.rad(50))
	Move( flare1, y_axis, math.rad(-3), math.rad(30))
	Sleep(200)
	Turn( cro1, x_axis, math.rad(140.016484), math.rad(900))
	Turn( cro1, z_axis, math.rad(-30), math.rad(800))
	Turn( cro1, y_axis, math.rad(60.005495), math.rad(500))
	Turn( cro2, x_axis, math.rad(140.016484), math.rad(900))
	Turn( cro2, z_axis, math.rad(30), math.rad(800))
	Turn( cro2, y_axis, math.rad(-60.005495), math.rad(500))
	Sleep(250)
	Turn( cro1, x_axis, math.rad(0), math.rad(900))
	Turn( cro1, z_axis, math.rad(0), math.rad(800))
	Turn( cro1, y_axis, math.rad(0), math.rad(500))
	Turn( cro2, x_axis, math.rad(0), math.rad(900))
	Turn( cro2, z_axis, math.rad(0), math.rad(800))
	Turn( cro2, y_axis, math.rad(0), math.rad(500))
	Move( base, z_axis, math.rad(0), math.rad(50))
	Move( base, y_axis, math.rad(0), math.rad(30))
	Move( flare1, z_axis, math.rad(0), math.rad(50))
	Move( flare1, y_axis, math.rad(0), math.rad(30))
end

function script.AimFromWeapon1()
	return base
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth*100
	if( severity <= 25 ) then
		Explode( cro1, SFX.SHATTER)
		Explode( cro2, SFX.SHATTER)
		Explode( leg1, SFX.FALL)
		return (1)
	end
	if( severity <= 50 ) then
		Explode( cro1, SFX.FALL)
		Explode( cro2, SFX.FALL)
		Explode( base, SFX.SHATTER)
		Explode( flare1, SFX.SHATTER)
		Explode( leg1, SFX.SHATTER)
		Explode( leg5, SFX.FALL)
		return (2)
	end
	if( severity <= 99 ) then
		Explode( cro1, SFX.FALL)
		Explode( cro2, SFX.FALL)
		Explode( base, SFX.SHATTER)
		Explode( flare1, SFX.FALL)
		Explode( flare2, SFX.FALL)
		Explode( leg1, SFX.FALL)
		Explode( leg2, SFX.FALL)
		Explode( leg3, SFX.FALL)
		Explode( leg4, SFX.FALL)
		Explode( leg5, SFX.SHATTER)
		Explode( leg6, SFX.SHATTER)
		return (3)
	end
	Explode( cro1, SFX.FALL)
	Explode( cro2, SFX.FALL)
	Explode( base, SFX.SHATTER)
	Explode( flare1, SFX.SHATTER)
	Explode( flare2, SFX.SHATTER)
	Explode( leg1, SFX.FALL)
	Explode( leg2, SFX.SHATTER)
	Explode( leg3, SFX.SHATTER)
	Explode( leg4, SFX.FALL)
	Explode( leg5, SFX.FALL)
	Explode( leg6, SFX.SHATTER)
	return (3)
end