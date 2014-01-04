function widget:GetInfo()
	return {
		name		= "HeroInfo",
		desc		= "Window that contains players HP/energy",
		author		= "Pavel",
		date		= "2014-01-04",
		license     = "GNU GPL v2",
		layer		= math.huge,
		enabled   	= true,
		handler		= true,
	}
end

local energyBar
local hpBar

local Chili

function GetHeroStats()
--TODO: read hero stats from definition file, and 
	local heroStats={
	image	= "LuaUI/Images/hero_sample_image.png",
	unitID	= 42,
	teamID	= 0,
	}
--now returns example table for debug:
	return heroStats
end

function widget:Initialize()
	
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
		file		= heroStats["image"],
		minWidth	= 256,
		minHeight	= 256,
	}
	
	local actualE, maximalE = Spring.GetTeamResources(heroStats["teamID"], "energy")
	if (not actualE) then actualE = 0 end
	if (not maximalE) then maximalE = 0 end
	energyBar = Chili.Progressbar:New{
		x			= 260,
		y			= 44,
		parent		= infoWindow,
		value	 	= actualE,
		max			= maximalE,
		caption		= "Energy: " .. '\n' .. actualE .. "/" .. maximalE,
		minWidth	= 40,
		minHeight	= 256,
		maxWidth	= 40,
		orientation	= "vertical",
		color		= {0,1,1,1}
	}
	
	local actualHp, maximalHp = Spring.GetUnitHealth(heroStats["unitID"])
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
	
	Spring.Echo(Spring.GetUnitHealth(heroStats["unitID"]))
end


--TODO: OPTIMALIZE!!!!!!!!!!!!!!!!!!!!
function widget:GameFrame(frameNumber)
	heroStats = GetHeroStats()
	actualE, maximalE = Spring.GetTeamResources(heroStats["teamID"], "energy")
	if (not actualE) then actualE = 0 end
	if (not maximalE) then maximalE = 0 end
	actualHp, maximalHp = Spring.GetUnitHealth(heroStats["unitID"])
	if (not actualHp) then actualHp = 0 end
	if (not maximalHp) then maximalHp = 0 end
	hpBar:SetMinMax(0, maximalHp)
	hpBar:SetValue(actualHp)
	hpBar:SetCaption("HP: " .. actualHp .. "/" .. maximalHp)
	energyBar:SetMinMax(0, maximalE)
	energyBar:SetValue(actualE)
	energyBar:SetCaption("HP: " .. actualE .. "/" .. maximalE)
end