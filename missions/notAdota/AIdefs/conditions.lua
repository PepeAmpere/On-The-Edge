----- mission conditions settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newCondition = {
	["timeMinute"] = function()
		-- DESCRIPTION --
		-- returns true each minute
		if (realGameTime[3] == 0) then
		    return true
		else
			return false
		end
	end,
}