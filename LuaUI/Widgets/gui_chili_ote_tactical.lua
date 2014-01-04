function widget:GetInfo()
	return {
		name		= "TacticalWindow",
		desc		= "Tactical Window for OTE",
		author		= "Pavel",
		date		= "2014-01-04",
		license     = "GNU GPL v2",
		layer		= math.huge,
		enabled   	= true,
		handler		= true,
	}
end

local tacticalWindow
local Chili

function ButtonClicked(chiliButton, x, y, button, mods)
	--TODO: call some action, and/or check conditions
	Spring.Echo("Action called from tactical menu: " .. chiliButton.action)
end

function LineButtonClicked(chiliButton, x, y, button, mods)
	--TODO: call action to improve units stats in given line
	Spring.Echo("Line improve units called type: " .. chiliButton.action .. " in line:" .. chiliButton.inLine)
end

function widget:Initialize()
	
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	
	Chili = WG.Chili
	local screen0 = Chili.Screen0
	
	local screenX, screenY	= Spring.GetViewGeometry()
	local wWidth, wHeight	= 200,250
	tacticalWindow = Chili.Control:New{
		x 				= screenX - wWidth - 30,
		y 				= screenY - wHeight - 30,
		dockable 		= false,
		parent			= screen0,
		caption			= "",
		dragable		= false,
		resizable		= true,
		clientWidth		= wWidth,
		clientHeight	= wHeight,
		backgroundColor	= {0,0,0,0},
	}
	
	local powersWindow = Chili.Control:New{
		x				= 0,
		y				= 0,
		dockable		= false,
		parent			= tacticalWindow,
		caption			= "",
		dragable		= false,
		resizable		= false,
		clientWidth		= wWidth -30,
		clientHeight	= 50,
		backgroundColor	= {0,0,0,0},
	}
	
	local linesWindow = Chili.Window:New{
		x				= 0,
		y				= 75,
		dockable		= false,
		parent			= tacticalWindow,
		caption			= "",
		dragable		= false,
		resizable		= false,
		clientWidth		= wWidth -30,
		clientHeight	= 150,
		backgroundColor	= {0,0,0,1},
	}
	
	local powersButtons = {
		{caption="Airstrike", action="airstrike"},
		{caption="Minefield",action="minefield"},
		{caption="BaseUp", action="baseup"},
		{caption="The fourth thing", action="..."},
	}
	
	for i=1, #powersButtons do
		local button = Chili.Button:New{
			parent		= powersWindow,
			x 			= (i-1)*42,
			y 			= 0,
			padding		= {3, 3, 3, 3},
			margin		= {0, 0, 0, 0},
			minWidth	= 40,
			minHeight	= 55,
			maxWidth	= 50,
			caption 	= powersButtons[i]["caption"],
			isDisabled 	= false,
			action 		= powersButtons[i]["action"],
			OnMouseDown = {ButtonClicked},
		}	
	end
	
	local lineButtons = {
		{caption="Combat", action="combatAdd"},
		{caption="Monster", action="monsterAdd"},
		{caption="HeroParts", action="partsAdd"},
		{caption="TowerParts", action="towerAdd"},
	}
	
	local linesDesc = { "north", "center", "south" }
	
	for i=1, #linesDesc do
		for j=1, #lineButtons do
			local button = Chili.Button:New{
			parent		= linesWindow,
			x 			= (j-1)*42,
			y 			= (i-1)*45,
			padding		= {5, 5, 5, 5},
			margin		= {0, 0, 0, 0},
			minWidth	= 40,
			minHeight	= 55,
			maxWidth	= 50,
			caption 	= lineButtons[j]["caption"],
			isDisabled 	= false,
			action 		= lineButtons[j]["action"],
			inLine		= linesDesc[i],
			OnMouseDown = {LineButtonClicked},
		}	
		end
	end
	
end