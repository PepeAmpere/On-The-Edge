------------------------------------------------------------------------------
-- NOE TEAMS CONTROLLER
-- functions taking care about teams tables and settings
------------------------------------------------------------------------------

local spGetTeamResources               = Spring.GetTeamResources
local spSetTeamResource                = Spring.SetTeamResource
local spAddTeamResource                = Spring.AddTeamResource

function SetResources()
	---- RESOURCES SETTING FOR ALL NOE GAMES -----
	for i=1,#teamList do
		local id = teamList[i]
		local _,_,_,isAI,side 	= Spring.GetTeamInfo(id)
		local aiInfo          	= Spring.GetTeamLuaAI(id)
		local m,ms,e,es
		local setThem 			= {true,true,true,true}
		if ((isAI) and (aiInfo == "Mission AI") and (sideSettings[teamIDtoName[tostring(id)]].startMetal ~= nil)) then
			m  = sideSettings[teamIDtoName[tostring(id)]].startMetal
			ms = sideSettings[teamIDtoName[tostring(id)]].startMetalStorage
			e  = sideSettings[teamIDtoName[tostring(id)]].startEnergy
			es = sideSettings[teamIDtoName[tostring(id)]].startEnergyStorage
		else
			-- hotfix for OTE
			if (heroClass and oteRule) then
				-- TODO: get metal value and class from setup
				local metalCurrent 	= 0
				setThem[1]	= false
				setThem[2]	= false
				setThem[4]	= false
				-- Spring.Echo(oteRule.energy[heroClass[class].statsClass[3]])
				-- m  = metalCurrent
				ms = 100000
				-- e  = oteRule.energy[heroClass[class].statsClass[3]]
				-- es = oteRule.energy[heroClass[class].statsClass[3]]
			else
				m  = floor((missionInfo.playersMetal or 1000)/missionPlayersCount)
				ms = floor((missionInfo.playersMetal or 1000)/missionPlayersCount)
				e  = floor((missionInfo.playersEnergy or 1000)/missionPlayersCount) 
				es = floor((missionInfo.playersEnergy or 1000)/missionPlayersCount)
			end
		end
		--Spring.Echo("res",id,m,e,ms,es)
		if (setThem[1]) then spSetTeamResource(id, "m", m) end
		if (setThem[2]) then spSetTeamResource(id, "e", e) end 
		if (setThem[3]) then spSetTeamResource(id, "ms", ms) end 
		if (setThem[4]) then spSetTeamResource(id, "es", es) end
	end
	---- END OF RESOURCES SETTING ----
end

-- ?DELETE?
function SetResEnergy(teamNumber)
    local thisTeam = teamInfo[teamNumber]	     
	local levelEnergy,storageEnergy,_,incomeEnergy,expenseEnergy = spGetTeamResources(thisTeam.teamID,"energy")       
	thisTeam.energyLevel   = levelEnergy
	thisTeam.energyStorage = storageEnergy
	thisTeam.energyIncome  = incomeEnergy
	thisTeam.energyExpense = expenseEnergy
end

-- ?DELETE?
function SetResMetal(teamNumber)
    local thisTeam = teamInfo[teamNumber]
    local levelMetal,storageMetal,_,incomeMetal,expenseMetal = spGetTeamResources(thisTeam.teamID,"metal") 
	thisTeam.metalLevel    = levelMetal
	thisTeam.metalStorage  = storageMetal
	thisTeam.metalIncome   = incomeMetal
	thisTeam.metalExpense  = expenseMetal	
end