function widget:GetInfo()
 	return {
 		name		= "helloworld",
 		desc		= "hello world tutorial",
 		author		= "Pavel",
 		date		= "2011-06-19",
 		license     = "GNU GPL v2",
 		layer		= 1,
 		enabled   	= true
 	}
 end
 
-- INCLUDES
-- CONSTANTS
-- SYNCED CONTROLS
-- CHILI CONTROLS
-- MEMBERS
-- SCRIPT FUNCTIONS
-- WIDGET CODE

function widget:Initialize()	
 	if (not WG.Chili) then
 		widgetHandler:RemoveWidget()
 		return
 	end
 	
 	Chili      = WG.Chili
 	local screen0 = Chili.Screen0
	
	helloWorldWindow = Chili.Window:New{
 		x = '50%',
 		y = '50%',	
 		dockable = true,
 		parent = screen0,
 		caption = "Pavlovo krutoprisne okynko",
 		clientWidth = 200,
 		clientHeight = 40,
 		backgroundColor = {0.8,0.8,0.8,0.9},
 	}	
 	
 	helloWorldLabel = Chili.Label:New{
 		x = '50%',
 		y = '50%',
 		width = 12,
 		parent = helloWorldWindow,
 		caption = "Napis ;)",
 		fontsize = 13,
 		textColor = {1,1,1,1},
 	}
 end