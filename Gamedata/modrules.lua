local modrules  = {
    movement = {
		allowPushingEnemyUnits  = true,
		
	},
	reclaim = {
	    reclaimMethod  = 0,
		unitMethod     = 4,
	}, 
    fireAtDead = {
		fireAtKilled   = true,
		fireAtCrashing = true,
    }, 
	paralyze = {
	    paralyzeOnMaxHealth = false,
	},
	system = {
	    pathFinderSystem = 0,
	    luaThreadingModel = 4,
	    giveAllSpacing = 2.0,
	},
	featureLOS = {
	    featureVisibility = 1,
	},
	sensors = {   
		los = {
			losMipLevel = 3, 
			losMul      = 1,
			airMipLevel = 6,
			airMul      = 1,
		},
	}, 
	experience = {
		experienceMult = 0,
	}
	
	--flankingBonus set at given units
	-- flankingBonus = {
	    -- defaultMode = 0,
	-- },
}

return modrules