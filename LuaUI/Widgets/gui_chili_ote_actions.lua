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

local myTeamID	= Spring.GetMyTeamID()					-- from this we know team from the beginning
local myUnitID	= 0

local upgradePoints = 1
local powers		= nil

function ButtonClicked(chiliButton, x, y, button, mods)
	--TODO: call some action, and/or check conditions
	Spring.Echo("Action called from powers menu: " .. chiliButton.action)
end

function UpgradeButtonClicked(chiliButton, x, y, button, mods)
	Spring.SendLuaRulesMsg("UPBUTTONCLICKED" .. "-" .. myUnitID .. "-" .. chiliButton.nextlevel)
end


function GeneratePowersButtons()
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
				x			= (i-1)*45,
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

-- function LevelUp()
	--upgradePoints = upgradePoints - 1
	
	-- local unitDefID = Spring.GetUnitDefID(myUnitID)
	-- local params = UnitDefs[unitDefID].customParams
	
	-- powers = {}
	
	-- for i=1,params.tsps_size do
		-- local tspName 		= "tsp" .. i .. "_name"
		-- local tspLevel		= "tsp" .. i .. "_level"	
		-- local tspNextName	= "tsp" .. i .. "_nextlevelname"
		-- local tspNextAllow	= "tsp" .. i .. "_nextlevelallowed"
		-- powers[i] = {
			-- name 				= params[tspName],
			-- level				= params[tspLevel],
			-- nextLevelName		= params[tspNextName],
			-- nextLevelAllowed	= params[tspNextAllow],
		-- }
	-- end
	
	-- powersWindow:clearChildren()
	-- GeneratePowersButtons()
	-- upgradeWindow:clearChildren()
	-- GenerateUpgradeButtons(upgradePoints)
-- end

function LevelUpPossible()
	upgradePoints = upgradePoints + 1
	upgradeWindow:clearChildren()
	GenerateUpgradeButtons(upgradePoints)
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
	
	GeneratePowersButtons()
	GenerateUpgradeButtons(upgradePoints)
	
end

local function ActivateScreen(unitID, unitDefID)
	myUnitID 	= unitID					-- for later access to units stats
	--Spring.Echo(unitDefID, UnitDefs[unitDefID].name, UnitDefs[unitDefID].customParams)
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
	active 		= true						-- we are ready to show it now
	needUnit	= false						-- we needed this check only once
end

function widget:RecvLuaMsg(msg, playerID)
	--if (playerID ~= LOCALPLAYER) then return end
	
	if(msg == "LEVELUP")then
		---Spring.Echo("Projde!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1")
		active 		= false
		needUnit	= true
		needInit 	= true
	end
end

function widget:GameFrame(frameNumber)
	if (active) then	
		-- i moved init here because we dont want to start init + show UI until hero is spawned before game is started
		if (needInit) then
			DelayedInitialization()
			needInit = false 			-- we needed this init only once
		end

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