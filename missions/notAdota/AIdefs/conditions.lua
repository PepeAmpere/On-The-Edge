----- mission conditions settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newCondition = {
    ["none"] = function(variable)
		if (variable >= 0) then
		    return true
		else
		    return false
		end
	end,
}