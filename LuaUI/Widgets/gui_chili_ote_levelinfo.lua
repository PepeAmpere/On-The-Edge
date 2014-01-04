function widget:GetInfo()
	return {
		name		= "LevelInfo",
		desc		= "Window that contains info about xp, playerLevel etc",
		author		= "Pavel",
		date		= "2014-01-04",
		license     = "GNU GPL v2",
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

local upgradePoints = 1
local playerLevel	= 1
local playerMetal	= 100
local playerXP		= 50
local nextLevelOn	= 100
--TODO: add function to listen to massages and update gui

function widget:Initialize()
	
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	
	Chili = WG.Chili
	local screen0 = Chili.Screen0
	
	local screenX, screenY	= Spring.GetViewGeometry()
	local wWidth, wHeight	= 120, 300
	
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
		caption	= playerMetal, -- string text contained in the editbox (default "")
	}
	
	xpBar = Chili.Progressbar:New{
		x			= 0,
		y			= 30,
		parent		= infoWindow,
		max 		= nextLevelOn, 	--int maximum value of the Progressbar (default 100)
		value		= playerXP, 	--int value of the Progressbar (default 100)
		caption 	= "EXP: " .. playerXP .. "/" .. nextLevelOn, -- string text to be displayed (default "")
		minWidth	= 90,
		minHeight	= 200,
		orientation = "vertical"
	}
	
	playerLevelCaption = Chili.Label:New{
		x		= 0,
		y		= 240,
		parent	= infoWindow,
		caption	= "LVL: " .. playerLevel, -- string text contained in the editbox (default "")
	}
	
	upgradePointsCaption = Chili.Label:New{
		x		= 60,
		y		= 240,
		parent	= infoWindow,
		caption	= upgradePoints .. "UP", -- string text contained in the editbox (default "")
	}
	
end

function widget:GameFrame(frameNumber)
	-- playerMetal = --TODO: get from struct
	-- playerXP 	= --TODO: get from struct
	metalCaption:SetCaption(playerMetal)
	xpBar:SetValue(playerXP)
	xpBar:SetCaption("EXP: " .. playerXP .. "/" .. nextLevelOn)
end