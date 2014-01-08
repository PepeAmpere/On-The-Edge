function widget:GetInfo()
	return {
		name		= "OTE UI HeroInfo",
		desc		= "Window that contains players HP/energy",
		author		= "Pavel",
		date		= "2014-01-04",
		license     = "OTE license",
		layer		= math.huge,
		enabled   	= true,
		handler		= true,
	}
end

local energyBar
local hpBar

local Chili
local active 	= false
local needUnit	= true
local needInit 	= true

local class 	= ""									-- = name of hero
local path 		= "LuaUI/oteUI/heroes256x256/"			-- folder with images of heroes 256x256 pixels
local myUnitID 	= 0
local myTeamID	= Spring.GetMyTeamID()					-- from this we know team from the beginning

local function GetHeroStats()
	-- !! not possible to include files outside LuaUI
	local heroStats = {
		image	= path .. class .. ".png",
		unitID	= myUnitID,
		teamID	= myTeamID,
	}
	--now returns example table for debug:
	return heroStats
end

local function DelayedInitialization()
	
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	
	Chili = WG.Chili
	local screen0 = Chili.Screen0
	
	local screenX, screenY	= Spring.GetViewGeometry()
	local wWidth, wHeight	= 300, 300
	
	local heroStats = GetHeroStats()
	
	infoWindow = Chili.Window:New{
		x 				= 130,
		y 				= screenY - wHeight - 30,
		dockable 		= false,
		parent			= screen0,
		caption			= "",
		draggable		= false,
		resizable		= true,
		clientWidth		= wWidth,
		clientHeight	= wHeight,
		backgroundColor	= {0,0,0,1},
	}
	
	local heroImage = Chili.Image:New{
		x 			= 0,
		y 			= 44,
		parent		= infoWindow,
		file		= heroStats.image,
		minWidth	= 256,
		minHeight	= 256,
	}
	
	local actualE, maximalE = Spring.GetTeamResources(heroStats.teamID, "energy")
	if (not actualE) then actualE = 0 end
	if (not maximalE) then maximalE = 0 end
	energyBar = Chili.Progressbar:New{
		x			= 260,
		y			= 44,
		parent		= infoWindow,
		value	 	= actualE,
		max			= maximalE,
		caption		= "E\nN\nE\nR\nG\nY\n\n\n",
		minWidth	= 40,
		minHeight	= 256,
		maxWidth	= 40,
		orientation	= "vertical",
		color		= {0,1,1,1}
	}
	
	energyValues = Chili.Label:New{
		x			= 260,
		y			= 0,
		maxHeight	= 40,
		maxWidth	= 40,
		align		= "center",
		parent		= infoWindow,
		caption		= "[" .. maximalE .. "]" .. "\n " .. actualE,
	}
	
	local actualHp, maximalHp = Spring.GetUnitHealth(heroStats.unitID)
	if (not actualHp) then actualHp = 0 end
	if (not maximalHp) then maximalHp = 0 end
	hpBar = Chili.Progressbar:New{
		x			= 0,
		y			= 0,
		parent		= infoWindow,
		value	 	= actualHp,
		max			= maximalHp,
		caption		= "HP: " .. actualHp .. "/" .. maximalHp, 
		minWidth	= 256,
		minHeight	= 40,
		color		= {0,1,0,1}
	}
	
	Spring.Echo(Spring.GetUnitHealth(heroStats.unitID))
end


local function ActivateScreen(unitID, unitDefID)
	myUnitID 	= unitID					-- for later access to units stats
	class		= UnitDefs[unitDefID].name	-- connection not via our tables, but via spring table (due reason on line 29)
	active 		= true						-- we are ready to show it now
	needUnit	= false						-- we needed this check only once
end

-- just connect UI widget with given unit and team
function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	if (myTeamID == unitTeam and needUnit) then
		ActivateScreen(unitID, unitDefID)
	end
end

--TODO: OPTIMALIZE!!!!!!!!!!!!!!!!!!!!
function widget:GameFrame(frameNumber)
	if (active) then	
		-- i moved init here because we dont want to start init + show UI until hero is spawned before game is started
		if (needInit) then
			DelayedInitialization()
			needInit = false 			-- we needed this init only once
		end
	
		-- window itself
		heroStats = GetHeroStats()
		actualE, maximalE = Spring.GetTeamResources(heroStats.teamID, "energy")
		if (not actualE) then actualE = 0 end
		if (not maximalE) then maximalE = 0 end
		actualHp, maximalHp = Spring.GetUnitHealth(heroStats.unitID)
		if (not actualHp) then actualHp = 0 end
		if (not maximalHp) then maximalHp = 0 end
		actualHp = math.floor(actualHp)
		maximalHp = math.floor(maximalHp)
		actualE = math.floor(actualE)
		maximalE = math.floor(maximalE)
		hpBar:SetMinMax(0, maximalHp)
		hpBar:SetValue(actualHp)
		hpBar:SetCaption("HP: " .. actualHp .. "/" .. maximalHp)
		energyBar:SetMinMax(0, maximalE)
		energyBar:SetValue(actualE)
		-- energyBar:SetCaption("E\nN\nE\nR\nG\nY\n\n\n" .. actualE .. "\n/\n" .. maximalE)
		energyBar:SetCaption("E\nN\nE\nR\nG\nY\n\n\n")
		energyValues:SetCaption("[" .. maximalE .. "]" .. "\n " .. actualE)
	else
		-- fix for ingame reload of UI
		if (frameNumber % 60 == 0 and needUnit) then
			local listOfUnits = Spring.GetTeamUnits(myTeamID)
			if (listOfUnits) then				
				ActivateScreen(listOfUnits[1],Spring.GetUnitDefID(listOfUnits[1]))
			end
		end
	end
end