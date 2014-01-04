function widget:GetInfo()
	return {
		name		= "HeroActionsWindow",
		desc		= "Window that contains buttons for heroes actions and abilities for OTE",
		author		= "Pavel",
		date		= "2014-01-04",
		license     = "GNU GPL v2",
		layer		= math.huge,
		enabled   	= true,
		handler		= true,
	}
end

--UI Constants
local POWERBUTTONSIZE = 50
-----

local actionWindow
local powersWindow
local upgradeWindow

local Chili

local upgradePoints = 1

function ButtonClicked(chiliButton, x, y, button, mods)
	--TODO: call some action, and/or check conditions
	Spring.Echo("Action called from powers menu: " .. chiliButton.action)
end

function UpgradeButtonClicked(chiliButton, x, y, button, mods)
	--TODO: call action to improve units stats in given line
	Spring.Echo("Upgrade called to:" .. chiliButton.action)
end

function GetHeroPowers()
	--TODO: FROM HERO DEFINITION GET NAMES AND LEVES OF POWERS AND FROM THEIR DEFINITION GET IMAGE, CAPTION ETC.
	local powers = {
		{
			name 		= "power1",
			level 		= 1,
			levelCap	= 2,
			action 		= "action1",
			image		= "power_image1",
			caption		= "power_caption",
		},
		{
			name 		= "power2",
			level 		= 3,
			levelCap	= 3,
			action 		= "action2",
			image		= "power_image2",
			caption		= "power_caption",
		},
		{
			name 		= "power3",
			level 		= 2,
			levelCap	= 3,
			action 		= "action3",
			image		= "power_image1",
			caption		= "power_caption",
		},
	}
	-- now returns some example table for debug purpouses
	return powers
end

function GeneratePowersButtons(powers)
	for i=1, #powers do
		local button = Chili.Button:New{
			parent		= powersWindow,
			x 			= (i-1)*45,
			y 			= 0,
			padding		= {3, 3, 3, 3},
			margin		= {0, 0, 0, 0},
			minWidth	= 50,
			minHeight	= 50,
			maxWidth	= 50,
			caption 	= powers[i]["name"],
			action 		= powers[i]["action"],
			OnMouseDown = {ButtonClicked},
		}
	end
end

function GenerateUpgradeButtons(powers, points)
	for i=1, #powers do
		local disabled = false
		if (powers[i]["level"] == powers[i]["levelCap"] or points==0) then
			disabled = true
		end
		if not disabled then
			local button = Chili.Button:New{
				parent		= upgradeWindow,
				x			= (i-1)*45,
				y 			= 0,
				padding		= {3, 3, 3, 3},
				margin		= {0, 0, 0, 0},
				minWidth	= 50,
				minHeight	= 50,
				maxWidth	= 50,
				caption 	= "+1",
				action 		= "upgrade" .. powers[i]["action"],
				OnMouseDown = {UpgradeButtonClicked},
			}
		end
	end
end

function LevelUp()
	upgradePoints = upgradePoints - 1
	powersWindow:clearChildren()
	local powers = GetHeroPowers()
	GeneratePowersButtons(powers)
	upgradeWindow:clearChildren()
	GenerateUpgradeButtons(powers, upgradePoints)
end

function LevelUpPossible()
	upgradePoints = upgradePoints + 1
	upgradeWindow:clearChildren()
	local powers = GetHeroPowers()
	GenerateUpgradeButtons(powers, upgradePoints)
end

function widget:Initialize()
	
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	
	Chili = WG.Chili
	local screen0 = Chili.Screen0
	
	local powers = GetHeroPowers()
	local wWidth = #powers*POWERBUTTONSIZE + #powers*5
	
	local screenX, screenY	= Spring.GetViewGeometry()
	local wHeight			= 140
	
	actionWindow = Chili.Window:New{
		x 				= screenX/2 - wWidth/2,
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
	
	powersWindow = Chili.Window:New{
		x				= 0,
		y				= 55,
		dockable 		= false,
		parent			= actionWindow,
		caption			= "",
		draggable		= false,
		resizable		= true,
		clientWidth		= wWidth - 25,
		clientHeight	= 55,
		backgroundColor	= {0,0,0,1},
	}
	
	upgradeWindow = Chili.Window:New{
		x				= 0,
		y				= 0,
		dockable 		= false,
		parent			= actionWindow,
		caption			= "",
		draggable		= false,
		resizable		= true,
		clientWidth		= wWidth - 25,
		clientHeight	= 40,
		backgroundColor	= {0,0,0,1},
	}
	
	GeneratePowersButtons(powers)
	GenerateUpgradeButtons(powers, upgradePoints)
	
end