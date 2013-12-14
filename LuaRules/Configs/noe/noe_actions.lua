----------------------------------------------------------
-- NOE actions defs
-- WIKI: http://code.google.com/p/nota/wiki/NOE_actions
----------------------------------------------------------

action = {
	-- SPECIAL WIN/DEFEAT ACTIONS --
	["victoryForPlayers"] = function(teamNumberWinning,numberOfVictory)
		-- DESCRIPTION --
		-- ! declare vicotory for players
		-- ! after short delay
		Spring.Echo(missionInfo.victory[numberOfVictory].message)
		return true
	end,
	["defeatForPlayers"] = function(teamNumberDefeated,numberOfDefeat)
		-- DESCRIPTION --
		-- ! declare loose for players
		-- ! after shorter delay
		Spring.Echo(missionInfo.defeat[numberOfDefeat].message)
		return true
	end,
	
	-- OTHER --
    ["consoleWrite"] = function(word)
        if (word ~= nil) then
		    Spring.Echo(word)
			return true
		else
		    return false
		end
	end,
	
	-- TAUNTS --
	["tauntAttack"] = function(name)
        if (name ~= nil) then
		    -- ! temporary attack taunts list !
			local attackTaunts = {
				"(19) Attack!",
				"(20) Let's get 'em.",
				"(30) Prepare to be crushed.",
				"(127) Well now you'll gonna get it motherfucker! That's right, you and me, right now, we're havin' it out ! Let's go !C'mon ! C'mon !",
				"(496) Let the attack begin.",
				"(503) Get them minions! Get them!",
				"(564) You have made me very angry, very angry indeed!",
				"(647) I'm not finished yet!",
				"(711) This pisses me off!",
				"(857) Die you son of a bitch!",
			}
			
			local randomIndex	= math.random(1,#attackTaunts)
			local choosenTaunt  = attackTaunts[randomIndex]
			local word			= name .. choosenTaunt
			action["consoleWrite"](word)
			return true
		else
		    return false
		end
	end,
	
	--- SPECIAL ---
	-- ["write-bitch"] = function()
	    -- local result = action["consoleWrite"]("Bitch!")
        -- if (result) then
			-- return true
		-- else
		    -- return false
		-- end
	-- end,
}