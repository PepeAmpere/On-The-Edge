local SIG_AIM = 2

function script.Create()
    return 0
end

function script.AimWeapon(weaponID, heading, pitch)
	-- return true
end

function script.FireWeapon(weaponID)
	-- EmitSfx(flare, 0)
end

-- function script.QueryWeapon() return flare end
-- The piece that the bullet/laser/whatever comes out of.

-- function script.AimFromWeapon() return gun end
-- The unit looks from this piece down the QueryWeapon piece, to see whether it's aiming at anything.

function script.Killed(recentDamage, maxHealth)
	return 0
end

function script.HitByWeapon(x,z,weaponDef,damage)
    -- This stops the unit taking damage until it's been built.
	-- if GetUnitValue(COB.BUILD_PERCENT_LEFT)>2 then return 0
	-- else return damage
	-- end
end
