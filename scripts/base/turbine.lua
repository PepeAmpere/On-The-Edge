local base = piece 'base'
local body = piece 'body'
local turbine = piece 'turbine'

function script.Create()
	Spring.UnitScript.Spin( turbine, x_axis, math.rad(360) )
    return 0
end

function script.Killed(recentDamage, maxHealth)
	return 0
end