function widget:GetInfo()
	return {
		name		= "OTE UI LevelInfo",
		desc		= "Window that contains info about xp, playerLevel etc",
		author		= "Pavel",
		date		= "2014-01-04",
		license     = "OTE license",
		layer		= math.huge,
		enabled   	= true,
		handler		= true,
	}
end

local infoWindow
local metalCaption
local playerLevelCaption
local upgradePointsCaption

local Chili
local active 	= false
local needUnit	= true
local needInit 	= true

local upgradePoints = 0
local playerLevel	= 0
local myTeamID		= Spring.GetMyTeamID()					-- from this we know team from the beginning
local playerMetal	= 0
local playerXP		= 0
local nextLevelOn	= 0
--TODO: add function to listen to massages and update gui

local function DelayedInitialization()
	
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	
	Chili = WG.Chili
	local screen0 = Chili.Screen0
	
	local screenX, screenY	= Spring.GetViewGeometry()
	local wWidth, wHeight	= 65, 250
	
	infoWindow = Chili.Window:New{
		x 				= 10,
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
	
	metalCaption = Chili.Label:New{
		x		= 0,
		y		= 0,
		parent	= infoWindow,
		caption	= Spring.GetTeamResources(myTeamID,"metal"), 
	}
	
	xpBar = Chili.Progressbar:New{
		x			= 0,
		y			= 20,
		parent		= infoWindow,
		max 		= nextLevelOn, 	--int maximum value of the Progressbar (default 100)
		value		= playerXP, 	--int value of the Progressbar (default 100)
		caption 	= "EXP: \n" .. playerXP .. "/" .. nextLevelOn, -- string text to be displayed (default "")
		minWidth	= 65,
		maxWidth	= 65,
		minHeight	= 180,
		orientation = "vertical"
	}
	
	playerLevelCaption = Chili.Label:New{
		x		= 0,
		y		= 205,
		parent	= infoWindow,
		caption	= "LVL: " .. playerLevel, -- string text contained in the editbox (default "")
	}
	
	upgradePointsCaption = Chili.Label:New{
		x		= 0,
		y		= 225,
		parent	= infoWindow,
		caption	= upgradePoints .. " UP", -- string text contained in the editbox (default "")
	}
	
end

local function ActivateScreen(unitID, unitDefID)
	myUnitID 	= unitID					-- for later access to units stats
	nextLevelOn	= UnitDefs[unitDefID].customParams.nextlevelexp
	playerLevel	= UnitDefs[unitDefID].customParams.level
	active 		= true						-- we are ready to show it now
	needUnit	= false						-- we needed this check only once
end

function widget:GameFrame(frameNumber)
	if (active) then	
		-- i moved init here because we dont want to start init + show UI until hero is spawned before game is started
		if (needInit) then
			DelayedInitialization()
			needInit = false 			-- we needed this init only once
		end

		-- playerMetal = --TODO: get from struct
		-- playerXP 	= --TODO: get from struct
		metalCaption:SetCaption(Spring.GetTeamResources(myTeamID,"metal"))
		xpBar:SetValue(playerXP)
		xpBar:SetCaption("EXP: \n" .. playerXP .. "/" .. nextLevelOn)
	else
		if (frameNumber % 60 == 0 and needUnit) then
			myTeamID			= Spring.GetMyTeamID()
			local listOfUnits 	= Spring.GetTeamUnits(myTeamID)
			if (listOfUnits and (#listOfUnits > 0)) then
				for i=1,#listOfUnits do
					local unitDefID = Spring.GetUnitDefID(listOfUnits[i])
					if (UnitDefs[unitDefID].customParams.ishero) then
						ActivateScreen(listOfUnits[i],unitDefID)
					end
				end
			end
		end
	end
end