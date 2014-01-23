local base = piece 'base'
local bunker = piece 'bunker'
local radar = piece 'radar'
local lights = piece 'lights'

function script.Create()
	Spring.UnitScript.Spin( radar, y_axis, math.rad(64) )
    return 0
end

function script.Killed(recentDamage, maxHealth)
	return 0
end