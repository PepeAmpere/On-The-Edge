local base = piece 'base'
local body = piece 'body'
local turbine = piece 'turbine'

function script.Create()
	Spring.UnitScript.Spin( turbine, x_axis, math.rad(1440) )
	Spring.UnitScript.Spin( turbine, y_axis, math.rad(18) )
    return 0
end

function script.Killed(recentDamage, maxHealth)
	return 0
end