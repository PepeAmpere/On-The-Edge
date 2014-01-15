------------------------------------------------------------------------------
-- OTE HERO PRESETUP
-- prepare data structure which contains hero defs
------------------------------------------------------------------------------

local options       = Spring.GetModOptions()
neededCombos		= {}
neededCombosCounter	= 0

Spring.Echo("------------------ HERO PRESETUP ---------------------")
Spring.Echo("... current heros+item combos have to be generated ")

for k,v in pairs(options) do
	if (string.sub(k,1,4) == "team") then
		neededCombosCounter 				= neededCombosCounter + 1
		neededCombos[tostring(v)]			= true
		Spring.Echo(tostring(v))
	end
end


