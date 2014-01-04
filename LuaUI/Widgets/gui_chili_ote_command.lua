function widget:GetInfo()
	return {
		name		= "CommandWindow",
		desc		= "Command Window for OTE",
		author		= "Pavel",
		date		= "2014-01-03",
		license     = "GNU GPL v2",
		layer		= math.huge,
		enabled   	= true,
		handler		= true,
	}
end

local spSendCommands = Spring.SendCommands

--TODO: this has to be changed when these commands for unit are defined
local CMDPRIMARY	= 3000
local CMDPRIMARYCAN	= 3001

--UI - Constants:
local TACTICALHEIGHT = 300		

local commandWindow
local Chili

function ButtonClicked(chiliButton, x, y, button, mods)
	local index = Spring.GetCmdDescIndex(chiliButton.cmdid)
	if(index) then
		local left, right = (button == 1), (button == 3)
		local alt, ctrl, meta, shift = mods.alt, mods.ctrl, mods.meta, mods.shift

		if DEBUG then Spring.Echo("active command set to ", chiliButton.cmdid) end
		Spring.SetActiveCommand(index, button, left, right, alt, ctrl, meta, shift)
	end
end

function widget:Initialize()
	spSendCommands({"tooltip 0"})
	spSendCommands("resbar 0")
	spSendCommands({"console 0"})
	spSendCommands({"clock 0"})
	spSendCommands({"fps 0"})
	spSendCommands({"info 0"})
	spSendCommands({"speed 0"})
	
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	
	Chili = WG.Chili
	local screen0 = Chili.Screen0
	
	local screenX, screenY 			= Spring.GetViewGeometry()
	local clientWidth, clientHeight	= 80, 400
	local yPos = screenY - clientHeight - TACTICALHEIGHT
	if (yPos < 0) then
		yPos=0
	end
	-- create window with control buttons:
	commandWindow = Chili.Window:New{
		x 				= screenX - clientWidth - 30,
		y 				= yPos,
		dockable 		= false,
		parent			= screen0,
		caption			= "",
		draggable		= false,
		resizable		= true,
		clientWidth		= clientWidth,
		clientHeight	= clientHeight,
		backgroundColor	= {0,0,0,1},
	}
	
	local buttons = {
		{caption="Move", id=CMD.MOVE},
		{caption="Patrol",id=CMD.PATROL},
		{caption="Fight",id=CMD.FIGHT},
		{caption="Attack", id=CMD.ATTACK},
		{caption="Primary Target",id=CMDPRIMARY},
		{caption="Cancel Primary Target",id=CMDPRIMARYCAN},
		{caption="Stop",id=CMD.STOP},
		{caption="Wait",id=CMD.WAIT},
		{caption="Guard",id=CMD.GUARD}
	}
	
	for i=1, #buttons do
		local button = Chili.Button:New{
			parent		= commandWindow,
			x 			= 0,
			y 			= (i-1)*45,
			padding		= {5, 5, 5, 5},
			margin		= {0, 0, 0, 0},
			minWidth	= 40,
			minHeight	= 40,
			caption 	= buttons[i]["caption"],
			isDisabled 	= false,
			cmdid 		= buttons[i]["id"],
			OnMouseDown = {ButtonClicked},
		}	
	end
end

function widget:Shutdown()
  widgetHandler:ConfigLayoutHandler(nil)
  Spring.ForceLayoutUpdate()
  spSendCommands({"tooltip 1"})
end
	
	