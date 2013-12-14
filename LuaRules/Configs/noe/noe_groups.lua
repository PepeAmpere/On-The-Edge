----------------------------------------------------------
-- NOE groups defs
-- WIKI: http://code.google.com/p/nota/wiki/NOE_groups
----------------------------------------------------------

-- IMPORTANT HINTS:
-- !! all groups planned to be used have to be listed in noe_side.lua side list
-- !! be sure you use really unique names for groupDefs, if two names the same, the last one remains
-- ! OLD - current issue, its good to have some unit growth in each of 7 levels of each unitType of buildlist making, or the factory stops production
-- buffer groups are allways "first" in list to catch all created units of its type
-- status numbers 1) IOA, 2) heavy loses, 3) light loses, 4) rdy ,.... 5) = size, max units
-- preference says how many units in which level of AI growth should have the group have
-- source is name class producing this type of units
-- targetClasses list all names of classes of possible valuable targets of given group
-- ADD WHOLE MODULE? include file in noe_module_loader.lua

groupDef = {
	["testGroup"] = {},
	-- empty now
	-- expect some content can be added via modules loader
}

-- OLD DEPREC STUFF
function BuffersDebug(doit,groupCount,groupInfo,teamInfo,sourcesList,unitTypesList)
    if (doit) then
	    Spring.Echo("-------")
        Spring.Echo("Buffer dependancy")		
		for i=1,groupCount do
		    local thisGroup = groupInfo[i]
			local thisSpirit = string.sub(thisGroup.spirit,-6)
		    if (thisSpirit == "Buffer") then
			    local thisBufferList = thisGroup.bufferGroupIDs
				Spring.Echo(thisGroup.name .. "s dependeant group IDs:") 
			    for j=1,#thisBufferList do
				    Spring.Echo(thisBufferList[j])  
				end
			end
		end
		Spring.Echo("-------") 
		Spring.Echo("ORDERS LISTS")
		for i=1,#teamInfo do
		    Spring.Echo("Team " .. i)
			local thisTeam = teamInfo[i]
			for j=1,7 do
			    Spring.Echo("level: " .. j)			   
			    for k=1,#sourcesList do
					local factory = "buildOrders" .. sourcesList[k]
                    Spring.Echo(factory)					
					local thisList = thisTeam[factory][j]
					for l=1,#thisList do
					    Spring.Echo(thisList[l][1],thisList[l][2])
					end
                end				
			end
		end
		Spring.Echo("-------") 
		Spring.Echo("UNIT COUNTS")
		for i=1,#teamInfo do
		    Spring.Echo("Team " .. i)
			local thisTeam = teamInfo[i]
			for j=1,#unitTypesList do
			    Spring.Echo(thisTeam.unitTypeCount[unitTypesList[j]].name,thisTeam.unitTypeCount[unitTypesList[j]].count,thisTeam.unitTypeCount[unitTypesList[j]].limit,thisTeam.unitTypeCount[unitTypesList[j]].percent)
			end
		end
		return
	else
	    return
	end
end
