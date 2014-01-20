----- mission conditions settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newCondition = {
	["SecondInMinute"] = function(second)
		-- DESCRIPTION --
		-- returns true each minute
		if (realGameTime[3] == second) then
		    return true
		else
			return false
		end
	end,
	["GameUndecided"] = function()
		-- DESCRIPTION --
		-- check if both main bunkers are considered alive
		if (missionKnowledge.goodMain and missionKnowledge.badMain) then
		    return true
		else
			return false
		end
	end,
}