function widget:GetInfo()
	return {
		name		= "OTE UI HeroActionsWindow",
		desc		= "Window that contains buttons for heroes actions and abilities for OTE",
		author		= "Pavel",
		date		= "2014-01-04",
		license     = "OTE license",
		layer		= math.huge,
		enabled   	= true,
		handler		= true,
	}
end

VFS.Include("LuaRules/Gadgets/Includes/utilities.lua")

--UI Constants
local POWERBUTTONSIZE = 50
-----

local actionWindow
local powersWindow
local upgradeWindow

local Chili
local active 	= false
local needUnit	= true
local needInit 	= true
local update	= false

local myTeamID		= Spring.GetMyTeamID()					-- from this we know team from the beginning
local myUnitID		= 0
local playerLevel	= 0
local playerMetal	= 0
local playerXP		= 0
local nextLevelOn	= 0
local unitDef		= 0
local myUnitID		= 0
local upgradePoints	= 0

local powers		= nil

function ButtonClicked(chiliButton, x, y, button, mods)
	Spring.SendLuaRulesMsg("TSPACTION" .. "-" .. myUnitID .. "-" .. chiliButton.caption .. "-" .. chiliButton.level)
end

function UpgradeButtonClicked(chiliButton, x, y, button, mods)
	upgradePoints = upgradePoints - 1
	Spring.SendLuaRulesMsg("UPBUTTONCLICKED" .. "-" .. myUnitID .. "-" .. chiliButton.nextlevel)
end


function GeneratePowersButtons()
	powersWindow:ClearChildren()
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
			level 		= powers[i]["level"],
			OnMouseDown = {ButtonClicked},
		}
	end
end

function GenerateUpgradeButtons(points)
	upgradeWindow:ClearChildren()
	for i=1, #powers do
		local disabled = true
		Spring.Echo(powers[i]["nextLevelAllowed"])
		local allowed = ToBool( tostring(powers[i]["nextLevelAllowed"]))
		if (allowed) then
			if(points ~= 0) then
				disabled = false
			end
		end
		Spring.Echo("DISABLED?")
		Spring.Echo(disabled)
		if not disabled then
			local button = Chili.Button:New{
				parent		= upgradeWindow,
				x			= ((i-1)*45)+8,
				y 			= 0,
				padding		= {3, 3, 3, 3},
				margin		= {0, 0, 0, 0},
				minWidth	= 50,
				minHeight	= 50,
				maxWidth	= 50,
				caption 	= "+1",
				nextlevel	= powers[i]["nextLevelName"],
				OnMouseDown = {UpgradeButtonClicked},
			}
		end
	end
end

local function DelayedInitialization()
	
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	
	Chili = WG.Chili
	local screen0 = Chili.Screen0
	
	local wWidth = #powers*POWERBUTTONSIZE + #powers*5
	
	local screenX, screenY	= Spring.GetViewGeometry()
	local wHeight			= 150
	
	actionWindow = Chili.Control:New{
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
	
	upgradeWindow = Chili.Control:New{
		x				= 0,
		y				= 0,
		dockable 		= false,
		parent			= actionWindow,
		caption			= "",
		draggable		= false,
		resizable		= true,
		clientWidth		= wWidth - 15,
		clientHeight	= 55,
		backgroundColor	= {0,0,0,1},
	}
	
	GeneratePowersButtons()
	GenerateUpgradeButtons(upgradePoints)
	
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
	unitDef		= unitDefID
	
	nextLevelOn	= UnitDefs[unitDefID].customParams.nextlevelexp
	playerLevel	= UnitDefs[unitDefID].customParams.level
	
	local params = UnitDefs[unitDefID].customParams
	
	powers = {}
	
	for i=1,params.tsps_size do
		local tspName 		= "tsp" .. i .. "_name"
		local tspLevel		= "tsp" .. i .. "_level"	
		local tspNextName	= "tsp" .. i .. "_nextlevelname"
		local tspNextAllow	= "tsp" .. i .. "_nextlevelallowed"
		powers[i] = {
			name 				= params[tspName],
			level				= params[tspLevel],
			nextLevelName		= params[tspNextName],
			nextLevelAllowed	= params[tspNextAllow],
		}
	end
	
	Spring.Echo(powers)
	
	if update then
		GeneratePowersButtons()
		GenerateUpgradeButtons(upgradePoints)
	end
	
	active 		= true						-- we are ready to show it now
	needUnit	= false						-- we needed this check only once
	update		= false
end

local function AddExp(amount)
	local value = playerXP + amount
	Spring.Echo(value)
	if (value >= tonumber(nextLevelOn)) then
		upgradePoints = upgradePoints + 1
		GenerateUpgradeButtons(upgradePoints)
		playerXP = value - nextLevelOn
	else
		playerXP = value
	end
end

function widget:RecvLuaMsg(msg, playerID)
	if (playerID ~= Spring.GetMyPlayerID()) then return end
	
	local tokens = split(msg,"-")
	if(tokens[1] == "LEVELUP")then
		active 		= false
		needUnit	= true
		update		= true
	end
	
	if(tokens[1] == "EXPUP") then
		Spring.Echo(tokens[3], myUnitID)
		if(tokens[3] == tostring(myUnitID)) then
			Spring.Echo("CALL??")
			AddExp(tokens[4])
		end
	end
	
end

function widget:GameFrame(frameNumber)
	if (active) then	
		-- i moved init here because we dont want to start init + show UI until hero is spawned before game is started
		if (needInit) then
			DelayedInitialization()
			needInit = false 			-- we needed this init only once
		end

		metalCaption:SetCaption(Spring.GetTeamResources(myTeamID,"metal"))
		xpBar:SetValue(playerXP)
		xpBar:SetCaption("EXP: \n" .. playerXP .. "/" .. nextLevelOn)
		playerLevelCaption:SetCaption("LVL: " .. playerLevel)
		upgradePointsCaption:SetCaption(upgradePoints .. " UP")
		
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