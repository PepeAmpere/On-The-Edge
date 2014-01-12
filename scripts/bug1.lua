local base		= piece 'base'
local leg1		= piece 'leg1'
local leg2		= piece 'leg2'
local leg3		= piece 'leg3'
local leg4		= piece 'leg4'
local leg5		= piece 'leg5'
local leg6		= piece 'leg6'
local cro1		= piece 'cro1'
local cro2		= piece 'cro2'
local flare1	= piece 'flare1'
local flare2	= piece 'flare2'

local moving	= false
local SIG_Aim	= 2
local SIG_Walk	= 1

local now 		= nil
local rad0		= math.rad(0)
local rad100	= math.rad(100)
local rad200	= math.rad(200)

function script.Create()
	Hide (flare1)
	Hide (flare2)
	Move (base, y_axis, math.rad(-10), now)
	Move (base, y_axis, rad0, math.rad(5))
	moving = false
    return 0
end

local function Walk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
	while (true) do
	
		if (moving) then
			Turn( leg1, y_axis, math.rad(43.005495), now)
			Turn( leg1, y_axis, math.rad(0), math.rad(148.000000))
			Turn( leg1, z_axis, math.rad(0), now)
			Turn( leg1, z_axis, math.rad(0), math.rad(3.000000))
			Turn( leg2, z_axis, math.rad(0), now)
			Turn( leg2, z_axis, math.rad(31.005495), math.rad(155))
			Turn( leg3, y_axis, math.rad(34.005495), now)
			Turn( leg3, y_axis, math.rad(34.005495), math.rad(3))
			Turn( leg3, z_axis, math.rad(31.005495), now)
			Turn( leg3, z_axis, math.rad(0), math.rad(155))
			Turn( leg4, y_axis, math.rad(-40.005495), now)
			Turn( leg4, y_axis, math.rad(-40.005495), math.rad(0))
			Turn( leg4, z_axis, math.rad(-31.005495), now)
			Turn( leg4, z_axis, math.rad(0), math.rad(152))
			Turn( leg5, y_axis, math.rad(-37.005495), now)
			Turn( leg5, y_axis, math.rad(0), math.rad(185))
			Turn( leg5, z_axis, math.rad(0), now)
			Turn( leg5, z_axis, math.rad(0), math.rad(0))
			Turn( leg6, y_axis, math.rad(0), now)
			Turn( leg6, y_axis, math.rad(-30.005495), math.rad(152))
			Turn( leg6, z_axis, math.rad(-45.005495), now)
			Turn( cro1, z_axis, math.rad(5), math.rad(50))
			Turn( cro1, y_axis, math.rad(5), math.rad(50))
			Turn( cro1, x_axis, math.rad(5), math.rad(50))
			Turn( cro2, z_axis, math.rad(-5), math.rad(50))
			Turn( cro2, y_axis, math.rad(-5), math.rad(50))
			Turn( cro2, x_axis, math.rad(-5), math.rad(50))
			
			Sleep (200)
		end
		
		if (moving) then
			Turn( leg1, z_axis, math.rad(31.005495), math.rad(158))
			Turn( leg2, y_axis, math.rad(34.005495), math.rad(163))
			Turn( leg2, z_axis, math.rad(31.005495), math.rad(0))
			Turn( leg3, y_axis, math.rad(0), math.rad(160))
			Turn( leg3, z_axis, math.rad(0), math.rad(3))
			Turn( leg4, y_axis, math.rad(0), math.rad(200))
			Turn( leg5, z_axis, math.rad(-31.005495), math.rad(155))
			Turn( leg6, z_axis, math.rad(2), math.rad(237))
			Turn( cro1, z_axis, math.rad(-5), math.rad(50))
			Turn( cro1, y_axis, math.rad(-5), math.rad(50))
			Turn( cro1, x_axis, math.rad(-5), math.rad(50))
			Turn( cro2, z_axis, math.rad(5), math.rad(50))
			Turn( cro2, y_axis, math.rad(5), math.rad(50))
			Turn( cro2, x_axis, math.rad(5), math.rad(50))
			
			Sleep (200)
		end
		
		if (moving) then
			Turn( leg1, y_axis, math.rad(55.005495), math.rad(269))
			Turn( leg1, z_axis, math.rad(31.005495), math.rad(3))
			Turn( leg2, y_axis, math.rad(34.005495), math.rad(0))
			Turn( leg2, z_axis, math.rad(0), math.rad(152))
			Turn( leg3, z_axis, math.rad(31.005495), math.rad(158))
			Turn( leg4, y_axis, math.rad(0), math.rad(3))
			Turn( leg4, z_axis, math.rad(-31.005495), math.rad(152))
			Turn( leg5, y_axis, math.rad(-31.005495), math.rad(158))
			Turn( leg5, z_axis, math.rad(-31.005495), math.rad(0))
			Turn( leg6, y_axis, math.rad(3), math.rad(167))
			Turn( cro1, z_axis, math.rad(5), math.rad(50))
			Turn( cro1, y_axis, math.rad(5), math.rad(50))
			Turn( cro1, x_axis, math.rad(5), math.rad(50))
			Turn( cro2, z_axis, math.rad(-5), math.rad(50))
			Turn( cro2, y_axis, math.rad(-5), math.rad(50))
			Turn( cro2, x_axis, math.rad(-5), math.rad(50))
			
			Sleep (200)
		end
		
		Turn( leg1, y_axis, math.rad(43.005495), math.rad(80))
		Turn( leg1, z_axis, math.rad(0), math.rad(162))
		Turn( leg2, y_axis, math.rad(0), math.rad(163))
		Turn( leg2, z_axis, math.rad(0), math.rad(3))
		Turn( leg3, y_axis, math.rad(34.005495), math.rad(163))
		Turn( leg3, z_axis, math.rad(31.005495), math.rad(0))
		Turn( leg4, y_axis, math.rad(-40.005495), math.rad(197))
		Turn( leg4, z_axis, math.rad(-31.005495), math.rad(0))
		Turn( leg5, y_axis, math.rad(-37.005495), math.rad(27))
		Turn( leg5, z_axis, math.rad(0), math.rad(155))
		Turn( leg6, y_axis, math.rad(0), math.rad(15))
		Turn( leg6, z_axis, math.rad(-45.005495), math.rad(237))
		Turn( cro1, z_axis, math.rad(-5), math.rad(50))
		Turn( cro1, y_axis, math.rad(-5), math.rad(50))
		Turn( cro1, x_axis, math.rad(-5), math.rad(50))
		Turn( cro2, z_axis, math.rad(5), math.rad(50))
		Turn( cro2, y_axis, math.rad(5), math.rad(50))
		Turn( cro2, x_axis, math.rad(5), math.rad(50))
		
		Sleep (200)
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