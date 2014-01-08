----- mission spirits settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newPlan = {
    ["examplePlan"] = function(groupID,teamNumber)
        Spring.Echo("Peewee thinks: Im great example!")
	end,
}

newSpiritDef = {
    ["defaultSpirit"] = function(groupID,teamNumber,mode)
	    if (mode == "prepare") then
		    local thisGroup       = groupInfo[groupID]
		    thisGroup.planCurrent = "examplePlan"
		else  -- execute mode:
		    local thisGroup       = groupInfo[groupID]
		    plan[thisGroup.planCurrent](groupID,teamNumber)
		end
    end,
}