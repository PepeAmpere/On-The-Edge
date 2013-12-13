---------------------------------------
-------- NOE terraform library --------
---------------------------------------

local spSetHeightMapFunc	= Spring.SetHeightMapFunc
local spAddHeightMap		= Spring.AddHeightMap

terraform = {
    --- PARAMETRIZED ---
    ["circlePlatform"] = function(baseX,baseZ,radius,height)
        spSetHeightMapFunc(function()
		    local squareRadius = radius*radius
			for z=-radius,radius, Game.squareSize do
				for x=-radius,radius, Game.squareSize do
					if (((z*z) + (x*x) ) <= squareRadius) then
						spAddHeightMap(baseX+x,baseZ+z,height)
					end
				end
			end
		end)
	end,
	["circlePlatformSmoothed"] = function(baseX,baseZ,radiusPlatform,radiusBorder,height)
		-- version 1.0
		spSetHeightMapFunc(function()
		    local PIhalf				= math.pi/2
		    local squareBorderRadius 	= radiusBorder*radiusBorder
			local squareRadius			= radiusPlatform*radiusPlatform
			local smallRadius			= radiusBorder-radiusPlatform
			for z=-radiusBorder,radiusBorder, Game.squareSize do
				for x=-radiusBorder,radiusBorder, Game.squareSize do
				    local xzSquare = z*z + x*x
					if ((xzSquare <= squareBorderRadius) and (xzSquare >= squareRadius)) then
						local newHeight = math.cos(((GetDistance2D(0,0,x,z)-radiusPlatform)/smallRadius)*PIhalf)*height
						spAddHeightMap(baseX+x,baseZ+z,newHeight)
					elseif (xzSquare <= squareBorderRadius) then
						spAddHeightMap(baseX+x,baseZ+z,height)
					end
				end
			end
		end)
	end,
	["circleHill"] = function(baseX,baseZ,radius,height)
        spSetHeightMapFunc(function()
		    local PIhalf       = math.pi/2
		    local squareRadius = radius*radius
			for z=-radius,radius, Game.squareSize do
				for x=-radius,radius, Game.squareSize do
					if (((z*z) + (x*x) ) <= squareRadius) then
						local newHeight = math.cos((GetDistance2D(0,0,x,z)/radius)*PIhalf)*height
						--Spring.Echo(newHeight)
						spAddHeightMap(baseX+x,baseZ+z,newHeight)
					end
				end
			end
		end)
	end,
	--- OTHERS ---
	["finished"] = function()
        Spring.Echo("N.O.E. terraform: terraforming finished")
	end,
	["noForm"] = function()
	end,
}

terraformPlan = {
    -- {name = "finished", params = {},mode="public"},
}

function MakeTerraform(mode)
    for i=1,#terraformPlan do
	    local thisTerraform = terraformPlan[i]
		if ((thisTerraform.name ~= nil) and (thisTerraform.mode == mode)) then
		    if (thisTerraform.params ~= nil) then
				terraform[thisTerraform.name](unpack(thisTerraform.params))
			else
			    terraform[thisTerraform.name]()
			end
		end
	end
end